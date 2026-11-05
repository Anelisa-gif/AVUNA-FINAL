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
    public partial class ManageOrders : System.Web.UI.Page
    {
        // Orders with these statuses are finished (or cancelled), so they are NOT "pending".
        // Keep this the same as FinishedStatuses on the manager dashboard.
        private static readonly string[] FinishedStatuses = { "Completed", "Delivered", "Collected", "Cancelled" };

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

            // ManageOrders.aspx?view=pending shows only the orders that are not finished yet.
            bool pendingOnly = string.Equals(Request.QueryString["view"], "pending", StringComparison.OrdinalIgnoreCase);

            LoadOrders(pendingOnly);
        }

        private void LoadOrders(bool pendingOnly)
        {
            string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            var problems = new List<string>();

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
                    BuildHeader(pendingOnly, 0);
                    litOrderRows.Text = EmptyRow("Order data is unavailable right now.");
                    return;
                }

                // ---- Counts by status (the four cards) --------------------------
                int unfinished = 0;
                try
                {
                    int total = 0, pending = 0, inProgress = 0, completed = 0;

                    using (var cmd = new SqlCommand("SELECT order_Status, COUNT(*) FROM [Order] GROUP BY order_Status", conn))
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            string status = r.IsDBNull(0) ? "" : r.GetString(0).Trim();
                            int count = r.GetInt32(1);
                            total += count;

                            if (status.Equals("Pending", StringComparison.OrdinalIgnoreCase)) pending += count;
                            else if (status.Equals("In Progress", StringComparison.OrdinalIgnoreCase)) inProgress += count;
                            else if (status.Equals("Completed", StringComparison.OrdinalIgnoreCase)) completed += count;

                            if (!IsFinished(status)) unfinished += count;
                        }
                    }

                    litTotalOrders.Text = total.ToString("N0", CultureInfo.InvariantCulture);
                    litPendingCount.Text = pending.ToString("N0", CultureInfo.InvariantCulture);
                    litInProgressCount.Text = inProgress.ToString("N0", CultureInfo.InvariantCulture);
                    litCompletedCount.Text = completed.ToString("N0", CultureInfo.InvariantCulture);
                }
                catch (Exception ex)
                {
                    problems.Add("Order counts: " + ex.Message);
                }

                // ---- Order details table ----------------------------------------
                int shown = 0;
                try
                {
                    string sql =
                        "SELECT o.order_ID, o.order_Date, o.order_Status, o.order_TotalCost, " +
                        "       c.cust_First_Name, c.cust_Last_Name, c.cust_Phone_Number, p.payment_Status " +
                        "FROM [Order] o " +
                        "LEFT JOIN Customer c ON c.customer_ID = o.customer_ID " +
                        "OUTER APPLY (SELECT TOP 1 payment_Status FROM Payment " +
                        "             WHERE Payment.order_ID = o.order_ID ORDER BY payment_Date DESC) p ";

                    if (pendingOnly)
                    {
                        var names = new string[FinishedStatuses.Length];
                        for (int i = 0; i < names.Length; i++) names[i] = "@f" + i;
                        sql += "WHERE o.order_Status NOT IN (" + string.Join(", ", names) + ") ";
                    }

                    sql += "ORDER BY o.order_Date DESC, o.order_ID DESC";

                    var rows = new StringBuilder();
                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        if (pendingOnly)
                        {
                            for (int i = 0; i < FinishedStatuses.Length; i++)
                                cmd.Parameters.AddWithValue("@f" + i, FinishedStatuses[i]);
                        }

                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                shown++;

                                string orderId = r.GetString(0);
                                DateTime date = r.GetDateTime(1);
                                string status = r.IsDBNull(2) ? "" : r.GetString(2);
                                decimal totalCost = r.IsDBNull(3) ? 0m : r.GetDecimal(3);
                                string first = r.IsDBNull(4) ? "" : r.GetString(4);
                                string last = r.IsDBNull(5) ? "" : r.GetString(5);
                                string phone = r.IsDBNull(6) ? "" : r.GetString(6);
                                string payment = r.IsDBNull(7) ? "No payment yet" : r.GetString(7);

                                string customer = (first + " " + last).Trim();
                                if (customer.Length == 0) customer = "Unknown customer";

                                rows.Append("<tr>")
                                    .Append("<td class=\"avuna-order-number\">").Append(HttpUtility.HtmlEncode(orderId)).Append("</td>")
                                    .Append("<td>").Append(HttpUtility.HtmlEncode(customer)).Append("</td>")
                                    .Append("<td>").Append(HttpUtility.HtmlEncode(phone)).Append("</td>")
                                    .Append("<td>").Append(date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture)).Append("</td>")
                                    .Append("<td><span class=\"avuna-status ").Append(StatusClass(status)).Append("\">").Append(HttpUtility.HtmlEncode(status)).Append("</span></td>")
                                    .Append("<td>").Append(FormatRand(totalCost)).Append("</td>")
                                    .Append("<td>").Append(HttpUtility.HtmlEncode(payment)).Append("</td>")
                                    .Append("</tr>");
                            }
                        }
                    }

                    litOrderRows.Text = shown == 0
                        ? EmptyRow(pendingOnly ? "There are no pending orders right now." : "No orders have been placed yet.")
                        : rows.ToString();
                }
                catch (Exception ex)
                {
                    problems.Add("Order details: " + ex.Message);
                    litOrderRows.Text = EmptyRow("Order details could not be loaded.");
                }

                BuildHeader(pendingOnly, shown);
            }

            ShowNotice(problems);
        }

        private void BuildHeader(bool pendingOnly, int shown)
        {
            if (pendingOnly)
            {
                litTableTitle.Text = "Pending Orders";
                litTableSubtitle.Text = shown + (shown == 1 ? " order is" : " orders are") + " not finished yet (Pending or In Progress), newest first.";
                litToggleLink.Text = "<a href=\"ManageOrders.aspx\" class=\"avuna-view-all\">View all orders &rarr;</a>";
            }
            else
            {
                litTableTitle.Text = "All Orders";
                litTableSubtitle.Text = "A full view of customer orders and their current status, newest first.";
                litToggleLink.Text = "<a href=\"ManageOrders.aspx?view=pending\" class=\"avuna-view-all\">View pending orders only &rarr;</a>";
            }
        }

        private static bool IsFinished(string status)
        {
            foreach (string f in FinishedStatuses)
            {
                if (f.Equals(status, StringComparison.OrdinalIgnoreCase)) return true;
            }
            return false;
        }

        private static string StatusClass(string status)
        {
            if (status.Equals("Completed", StringComparison.OrdinalIgnoreCase)) return "avuna-completed";
            if (status.Equals("In Progress", StringComparison.OrdinalIgnoreCase)) return "avuna-production";
            return "avuna-pending";
        }

        private static string FormatRand(decimal amount)
        {
            return "R" + amount.ToString(amount == Math.Floor(amount) ? "N0" : "N2", CultureInfo.InvariantCulture);
        }

        private static string EmptyRow(string message)
        {
            return "<tr><td colspan=\"7\" style=\"text-align:center; color:#78827f; padding:30px;\">" + HttpUtility.HtmlEncode(message) + "</td></tr>";
        }

        private void ShowNotice(List<string> problems)
        {
            if (problems.Count == 0) return;

            var sb = new StringBuilder("<div class=\"avuna-db-notice\"><strong>Some order information could not be loaded from SQL Server.</strong><br />");
            foreach (string p in problems)
            {
                sb.Append(HttpUtility.HtmlEncode(p)).Append("<br />");
            }
            sb.Append("</div>");
            litDbNotice.Text = sb.ToString();
        }
    }
}