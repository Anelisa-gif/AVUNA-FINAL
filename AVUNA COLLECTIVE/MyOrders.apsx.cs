using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

namespace AVUNA_COLLECTIVE
{
    public partial class MyOrders : System.Web.UI.Page
    {
        private readonly Dictionary<string, string> _designKeys =
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        // Existing ASPX page uses this to show design images.
        protected string DesignStoreHtml = "";

        // Bind the viewstate to this visitor's session to reduce forged postbacks.
        protected override void OnInit(EventArgs e)
        {
            if (Session != null) ViewStateUserKey = Session.SessionID;
            base.OnInit(e);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int customerId = GetLoggedInCustomerId();
            if (customerId <= 0)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadOrders(customerId);

                string cancelledId = Session["AvunaCancelledOrderId"] as string;
                if (!String.IsNullOrEmpty(cancelledId))
                {
                    Session.Remove("AvunaCancelledOrderId");
                    ShowPopup("Order Cancelled Successfully!",
                        "Order " + cancelledId + " was moved to ArchivedOrder, and its reserved stock was returned to inventory.", true);
                }
            }
        }

        // Called by the confirmation button in the centred modal.
        protected void btnConfirmCancel_Click(object sender, EventArgs e)
        {
            int customerId = GetLoggedInCustomerId();
            if (customerId <= 0)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            string orderId = (Request.Form["avunaCancelOrderId"] ?? "").Trim();
            if (orderId.Length == 0 || orderId.Length > 50)
            {
                LoadOrders(customerId);
                ShowPopup("Cancellation not completed", "Please select a valid order.", false);
                return;
            }

            try
            {
                CancelPendingOrder(customerId, orderId);
                // Redirect after POST prevents refreshing the page from cancelling twice.
                Session["AvunaCancelledOrderId"] = orderId;
                Response.Redirect(Request.Path, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (InvalidOperationException ex)
            {
                LoadOrders(customerId);
                ShowPopup("Cancellation not completed", ex.Message, false);
            }
            catch (SqlException)
            {
                LoadOrders(customerId);
                ShowPopup("Cancellation not completed", "The database could not cancel this order. Please try again.", false);
            }
        }

        // Uses the SAME transaction for status changes and both stock tables.
        // Only Pending orders belonging to the current customer can be cancelled.
        private static void CancelPendingOrder(int customerId, string orderId)
        {
            string cs = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            using (var con = new SqlConnection(cs))
            {
                con.Open();
                using (var tx = con.BeginTransaction(IsolationLevel.Serializable))
                {
                    try
                    {
                        string status;
                        using (var cmd = new SqlCommand(@"
                            SELECT order_Status
                            FROM dbo.[Order] WITH (UPDLOCK, HOLDLOCK)
                            WHERE order_ID = @OrderId AND customer_ID = @CustomerId", con, tx))
                        {
                            cmd.Parameters.Add("@OrderId", SqlDbType.VarChar, 50).Value = orderId;
                            cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = customerId;
                            object result = cmd.ExecuteScalar();
                            if (result == null || result == DBNull.Value)
                                throw new InvalidOperationException("Order not found in your account.");
                            status = Convert.ToString(result).Trim();
                        }

                        if (!String.Equals(status, "Pending", StringComparison.OrdinalIgnoreCase))
                            throw new InvalidOperationException(
                                "Only Pending orders can be cancelled. In Progress, Completed and Cancelled orders cannot be cancelled.");

                        // Do not erase/"refund" a payment that has already been recorded as paid.
                        // Pending requests (including Pay Now simulations not yet completed)
                        // can be archived; paid or partial payments require staff handling.
                        using (var cmd = new SqlCommand(@"
                            SELECT COUNT(*) FROM dbo.Payment WITH (UPDLOCK, HOLDLOCK)
                            WHERE order_ID=@OrderId
                              AND (payment_Status IS NULL OR
                                   UPPER(LTRIM(RTRIM(payment_Status))) <> 'PENDING')", con, tx))
                        {
                            cmd.Parameters.Add("@OrderId", SqlDbType.VarChar, 50).Value = orderId;
                            if (Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                                throw new InvalidOperationException(
                                    "This order has a recorded payment. Contact staff for cancellation/refund.");
                        }

                        // The new CreateOrder flow deducts inventory when saving orders.
                        // Existing/seeded orders with missing variants are rejected rather than inflating stock.
                        const string restoreSql = @"
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM dbo.OrderItem WHERE order_ID = @OrderId)
    THROW 50011, 'Cannot restore stock: this order has no order items.', 1;

IF EXISTS (
    SELECT 1
    FROM dbo.OrderItem oi
    LEFT JOIN dbo.InventoryVariant v ON oi.Variant_ID = v.Variant_ID
    LEFT JOIN dbo.Inventory i ON v.item_ID = i.item_ID
    WHERE oi.order_ID = @OrderId
      AND (oi.Variant_ID IS NULL OR v.Variant_ID IS NULL OR i.item_ID IS NULL
           OR oi.orderItem_Quantity IS NULL OR oi.orderItem_Quantity <= 0)
)
    THROW 50012, 'Cannot restore stock: one or more order items lack a valid variant.', 1;

CREATE TABLE #RestoreVariant (Variant_ID INT NOT NULL PRIMARY KEY, Qty INT NOT NULL);
INSERT INTO #RestoreVariant(Variant_ID, Qty)
SELECT oi.Variant_ID, SUM(oi.orderItem_Quantity)
FROM dbo.OrderItem oi
WHERE oi.order_ID = @OrderId
GROUP BY oi.Variant_ID;

UPDATE v
SET v.QuantityAvailable = v.QuantityAvailable + r.Qty
FROM dbo.InventoryVariant v
JOIN #RestoreVariant r ON r.Variant_ID = v.Variant_ID;

IF @@ROWCOUNT <> (SELECT COUNT(*) FROM #RestoreVariant)
    THROW 50013, 'Could not restore variant stock.', 1;

CREATE TABLE #RestoreItem (item_ID VARCHAR(50) NOT NULL PRIMARY KEY, Qty INT NOT NULL);
INSERT INTO #RestoreItem(item_ID, Qty)
SELECT v.item_ID, SUM(r.Qty)
FROM #RestoreVariant r
JOIN dbo.InventoryVariant v ON v.Variant_ID = r.Variant_ID
GROUP BY v.item_ID;

UPDATE i
SET i.quantityAvailable = i.quantityAvailable + r.Qty
FROM dbo.Inventory i
JOIN #RestoreItem r ON r.item_ID = i.item_ID;

IF @@ROWCOUNT <> (SELECT COUNT(*) FROM #RestoreItem)
    THROW 50014, 'Could not restore inventory stock.', 1;

";
                        using (var cmd = new SqlCommand(restoreSql, con, tx))
                        {
                            cmd.Parameters.Add("@OrderId", SqlDbType.VarChar, 50).Value = orderId;
                            cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = customerId;
                            cmd.CommandTimeout = 30;
                            cmd.ExecuteNonQuery();
                        }

                        // Archive the parent order before the children, allowing archives
                        // that enforce foreign keys from ArchivedOrderItem to ArchivedOrder.
                        // All copies/deletes share the same SQL transaction.
                        ArchiveRows(con, tx, "Order", "ArchivedOrder", orderId,
                            "order_Status", "Cancelled", 1);
                        ArchiveRows(con, tx, "OrderItem", "ArchivedOrderItem", orderId,
                            "orderItem_Status", "Cancelled", -1);
                        ArchiveRows(con, tx, "Payment", "ArchivedPayment", orderId,
                            null, null, -1);

                        // Paid/partially paid transactions cannot be silently cancelled:
                        // they require a separate refund / staff review workflow.
                        // This is checked before any archive or stock update below.

                        DeleteOrderRows(con, tx, "Payment", orderId);
                        DeleteOrderRows(con, tx, "OrderItem", orderId);

                        // A Customer may also hold a pointer to their latest order.
                        using (var cmd = new SqlCommand(@"
                            UPDATE dbo.Customer SET order_ID = NULL
                            WHERE customer_ID=@CustomerId AND order_ID=@OrderId", con, tx))
                        {
                            cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = customerId;
                            cmd.Parameters.Add("@OrderId", SqlDbType.VarChar, 50).Value = orderId;
                            cmd.ExecuteNonQuery();
                        }

                        using (var cmd = new SqlCommand(@"
                            DELETE FROM dbo.[Order]
                            WHERE order_ID=@OrderId AND customer_ID=@CustomerId
                              AND LTRIM(RTRIM(order_Status))='Pending'", con, tx))
                        {
                            cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = customerId;
                            cmd.Parameters.Add("@OrderId", SqlDbType.VarChar, 50).Value = orderId;
                            if (cmd.ExecuteNonQuery() != 1)
                                throw new InvalidOperationException("Order changed during cancellation.");
                        }

                        tx.Commit();
                    }
                    catch
                    {
                        try { tx.Rollback(); } catch { }
                        throw;
                    }
                }
            }
        }

        // Copy every non-computed source field to the matching archive field.
        // Stop if an archive table is absent or incompatible instead of losing data.
        private static void ArchiveRows(SqlConnection con, SqlTransaction tx,
            string sourceTable, string archiveTable, string orderId,
            string statusColumn, string archiveStatus, int expectedRows)
        {
            // Table names are fixed by server-side code, never supplied by the browser.
            string sourceName = "dbo." + sourceTable;
            string destName = "dbo." + archiveTable;
            var sourceColumns = new List<string>();
            var destColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            const string columnSql = @"
                SELECT c.name
                FROM sys.columns c
                WHERE c.object_id=OBJECT_ID(@tableName)
                  AND c.is_computed=0
                  AND c.system_type_id<>189
                  AND c.is_identity=0
                ORDER BY c.column_id";
            foreach (var table in new[] { sourceName, destName })
            {
                using (var cmd = new SqlCommand(columnSql, con, tx))
                {
                    cmd.Parameters.Add("@tableName", SqlDbType.NVarChar, 256).Value = table;
                    using (var rd = cmd.ExecuteReader())
                        while (rd.Read())
                        {
                            if (table == sourceName) sourceColumns.Add(rd.GetString(0));
                            else destColumns.Add(rd.GetString(0));
                        }
                }
            }
            if (sourceColumns.Count == 0 || destColumns.Count == 0)
                throw new InvalidOperationException("Missing archive table: " + destName + ".");
            foreach (string column in sourceColumns)
                if (!destColumns.Contains(column))
                    throw new InvalidOperationException(
                        destName + " does not have the required column " + column + ".");

            var insertCols = new List<string>();
            var selectCols = new List<string>();
            foreach (string column in sourceColumns)
            {
                insertCols.Add(QuoteColumn(column));
                selectCols.Add(String.Equals(column, statusColumn, StringComparison.OrdinalIgnoreCase)
                    ? "@ArchiveStatus"
                    : "s." + QuoteColumn(column));
            }
            string sql = "INSERT INTO dbo." + QuoteColumn(archiveTable) + " (" +
                String.Join(",", insertCols) + ") SELECT " +
                String.Join(",", selectCols) + " FROM dbo." + QuoteColumn(sourceTable) +
                " s WHERE s.order_ID=@OrderId";
            using (var cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.Add("@OrderId", SqlDbType.VarChar, 50).Value = orderId;
                if (statusColumn != null)
                    cmd.Parameters.Add("@ArchiveStatus", SqlDbType.VarChar, 30).Value = archiveStatus;
                int copied = cmd.ExecuteNonQuery();
                if (expectedRows >= 0 && copied != expectedRows)
                    throw new InvalidOperationException("Archive row count does not match for " + sourceTable + ".");
            }
        }

        private static string QuoteColumn(string name)
        {
            return "[" + name.Replace("]", "]]") + "]";
        }

        private static void DeleteOrderRows(SqlConnection con, SqlTransaction tx,
            string table, string orderId)
        {
            // Only the two predefined child tables are permitted here.
            if (table != "Payment" && table != "OrderItem")
                throw new InvalidOperationException("Invalid deletion target.");
            using (var cmd = new SqlCommand(
                "DELETE FROM dbo.[" + table + "] WHERE order_ID=@OrderId", con, tx))
            {
                cmd.Parameters.Add("@OrderId", SqlDbType.VarChar, 50).Value = orderId;
                cmd.ExecuteNonQuery();
            }
        }

        private void ShowPopup(string heading, string message, bool success)
        {
            string js = "window.addEventListener('load', function(){" +
                        "avunaShowNotice('" + HttpUtility.JavaScriptStringEncode(heading) +
                        "','" + HttpUtility.JavaScriptStringEncode(message) +
                        "'," + (success ? "true" : "false") + ");});";
            ClientScript.RegisterStartupScript(GetType(), "avunaCancelNotice", js, true);
        }

        // Login page stores the customer as Session["customer_ID"].
        private int GetLoggedInCustomerId()
        {
            int id;
            if (Session["customer_ID"] != null &&
                int.TryParse(Session["customer_ID"].ToString(), out id)) return id;
            return 0;
        }

        private void LoadOrders(int customerId)
        {
            string cs = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            var orders = new DataTable();
            var items = new DataTable();

            const string ordersSql = @"
                SELECT order_ID, order_TotalCost, order_Status
                FROM [dbo].[Order]
                WHERE customer_ID = @CustomerId";

            const string itemsSql = @"
                SELECT o.order_ID, o.order_Date, o.order_Status,
                       oi.item, oi.DesignPackage, oi.orderItem_Quantity,
                       oi.orderItem_Size, oi.orderItem_Colour, oi.orderItem_Subtotal,
                       oi.designFile_ID,
                       ROW_NUMBER() OVER(PARTITION BY o.order_ID ORDER BY oi.orderItem_ID) AS ItemRowNumber
                FROM [dbo].[Order] o
                LEFT JOIN [dbo].[OrderItem] oi ON oi.order_ID = o.order_ID
                WHERE o.customer_ID = @CustomerId
                ORDER BY o.order_Date DESC, o.order_ID DESC, oi.orderItem_ID";

            const string photosSql = @"
                SELECT df.designFile_ID, df.design_Photo
                FROM [dbo].[DesignFile] df
                WHERE df.design_Photo IS NOT NULL
                  AND df.designFile_ID IN (
                        SELECT oi.designFile_ID
                        FROM [dbo].[OrderItem] oi
                        INNER JOIN [dbo].[Order] o ON o.order_ID = oi.order_ID
                        WHERE o.customer_ID = @CustomerId)";

            _designKeys.Clear();
            using (var con = new SqlConnection(cs))
            {
                con.Open();
                using (var cmd = new SqlCommand(ordersSql, con))
                {
                    cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = customerId;
                    using (var da = new SqlDataAdapter(cmd)) { da.Fill(orders); }
                }
                using (var cmd = new SqlCommand(itemsSql, con))
                {
                    cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = customerId;
                    using (var da = new SqlDataAdapter(cmd)) { da.Fill(items); }
                }

                var store = new StringBuilder();
                int n = 0;
                using (var cmd = new SqlCommand(photosSql, con))
                {
                    cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = customerId;
                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            string id = rd[0].ToString();
                            byte[] bytes = rd[1] == DBNull.Value ? null : (byte[])rd[1];
                            string uri = ToDataUri(bytes);
                            if (uri == null || _designKeys.ContainsKey(id)) continue;
                            string key = "dfimg_" + n++;
                            _designKeys[id] = key;
                            store.Append("<img id='").Append(key).Append("' src='")
                                 .Append(uri).Append("' alt='' />");
                        }
                    }
                }
                DesignStoreHtml = store.ToString();
            }

            gvOrders.DataSource = items;
            gvOrders.DataBind();

            int total = 0, completed = 0, active = 0;
            decimal outstanding = 0m;
            foreach (DataRow r in orders.Rows)
            {
                string status = (r["order_Status"] == DBNull.Value ? "" : r["order_Status"].ToString()).Trim().ToLowerInvariant();
                decimal cost = r["order_TotalCost"] == DBNull.Value ? 0m : Convert.ToDecimal(r["order_TotalCost"]);
                total++;
                if (status == "completed" || status == "delivered") completed++;
                else if (status != "cancelled")
                {
                    active++;
                    outstanding += cost;  // Preserved from your existing page.
                }
            }
            litTotal.Text = total.ToString();
            litCompleted.Text = completed.ToString();
            litActive.Text = active.ToString();
            litOutstanding.Text = "R" + outstanding.ToString("N2", CultureInfo.InvariantCulture);
        }

        // Only show ONE Cancel button per pending order (even if it contains multiple items).
        protected string RenderCancel(object status, object orderId, object rowNumber)
        {
            if (status == null || orderId == null || rowNumber == null ||
                !String.Equals(Convert.ToString(status).Trim(), "Pending", StringComparison.OrdinalIgnoreCase) ||
                Convert.ToInt32(rowNumber) != 1)
                return "<span class='no-design'>—</span>";

            return "<button type='button' class='cancel-order-btn' data-order='" +
                   HttpUtility.HtmlAttributeEncode(Convert.ToString(orderId)) +
                   "'>Cancel Order</button>";
        }

        protected string RenderDesign(object designFileId, object orderId, object item)
        {
            string key;
            if (designFileId == null || designFileId == DBNull.Value
                || !_designKeys.TryGetValue(designFileId.ToString(), out key))
                return "<span class='no-design'>No design</span>";

            string title = "Order " + orderId + (item == null || item == DBNull.Value ? "" : " - " + item);
            return "<button type='button' class='view-design-btn' data-img='" + key
                 + "' data-title='" + HttpUtility.HtmlAttributeEncode(title) + "'>View Design</button>";
        }

        private static string ToDataUri(byte[] bytes)
        {
            if (bytes == null || bytes.Length == 0) return null;
            string mime = DetectMime(bytes);
            if (mime == null)
            {
                try
                {
                    string t = Encoding.ASCII.GetString(bytes).Trim();
                    int comma = t.IndexOf(',');
                    if (t.StartsWith("data:", StringComparison.OrdinalIgnoreCase) && comma > 0)
                        t = t.Substring(comma + 1);
                    byte[] decoded = Convert.FromBase64String(t);
                    mime = DetectMime(decoded);
                    if (mime != null) bytes = decoded;
                }
                catch { return null; }
            }
            return mime == null ? null : "data:" + mime + ";base64," + Convert.ToBase64String(bytes);
        }

        private static string DetectMime(byte[] b)
        {
            if (b.Length > 3 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47) return "image/png";
            if (b.Length > 2 && b[0] == 0xFF && b[1] == 0xD8) return "image/jpeg";
            if (b.Length > 3 && b[0] == 0x47 && b[1] == 0x49 && b[2] == 0x46) return "image/gif";
            if (b.Length > 1 && b[0] == 0x42 && b[1] == 0x4D) return "image/bmp";
            if (b.Length > 11 && b[0] == 0x52 && b[1] == 0x49 && b[8] == 0x57 && b[9] == 0x45) return "image/webp";
            return null;
        }

        protected string GetStatusClass(object status)
        {
            string s = status == null ? "" : status.ToString();
            switch (s.Trim().ToLowerInvariant())
            {
                case "delivered":
                case "completed": return "status-delivered";
                case "pending": return "status-pending";
                case "cancelled": return "status-cancelled";
                default: return "status-processing";
            }
        }

        protected string FormatStatus(object status)
        {
            string s = status == null ? "" : status.ToString().Trim();
            return Regex.Replace(s, "(?<=[a-z])(?=[A-Z])", " ");
        }
    }
}
