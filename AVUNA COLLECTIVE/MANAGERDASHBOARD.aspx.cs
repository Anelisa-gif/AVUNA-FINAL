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
	public partial class MANAGERDASHBOARD : System.Web.UI.Page
	{
		// =====================================================================
		// DATABASE NAMES USED BY THE DASHBOARD  (database: GroupWst2)
		//
		// Names confirmed from the SQL Server Management Studio table designs.
		// "Order" is a reserved word in SQL, so it must be written as [Order].
		// The status values below are still assumptions - see FinishedStatuses.
		// =====================================================================
		private const string CustomerTable = "Customer";

		private const string OrderTable = "[Order]";              // dbo.Order
		private const string OrderDateColumn = "order_Date";      // date the order was placed
		private const string OrderStatusColumn = "order_Status";    // e.g. Pending, In Production, Completed
		private const string OrderTotalColumn = "order_TotalCost";  // order value in rand

		// Orders with these statuses are finished (or cancelled), so they are NOT "pending".
		private static readonly string[] FinishedStatuses = { "Completed", "Delivered", "Collected", "Cancelled" };

		// Cancelled orders are not counted as sales.
		private static readonly string[] NotSalesStatuses = { "Cancelled" };

		private const int ChartMonths = 6;   // how many months the Sales Overview shows

		protected void Page_Load(object sender, EventArgs e)
		{
			if (Session["staff_Role"] == null)
			{
				Response.Redirect("~/Default.aspx");
				return;
			}

			// Only allow Manager/Admin Staff, not customers
			string role = Session["staff_Role"].ToString();
			if (role != "Manager" && role != "Admin Staff")
			{
				Response.Redirect("~/Default.aspx");
				return;
			}

			// ManageOrders.aspx and ManageStaff.aspx also inherit this class but don't contain the
			// dashboard controls, so only fill in the dashboard when those controls exist.
			if (litManagerName == null) return;

			// Name of the staff member who logged in (stored by Login.aspx.cs from the AdminStaff table)
			string fullName = ((Session["staff_First_Name"] as string ?? "") + " " + (Session["staff_Last_Name"] as string ?? "")).Trim();
			litManagerName.Text = HttpUtility.HtmlEncode(fullName.Length == 0 ? "Manager" : fullName);

			LoadDashboard();
			litDbNotice.Text += Inventory.LowStockAlertHtml(Session);
		}

		private void LoadDashboard()
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
					BuildChart(new decimal[ChartMonths], MonthStarts());
					litPendingAlert.Text = "Order data is unavailable right now.";
					return;
				}

				// ---- Customers --------------------------------------------------
				try
				{
					using (var cmd = new SqlCommand("SELECT COUNT(*) FROM " + CustomerTable, conn))
					{
						litCustomers.Text = Convert.ToInt32(cmd.ExecuteScalar()).ToString("N0", CultureInfo.InvariantCulture);
					}
				}
				catch (Exception ex)
				{
					problems.Add("Customers: " + ex.Message);
				}

				// ---- Total sales, total orders, pending orders ------------------
				try
				{
					string sql =
						"SELECT COUNT(*), " +
						"ISNULL(SUM(CASE WHEN " + OrderStatusColumn + " NOT IN (" + ParamList("n", NotSalesStatuses.Length) + ") THEN " + OrderTotalColumn + " ELSE 0 END), 0), " +
						"ISNULL(SUM(CASE WHEN " + OrderStatusColumn + " NOT IN (" + ParamList("f", FinishedStatuses.Length) + ") THEN 1 ELSE 0 END), 0) " +
						"FROM " + OrderTable;

					using (var cmd = new SqlCommand(sql, conn))
					{
						AddParams(cmd, "n", NotSalesStatuses);
						AddParams(cmd, "f", FinishedStatuses);

						using (var r = cmd.ExecuteReader())
						{
							if (r.Read())
							{
								int totalOrders = r.GetInt32(0);
								decimal totalSales = Convert.ToDecimal(r.GetValue(1));
								int pending = Convert.ToInt32(r.GetValue(2));

								litTotalOrders.Text = totalOrders.ToString("N0", CultureInfo.InvariantCulture);
								litTotalSales.Text = FormatRand(totalSales);
								litPendingOrders.Text = pending.ToString("N0", CultureInfo.InvariantCulture);
								litPendingAlert.Text = pending == 0
									? "No orders are currently pending."
									: pending + (pending == 1 ? " order is" : " orders are") + " currently pending.";
							}
						}
					}
				}
				catch (Exception ex)
				{
					problems.Add("Orders: " + ex.Message);
					litPendingAlert.Text = "Pending order data is unavailable right now.";
				}

				// ---- Monthly sales for the chart ---------------------------------
				var months = MonthStarts();
				var totals = new decimal[ChartMonths];
				try
				{
					string sql =
						"SELECT YEAR(" + OrderDateColumn + "), MONTH(" + OrderDateColumn + "), ISNULL(SUM(" + OrderTotalColumn + "), 0) " +
						"FROM " + OrderTable + " " +
						"WHERE " + OrderDateColumn + " >= @start " +
						"AND " + OrderStatusColumn + " NOT IN (" + ParamList("n", NotSalesStatuses.Length) + ") " +
						"GROUP BY YEAR(" + OrderDateColumn + "), MONTH(" + OrderDateColumn + ")";

					using (var cmd = new SqlCommand(sql, conn))
					{
						cmd.Parameters.AddWithValue("@start", months[0]);
						AddParams(cmd, "n", NotSalesStatuses);

						using (var r = cmd.ExecuteReader())
						{
							while (r.Read())
							{
								int year = r.GetInt32(0);
								int month = r.GetInt32(1);
								decimal sum = Convert.ToDecimal(r.GetValue(2));

								for (int i = 0; i < ChartMonths; i++)
								{
									if (months[i].Year == year && months[i].Month == month)
									{
										totals[i] = sum;
										break;
									}
								}
							}
						}
					}
				}
				catch (Exception ex)
				{
					problems.Add("Monthly sales: " + ex.Message);
				}

				BuildChart(totals, months);
			}

			ShowNotice(problems);
		}

		// First day of each month, oldest first, ending with the current month.
		private static DateTime[] MonthStarts()
		{
			var result = new DateTime[ChartMonths];
			var thisMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
			for (int i = 0; i < ChartMonths; i++)
			{
				result[i] = thisMonth.AddMonths(-(ChartMonths - 1 - i));
			}
			return result;
		}

		private void BuildChart(decimal[] totals, DateTime[] months)
		{
			decimal max = 0;
			foreach (decimal t in totals) { if (t > max) max = t; }

			// Round the top of the axis up to a tidy number so the labels read cleanly.
			decimal step = NiceStep(max / 4m);
			decimal axisMax = step * 4m;

			var axis = new StringBuilder();
			for (int i = 4; i >= 0; i--)
			{
				axis.Append("<span>").Append(FormatShort(step * i)).Append("</span>");
			}
			litChartAxis.Text = axis.ToString();

			var bars = new StringBuilder();
			for (int i = 0; i < totals.Length; i++)
			{
				double pct = axisMax > 0 ? (double)(totals[i] / axisMax * 100m) : 0;
				if (totals[i] > 0 && pct < 1.5) pct = 1.5;

				bars.Append("<div class=\"avuna-bar-column\">")
					.Append("<span class=\"avuna-bar-value\">").Append(FormatRand(totals[i])).Append("</span>")
					.Append("<div class=\"avuna-bar\" style=\"height:").Append(pct.ToString("0.##", CultureInfo.InvariantCulture)).Append("%;\"></div>")
					.Append("<span class=\"avuna-month\">").Append(months[i].ToString("MMM", CultureInfo.InvariantCulture)).Append("</span>")
					.Append("</div>");
			}
			litChartBars.Text = bars.ToString();
		}

		// Smallest "nice" number (1, 2, 2.5, 5 x 10^n) that is >= value.
		private static decimal NiceStep(decimal value)
		{
			if (value <= 0) return 250m;

			decimal magnitude = 1m;
			while (value > 10m * magnitude) magnitude *= 10m;
			while (value < magnitude && magnitude > 0.01m) magnitude /= 10m;

			foreach (decimal m in new[] { 1m, 2m, 2.5m, 5m, 10m })
			{
				if (value <= m * magnitude) return m * magnitude;
			}
			return 10m * magnitude;
		}

		private static string FormatRand(decimal amount)
		{
			return "R" + amount.ToString("N0", CultureInfo.InvariantCulture);
		}

		private static string FormatShort(decimal amount)
		{
			if (amount >= 1000000m) return "R" + (amount / 1000000m).ToString("0.##", CultureInfo.InvariantCulture) + "m";
			if (amount >= 1000m) return "R" + (amount / 1000m).ToString("0.##", CultureInfo.InvariantCulture) + "k";
			return "R" + amount.ToString("0.##", CultureInfo.InvariantCulture);
		}

		private static string ParamList(string prefix, int count)
		{
			var names = new string[count];
			for (int i = 0; i < count; i++) names[i] = "@" + prefix + i;
			return string.Join(", ", names);
		}

		private static void AddParams(SqlCommand cmd, string prefix, string[] values)
		{
			for (int i = 0; i < values.Length; i++)
			{
				cmd.Parameters.AddWithValue("@" + prefix + i, values[i]);
			}
		}

		private void ShowNotice(List<string> problems)
		{
			if (problems.Count == 0) return;

			var sb = new StringBuilder("<div class=\"avuna-db-notice\"><strong>Some dashboard figures could not be loaded from SQL Server.</strong><br />");
			foreach (string p in problems)
			{
				sb.Append(HttpUtility.HtmlEncode(p)).Append("<br />");
			}
			sb.Append("</div>");
			litDbNotice.Text = sb.ToString();
		}
	}
}
