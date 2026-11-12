using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;

namespace AVUNA_COLLECTIVE
{
    public partial class Payment : Page
    {
        public string PaymentFeedbackHtml { get; private set; } = "";
        public string CurrentOrderId { get; private set; } = "";
        public string CurrentOrderStatus { get; private set; } = "";
        public decimal AmountDue { get; private set; }
        public bool ShowPaymentDetails { get; private set; }
        public string CardholderName { get; private set; } = "";
        public bool ShowSuccessModal { get; private set; }
        public string SubmittedPaymentId { get; private set; } = "";
        public string SubmittedMethod { get; private set; } = "";

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            if (Session != null) ViewStateUserKey = Session.SessionID;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int customerId;
            if (!Int32.TryParse(Convert.ToString(Session["customer_ID"]), out customerId))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
            CurrentOrderId = (Request.QueryString["order"] ?? "").Trim();
            if (CurrentOrderId.Length < 1 || CurrentOrderId.Length > 50)
            {
                Error("Select an order to pay for. You can return to Create Order.");
                return;
            }
            try
            {
                using (var con = new SqlConnection(ConnectionString()))
                {
                    con.Open();
                    if (Request.HttpMethod == "POST" && Request.Form["avunaPaymentSubmit"] == "1")
                    {
                        string method = Request.Form["avunaPaymentMethod"];
                        if (method != "EFT" && method != "Card")
                            throw new InvalidOperationException("Invalid payment method.");
                        if (!String.Equals(ConfigurationManager.AppSettings["AvunaDemoPaymentMode"], "true", StringComparison.OrdinalIgnoreCase))
                            throw new InvalidOperationException("Simulated payments are disabled. Enable AvunaDemoPaymentMode only in a demonstration environment.");
                        PaymentAttempt attempt = CreateAttempt(con, customerId, CurrentOrderId, method);
                        SubmittedPaymentId = attempt.PaymentId;
                        SubmittedMethod = method == "EFT" ? "EFT" : "card";
                        ShowSuccessModal = true;
                    }
                    LoadOrder(con, customerId, CurrentOrderId);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("AVUNA Payment failure: " + ex);
                if (ex is InvalidOperationException) Error(ex.Message);
                else Error("Unable to process payment. No payment was confirmed. Check the Visual Studio Output log.");
            }
        }

        private static string ConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
        }
        private void Error(string message)
        {
            PaymentFeedbackHtml = "<div class='panel'><div class='error'>" + HttpUtility.HtmlEncode(message) + "</div></div>";
        }
        private void LoadOrder(SqlConnection con, int customerId, string orderId)
        {
            // Login.aspx.cs stores customer_ID in Session, not username.
            // Look up the authenticated customer's username; never trust form input for it.
            using (var userCmd = new SqlCommand(@"SELECT username FROM dbo.Customer WHERE customer_ID=@customer", con))
            {
                userCmd.Parameters.Add("@customer", SqlDbType.Int).Value = customerId;
                CardholderName = Convert.ToString(userCmd.ExecuteScalar()) ?? "";
            }
            using (var cmd = new SqlCommand(@"
SELECT o.order_TotalCost, o.order_Status,
       COALESCE((SELECT SUM(p.payment_Amount) FROM dbo.Payment p
                 WHERE p.order_ID=o.order_ID AND p.payment_Status IN ('Paid','Partial')),0) AS AlreadyPaid
FROM dbo.[Order] o WHERE o.order_ID=@order AND o.customer_ID=@customer", con))
            {
                cmd.Parameters.Add("@order", SqlDbType.VarChar, 50).Value = orderId;
                cmd.Parameters.Add("@customer", SqlDbType.Int).Value = customerId;
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) { ShowPaymentDetails = false; Error("Order not found or it does not belong to this customer."); return; }
                    decimal total = Convert.ToDecimal(reader[0]);
                    CurrentOrderStatus = Convert.ToString(reader[1]);
                    AmountDue = Math.Max(0m, total - Convert.ToDecimal(reader[2]));
                    ShowPaymentDetails = true;
                }
            }
        }
        private sealed class PaymentAttempt
        {
            public string PaymentId;
            public string OrderId;
            public decimal Amount;
        }
        private static PaymentAttempt CreateAttempt(SqlConnection con, int customerId, string orderId, string method)
        {
            using (var tx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    // Protect allocation of legacy-style IDs and prevent paying more than the balance.
                    using (var app = new SqlCommand("DECLARE @r INT; EXEC @r=sp_getapplock @Resource='Avuna_Payment_Ids',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=15000; SELECT @r;", con, tx))
                        if (Convert.ToInt32(app.ExecuteScalar()) < 0) throw new InvalidOperationException("Could not obtain payment lock.");
                    decimal total;
                    using (var cmd = new SqlCommand("SELECT order_TotalCost FROM dbo.[Order] WITH (UPDLOCK,HOLDLOCK) WHERE order_ID=@id AND customer_ID=@customer", con, tx))
                    {
                        cmd.Parameters.Add("@id", SqlDbType.VarChar, 50).Value = orderId;
                        cmd.Parameters.Add("@customer", SqlDbType.Int).Value = customerId;
                        object raw = cmd.ExecuteScalar();
                        if (raw == null || raw == DBNull.Value) throw new InvalidOperationException("Order does not belong to the current customer.");
                        total = Convert.ToDecimal(raw);
                    }
                    decimal paid;
                    using (var cmd = new SqlCommand("SELECT COALESCE(SUM(payment_Amount),0) FROM dbo.Payment WITH (UPDLOCK,HOLDLOCK) WHERE order_ID=@id AND payment_Status IN ('Paid','Partial')", con, tx))
                    {
                        cmd.Parameters.Add("@id", SqlDbType.VarChar, 50).Value = orderId;
                        paid = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                    decimal remaining = Math.Max(0m, total - paid);
                    if (remaining <= 0) throw new InvalidOperationException("The order has already been paid.");
                    // A previous Pending request for this order/method can be completed
                    // in demonstration mode instead of creating a duplicate.
                    string pendingPaymentId = null;
                    using (var cmd = new SqlCommand(@"SELECT TOP (1) payment_ID FROM dbo.Payment WITH (UPDLOCK,HOLDLOCK)
                        WHERE order_ID=@id AND payment_Method=@method AND payment_Status='Pending'
                        ORDER BY payment_ID DESC", con, tx))
                    {
                        cmd.Parameters.Add("@id", SqlDbType.VarChar, 50).Value = orderId;
                        cmd.Parameters.Add("@method", SqlDbType.VarChar, 50).Value = method;
                        object existing = cmd.ExecuteScalar();
                        if (existing != null && existing != DBNull.Value)
                            pendingPaymentId = Convert.ToString(existing);
                    }
                    int highest = 0;
                    if (pendingPaymentId == null)
                        using (var cmd = new SqlCommand("SELECT payment_ID FROM dbo.Payment WITH (UPDLOCK,HOLDLOCK)", con, tx))
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string id = Convert.ToString(reader[0]);
                                int number;
                                if (id.StartsWith("PT", StringComparison.OrdinalIgnoreCase) && Int32.TryParse(id.Substring(2), out number))
                                    highest = Math.Max(highest, number);
                            }
                        }
                    string paymentId = pendingPaymentId ?? ("PT" + checked(highest + 1).ToString("D3", CultureInfo.InvariantCulture));
                    // DEMO ONLY: simulate full payment, without processing or receiving funds.
                    // Complete an existing Pending request if present; otherwise insert a new one.
                    if (pendingPaymentId != null)
                    {
                        using (var cmd = new SqlCommand(@"UPDATE dbo.Payment
SET payment_Amount=@amount, payment_Status='Paid', AmountDue=0, payment_Date=@date
WHERE payment_ID=@id AND order_ID=@order AND payment_Status='Pending'", con, tx))
                        {
                            cmd.Parameters.Add("@id", SqlDbType.VarChar, 50).Value = paymentId;
                            cmd.Parameters.Add("@order", SqlDbType.VarChar, 50).Value = orderId;
                            var amount = cmd.Parameters.Add("@amount", SqlDbType.Decimal);
                            amount.Precision = 18; amount.Scale = 2; amount.Value = remaining;
                            cmd.Parameters.Add("@date", SqlDbType.Date).Value = DateTime.Today;
                            if (cmd.ExecuteNonQuery() != 1)
                                throw new InvalidOperationException("Could not complete the existing simulated payment.");
                        }
                    }
                    else
                    {
                        using (var cmd = new SqlCommand(@"INSERT INTO dbo.Payment
(payment_ID,payment_Amount,payment_Method,payment_Status,payment_Date,order_ID,staff_ID,AmountDue)
VALUES(@id,@amount,@method,'Paid',@date,@order,NULL,0)", con, tx))
                        {
                            cmd.Parameters.Add("@id", SqlDbType.VarChar, 50).Value = paymentId;
                            var amount = cmd.Parameters.Add("@amount", SqlDbType.Decimal);
                            amount.Precision = 18; amount.Scale = 2; amount.Value = remaining;
                            cmd.Parameters.Add("@method", SqlDbType.VarChar, 50).Value = method;
                            cmd.Parameters.Add("@date", SqlDbType.Date).Value = DateTime.Today;
                            cmd.Parameters.Add("@order", SqlDbType.VarChar, 50).Value = orderId;
                            if (cmd.ExecuteNonQuery() != 1)
                                throw new InvalidOperationException("Could not save the simulated payment.");
                        }
                    }
                    using (var cmd = new SqlCommand(@"UPDATE dbo.[Order]
SET order_Status='Paid'
WHERE order_ID=@order AND customer_ID=@customer", con, tx))
                    {
                        cmd.Parameters.Add("@order", SqlDbType.VarChar, 50).Value = orderId;
                        cmd.Parameters.Add("@customer", SqlDbType.Int).Value = customerId;
                        if (cmd.ExecuteNonQuery() != 1)
                            throw new InvalidOperationException("Could not update order status.");
                    }
                    tx.Commit();
                    return new PaymentAttempt { PaymentId = paymentId, OrderId = orderId, Amount = remaining };
                }
                catch { try { tx.Rollback(); } catch { } throw; }
            }
        }

    }
}
