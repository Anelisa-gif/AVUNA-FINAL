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

		// Used by ManageOrders.aspx to switch between the orders table and the ratings panel.
		protected bool ShowRatings;
		protected string RatingsHtml = "";

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

			// ManageOrders.aspx?view=ratings shows the customer ratings (with a box to respond) instead of the orders table.
			ShowRatings = string.Equals(Request.QueryString["view"], "ratings", StringComparison.OrdinalIgnoreCase);
			if (Request.HttpMethod == "POST" && Request.Form["avRatingSave"] == "1")
			{
				SaveRatingResponse();   // always redirects back to the ratings view
				return;
			}
			if (ShowRatings) RatingsHtml = BuildRatings();

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

		// ---------------------------------------------------------------------------------------------
		//  CUSTOMER RATINGS: list every rating (linked to its order) and let the manager respond.
		//  Responses are saved in dbo.Rating.manager_Response / response_Date (see the SQL shown on the
		//  page if those two columns do not exist yet).
		// ---------------------------------------------------------------------------------------------
		private static string Txt(SqlDataReader r, int i)
		{
			return r.IsDBNull(i) ? "" : Convert.ToString(r.GetValue(i), CultureInfo.InvariantCulture);
		}

		private string BuildRatings()
		{
			string filter = (Request.QueryString["filter"] ?? "").Trim().ToLowerInvariant();
			if (filter != "open" && filter != "done") filter = "";

			var all = new List<string[]>();   // id, date, review, score, orderId, customer, response, responseDate
			bool hasResponseColumns = false;
			string problem = null;

			try
			{
				string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
				using (var conn = new SqlConnection(connStr))
				{
					conn.Open();
					using (var chk = new SqlCommand("SELECT CASE WHEN COL_LENGTH('dbo.Rating','manager_Response') IS NOT NULL AND COL_LENGTH('dbo.Rating','response_Date') IS NOT NULL THEN 1 ELSE 0 END", conn))
					{
						hasResponseColumns = Convert.ToInt32(chk.ExecuteScalar(), CultureInfo.InvariantCulture) == 1;
					}

					string sql =
						"SELECT r.rating_ID, r.rating_Date, r.rating_Review, r.rating_Score, r.order_ID, " +
						"       c.cust_First_Name, c.cust_Last_Name" +
						(hasResponseColumns ? ", r.manager_Response, r.response_Date " : " ") +
						"FROM dbo.Rating r " +
						"LEFT JOIN [Order] o ON o.order_ID = r.order_ID " +
						"LEFT JOIN Customer c ON c.customer_ID = o.customer_ID " +
						"ORDER BY r.rating_Date DESC, r.rating_ID DESC";
					using (var cmd = new SqlCommand(sql, conn))
					using (var r = cmd.ExecuteReader())
					{
						while (r.Read())
						{
							string date = "";
							if (!r.IsDBNull(1)) date = r.GetDateTime(1).ToString("d MMM yyyy", CultureInfo.InvariantCulture);
							string customer = (Txt(r, 5) + " " + Txt(r, 6)).Trim();
							string resp = hasResponseColumns ? Txt(r, 7) : "";
							string respDate = "";
							if (hasResponseColumns && !r.IsDBNull(8)) respDate = r.GetDateTime(8).ToString("d MMM yyyy", CultureInfo.InvariantCulture);
							all.Add(new[] { Txt(r, 0), date, Txt(r, 2), Txt(r, 3), Txt(r, 4), customer, resp, respDate });
						}
					}
				}
			}
			catch (Exception ex)
			{
				problem = ex.Message;
			}

			var sb = new StringBuilder();
			sb.Append("<section class=\"avuna-card\" id=\"ratings-panel\">");

			string saved = Request.QueryString["saved"];
			if (saved == "1") sb.Append("<div class=\"rt-note rt-ok\">Your response has been saved.</div>");
			else if (saved == "0") sb.Append("<div class=\"rt-note rt-bad\">Your response could not be saved. Please try again.</div>");

			if (problem != null)
			{
				sb.Append("<div class=\"rt-note rt-bad\"><strong>Ratings could not be loaded.</strong><br />").Append(HttpUtility.HtmlEncode(problem)).Append("</div></section>");
				return sb.ToString();
			}

			if (!hasResponseColumns)
			{
				sb.Append("<div class=\"rt-note rt-warn\"><strong>One-time database step needed before responses can be saved.</strong> " +
						  "Run this in SQL Server Management Studio (database GroupWst2), then refresh this page:" +
						  "<pre>ALTER TABLE dbo.Rating ADD manager_Response NVARCHAR(500) NULL, response_Date DATETIME NULL;</pre></div>");
			}

			int open = 0; double sum = 0; int counted = 0;
			foreach (string[] a in all)
			{
				if (a[6].Length == 0) open++;
				int sc; if (int.TryParse(a[3], NumberStyles.Integer, CultureInfo.InvariantCulture, out sc)) { sum += sc; counted++; }
			}
			string avg = counted == 0 ? "-" : (sum / counted).ToString("0.0", CultureInfo.InvariantCulture);

			sb.Append("<div class=\"avuna-orders-header\"><div><h2>Customer Ratings</h2><p>")
			  .Append(all.Count).Append(all.Count == 1 ? " rating" : " ratings")
			  .Append(" &middot; average ").Append(avg).Append(" out of 5 &middot; ")
			  .Append(hasResponseColumns ? open + " waiting for a response" : "responses are not set up yet")
			  .Append("</p></div><a href=\"ManageOrders.aspx\" class=\"avuna-view-all\">&larr; Back to all orders</a></div>");

			sb.Append("<div class=\"rt-tabs\">")
			  .Append(RtTab("", "All", filter)).Append(RtTab("open", "Needs response", filter)).Append(RtTab("done", "Responded", filter))
			  .Append("</div>");

			int shown = 0;
			foreach (string[] a in all)
			{
				bool answered = a[6].Length > 0;
				if (filter == "open" && answered) continue;
				if (filter == "done" && !answered) continue;
				shown++;

				int score; if (!int.TryParse(a[3], NumberStyles.Integer, CultureInfo.InvariantCulture, out score)) score = 0;
				if (score < 0) score = 0; if (score > 5) score = 5;
				string stars = new string('\u2605', score) + "<span class=\"rt-off\">" + new string('\u2605', 5 - score) + "</span>";
				string idEnc = HttpUtility.HtmlEncode(a[0]);
				string idAttr = HttpUtility.HtmlAttributeEncode(a[0]);

				sb.Append("<article class=\"rt-card\"><div class=\"rt-top\"><div class=\"rt-stars\">").Append(stars)
				  .Append(" <b>").Append(score).Append("/5</b></div><div class=\"rt-meta\">")
				  .Append("Order <b>").Append(HttpUtility.HtmlEncode(a[4])).Append("</b>");
				if (a[5].Length > 0) sb.Append(" &middot; ").Append(HttpUtility.HtmlEncode(a[5]));
				if (a[1].Length > 0) sb.Append(" &middot; ").Append(HttpUtility.HtmlEncode(a[1]));
				sb.Append("</div></div><p class=\"rt-review\">")
				  .Append(a[2].Length == 0 ? "<i>No written review.</i>" : HttpUtility.HtmlEncode(a[2])).Append("</p>");

				if (answered)
				{
					sb.Append("<div class=\"rt-resp\"><span>Your response")
					  .Append(a[7].Length > 0 ? " &middot; " + HttpUtility.HtmlEncode(a[7]) : "").Append("</span><p>")
					  .Append(HttpUtility.HtmlEncode(a[6])).Append("</p></div>");
				}

				if (hasResponseColumns)
				{
					sb.Append("<button type=\"button\" class=\"rt-btn\" onclick=\"rtOpen(this)\" data-id=\"").Append(idAttr).Append("\">")
					  .Append(answered ? "Edit response" : "Respond").Append("</button>");
					sb.Append("<div class=\"rt-form\" id=\"rf_").Append(idAttr).Append("\" style=\"display:none\">")
					  .Append("<textarea maxlength=\"500\" placeholder=\"Write a short, polite reply to this customer (max 500 characters)\">")
					  .Append(HttpUtility.HtmlEncode(a[6])).Append("</textarea>")
					  .Append("<div class=\"rt-actions\"><button type=\"button\" class=\"rt-cancel\" onclick=\"rtClose(this)\">Cancel</button>")
					  .Append("<button type=\"button\" class=\"rt-send\" onclick=\"rtSend(this)\" data-id=\"").Append(idAttr)
					  .Append("\" data-order=\"").Append(HttpUtility.HtmlAttributeEncode(a[4])).Append("\">Save response</button></div></div>");
				}
				sb.Append("</article>");
			}
			if (shown == 0) sb.Append("<div class=\"rt-empty\">No ratings to show here yet.</div>");

			sb.Append("</section>");
			return sb.ToString();
		}

		private static string RtTab(string filter, string label, string current)
		{
			string href = "ManageOrders.aspx?view=ratings" + (filter.Length > 0 ? "&filter=" + filter : "");
			return "<a href=\"" + href + "\" class=\"rt-tab" + (filter == current ? " rt-on" : "") + "\">" + label + "</a>";
		}

		private void SaveRatingResponse()
		{
			string id = (Request.Form["avRatingId"] ?? "").Trim();
			string reply = (Request.Form["avRatingReply"] ?? "").Trim();
			if (reply.Length > 500) reply = reply.Substring(0, 500);

			bool ok = false;
			if (id.Length > 0 && id.Length <= 20 && reply.Length > 0)
			{
				try
				{
					string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
					using (var conn = new SqlConnection(connStr))
					using (var cmd = new SqlCommand("UPDATE dbo.Rating SET manager_Response = @t, response_Date = @d WHERE rating_ID = @id", conn))
					{
						cmd.Parameters.AddWithValue("@t", reply);
						cmd.Parameters.AddWithValue("@d", DateTime.Now);
						cmd.Parameters.AddWithValue("@id", id);
						conn.Open();
						ok = cmd.ExecuteNonQuery() > 0;
					}
				}
				catch (Exception)
				{
					ok = false;
				}
			}
			Response.Redirect("ManageOrders.aspx?view=ratings&saved=" + (ok ? "1" : "0"));
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
