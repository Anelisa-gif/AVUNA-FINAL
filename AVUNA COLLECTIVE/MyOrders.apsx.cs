using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace AVUNA_COLLECTIVE
{
    public partial class MyOrders : System.Web.UI.Page
    {
        // Longest review we accept (keep this <= the size of Rating.rating_Review in your database)
        private const int MaxReviewLength = 200;

        // designFile_ID -> element id of its hidden <img> on the page
        private readonly Dictionary<string, string> _designKeys =
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        // Hidden <img> tags holding each design photo (written into the page by the .aspx)
        protected string DesignStoreHtml = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            int customerId = GetLoggedInCustomerId();
            if (customerId <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            LoadOrders(customerId);
        }

        // Login page stores the customer as Session["customer_ID"]
        private int GetLoggedInCustomerId()
        {
            int id;
            if (Session["customer_ID"] != null && int.TryParse(Session["customer_ID"].ToString(), out id))
                return id;
            return 0;
        }

        private static string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString; }
        }

        private void LoadOrders(int customerId)
        {
            string cs = ConnStr;
            var orders = new DataTable();   // one row per order      -> the 4 cards
            var items = new DataTable();    // one row per order item -> the grid

            const string ordersSql = @"
                SELECT order_ID, order_TotalCost, order_Status
                FROM [dbo].[Order]
                WHERE customer_ID = @CustomerId";

            // RowNo = 1 marks the first item row of each order, so the rating
            // button / badge is only shown once per order.
            // rating_Score is NULL until the customer has rated that order.
            const string itemsSql = @"
                SELECT o.order_ID, o.order_Date, o.order_Status,
                       oi.item, oi.DesignPackage, oi.orderItem_Quantity,
                       oi.orderItem_Size, oi.orderItem_Colour, oi.orderItem_Subtotal,
                       oi.designFile_ID,
                       ROW_NUMBER() OVER (PARTITION BY o.order_ID ORDER BY oi.orderItem_ID) AS RowNo,
                       rt.rating_Score
                FROM [dbo].[Order] o
                LEFT JOIN [dbo].[OrderItem] oi ON oi.order_ID = o.order_ID
                OUTER APPLY (SELECT TOP 1 r.rating_Score
                             FROM [dbo].[Rating] r
                             WHERE r.order_ID = o.order_ID
                             ORDER BY r.rating_Date DESC) rt
                WHERE o.customer_ID = @CustomerId
                ORDER BY o.order_Date DESC, o.order_ID DESC, oi.orderItem_ID";

            // One row per design photo that belongs to THIS customer's orders
            const string photosSql = @"
                SELECT df.designFile_ID, df.design_Photo
                FROM [dbo].[DesignFile] df
                WHERE df.design_Photo IS NOT NULL
                  AND df.designFile_ID IN (
                        SELECT oi.designFile_ID
                        FROM [dbo].[OrderItem] oi
                        INNER JOIN [dbo].[Order] o ON o.order_ID = oi.order_ID
                        WHERE o.customer_ID = @CustomerId)";

            using (var con = new SqlConnection(cs))
            {
                con.Open();

                using (var cmd = new SqlCommand(ordersSql, con))
                {
                    cmd.Parameters.AddWithValue("@CustomerId", customerId);
                    using (var da = new SqlDataAdapter(cmd)) { da.Fill(orders); }
                }
                using (var cmd = new SqlCommand(itemsSql, con))
                {
                    cmd.Parameters.AddWithValue("@CustomerId", customerId);
                    using (var da = new SqlDataAdapter(cmd)) { da.Fill(items); }
                }

                // Load the photos and build the hidden <img> tags
                var store = new StringBuilder();
                int n = 0;
                using (var cmd = new SqlCommand(photosSql, con))
                {
                    cmd.Parameters.AddWithValue("@CustomerId", customerId);
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
                            store.Append("<img id='").Append(key).Append("' src='").Append(uri).Append("' alt='' />");
                        }
                    }
                }
                DesignStoreHtml = store.ToString();
            }

            // Grid
            gvOrders.DataSource = items;
            gvOrders.DataBind();

            // Cards (counted per order, not per item)
            int total = 0, completed = 0, active = 0;
            decimal outstanding = 0m;

            foreach (DataRow r in orders.Rows)
            {
                string status = (r["order_Status"] == DBNull.Value ? "" : r["order_Status"].ToString()).Trim().ToLower();
                decimal cost = r["order_TotalCost"] == DBNull.Value ? 0m : Convert.ToDecimal(r["order_TotalCost"]);

                total++;

                if (status == "completed" || status == "delivered")
                {
                    completed++;
                }
                else if (status != "cancelled")
                {
                    active++;
                    outstanding += cost;   // not yet completed = still owed
                }
            }

            litTotal.Text = total.ToString();
            litCompleted.Text = completed.ToString();
            litActive.Text = active.ToString();
            litOutstanding.Text = "R" + outstanding.ToString("N2", CultureInfo.InvariantCulture);
        }

        // =====================================================================
        // RATINGS
        // =====================================================================

        // Rating cell: "Rate Order" button (completed + not yet rated),
        // the stars given (already rated) or a hint (not completed yet).
        // Only shown on the first row of each order.
        protected string RenderRating(object orderId, object status, object score, object rowNo)
        {
            int row;
            if (rowNo == null || rowNo == DBNull.Value || !int.TryParse(rowNo.ToString(), out row) || row != 1)
                return "";

            if (score != null && score != DBNull.Value)
            {
                int s;
                if (!int.TryParse(score.ToString(), out s)) s = 0;
                s = Math.Max(0, Math.Min(5, s));
                return "<span class='rated-badge' title='You rated this order " + s + " out of 5'>"
                     + new string('\u2605', s) + "<span class='rated-off'>" + new string('\u2605', 5 - s) + "</span>"
                     + "</span>";
            }

            if (IsCompletedStatus(status))
            {
                return "<button type='button' class='rate-order-btn' data-order='"
                     + HttpUtility.HtmlAttributeEncode(orderId.ToString()) + "'>Rate Order</button>";
            }

            return "<span class='no-design'>After completion</span>";
        }

        private static bool IsCompletedStatus(object status)
        {
            string s = status == null || status == DBNull.Value ? "" : status.ToString().Trim().ToLower();
            return s == "completed" || s == "delivered";
        }

        protected void btnSubmitRating_Click(object sender, EventArgs e)
        {
            int customerId = GetLoggedInCustomerId();
            if (customerId <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string orderId = (hfRateOrderID.Value ?? "").Trim();
            int score;
            int.TryParse(hfScore.Value, out score);
            string review = (txtReview.Text ?? "").Trim();

            string error = null;
            if (orderId.Length == 0) error = "Something went wrong. Please close this window and try again.";
            else if (score < 1 || score > 5) error = "Please choose a star rating.";
            else if (review.Length == 0) error = "Please write a short comment.";
            else if (review.Length > MaxReviewLength) error = "Your comment is too long (max " + MaxReviewLength + " characters).";
            else error = SaveRating(customerId, orderId, score, review);

            // Re-load so the grid, cards and photos are rebuilt
            LoadOrders(customerId);

            if (error != null)
            {
                lblRateError.Text = HttpUtility.HtmlEncode(error);
                // reopen the popup with what the customer already typed
                ClientScript.RegisterStartupScript(GetType(), "reopenRate",
                    "openRate('" + HttpUtility.JavaScriptStringEncode(orderId) + "', true);", true);
            }
            else
            {
                lblRateError.Text = "";
                txtReview.Text = "";
                hfScore.Value = "0";
                lblRateMsg.Text = "Thank you! Your rating for order " + HttpUtility.HtmlEncode(orderId) + " has been saved.";
                lblRateMsg.Visible = true;
            }
        }

        // Returns null on success, otherwise a message for the customer.
        private string SaveRating(int customerId, string orderId, int score, string review)
        {
            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();
                using (var tx = con.BeginTransaction(IsolationLevel.Serializable))
                {
                    try
                    {
                        // 1. The order must belong to this customer AND be completed
                        using (var chk = new SqlCommand(
                            @"SELECT COUNT(*) FROM [dbo].[Order]
                              WHERE order_ID = @oid AND customer_ID = @cid
                                AND order_Status IN ('Completed', 'Delivered')", con, tx))
                        {
                            chk.Parameters.AddWithValue("@oid", orderId);
                            chk.Parameters.AddWithValue("@cid", customerId);
                            if ((int)chk.ExecuteScalar() == 0)
                            {
                                tx.Rollback();
                                return "This order can't be rated yet.";
                            }
                        }

                        // 2. Only one rating per order
                        using (var dup = new SqlCommand(
                            "SELECT COUNT(*) FROM [dbo].[Rating] WHERE order_ID = @oid", con, tx))
                        {
                            dup.Parameters.AddWithValue("@oid", orderId);
                            if ((int)dup.ExecuteScalar() > 0)
                            {
                                tx.Rollback();
                                return "You've already rated this order.";
                            }
                        }

                        // 3. Next ID in the same style as the existing ones: RAT022 -> RAT023
                        string newId;
                        using (var next = new SqlCommand(
                            @"SELECT ISNULL(MAX(TRY_CAST(SUBSTRING(rating_ID, 4, 20) AS INT)), 0) + 1
                              FROM [dbo].[Rating] WITH (UPDLOCK, HOLDLOCK)", con, tx))
                        {
                            newId = "RAT" + Convert.ToInt32(next.ExecuteScalar()).ToString("000");
                        }

                        // 4. Save it
                        using (var ins = new SqlCommand(
                            @"INSERT INTO [dbo].[Rating] (rating_ID, rating_Date, rating_Review, rating_Score, order_ID)
                              VALUES (@id, @d, @rev, @score, @oid)", con, tx))
                        {
                            ins.Parameters.AddWithValue("@id", newId);
                            ins.Parameters.AddWithValue("@d", DateTime.Today);
                            ins.Parameters.AddWithValue("@rev", review);
                            ins.Parameters.AddWithValue("@score", score);
                            ins.Parameters.AddWithValue("@oid", orderId);
                            ins.ExecuteNonQuery();
                        }

                        tx.Commit();
                        return null;
                    }
                    catch
                    {
                        try { tx.Rollback(); } catch { }
                        return "We couldn't save your rating. Please try again.";
                    }
                }
            }
        }

        // =====================================================================
        // EXISTING HELPERS (unchanged)
        // =====================================================================

        // "View Design" button for items that have a photo; "No design" otherwise
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

        // Turns the stored bytes into a data: URL the browser can show. Returns null if it is not an image.
        private static string ToDataUri(byte[] bytes)
        {
            if (bytes == null || bytes.Length == 0) return null;

            string mime = DetectMime(bytes);

            // If the column holds Base64 text / a data:image string instead of raw bytes, decode it
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

        // Colours the status badge
        protected string GetStatusClass(object status)
        {
            string s = status == null ? "" : status.ToString();
            switch (s.Trim().ToLower())
            {
                case "delivered":
                case "completed": return "status-delivered";
                case "pending": return "status-pending";
                case "cancelled": return "status-cancelled";
                default: return "status-processing";   // InProgress etc.
            }
        }

        // Turns "InProgress" into "In Progress"
        protected string FormatStatus(object status)
        {
            string s = status == null ? "" : status.ToString().Trim();
            return Regex.Replace(s, "(?<=[a-z])(?=[A-Z])", " ");
        }
    }
}