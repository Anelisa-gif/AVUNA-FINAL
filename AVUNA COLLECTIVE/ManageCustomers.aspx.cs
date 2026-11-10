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
    public partial class ManageCustomers : System.Web.UI.Page
    {
        private class Cust
        {
            public int Id;
            public string First = "", Last = "", Type = "", Email = "", Phone = "", Street = "", House = "", Suburb = "", Town = "";
            public string Name
            {
                get
                {
                    string n = (First + " " + Last).Trim();
                    return n.Length == 0 ? "Customer #" + Id : n;
                }
            }
            public List<Ord> Orders = new List<Ord>();
        }

        private class Ord
        {
            public string Id = "";
            public int CustomerId;
            public DateTime Date;
            public string Status = "";
            public decimal Total;
            public decimal Paid;
            public List<Pay> Payments = new List<Pay>();
        }

        private class Pay
        {
            public string Id = "";
            public string OrderId = "";
            public decimal Amount;
            public string Method = "";
            public string Status = "";
            public DateTime? Date;
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

            LoadCustomers(q);
        }

        private void LoadCustomers(string q)
        {
            var problems = new List<string>();
            var customers = new List<Cust>();
            var byId = new Dictionary<int, Cust>();

            string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                try
                {
                    conn.Open();
                }
                catch (Exception ex)
                {
                    problems.Add("Could not connect to the database: " + ex.Message);
                    ShowNotice(problems);
                    litToolbar.Text = BuildToolbar(q);
                    litTableTitle.Text = "Customers";
                    litTableSubtitle.Text = "Customer data is unavailable right now.";
                    litCustomerRows.Text = EmptyRow("Customer data is unavailable right now.");
                    return;
                }

                // ---- customers ---------------------------------------------------
                try
                {
                    const string sql =
                        "SELECT customer_ID, cust_First_Name, cust_Last_Name, cust_Type, cust_Email, cust_Phone_Number, " +
                        "       cust_Street_Name, CONVERT(varchar(30), cust_House_Number), cust_Suburb, cust_Town " +
                        "FROM Customer ORDER BY cust_Last_Name, cust_First_Name";
                    using (var cmd = new SqlCommand(sql, conn))
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            var c = new Cust();
                            c.Id = r.GetInt32(0);
                            c.First = Str(r, 1);
                            c.Last = Str(r, 2);
                            c.Type = Str(r, 3);
                            c.Email = Str(r, 4);
                            c.Phone = Str(r, 5);
                            c.Street = Str(r, 6);
                            c.House = Str(r, 7);
                            c.Suburb = Str(r, 8);
                            c.Town = Str(r, 9);
                            customers.Add(c);
                            byId[c.Id] = c;
                        }
                    }
                }
                catch (Exception ex)
                {
                    problems.Add("Customers: " + ex.Message);
                }

                // ---- orders ------------------------------------------------------
                var ordersById = new Dictionary<string, Ord>(StringComparer.OrdinalIgnoreCase);
                try
                {
                    const string sql = "SELECT order_ID, order_Date, order_Status, order_TotalCost, customer_ID FROM [Order] ORDER BY order_Date DESC, order_ID DESC";
                    using (var cmd = new SqlCommand(sql, conn))
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            if (r.IsDBNull(4)) continue;
                            var o = new Ord();
                            o.Id = r.GetString(0);
                            o.Date = r.IsDBNull(1) ? DateTime.MinValue : r.GetDateTime(1);
                            o.Status = Str(r, 2);
                            o.Total = r.IsDBNull(3) ? 0m : r.GetDecimal(3);
                            o.CustomerId = r.GetInt32(4);
                            ordersById[o.Id] = o;
                            Cust c;
                            if (byId.TryGetValue(o.CustomerId, out c)) c.Orders.Add(o);
                        }
                    }
                }
                catch (Exception ex)
                {
                    problems.Add("Orders: " + ex.Message);
                }

                // ---- payments ----------------------------------------------------
                try
                {
                    const string sql = "SELECT payment_ID, payment_Amount, payment_Method, payment_Status, payment_Date, order_ID FROM Payment ORDER BY payment_Date DESC";
                    using (var cmd = new SqlCommand(sql, conn))
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            var p = new Pay();
                            p.Id = r.GetString(0);
                            p.Amount = r.IsDBNull(1) ? 0m : r.GetDecimal(1);
                            p.Method = Str(r, 2);
                            p.Status = Str(r, 3);
                            p.Date = r.IsDBNull(4) ? (DateTime?)null : r.GetDateTime(4);
                            p.OrderId = r.IsDBNull(5) ? "" : r.GetString(5);
                            Ord o;
                            if (p.OrderId.Length > 0 && ordersById.TryGetValue(p.OrderId, out o))
                            {
                                o.Payments.Add(p);
                                if (IsPaid(p.Status)) o.Paid += p.Amount;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    problems.Add("Payments: " + ex.Message);
                }
            }

            ShowNotice(problems);

            // ---- cards (always for ALL customers) --------------------------------
            int withOrders = 0;
            decimal totalOrdered = 0m, totalOwing = 0m;
            foreach (Cust c in customers)
            {
                decimal ordered, paid;
                Totals(c, out ordered, out paid);
                if (c.Orders.Count > 0) withOrders++;
                totalOrdered += ordered;
                totalOwing += Math.Max(0m, ordered - paid);
            }
            litTotalCustomers.Text = customers.Count.ToString(CultureInfo.InvariantCulture);
            litWithOrders.Text = withOrders.ToString(CultureInfo.InvariantCulture);
            litTotalOrdered.Text = Rand(totalOrdered);
            litOutstanding.Text = Rand(totalOwing);

            // ---- search ----------------------------------------------------------
            var shown = new List<Cust>();
            foreach (Cust c in customers)
            {
                if (q.Length == 0 || Matches(c, q)) shown.Add(c);
            }

            litToolbar.Text = BuildToolbar(q);
            if (q.Length == 0)
            {
                litTableTitle.Text = "All Customers";
                litTableSubtitle.Text = customers.Count + (customers.Count == 1 ? " customer" : " customers") + ", sorted by surname. Open Details to see a customer's orders and payments.";
            }
            else
            {
                litTableTitle.Text = "Search results";
                litTableSubtitle.Text = shown.Count + (shown.Count == 1 ? " customer matches " : " customers match ") + "“" + HttpUtility.HtmlEncode(q) + "”.";
            }

            var rows = new StringBuilder();
            bool autoOpen = q.Length > 0 && shown.Count == 1;
            foreach (Cust c in shown)
            {
                rows.Append(BuildRow(c, q, autoOpen));
            }
            litCustomerRows.Text = shown.Count == 0
                ? EmptyRow(q.Length == 0 ? "No customers have registered yet." : "No customer matches that search. Try a name, phone number, email, order number or payment number.")
                : rows.ToString();
        }

        // -------------------------------------------------------------------------
        private static string BuildRow(Cust c, string q, bool open)
        {
            decimal ordered, paid;
            Totals(c, out ordered, out paid);
            decimal balance = Math.Max(0m, ordered - paid);
            string idStr = c.Id.ToString(CultureInfo.InvariantCulture);

            string location = JoinNonEmpty(", ", c.Suburb, c.Town);
            var sb = new StringBuilder();

            sb.Append("<tr>")
              .Append("<td><span class=\"avuna-name\">").Append(HttpUtility.HtmlEncode(c.Name)).Append("</span><span class=\"avuna-sub\">Customer no. ").Append(idStr).Append("</span></td>")
              .Append("<td>").Append(Dash(c.Type)).Append("</td>")
              .Append("<td>").Append(Dash(c.Phone)).Append("<span class=\"avuna-sub\">").Append(HttpUtility.HtmlEncode(c.Email)).Append("</span></td>")
              .Append("<td>").Append(Dash(location)).Append("</td>")
              .Append("<td>").Append(c.Orders.Count).Append("</td>")
              .Append("<td class=\"avuna-money\">").Append(Rand(ordered)).Append("</td>")
              .Append("<td class=\"avuna-money\">").Append(Rand(paid)).Append("</td>")
              .Append("<td class=\"avuna-money ").Append(balance > 0m ? "avuna-owing" : (ordered > 0m ? "avuna-settled" : "avuna-muted")).Append("\">")
              .Append(ordered == 0m ? "-" : (balance > 0m ? Rand(balance) : "Settled")).Append("</td>")
              .Append("<td><button type=\"button\" class=\"avuna-btn-sm\" id=\"cb-").Append(idStr).Append("\" onclick=\"toggleCust(").Append(idStr).Append(")\">")
              .Append(open ? "Hide" : "Details").Append("</button></td>")
              .Append("</tr>");

            // ---- the details row (opens under the customer) ----
            sb.Append("<tr class=\"avuna-detail-row\" id=\"cd-").Append(idStr).Append("\" style=\"display:").Append(open ? "table-row" : "none").Append("\"><td colspan=\"9\">")
              .Append("<div class=\"avuna-detail-grid\">");

            sb.Append("<div><h4>CUSTOMER DETAILS</h4><dl class=\"avuna-dl\">")
              .Append(Dl("Customer no.", idStr))
              .Append(Dl("Name", c.Name))
              .Append(Dl("Type", c.Type))
              .Append(Dl("Phone", c.Phone))
              .Append(Dl("Email", c.Email))
              .Append(Dl("Address", JoinNonEmpty(" ", c.House, c.Street)))
              .Append(Dl("Suburb", c.Suburb))
              .Append(Dl("Town", c.Town))
              .Append("</dl></div>");

            sb.Append("<div><h4>ORDERS AND PAYMENTS</h4>");
            if (c.Orders.Count == 0)
            {
                sb.Append("<p class=\"avuna-muted\">This customer has not placed an order yet.</p>");
            }
            else
            {
                sb.Append("<table class=\"avuna-subtable\"><thead><tr><th>ORDER NO.</th><th>DATE</th><th>STATUS</th><th>TOTAL</th><th>PAID</th><th>PAYMENT PROGRESS</th></tr></thead><tbody>");
                foreach (Ord o in c.Orders)
                {
                    bool hit = q.Length > 0 && Has(o.Id, q);
                    int pct = o.Total <= 0m ? 0 : (int)Math.Min(100m, Math.Round(o.Paid * 100m / o.Total));
                    sb.Append("<tr").Append(hit ? " class=\"avuna-hit\"" : "").Append(">")
                      .Append("<td><strong>").Append(HttpUtility.HtmlEncode(o.Id)).Append("</strong>").Append(hit ? "<span class=\"avuna-hit-tag\">match</span>" : "").Append("</td>")
                      .Append("<td>").Append(o.Date == DateTime.MinValue ? "-" : o.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture)).Append("</td>")
                      .Append("<td><span class=\"avuna-status ").Append(OrderClass(o.Status)).Append("\">").Append(HttpUtility.HtmlEncode(o.Status)).Append("</span></td>")
                      .Append("<td class=\"avuna-money\">").Append(Rand(o.Total)).Append("</td>")
                      .Append("<td class=\"avuna-money\">").Append(Rand(o.Paid)).Append("</td>")
                      .Append("<td>").Append(ProgressBar(pct)).Append("</td>")
                      .Append("</tr>");
                }
                sb.Append("</tbody></table>");

                bool anyPay = false;
                foreach (Ord o in c.Orders) if (o.Payments.Count > 0) anyPay = true;

                if (anyPay)
                {
                    sb.Append("<table class=\"avuna-subtable\"><thead><tr><th>PAYMENT NO.</th><th>ORDER NO.</th><th>DATE</th><th>METHOD</th><th>AMOUNT</th><th>STATUS</th></tr></thead><tbody>");
                    foreach (Ord o in c.Orders)
                    {
                        foreach (Pay p in o.Payments)
                        {
                            bool hit = q.Length > 0 && Has(p.Id, q);
                            sb.Append("<tr").Append(hit ? " class=\"avuna-hit\"" : "").Append(">")
                              .Append("<td><strong>").Append(HttpUtility.HtmlEncode(p.Id)).Append("</strong>").Append(hit ? "<span class=\"avuna-hit-tag\">match</span>" : "").Append("</td>")
                              .Append("<td>").Append(HttpUtility.HtmlEncode(p.OrderId)).Append("</td>")
                              .Append("<td>").Append(p.Date.HasValue ? p.Date.Value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture) : "-").Append("</td>")
                              .Append("<td>").Append(HttpUtility.HtmlEncode(p.Method)).Append("</td>")
                              .Append("<td class=\"avuna-money\">").Append(Rand(p.Amount)).Append("</td>")
                              .Append("<td><span class=\"avuna-status ").Append(PayClass(p.Status)).Append("\">").Append(HttpUtility.HtmlEncode(p.Status)).Append("</span></td>")
                              .Append("</tr>");
                        }
                    }
                    sb.Append("</tbody></table>");
                }
                else
                {
                    sb.Append("<p class=\"avuna-muted\">No payments have been recorded for this customer's orders yet.</p>");
                }
            }
            sb.Append("</div></div></td></tr>");
            return sb.ToString();
        }

        private static void Totals(Cust c, out decimal ordered, out decimal paid)
        {
            ordered = 0m;
            paid = 0m;
            foreach (Ord o in c.Orders)
            {
                if (o.Status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase)) continue;
                ordered += o.Total;
                paid += Math.Min(o.Paid, o.Total);
            }
        }

        // A customer matches when the text is found in their details, one of their order numbers or one of their payment numbers.
        private static bool Matches(Cust c, string q)
        {
            if (Has(c.Name, q) || Has(c.First, q) || Has(c.Last, q) || Has(c.Email, q) || Has(c.Phone, q) || Has(c.Type, q) ||
                Has(c.Town, q) || Has(c.Suburb, q) || Has(c.Street, q) || Has(JoinNonEmpty(" ", c.House, c.Street), q))
                return true;

            if (c.Id.ToString(CultureInfo.InvariantCulture) == q) return true;

            string digits = DigitsOnly(q);
            if (digits.Length >= 4 && DigitsOnly(c.Phone).Contains(digits)) return true;

            foreach (Ord o in c.Orders)
            {
                if (Has(o.Id, q)) return true;
                foreach (Pay p in o.Payments)
                {
                    if (Has(p.Id, q)) return true;
                }
            }
            return false;
        }

        private static bool Has(string text, string q)
        {
            return !string.IsNullOrEmpty(text) && text.IndexOf(q, StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static string DigitsOnly(string s)
        {
            var sb = new StringBuilder();
            foreach (char ch in s ?? "") if (char.IsDigit(ch)) sb.Append(ch);
            return sb.ToString();
        }

        private static string BuildToolbar(string q)
        {
            var sb = new StringBuilder();
            sb.Append("<div class=\"avuna-toolbar\"><div class=\"avuna-search\">")
              .Append("<input type=\"text\" id=\"custSearch\" maxlength=\"80\" autocomplete=\"off\" placeholder=\"Search by name, phone, email, town, order number or payment number\" value=\"")
              .Append(HttpUtility.HtmlEncode(q)).Append("\" />")
              .Append("<button type=\"button\" onclick=\"doSearch()\">Search</button>");
            if (q.Length > 0) sb.Append("<a href=\"ManageCustomers.aspx\" class=\"avuna-clear\">Clear</a>");
            sb.Append("</div></div>");
            return sb.ToString();
        }

        // ---------------------------------------------------------------------------
        private static string Str(SqlDataReader r, int i)
        {
            return r.IsDBNull(i) ? "" : Convert.ToString(r.GetValue(i), CultureInfo.InvariantCulture).Trim();
        }

        private static string JoinNonEmpty(string sep, params string[] parts)
        {
            var list = new List<string>();
            foreach (string p in parts) if (!string.IsNullOrWhiteSpace(p)) list.Add(p.Trim());
            return string.Join(sep, list);
        }

        private static string Dash(string s)
        {
            return string.IsNullOrWhiteSpace(s) ? "<span class=\"avuna-muted\">-</span>" : HttpUtility.HtmlEncode(s);
        }

        private static string Dl(string label, string value)
        {
            return "<div><dt>" + label + "</dt><dd>" + (string.IsNullOrWhiteSpace(value) ? "-" : HttpUtility.HtmlEncode(value)) + "</dd></div>";
        }

        private static string ProgressBar(int pct)
        {
            string cls = pct >= 100 ? "" : (pct > 0 ? " avuna-progress-amber" : " avuna-progress-red");
            return "<div class=\"avuna-progress" + cls + "\"><span style=\"width:" + pct + "%\"></span></div><span class=\"avuna-progress-label\">" + pct + "% paid</span>";
        }

        // "Paid" means money received. Words like unpaid, pending, failed or refunded do not count.
        private static bool IsPaid(string status)
        {
            string s = (status ?? "").ToLowerInvariant();
            if (s.Contains("unpaid") || s.Contains("not paid") || s.Contains("pend") || s.Contains("fail") || s.Contains("declin") ||
                s.Contains("cancel") || s.Contains("refund") || s.Contains("overdue") || s.Contains("await") || s.Contains("partial"))
                return false;
            return s.Contains("paid") || s.Contains("complet") || s.Contains("success") || s.Contains("receiv") || s.Contains("approved");
        }

        private static string PayClass(string status)
        {
            string s = (status ?? "").ToLowerInvariant();
            if (IsPaid(status)) return "avuna-completed";
            if (s.Contains("unpaid") || s.Contains("fail") || s.Contains("declin") || s.Contains("cancel") || s.Contains("overdue")) return "avuna-failed";
            return "avuna-pending";
        }

        private static string OrderClass(string status)
        {
            string s = (status ?? "").ToLowerInvariant();
            if (s.Contains("complet") || s.Contains("deliver") || s.Contains("collect")) return "avuna-completed";
            if (s.Contains("cancel")) return "avuna-failed";
            if (s.Contains("progress") || s.Contains("production")) return "avuna-production";
            return "avuna-pending";
        }

        private static string Rand(decimal amount)
        {
            return "R" + amount.ToString(amount == Math.Floor(amount) ? "N0" : "N2", CultureInfo.InvariantCulture);
        }

        private static string EmptyRow(string message)
        {
            return "<tr><td colspan=\"9\" style=\"text-align:center; color:#8a7f72; padding:30px;\">" + HttpUtility.HtmlEncode(message) + "</td></tr>";
        }

        private void ShowNotice(List<string> problems)
        {
            if (problems.Count == 0) return;
            var sb = new StringBuilder("<div class=\"avuna-db-notice\"><strong>Some customer information could not be loaded from SQL Server.</strong><br />");
            foreach (string p in problems) sb.Append(HttpUtility.HtmlEncode(p)).Append("<br />");
            sb.Append("</div>");
            litDbNotice.Text = sb.ToString();
        }
    }
}
