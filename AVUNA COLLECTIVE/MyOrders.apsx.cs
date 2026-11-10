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

        private void LoadOrders(int customerId)
        {
            string cs = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            var orders = new DataTable();   // one row per order      -> the 4 cards
            var items = new DataTable();    // one row per order item -> the grid

            const string ordersSql = @"
                SELECT order_ID, order_TotalCost, order_Status
                FROM [dbo].[Order]
                WHERE customer_ID = @CustomerId";

            const string itemsSql = @"
                SELECT o.order_ID, o.order_Date, o.order_Status,
                       oi.item, oi.DesignPackage, oi.orderItem_Quantity,
                       oi.orderItem_Size, oi.orderItem_Colour, oi.orderItem_Subtotal,
                       oi.designFile_ID
                FROM [dbo].[Order] o
                LEFT JOIN [dbo].[OrderItem] oi ON oi.order_ID = o.order_ID
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