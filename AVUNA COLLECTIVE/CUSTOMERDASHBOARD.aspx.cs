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
    public partial class CUSTOMERDASHBOARD : System.Web.UI.Page
    {
        // Text put back into the "Track an order" box after a search.
        protected string TrackValue = "";

        private class Ord
        {
            public string Id = "", Status = "";
            public DateTime Date = DateTime.MinValue;
            public decimal Total, Paid;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["customer_ID"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            int customerId;
            if (!Int32.TryParse(Convert.ToString(Session["customer_ID"]), out customerId) || customerId < 1)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string track = (Request.QueryString["track"] ?? "").Trim();
            if (track.Length > 20) track = track.Substring(0, 20);
            TrackValue = track;

            LoadDashboard(customerId, track);
        }

        private void LoadDashboard(int customerId, string track)
        {
            string problem = null;
            string firstName = "";
            var recent = new List<Ord>();
            Ord tracked = null;
            bool trackSearched = track.Length > 0;

            string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // ---- the customer's name -------------------------------------
                    using (var cmd = new SqlCommand("SELECT cust_First_Name FROM Customer WHERE customer_ID = @id", conn))
                    {
                        cmd.Parameters.AddWithValue("@id", customerId);
                        object v = cmd.ExecuteScalar();
                        if (v != null && v != DBNull.Value) firstName = Convert.ToString(v).Trim();
                    }

                    // ---- all of THIS customer's orders (newest first) ------------
                    var all = new Dictionary<string, Ord>(StringComparer.OrdinalIgnoreCase);
                    var ordered = new List<Ord>();
                    using (var cmd = new SqlCommand(
                        "SELECT order_ID, order_Date, order_Status, order_TotalCost FROM [Order] " +
                        "WHERE customer_ID = @id ORDER BY order_Date DESC, order_ID DESC", conn))
                    {
                        cmd.Parameters.AddWithValue("@id", customerId);
                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                var o = new Ord();
                                o.Id = Str(r, 0);
                                o.Date = r.IsDBNull(1) ? DateTime.MinValue : Convert.ToDateTime(r.GetValue(1), CultureInfo.InvariantCulture);
                                o.Status = Str(r, 2);
                                o.Total = r.IsDBNull(3) ? 0m : Convert.ToDecimal(r.GetValue(3), CultureInfo.InvariantCulture);
                                all[o.Id] = o;
                                ordered.Add(o);
                            }
                        }
                    }

                    // ---- money received for those orders -------------------------
                    using (var cmd = new SqlCommand(
                        "SELECT p.order_ID, p.payment_Amount, p.payment_Status FROM Payment p " +
                        "INNER JOIN [Order] o ON o.order_ID = p.order_ID WHERE o.customer_ID = @id", conn))
                    {
                        cmd.Parameters.AddWithValue("@id", customerId);
                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                Ord o;
                                if (all.TryGetValue(Str(r, 0), out o) && IsPaid(Str(r, 2)))
                                    o.Paid += r.IsDBNull(1) ? 0m : Convert.ToDecimal(r.GetValue(1), CultureInfo.InvariantCulture);
                            }
                        }
                    }

                    for (int i = 0; i < ordered.Count && i < 5; i++) recent.Add(ordered[i]);
                    if (trackSearched) all.TryGetValue(track, out tracked);
                }
            }
            catch (Exception ex)
            {
                problem = ex.Message;
            }

            litGreetName.Text = firstName.Length == 0 ? "" : ", " + HttpUtility.HtmlEncode(firstName);

            if (problem != null)
            {
                litDbNotice.Text = "<div class=\"dash-notice\"><strong>We could not load your orders right now.</strong> Please refresh the page or try again in a moment.</div>";
                litRecentSub.Text = "Your orders are unavailable right now.";
                litRecentRows.Text = EmptyRow("Your orders are unavailable right now.");
                System.Diagnostics.Trace.TraceError("Customer dashboard: " + problem);
                return;
            }

            // ---- recent orders table -------------------------------------------
            if (recent.Count == 0)
            {
                litRecentSub.Text = "You have not placed an order yet.";
                litRecentRows.Text = "<tr><td colspan=\"6\" class=\"dash-empty\">No orders yet. <a href=\"CreateOrder.aspx\" class=\"view-link\">Create your first order &rarr;</a></td></tr>";
            }
            else
            {
                litRecentSub.Text = recent.Count == 1 ? "Your most recent order." : "Your " + recent.Count + " most recent orders.";
                var sb = new StringBuilder();
                foreach (Ord o in recent)
                {
                    decimal balance = Balance(o);
                    sb.Append("<tr>")
                      .Append("<td><strong>").Append(HttpUtility.HtmlEncode(o.Id)).Append("</strong></td>")
                      .Append("<td>").Append(DateText(o.Date)).Append("</td>")
                      .Append("<td>").Append(StatusPill(o.Status)).Append("</td>")
                      .Append("<td class=\"dash-money\">").Append(Rand(o.Total)).Append("</td>")
                      .Append("<td class=\"dash-money ").Append(IsCancelled(o.Status) ? "dash-muted" : (balance > 0m ? "dash-owing" : "dash-settled")).Append("\">")
                      .Append(IsCancelled(o.Status) ? "-" : (balance > 0m ? Rand(balance) : "Paid")).Append("</td>")
                      .Append("<td><a class=\"view-link\" href=\"?track=").Append(HttpUtility.UrlEncode(o.Id)).Append("#track\">Track</a></td>")
                      .Append("</tr>");
                }
                litRecentRows.Text = sb.ToString();
            }

            // ---- track an order -------------------------------------------------
            if (!trackSearched)
            {
                litTrackResult.Text = "<p class=\"dash-hint\">Type an order number such as <strong>ORD001</strong> to see where it is.</p>";
            }
            else if (tracked == null)
            {
                litTrackResult.Text = "<div class=\"dash-notice\">We could not find order <strong>" + HttpUtility.HtmlEncode(track) + "</strong> on your account. Check the number and try again.</div>";
            }
            else
            {
                litTrackResult.Text = BuildTrackResult(tracked);
            }
        }

        // ---------------------------------------------------------------------------
        private static string BuildTrackResult(Ord o)
        {
            decimal balance = Balance(o);
            int pct = o.Total <= 0m ? 0 : (int)Math.Min(100m, Math.Round(Math.Min(o.Paid, o.Total) * 100m / o.Total));
            int step = StatusStep(o.Status);
            var sb = new StringBuilder();
            sb.Append("<div class=\"track-card\">")
              .Append("<div class=\"track-top\"><strong>").Append(HttpUtility.HtmlEncode(o.Id)).Append("</strong>").Append(StatusPill(o.Status)).Append("</div>")
              .Append("<span class=\"dash-muted\">Placed ").Append(DateText(o.Date)).Append("</span>");

            if (step == 0)
            {
                sb.Append("<p class=\"track-cancelled\">This order was cancelled.</p>");
            }
            else
            {
                sb.Append("<div class=\"track-steps\">")
                  .Append(Step("Order placed", 1, step))
                  .Append(Step("In production", 2, step))
                  .Append(Step("Completed", 3, step))
                  .Append("</div>");
            }

            sb.Append("<div class=\"track-money\"><div><span>Total</span><strong>").Append(Rand(o.Total)).Append("</strong></div>")
              .Append("<div><span>Paid</span><strong>").Append(Rand(Math.Min(o.Paid, o.Total))).Append("</strong></div>")
              .Append("<div><span>Balance</span><strong class=\"").Append(step == 0 ? "dash-muted" : (balance > 0m ? "dash-owing" : "dash-settled")).Append("\">")
              .Append(step == 0 ? "-" : (balance > 0m ? Rand(balance) : "Paid")).Append("</strong></div></div>");

            if (step != 0)
            {
                string cls = pct >= 100 ? "" : (pct > 0 ? " amber" : " red");
                sb.Append("<div class=\"track-bar").Append(cls).Append("\"><span style=\"width:").Append(pct).Append("%\"></span></div>")
                  .Append("<span class=\"dash-muted\" style=\"display:block\">").Append(pct).Append("% paid</span>");
            }
            sb.Append("<a href=\"MyOrders.aspx\" class=\"view-link\" style=\"display:inline-block;margin-top:12px\">See all details in My Orders &rarr;</a>")
              .Append("</div>");
            return sb.ToString();
        }

        private static string Step(string label, int number, int current)
        {
            string cls = number < current ? "done" : (number == current ? (current == 3 ? "done" : "current") : "");
            return "<span class=\"" + cls + "\">" + label + "</span>";
        }

        // 0 = cancelled, 1 = placed / pending, 2 = in production, 3 = completed
        private static int StatusStep(string status)
        {
            string s = (status ?? "").ToLowerInvariant();
            if (s.Contains("cancel")) return 0;
            if (s.Contains("complet") || s.Contains("deliver") || s.Contains("collect")) return 3;
            if (s.Contains("progress") || s.Contains("production") || s.Contains("process") || s.Contains("print")) return 2;
            return 1;
        }

        private static bool IsCancelled(string status)
        {
            return StatusStep(status) == 0;
        }

        private static decimal Balance(Ord o)
        {
            return IsCancelled(o.Status) ? 0m : Math.Max(0m, o.Total - o.Paid);
        }

        private static string StatusPill(string status)
        {
            int step = StatusStep(status);
            string cls = step == 0 ? "st-failed" : step == 3 ? "st-done" : step == 2 ? "st-prod" : "st-pending";
            return "<span class=\"st-pill " + cls + "\">" + HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(status) ? "Pending" : status) + "</span>";
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

        private static string DateText(DateTime d)
        {
            return d == DateTime.MinValue ? "-" : d.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
        }

        private static string Rand(decimal amount)
        {
            return "R" + amount.ToString(amount == Math.Floor(amount) ? "N0" : "N2", CultureInfo.InvariantCulture);
        }

        private static string Str(SqlDataReader r, int i)
        {
            return r.IsDBNull(i) ? "" : Convert.ToString(r.GetValue(i), CultureInfo.InvariantCulture).Trim();
        }

        private static string EmptyRow(string message)
        {
            return "<tr><td colspan=\"6\" class=\"dash-empty\">" + HttpUtility.HtmlEncode(message) + "</td></tr>";
        }
    }
}
