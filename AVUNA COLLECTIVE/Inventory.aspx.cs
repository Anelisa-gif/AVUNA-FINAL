using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.UI;

namespace AVUNA_COLLECTIVE
{
    public partial class Inventory : System.Web.UI.Page
    {
        // A variant with this many units or fewer (but more than 0) is shown as "Low stock".
        private const int LowStockLimit = 20;

        private class Variant
        {
            public int Id;
            public string ItemId = "", ItemName = "", Size = "", Colour = "";
            public int Qty;
            public decimal UnitCost;
            public bool Estimated;
            public decimal Value { get { return Qty * UnitCost; } }
            public string Status
            {
                get { return Qty <= 0 ? "Out of stock" : (Qty <= LowStockLimit ? "Low stock" : "In stock"); }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["staff_Role"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            string role = Session["staff_Role"].ToString();
            if (role != "Manager" && role != "Admin Staff")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            string fullName = ((Session["staff_First_Name"] as string ?? "") + " " + (Session["staff_Last_Name"] as string ?? "")).Trim();
            litManagerName.Text = HttpUtility.HtmlEncode(fullName.Length == 0 ? "Manager" : fullName);

            string q = (Request.QueryString["q"] ?? "").Trim();
            if (q.Length > 80) q = q.Substring(0, 80);

            string status = (Request.QueryString["status"] ?? "").Trim().ToLowerInvariant();
            if (status != "in" && status != "low" && status != "out") status = "";

            LoadInventory(q, status);
        }

        private void LoadInventory(string q, string status)
        {
            var variants = new List<Variant>();
            string problem = null;

            string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    const string sql =
                        "SELECT Variant_ID, item_ID, item_Name, Variant_Size, Variant_Colour, QuantityAvailable, UnitCost, IsEstimated " +
                        "FROM dbo.InventoryVariant ORDER BY item_Name, Variant_ID";
                    using (var cmd = new SqlCommand(sql, conn))
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            var v = new Variant();
                            v.Id = r.IsDBNull(0) ? 0 : Convert.ToInt32(r.GetValue(0), CultureInfo.InvariantCulture);
                            v.ItemId = Str(r, 1);
                            v.ItemName = Str(r, 2);
                            v.Size = Str(r, 3);
                            v.Colour = Str(r, 4);
                            v.Qty = r.IsDBNull(5) ? 0 : Convert.ToInt32(r.GetValue(5), CultureInfo.InvariantCulture);
                            v.UnitCost = r.IsDBNull(6) ? 0m : Convert.ToDecimal(r.GetValue(6), CultureInfo.InvariantCulture);
                            v.Estimated = !r.IsDBNull(7) && Convert.ToBoolean(r.GetValue(7), CultureInfo.InvariantCulture);
                            variants.Add(v);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                problem = ex.Message;
            }

            if (problem != null)
            {
                litDbNotice.Text = "<div class=\"avuna-db-notice\"><strong>Inventory could not be loaded from SQL Server.</strong><br />" + HttpUtility.HtmlEncode(problem) + "</div>";
                litToolbar.Text = BuildToolbar(q, status);
                litTableTitle.Text = "Inventory";
                litTableSubtitle.Text = "Inventory data is unavailable right now.";
                litRows.Text = EmptyRow("Inventory data is unavailable right now.");
                return;
            }

            // ---- cards (always for ALL variants) -------------------------------
            var products = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            long units = 0;
            decimal value = 0m;
            int low = 0, outOf = 0;
            bool anyEstimated = false;
            foreach (Variant v in variants)
            {
                products.Add(v.ItemId.Length > 0 ? v.ItemId : v.ItemName);
                if (v.Qty > 0) units += v.Qty;
                value += Math.Max(0, v.Qty) * v.UnitCost;
                if (v.Qty <= 0) outOf++; else if (v.Qty <= LowStockLimit) low++;
                if (v.Estimated) anyEstimated = true;
            }
            litTotalVariants.Text = variants.Count.ToString(CultureInfo.InvariantCulture);
            litItemsNote.Text = "Across " + products.Count + (products.Count == 1 ? " product" : " products");
            litTotalUnits.Text = units.ToString("N0", CultureInfo.InvariantCulture);
            litStockValue.Text = Rand(value);
            litAttention.Text = (low + outOf).ToString(CultureInfo.InvariantCulture);
            litAttentionNote.Text = low + " low, " + outOf + " out of stock";

            // ---- filter and search ---------------------------------------------
            var shown = new List<Variant>();
            foreach (Variant v in variants)
            {
                if (status == "in" && v.Qty <= LowStockLimit) continue;
                if (status == "low" && !(v.Qty > 0 && v.Qty <= LowStockLimit)) continue;
                if (status == "out" && v.Qty > 0) continue;
                if (q.Length == 0 || Matches(v, q)) shown.Add(v);
            }

            litToolbar.Text = BuildToolbar(q, status);

            string statusWords = status == "in" ? "in-stock " : (status == "low" ? "low-stock " : (status == "out" ? "out-of-stock " : ""));
            if (q.Length == 0 && status.Length == 0)
            {
                litTableTitle.Text = "All Stock";
                litTableSubtitle.Text = variants.Count + (variants.Count == 1 ? " variant" : " variants") + ", sorted by product. Low stock means " + LowStockLimit + " units or fewer."
                    + (anyEstimated ? " Costs marked \"Estimated\" have not been confirmed yet." : "");
            }
            else
            {
                litTableTitle.Text = q.Length == 0 ? "Filtered stock" : "Search results";
                litTableSubtitle.Text = shown.Count + (shown.Count == 1 ? " " + statusWords + "variant" : " " + statusWords + "variants")
                    + (q.Length == 0 ? " shown." : " match “" + HttpUtility.HtmlEncode(q) + "”.");
            }

            var rows = new StringBuilder();
            foreach (Variant v in shown) rows.Append(BuildRow(v));
            litRows.Text = shown.Count == 0
                ? EmptyRow(variants.Count == 0 ? "No inventory has been added yet." : "No stock matches that search. Try a product, size, colour or variant number.")
                : rows.ToString();
        }

        // ---------------------------------------------------------------------------
        private static string BuildRow(Variant v)
        {
            string cls = v.Qty <= 0 ? "avuna-failed" : (v.Qty <= LowStockLimit ? "avuna-pending" : "avuna-completed");
            string barCls = v.Qty <= 0 ? " avuna-stockbar-red" : (v.Qty <= LowStockLimit ? " avuna-stockbar-amber" : "");
            int pct = (int)Math.Min(100, Math.Max(0, v.Qty) * 100 / 200);   // bar is full at 200 units
            if (v.Qty > 0 && pct < 4) pct = 4;

            var sb = new StringBuilder();
            sb.Append("<tr>")
              .Append("<td><span class=\"avuna-name\">#").Append(v.Id.ToString(CultureInfo.InvariantCulture)).Append("</span></td>")
              .Append("<td><span class=\"avuna-name\">").Append(Dash(v.ItemName)).Append("</span><span class=\"avuna-sub\">Item ").Append(HttpUtility.HtmlEncode(v.ItemId)).Append("</span></td>")
              .Append("<td>").Append(v.Size.Length == 0 ? "<span class=\"avuna-muted\">-</span>" : "<span class=\"avuna-size\">" + HttpUtility.HtmlEncode(v.Size) + "</span>").Append("</td>")
              .Append("<td>").Append(v.Colour.Length == 0 ? "<span class=\"avuna-muted\">-</span>" : "<span class=\"avuna-swatch\" style=\"background:" + Swatch(v.Colour) + "\"></span>" + HttpUtility.HtmlEncode(v.Colour)).Append("</td>")
              .Append("<td class=\"num\"><span class=\"avuna-qty\">").Append(v.Qty.ToString("N0", CultureInfo.InvariantCulture)).Append("</span>")
              .Append("<div class=\"avuna-stockbar").Append(barCls).Append("\"><span style=\"width:").Append(pct).Append("%\"></span></div></td>")
              .Append("<td class=\"num avuna-money\">").Append(Rand(v.UnitCost)).Append(v.Estimated ? "<span class=\"avuna-est\">Estimated</span>" : "").Append("</td>")
              .Append("<td class=\"num avuna-money\">").Append(Rand(v.Value)).Append("</td>")
              .Append("<td><span class=\"avuna-status ").Append(cls).Append("\">").Append(v.Status).Append("</span></td>")
              .Append("</tr>");
            return sb.ToString();
        }

        // A variant matches when the text is found in its product, size, colour, item number, variant number or stock status.
        private static bool Matches(Variant v, string q)
        {
            if (Has(v.ItemName, q) || Has(v.ItemId, q) || Has(v.Size, q) || Has(v.Colour, q) || Has(v.Status, q)) return true;
            if (v.Id.ToString(CultureInfo.InvariantCulture) == q.TrimStart('#')) return true;
            if (v.Estimated && Has("estimated", q)) return true;
            if (Has(v.ItemName + " " + v.Colour, q) || Has(v.ItemName + " " + v.Size, q) || Has(v.Colour + " " + v.ItemName, q)) return true;
            return false;
        }

        private static bool Has(string text, string q)
        {
            return !string.IsNullOrEmpty(text) && text.IndexOf(q, StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static string BuildToolbar(string q, string status)
        {
            var sb = new StringBuilder();
            sb.Append("<div class=\"avuna-toolbar\"><div class=\"avuna-search\">")
              .Append("<input type=\"text\" id=\"invSearch\" maxlength=\"80\" autocomplete=\"off\" placeholder=\"Search by product, size, colour, item number or variant number\" value=\"")
              .Append(HttpUtility.HtmlEncode(q)).Append("\" />")
              .Append("<input type=\"hidden\" id=\"invStatus\" value=\"").Append(status).Append("\" />")
              .Append("<button type=\"button\" onclick=\"doSearch()\">Search</button>");
            if (q.Length > 0 || status.Length > 0) sb.Append("<a href=\"Inventory.aspx\" class=\"avuna-clear\">Clear</a>");
            sb.Append("</div><div class=\"avuna-filters\">")
              .Append(Chip("", "All stock", status, q))
              .Append(Chip("in", "In stock", status, q))
              .Append(Chip("low", "Low stock", status, q))
              .Append(Chip("out", "Out of stock", status, q))
              .Append("</div></div>");
            return sb.ToString();
        }

        private static string Chip(string value, string label, string current, string q)
        {
            var parts = new List<string>();
            if (q.Length > 0) parts.Add("q=" + HttpUtility.UrlEncode(q));
            if (value.Length > 0) parts.Add("status=" + value);
            string href = "Inventory.aspx" + (parts.Count > 0 ? "?" + string.Join("&", parts) : "");
            return "<a class=\"avuna-chip" + (value == current ? " active" : "") + "\" href=\"" + href + "\">" + label + "</a>";
        }

        private static string Swatch(string colour)
        {
            switch ((colour ?? "").Trim().ToLowerInvariant())
            {
                case "black": return "#1a1a1a";
                case "white": return "#ffffff";
                case "blue": return "#2f5fb3";
                case "navy": case "navy blue": return "#1c2a5a";
                case "red": return "#c0392b";
                case "green": return "#2f8f5b";
                case "orange": return "#e8801f";
                case "yellow": return "#f2c230";
                case "brown": return "#7b4a2a";
                case "grey": case "gray": return "#9a9a9a";
                case "pink": return "#e58fb0";
                case "purple": return "#7b4fa0";
                case "maroon": return "#6e1f2b";
                case "beige": case "cream": return "#e8dcc0";
                default: return "#d8d0c0";
            }
        }

        // ---------------------------------------------------------------------------
        private static string Str(SqlDataReader r, int i)
        {
            return r.IsDBNull(i) ? "" : Convert.ToString(r.GetValue(i), CultureInfo.InvariantCulture).Trim();
        }

        private static string Dash(string s)
        {
            return string.IsNullOrWhiteSpace(s) ? "<span class=\"avuna-muted\">-</span>" : HttpUtility.HtmlEncode(s);
        }

        private static string Rand(decimal amount)
        {
            return "R" + amount.ToString(amount == Math.Floor(amount) ? "N0" : "N2", CultureInfo.InvariantCulture);
        }

        private static string EmptyRow(string message)
        {
            return "<tr><td colspan=\"8\" style=\"text-align:center; color:#8a7f72; padding:30px;\">" + HttpUtility.HtmlEncode(message) + "</td></tr>";
        }
    }
}

