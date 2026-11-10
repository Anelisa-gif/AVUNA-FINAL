using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AVUNA_COLLECTIVE
{
    // =====================================================================
    //  The page itself - everything else in this file is the report engine
    // =====================================================================
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportRunner.Show(this, litReport, Request.QueryString["report"]);
        }
    }

    // =====================================================================
    //  Rows read from SQL Server (database GroupWst2)
    // =====================================================================
    public class OrderRow
    {
        public string Id;
        public DateTime Date;
        public string Status;
        public decimal Total;
        public int? CustomerId;
        public string Customer;
    }

    public class PaymentRow
    {
        public string Id;
        public decimal Amount;
        public string Method;
        public string Status;
        public DateTime? Date;
        public string OrderId;
        public string StaffId;
    }

    public class CustomerRow
    {
        public int Id;
        public string Name;
        public string Type;
        public string Town;
        public string Suburb;
    }

    public class RatingRow
    {
        public DateTime Date;
        public int Score;
        public string Review;
    }

    public class StaffRow
    {
        public string Id;
        public string Name;
        public string Role;
        public string Email;
        public string Phone;
    }

    public class TimelineItem
    {
        public string Date;
        public string Title;
        public string Text;
        public string Color;
    }

    public class ReportView
    {
        public string Eyebrow;
        public string Heading;
        public string Intro;
        public string Active;      // sales | orders | customers | staff
        public string Body;        // HTML
        public string Script;      // JavaScript that draws the charts
    }

    // =====================================================================
    //  Helpers shared by every report
    // =====================================================================
    public static class Rpt
    {
        public const string ChartJsUrl = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js";

        public static readonly string[] Palette =
            { "#2a2118", "#d9711f", "#d9a52c", "#2f8f83", "#7a5c99", "#c84b4b", "#3b78a8", "#687d71" };

        public static readonly string[] FinishedStatuses = { "Completed", "Delivered", "Collected", "Cancelled" };

        public static bool IsCancelled(string status)
        {
            return string.Equals((status ?? "").Trim(), "Cancelled", StringComparison.OrdinalIgnoreCase);
        }

        public static bool IsFinished(string status)
        {
            string s = (status ?? "").Trim();
            foreach (string f in FinishedStatuses)
            {
                if (string.Equals(f, s, StringComparison.OrdinalIgnoreCase)) return true;
            }
            return false;
        }

        // Colour that matches the meaning of a status (green = done, orange = in progress, gold = waiting, red = problem)
        public static string StatusColor(string status, int index)
        {
            string s = (status ?? "").ToLowerInvariant();
            if (s.Contains("unpaid") || s.Contains("fail") || s.Contains("cancel") || s.Contains("declin") || s.Contains("overdue") || s.Contains("no payment"))
                return "#c84b4b";
            if (s.Contains("paid") || s.Contains("complet") || s.Contains("success") || s.Contains("deliver") || s.Contains("collect"))
                return "#2f8f5b";
            if (s.Contains("progress") || s.Contains("process") || s.Contains("production"))
                return "#d9711f";
            if (s.Contains("pend") || s.Contains("due") || s.Contains("partial") || s.Contains("outstanding") || s.Contains("await"))
                return "#d9a52c";
            return Palette[(index + 3) % Palette.Length];
        }

        // ---------- formatting ----------
        public static string Esc(string s)
        {
            return HttpUtility.HtmlEncode(s ?? "");
        }

        public static string Money(decimal v)
        {
            return "R" + v.ToString(v == Math.Floor(v) ? "N0" : "N2", CultureInfo.InvariantCulture);
        }

        public static string Int(int v)
        {
            return v.ToString("N0", CultureInfo.InvariantCulture);
        }

        public static string MonthKey(DateTime d)
        {
            return d.ToString("yyyy-MM", CultureInfo.InvariantCulture);
        }

        public static string MonthLabel(DateTime d)
        {
            return d.ToString("MMM yy", CultureInfo.InvariantCulture);
        }

        public static string DateText(DateTime d)
        {
            return d.ToString("dd MMM yyyy", CultureInfo.InvariantCulture).ToUpperInvariant();
        }

        // ---------- JavaScript data ----------
        public static string JsStr(string s)
        {
            var sb = new StringBuilder("\"");
            foreach (char c in s ?? "")
            {
                switch (c)
                {
                    case '\\': sb.Append("\\\\"); break;
                    case '"': sb.Append("\\\""); break;
                    case '\n': sb.Append("\\n"); break;
                    case '\r': break;
                    case '<': sb.Append("\\u003c"); break;
                    case '>': sb.Append("\\u003e"); break;
                    case '&': sb.Append("\\u0026"); break;
                    default:
                        if ((int)c == 0x2028) sb.Append("\\u2028");
                        else if ((int)c == 0x2029) sb.Append("\\u2029");
                        else sb.Append(c < ' ' ? ' ' : c);
                        break;
                }
            }
            return sb.Append('"').ToString();
        }

        public static string JsArr(IEnumerable<string> items)
        {
            return "[" + string.Join(",", items.Select(i => JsStr(i)).ToArray()) + "]";
        }

        public static string JsNums(IEnumerable<decimal> items)
        {
            return "[" + string.Join(",", items.Select(i => Math.Round(i, 2).ToString(CultureInfo.InvariantCulture)).ToArray()) + "]";
        }

        public static string JsNumsN(IEnumerable<decimal?> items)
        {
            return "[" + string.Join(",", items.Select(i => i.HasValue ? Math.Round(i.Value, 2).ToString(CultureInfo.InvariantCulture) : "null").ToArray()) + "]";
        }

        // ---------- months shown on the charts ----------
        // range: 6 or 12 months, or 0 = everything (up to 24 months back)
        public static List<DateTime> Months(int range, IEnumerable<DateTime> dates)
        {
            DateTime now = DateTime.Now;
            var current = new DateTime(now.Year, now.Month, 1);
            int n = range;

            if (n <= 0)
            {
                n = 6;
                DateTime? min = null;
                foreach (DateTime d in dates)
                {
                    if (!min.HasValue || d < min.Value) min = d;
                }
                if (min.HasValue)
                {
                    int diff = (current.Year - min.Value.Year) * 12 + current.Month - min.Value.Month + 1;
                    n = Math.Max(1, Math.Min(24, diff));
                }
            }

            var list = new List<DateTime>();
            for (int i = n - 1; i >= 0; i--) list.Add(current.AddMonths(-i));
            return list;
        }

        // ---------- SQL loaders ----------
        public static SqlConnection Open(List<string> problems)
        {
            try
            {
                var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString);
                conn.Open();
                return conn;
            }
            catch (Exception ex)
            {
                problems.Add("Could not connect to the database: " + ex.Message);
                return null;
            }
        }

        public static List<OrderRow> LoadOrders(SqlConnection conn, List<string> problems)
        {
            var list = new List<OrderRow>();
            if (conn == null) return list;
            try
            {
                const string sql =
                    "SELECT o.order_ID, o.order_Date, o.order_Status, o.order_TotalCost, o.customer_ID, " +
                    "       c.cust_First_Name, c.cust_Last_Name " +
                    "FROM [Order] o LEFT JOIN Customer c ON c.customer_ID = o.customer_ID";

                using (var cmd = new SqlCommand(sql, conn))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        string first = r.IsDBNull(5) ? "" : r.GetString(5);
                        string last = r.IsDBNull(6) ? "" : r.GetString(6);
                        string name = (first + " " + last).Trim();

                        list.Add(new OrderRow
                        {
                            Id = r.GetString(0),
                            Date = r.GetDateTime(1),
                            Status = r.IsDBNull(2) ? "" : r.GetString(2).Trim(),
                            Total = r.IsDBNull(3) ? 0m : r.GetDecimal(3),
                            CustomerId = r.IsDBNull(4) ? (int?)null : r.GetInt32(4),
                            Customer = name.Length == 0 ? "Unknown customer" : name
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                problems.Add("Orders: " + ex.Message);
            }
            return list;
        }

        public static List<PaymentRow> LoadPayments(SqlConnection conn, List<string> problems)
        {
            var list = new List<PaymentRow>();
            if (conn == null) return list;
            try
            {
                const string sql =
                    "SELECT payment_ID, payment_Amount, payment_Method, payment_Status, payment_Date, order_ID, staff_ID FROM Payment";

                using (var cmd = new SqlCommand(sql, conn))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new PaymentRow
                        {
                            Id = r.GetString(0),
                            Amount = r.IsDBNull(1) ? 0m : r.GetDecimal(1),
                            Method = r.IsDBNull(2) ? "Unknown" : r.GetString(2).Trim(),
                            Status = r.IsDBNull(3) ? "Unknown" : r.GetString(3).Trim(),
                            Date = r.IsDBNull(4) ? (DateTime?)null : r.GetDateTime(4),
                            OrderId = r.IsDBNull(5) ? "" : r.GetString(5),
                            StaffId = r.IsDBNull(6) ? null : r.GetString(6)
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                problems.Add("Payments: " + ex.Message);
            }
            return list;
        }

        public static List<CustomerRow> LoadCustomers(SqlConnection conn, List<string> problems)
        {
            var list = new List<CustomerRow>();
            if (conn == null) return list;
            try
            {
                const string sql =
                    "SELECT customer_ID, cust_First_Name, cust_Last_Name, cust_Type, cust_Town, cust_Suburb FROM Customer";

                using (var cmd = new SqlCommand(sql, conn))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        int id = r.GetInt32(0);
                        string name = ((r.IsDBNull(1) ? "" : r.GetString(1)) + " " + (r.IsDBNull(2) ? "" : r.GetString(2))).Trim();

                        list.Add(new CustomerRow
                        {
                            Id = id,
                            Name = name.Length == 0 ? "Customer #" + id : name,
                            Type = r.IsDBNull(3) || r.GetString(3).Trim().Length == 0 ? "Not specified" : r.GetString(3).Trim(),
                            Town = r.IsDBNull(4) || r.GetString(4).Trim().Length == 0 ? "Not given" : r.GetString(4).Trim(),
                            Suburb = r.IsDBNull(5) || r.GetString(5).Trim().Length == 0 ? "Not given" : r.GetString(5).Trim()
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                problems.Add("Customers: " + ex.Message);
            }
            return list;
        }

        public static List<RatingRow> LoadRatings(SqlConnection conn, List<string> problems)
        {
            var list = new List<RatingRow>();
            if (conn == null) return list;
            try
            {
                const string sql = "SELECT rating_Date, rating_Score, rating_Review FROM Rating";

                using (var cmd = new SqlCommand(sql, conn))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new RatingRow
                        {
                            Date = r.GetDateTime(0),
                            Score = Math.Max(1, Math.Min(5, r.GetInt32(1))),
                            Review = r.IsDBNull(2) ? "" : r.GetString(2)
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                problems.Add("Ratings: " + ex.Message);
            }
            return list;
        }

        // Passwords are never read.
        public static List<StaffRow> LoadAdminStaff(SqlConnection conn, List<string> problems)
        {
            var list = new List<StaffRow>();
            if (conn == null) return list;
            try
            {
                const string sql =
                    "SELECT staff_ID, staff_First_Name, staff_Last_Name, staff_Role, staff_Email, staff_Phone_Number FROM AdminStaff";

                using (var cmd = new SqlCommand(sql, conn))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new StaffRow
                        {
                            Id = r.GetString(0),
                            Name = ((r.IsDBNull(1) ? "" : r.GetString(1)) + " " + (r.IsDBNull(2) ? "" : r.GetString(2))).Trim(),
                            Role = r.IsDBNull(3) ? "Staff" : r.GetString(3).Trim(),
                            Email = r.IsDBNull(4) ? "" : r.GetString(4),
                            Phone = r.IsDBNull(5) ? "" : r.GetString(5)
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                problems.Add("Admin staff: " + ex.Message);
            }
            return list;
        }

        // Column names are matched by keyword (first / last / phone / email); the password column is never read.
        public static List<StaffRow> LoadProductionStaff(SqlConnection conn, List<string> problems)
        {
            var list = new List<StaffRow>();
            if (conn == null) return list;
            try
            {
                using (var cmd = new SqlCommand("SELECT * FROM productionStaff", conn))
                using (var r = cmd.ExecuteReader())
                {
                    int idCol = -1, firstCol = -1, lastCol = -1, phoneCol = -1, emailCol = -1;
                    for (int i = 0; i < r.FieldCount; i++)
                    {
                        string n = r.GetName(i).ToLowerInvariant();
                        if (n.Contains("password")) continue;
                        if (n.EndsWith("_id") && idCol < 0) idCol = i;
                        else if (n.Contains("first")) firstCol = i;
                        else if (n.Contains("last")) lastCol = i;
                        else if (n.Contains("phone")) phoneCol = i;
                        else if (n.Contains("email")) emailCol = i;
                    }

                    while (r.Read())
                    {
                        string first = firstCol >= 0 && !r.IsDBNull(firstCol) ? Convert.ToString(r.GetValue(firstCol)) : "";
                        string last = lastCol >= 0 && !r.IsDBNull(lastCol) ? Convert.ToString(r.GetValue(lastCol)) : "";

                        list.Add(new StaffRow
                        {
                            Id = idCol >= 0 && !r.IsDBNull(idCol) ? Convert.ToString(r.GetValue(idCol)) : "",
                            Name = (first + " " + last).Trim(),
                            Role = "Production Staff",
                            Email = emailCol >= 0 && !r.IsDBNull(emailCol) ? Convert.ToString(r.GetValue(emailCol)) : "",
                            Phone = phoneCol >= 0 && !r.IsDBNull(phoneCol) ? Convert.ToString(r.GetValue(phoneCol)) : ""
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                problems.Add("Production staff: " + ex.Message);
            }
            return list;
        }

        // ---------- HTML pieces ----------
        public static string Kpi(string label, string value, string sub, string accent, string icon)
        {
            return "<article class=\"rp-kpi\" style=\"--accent:" + accent + "\">" +
                   "<div class=\"rp-kpi-icon\">" + icon + "</div>" +
                   "<div><span class=\"rp-kpi-label\">" + Esc(label) + "</span>" +
                   "<strong class=\"rp-kpi-value\">" + Esc(value) + "</strong>" +
                   "<small class=\"rp-kpi-sub\">" + sub + "</small></div></article>";
        }

        public static string ChartCard(string canvasId, string title, string subtitle, int span, int height)
        {
            return "<section class=\"rp-card rp-span-" + span + "\">" +
                   "<header class=\"rp-card-h\"><h3>" + Esc(title) + "</h3><p>" + Esc(subtitle) + "</p></header>" +
                   "<div class=\"rp-chart\" style=\"height:" + height + "px\"><canvas id=\"" + canvasId + "\"></canvas></div>" +
                   "</section>";
        }

        public static string HtmlCard(string title, string subtitle, int span, string inner)
        {
            return "<section class=\"rp-card rp-span-" + span + "\">" +
                   "<header class=\"rp-card-h\"><h3>" + Esc(title) + "</h3><p>" + Esc(subtitle) + "</p></header>" +
                   "<div class=\"rp-card-body\">" + inner + "</div></section>";
        }

        public static string Timeline(List<TimelineItem> items)
        {
            if (items.Count == 0) return "<p class=\"rp-empty\">Nothing to show yet.</p>";

            var sb = new StringBuilder("<ul class=\"rp-timeline\">");
            foreach (TimelineItem i in items)
            {
                sb.Append("<li class=\"rp-tl-item\"><span class=\"rp-tl-dot\" style=\"--dot:").Append(i.Color).Append("\"></span>")
                  .Append("<div class=\"rp-tl-date\">").Append(Esc(i.Date)).Append("</div>")
                  .Append("<div class=\"rp-tl-title\">").Append(i.Title).Append("</div>")
                  .Append("<div class=\"rp-tl-text\">").Append(i.Text).Append("</div></li>");
            }
            return sb.Append("</ul>").ToString();
        }

        public static string Stars(int score)
        {
            var sb = new StringBuilder();
            for (int i = 1; i <= 5; i++) sb.Append(i <= score ? "&#9733;" : "&#9734;");
            return sb.ToString();
        }

        // ---------- JavaScript that every report starts with ----------
        private const string ScriptStart = @"
(function(){
var P = __PALETTE__;
if (typeof Chart === 'undefined') { var nc = document.getElementById('rp-nochart'); if (nc) nc.style.display = 'block'; return; }
Chart.defaults.font.family = 'Arial, Helvetica, sans-serif';
Chart.defaults.font.size = 11;
Chart.defaults.color = '#5d6a67';
Chart.defaults.maintainAspectRatio = false;
Chart.defaults.plugins.legend.labels.usePointStyle = true;
Chart.defaults.plugins.legend.labels.boxWidth = 8;
Chart.defaults.plugins.tooltip.backgroundColor = '#2a2118';
Chart.defaults.plugins.tooltip.padding = 10;
Chart.defaults.plugins.tooltip.cornerRadius = 8;
function R(v){ v = Number(v) || 0; return 'R' + v.toLocaleString('en-US', {maximumFractionDigits: 2}); }
function RS(v){ v = Number(v) || 0; if (v >= 1e6) return 'R' + (v/1e6).toFixed(1).replace(/\.0$/, '') + 'm'; if (v >= 1e3) return 'R' + (v/1e3).toFixed(1).replace(/\.0$/, '') + 'k'; return 'R' + v; }
function hasData(cfg){ var ok = false; (cfg.data.datasets || []).forEach(function(d){ (d.data || []).forEach(function(x){ if (Number(x) > 0) ok = true; }); }); return ok; }
function mk(id, cfg){
  var el = document.getElementById(id); if (!el) return;
  if (!hasData(cfg)) { el.parentNode.innerHTML = '<div class=""rp-nodata"">No data to show yet</div>'; return; }
  try { new Chart(el, cfg); } catch (e) { if (window.console) console.error(id, e); }
}
var GRID = '#eef2ef';
var moneyY = { beginAtZero: true, grid: { color: GRID }, ticks: { callback: function(v){ return RS(v); } } };
var countY = { beginAtZero: true, grid: { color: GRID }, ticks: { precision: 0 } };
var noGrid = { grid: { display: false } };
var moneyTip = { callbacks: { label: function(c){ return ' ' + (c.dataset.label ? c.dataset.label + ': ' : '') + R(c.parsed.y !== undefined ? c.parsed.y : c.parsed); } } };
var moneyTipH = { callbacks: { label: function(c){ return ' ' + R(c.parsed.x); } } };
var pieMoney = { legend: { position: 'bottom' }, tooltip: { callbacks: { label: function(c){ return ' ' + c.label + ': ' + R(c.parsed); } } } };
var pieCount = { legend: { position: 'bottom' }, tooltip: { callbacks: { label: function(c){ return ' ' + c.label + ': ' + c.parsed; } } } };
";

        public static string Script(string charts)
        {
            return ScriptStart.Replace("__PALETTE__", JsArr(Palette)) + charts + "\n})();";
        }

        // ---------- the whole page ----------
        public static string Shell(ReportView v, int range, List<string> problems, string cssUrl, string chartJsUrl)
        {
            var sb = new StringBuilder();

            sb.Append("<div class=\"rp-page\">");

            // hero
            sb.Append("<section class=\"rp-hero\"><div class=\"rp-hero-copy\">")
              .Append("<span class=\"rp-eyebrow\">").Append(Esc(v.Eyebrow)).Append("</span>")
              .Append("<h1>").Append(Esc(v.Heading)).Append("</h1>")
              .Append("<p>").Append(Esc(v.Intro)).Append("</p>")
              .Append("<div class=\"rp-hero-actions\">")
              .Append("<a class=\"rp-btn rp-btn-primary\" href=\"ManagerDashboard.aspx\">Back to Dashboard</a>")
              .Append("<button type=\"button\" class=\"rp-btn rp-btn-ghost\" onclick=\"window.print()\">Print / Save as PDF</button>")
              .Append("</div></div>")
              .Append("</section>");

            sb.Append("<main class=\"rp-body\">");

            // tabs
            sb.Append("<nav class=\"rp-tabs\">")
              .Append(Tab("Reports.aspx?report=sales", "Sales Report", v.Active == "sales"))
              .Append(Tab("Reports.aspx?report=orders", "Order Report", v.Active == "orders"))
              .Append(Tab("Reports.aspx?report=customers", "Customer Report", v.Active == "customers"))
              .Append(Tab("Reports.aspx?report=staff", "Staff Report", v.Active == "staff"))
              .Append("</nav>");

            // period selector
            sb.Append("<div class=\"rp-toolbar\"><b>PERIOD</b>")
              .Append(Pill("Reports.aspx?report=" + v.Active + "&range=6", "Last 6 months", range == 6))
              .Append(Pill("Reports.aspx?report=" + v.Active + "&range=12", "Last 12 months", range == 12))
              .Append(Pill("Reports.aspx?report=" + v.Active + "&range=all", "All time", range == 0))
              .Append("<span class=\"rp-updated\">Updated ")
              .Append(DateTime.Now.ToString("d MMM yyyy, HH:mm", CultureInfo.InvariantCulture)).Append("</span></div>");

            if (problems.Count > 0)
            {
                sb.Append("<div class=\"rp-notice\"><strong>Some information could not be loaded from SQL Server.</strong><br />");
                foreach (string p in problems) sb.Append(Esc(p)).Append("<br />");
                sb.Append("</div>");
            }

            sb.Append("<div id=\"rp-nochart\" class=\"rp-nochart\">The chart library could not be loaded (internet connection needed). Figures and tables are still shown.</div>");

            sb.Append(v.Body);
            sb.Append("</main></div>");

            sb.Append("<script src=\"").Append(chartJsUrl).Append("\"></script>");
            sb.Append("<script>").Append(v.Script).Append("</script>");

            return sb.ToString();
        }

        private static string Tab(string href, string text, bool active)
        {
            return "<a class=\"rp-tab" + (active ? " rp-active" : "") + "\" href=\"" + href + "\">" + text + "</a>";
        }

        private static string Pill(string href, string text, bool active)
        {
            return "<a class=\"rp-pill" + (active ? " rp-active" : "") + "\" href=\"" + href + "\">" + text + "</a>";
        }
    }

    // =====================================================================
    //  Access check + choosing which report to show
    // =====================================================================
    public static class ReportRunner
    {
        public static void Show(Page page, Literal target, string report)
        {
            if (page.Session["staff_Role"] == null)
            {
                page.Response.Redirect("~/Default.aspx");
                return;
            }

            string role = page.Session["staff_Role"].ToString();
            if (role != "Manager" && role != "Admin Staff")
            {
                page.Response.Redirect("~/Default.aspx");
                return;
            }

            // ?range=6 | 12 | all   (default 12 months)
            int range = 12;
            string q = (page.Request.QueryString["range"] ?? "").Trim().ToLowerInvariant();
            if (q == "6") range = 6;
            else if (q == "all") range = 0;

            var problems = new List<string>();
            ReportView view = ReportPages.Build((report ?? "").Trim().ToLowerInvariant(), range, problems);

            target.Text = Rpt.Shell(view, range, problems, "", Rpt.ChartJsUrl);
        }
    }

    // =====================================================================
    //  Small helpers used by the four builders
    // =====================================================================
    internal static class RptUtil
    {
        // Replaces __TOKEN__ placeholders in a JavaScript template
        public static string Fill(string js, params string[] pairs)
        {
            for (int i = 0; i + 1 < pairs.Length; i += 2) js = js.Replace(pairs[i], pairs[i + 1]);
            return js;
        }

        public static readonly string[] DayNames = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };

        // Monday = 0 ... Sunday = 6
        public static int DayIndex(DateTime d)
        {
            return ((int)d.DayOfWeek + 6) % 7;
        }

        public static string Pct(decimal v)
        {
            return Math.Abs(Math.Round(v, 1)).ToString("0.#", CultureInfo.InvariantCulture) + "%";
        }

        public static string Status(string s)
        {
            return string.IsNullOrWhiteSpace(s) ? "Unknown" : s;
        }
    }

    // =====================================================================
    //  1. SALES REPORT
    // =====================================================================
    public static class SalesReportBuilder
    {
        public static ReportView Build(List<OrderRow> orders, List<PaymentRow> pays, int range)
        {
            // Cancelled orders are not counted as sales
            var sold = orders.Where(o => !Rpt.IsCancelled(o.Status)).ToList();
            var months = Rpt.Months(range, orders.Select(o => o.Date));

            var salesBy = new Dictionary<string, decimal>();
            var countBy = new Dictionary<string, int>();
            foreach (DateTime m in months) { salesBy[Rpt.MonthKey(m)] = 0m; countBy[Rpt.MonthKey(m)] = 0; }
            foreach (OrderRow o in sold)
            {
                string k = Rpt.MonthKey(o.Date);
                if (salesBy.ContainsKey(k)) { salesBy[k] += o.Total; countBy[k]++; }
            }

            var monthLabels = months.Select(m => Rpt.MonthLabel(m)).ToList();
            var monthSales = months.Select(m => salesBy[Rpt.MonthKey(m)]).ToList();
            var monthCounts = months.Select(m => (decimal)countBy[Rpt.MonthKey(m)]).ToList();

            // running total (includes everything sold before the first month shown)
            decimal running = sold.Where(o => o.Date < months[0]).Sum(o => o.Total);
            var cumulative = new List<decimal>();
            foreach (decimal s in monthSales) { running += s; cumulative.Add(running); }

            // ---- KPIs ----
            decimal totalSales = sold.Sum(o => o.Total);
            string thisKey = Rpt.MonthKey(DateTime.Now);
            string lastKey = Rpt.MonthKey(DateTime.Now.AddMonths(-1));
            decimal thisMonth = sold.Where(o => Rpt.MonthKey(o.Date) == thisKey).Sum(o => o.Total);
            decimal lastMonth = sold.Where(o => Rpt.MonthKey(o.Date) == lastKey).Sum(o => o.Total);
            decimal avg = sold.Count > 0 ? totalSales / sold.Count : 0m;
            decimal largest = sold.Count > 0 ? sold.Max(o => o.Total) : 0m;
            decimal paymentsTotal = pays.Sum(p => p.Amount);

            string delta;
            if (lastMonth > 0)
            {
                decimal pct = (thisMonth - lastMonth) / lastMonth * 100m;
                delta = "<span class=\"" + (pct >= 0 ? "rp-up" : "rp-down") + "\">" + (pct >= 0 ? "&#9650; " : "&#9660; ") + RptUtil.Pct(pct) + "</span> vs last month";
            }
            else
            {
                delta = "No sales recorded last month";
            }

            // ---- sales by order status / payments ----
            var byStatus = orders.GroupBy(o => RptUtil.Status(o.Status))
                                 .Select(g => new { Name = g.Key, Value = g.Sum(x => x.Total) })
                                 .OrderByDescending(x => x.Value).ToList();

            var byMethod = pays.GroupBy(p => RptUtil.Status(p.Method))
                               .Select(g => new { Name = g.Key, Value = g.Sum(x => x.Amount) })
                               .OrderByDescending(x => x.Value).ToList();

            var byPayStatus = pays.GroupBy(p => RptUtil.Status(p.Status))
                                  .Select(g => new { Name = g.Key, Value = g.Sum(x => x.Amount) })
                                  .OrderByDescending(x => x.Value).ToList();

            // ---- top customers ----
            var top = sold.Where(o => o.CustomerId.HasValue)
                          .GroupBy(o => o.CustomerId.Value)
                          .Select(g => new { Name = g.First().Customer, Value = g.Sum(x => x.Total) })
                          .OrderByDescending(x => x.Value).Take(5).ToList();

            // ---- order value distribution ----
            string[] distLabels = { "Under R500", "R500 - R999", "R1,000 - R2,499", "R2,500 - R4,999", "R5,000 +" };
            var dist = new decimal[5];
            foreach (OrderRow o in sold)
            {
                int idx = o.Total < 500 ? 0 : o.Total < 1000 ? 1 : o.Total < 2500 ? 2 : o.Total < 5000 ? 3 : 4;
                dist[idx]++;
            }

            // ---- sales by weekday ----
            var day = new decimal[7];
            foreach (OrderRow o in sold) day[RptUtil.DayIndex(o.Date)] += o.Total;

            // ---- timeline: latest payments ----
            var timeline = new List<TimelineItem>();
            foreach (PaymentRow p in pays.OrderByDescending(x => x.Date ?? DateTime.MinValue).Take(6))
            {
                timeline.Add(new TimelineItem
                {
                    Date = p.Date.HasValue ? Rpt.DateText(p.Date.Value) : "DATE NOT RECORDED",
                    Title = Rpt.Money(p.Amount) + " &middot; " + Rpt.Esc(p.Method),
                    Text = "Payment " + Rpt.Esc(p.Id) + " for order " + Rpt.Esc(p.OrderId) + " &mdash; <b>" + Rpt.Esc(p.Status) + "</b>",
                    Color = Rpt.StatusColor(p.Status, 0)
                });
            }

            // ---- page ----
            var body = new StringBuilder();
            body.Append("<section class=\"rp-kpis\">")
                .Append(Rpt.Kpi("TOTAL SALES", Rpt.Money(totalSales), "All orders except cancelled", "#2a2118", "R"))
                .Append(Rpt.Kpi("THIS MONTH", Rpt.Money(thisMonth), delta, "#d9711f", "&#9650;"))
                .Append(Rpt.Kpi("AVERAGE ORDER", Rpt.Money(Math.Round(avg, 2)), Rpt.Int(sold.Count) + " orders counted", "#d9a52c", "&#8960;"))
                .Append(Rpt.Kpi("LARGEST ORDER", Rpt.Money(largest), "Biggest single order", "#2f8f83", "&#9733;"))
                .Append(Rpt.Kpi("PAYMENTS RECORDED", Rpt.Money(paymentsTotal), Rpt.Int(pays.Count) + " payments in total", "#7a5c99", "&#10003;"))
                .Append("</section><div class=\"rp-grid\">")
                .Append(Rpt.ChartCard("cMonthly", "Monthly Sales", "Sales value (bars) and number of orders (line) for each month", 8, 340))
                .Append(Rpt.ChartCard("cStatus", "Order Value by Status", "Where the money sits across order statuses", 4, 340))
                .Append(Rpt.ChartCard("cCum", "Cumulative Sales", "Running total of sales over time", 6, 300))
                .Append(Rpt.ChartCard("cTop", "Top Customers by Spend", "The five customers who have spent the most", 6, 300))
                .Append(Rpt.ChartCard("cMethod", "Payment Methods", "Payment value by method used", 4, 300))
                .Append(Rpt.ChartCard("cPayStatus", "Payment Status", "Payment value by payment status", 4, 300))
                .Append(Rpt.ChartCard("cDay", "Sales by Day of the Week", "Which days bring in the most sales", 4, 300))
                .Append(Rpt.ChartCard("cDist", "Order Value Distribution", "How many orders fall into each value range", 6, 300))
                .Append(Rpt.HtmlCard("Payment Timeline", "The most recent payments, newest first", 6, Rpt.Timeline(timeline)))
                .Append("</div>");

            const string charts = @"
mk('cMonthly', { type: 'bar', data: { labels: __ML__, datasets: [
  { type: 'bar', label: 'Sales', data: __MS__, backgroundColor: '#d9711f', borderRadius: 8, maxBarThickness: 46, order: 2 },
  { type: 'line', label: 'Orders', data: __MC__, borderColor: '#2a2118', backgroundColor: '#2a2118', borderWidth: 3, tension: .15, pointRadius: 4, yAxisID: 'y1', order: 1 } ] },
  options: { interaction: { mode: 'index', intersect: false },
    scales: { x: noGrid, y: moneyY, y1: { position: 'right', beginAtZero: true, grid: { drawOnChartArea: false }, ticks: { precision: 0 } } },
    plugins: { legend: { position: 'top', align: 'end' }, tooltip: { callbacks: { label: function(c){ return ' ' + c.dataset.label + ': ' + (c.dataset.yAxisID === 'y1' ? c.parsed.y + ' orders' : R(c.parsed.y)); } } } } } });
mk('cStatus', { type: 'doughnut', data: { labels: __SL__, datasets: [{ data: __SV__, backgroundColor: __SC__, borderColor: '#fff', borderWidth: 3 }] },
  options: { cutout: '62%', plugins: pieMoney } });
mk('cCum', { type: 'line', data: { labels: __ML__, datasets: [{ label: 'Cumulative sales', data: __CUM__, borderColor: '#d9711f', backgroundColor: 'rgba(217,113,31,.18)', fill: true, tension: .35, borderWidth: 3, pointBackgroundColor: '#fff', pointBorderColor: '#d9711f', pointBorderWidth: 2, pointRadius: 4 }] },
  options: { scales: { x: noGrid, y: moneyY }, plugins: { legend: { display: false }, tooltip: moneyTip } } });
mk('cTop', { type: 'bar', data: { labels: __TL__, datasets: [{ data: __TV__, backgroundColor: P, borderRadius: 8, maxBarThickness: 30 }] },
  options: { indexAxis: 'y', scales: { x: moneyY, y: noGrid }, plugins: { legend: { display: false }, tooltip: moneyTipH } } });
mk('cMethod', { type: 'doughnut', data: { labels: __PML__, datasets: [{ data: __PMV__, backgroundColor: P, borderColor: '#fff', borderWidth: 3 }] },
  options: { cutout: '62%', plugins: pieMoney } });
mk('cPayStatus', { type: 'pie', data: { labels: __PSL__, datasets: [{ data: __PSV__, backgroundColor: __PSC__, borderColor: '#fff', borderWidth: 3 }] },
  options: { plugins: pieMoney } });
mk('cDay', { type: 'bar', data: { labels: __WL__, datasets: [{ label: 'Sales', data: __WV__, backgroundColor: P, borderRadius: 8, maxBarThickness: 36 }] },
  options: { scales: { x: noGrid, y: moneyY }, plugins: { legend: { display: false }, tooltip: moneyTip } } });
mk('cDist', { type: 'bar', data: { labels: __DL__, datasets: [{ label: 'Orders', data: __DV__, backgroundColor: ['#2f8f83', '#3b78a8', '#d9a52c', '#d9711f', '#c84b4b'], borderRadius: 8, maxBarThickness: 50 }] },
  options: { scales: { x: noGrid, y: countY }, plugins: { legend: { display: false } } } });
";

            string js = RptUtil.Fill(charts,
                "__ML__", Rpt.JsArr(monthLabels),
                "__MS__", Rpt.JsNums(monthSales),
                "__MC__", Rpt.JsNums(monthCounts),
                "__SL__", Rpt.JsArr(byStatus.Select(x => x.Name)),
                "__SV__", Rpt.JsNums(byStatus.Select(x => x.Value)),
                "__SC__", Rpt.JsArr(byStatus.Select((x, i) => Rpt.StatusColor(x.Name, i))),
                "__CUM__", Rpt.JsNums(cumulative),
                "__TL__", Rpt.JsArr(top.Select(x => x.Name)),
                "__TV__", Rpt.JsNums(top.Select(x => x.Value)),
                "__PML__", Rpt.JsArr(byMethod.Select(x => x.Name)),
                "__PMV__", Rpt.JsNums(byMethod.Select(x => x.Value)),
                "__PSL__", Rpt.JsArr(byPayStatus.Select(x => x.Name)),
                "__PSV__", Rpt.JsNums(byPayStatus.Select(x => x.Value)),
                "__PSC__", Rpt.JsArr(byPayStatus.Select((x, i) => Rpt.StatusColor(x.Name, i))),
                "__WL__", Rpt.JsArr(RptUtil.DayNames),
                "__WV__", Rpt.JsNums(day),
                "__DL__", Rpt.JsArr(distLabels),
                "__DV__", Rpt.JsNums(dist));

            return new ReportView
            {
                Eyebrow = "MANAGER PORTAL",
                Heading = "Sales Report",
                Intro = "Revenue, payments and customer spending.",
                Active = "sales",
                Body = body.ToString(),
                Script = Rpt.Script(js)
            };
        }
    }

    // =====================================================================
    //  2. ORDER REPORT
    // =====================================================================
    public static class OrderReportBuilder
    {
        public static ReportView Build(List<OrderRow> orders, List<PaymentRow> pays, int range)
        {
            var months = Rpt.Months(range, orders.Select(o => o.Date));
            var open = orders.Where(o => !Rpt.IsFinished(o.Status)).ToList();

            int pending = orders.Count(o => string.Equals(o.Status, "Pending", StringComparison.OrdinalIgnoreCase));
            int inProgress = orders.Count(o => string.Equals(o.Status, "In Progress", StringComparison.OrdinalIgnoreCase));
            int completed = orders.Count(o => string.Equals(o.Status, "Completed", StringComparison.OrdinalIgnoreCase));
            decimal openValue = open.Sum(o => o.Total);

            // statuses (biggest first)
            var statuses = orders.GroupBy(o => RptUtil.Status(o.Status))
                                 .Select(g => new { Name = g.Key, Count = g.Count() })
                                 .OrderByDescending(x => x.Count).ToList();

            // orders per month, split by status (stacked bars)
            var datasets = new StringBuilder();
            for (int i = 0; i < statuses.Count; i++)
            {
                string st = statuses[i].Name;
                var counts = new List<decimal>();
                foreach (DateTime m in months)
                {
                    string key = Rpt.MonthKey(m);
                    counts.Add(orders.Count(o => RptUtil.Status(o.Status) == st && Rpt.MonthKey(o.Date) == key));
                }
                if (i > 0) datasets.Append(",");
                datasets.Append("{label:").Append(Rpt.JsStr(st))
                        .Append(",data:").Append(Rpt.JsNums(counts))
                        .Append(",backgroundColor:").Append(Rpt.JsStr(Rpt.StatusColor(st, i)))
                        .Append(",borderRadius:4,maxBarThickness:46,stack:'s'}");
            }

            // how long have open orders been waiting?
            string[] ageLabels = { "0 - 7 days", "8 - 14 days", "15 - 30 days", "Over 30 days" };
            var age = new decimal[4];
            DateTime today = DateTime.Now.Date;
            foreach (OrderRow o in open)
            {
                int d = Math.Max(0, (today - o.Date.Date).Days);
                age[d <= 7 ? 0 : d <= 14 ? 1 : d <= 30 ? 2 : 3]++;
            }

            // orders by weekday
            var day = new decimal[7];
            foreach (OrderRow o in orders) day[RptUtil.DayIndex(o.Date)]++;

            // payment position of each order (status of its most recent payment)
            var latestPay = pays.Where(p => !string.IsNullOrEmpty(p.OrderId))
                                .GroupBy(p => p.OrderId)
                                .ToDictionary(g => g.Key, g => g.OrderByDescending(x => x.Date ?? DateTime.MinValue).First().Status);
            var payPos = orders.Where(o => !Rpt.IsCancelled(o.Status))
                               .GroupBy(o => latestPay.ContainsKey(o.Id) ? latestPay[o.Id] : "No payment yet")
                               .Select(g => new { Name = g.Key, Count = g.Count() })
                               .OrderByDescending(x => x.Count).ToList();

            // timeline: latest orders
            var timeline = new List<TimelineItem>();
            foreach (OrderRow o in orders.OrderByDescending(x => x.Date).ThenByDescending(x => x.Id).Take(6))
            {
                timeline.Add(new TimelineItem
                {
                    Date = Rpt.DateText(o.Date),
                    Title = "Order " + Rpt.Esc(o.Id) + " &middot; " + Rpt.Esc(o.Customer),
                    Text = "<b>" + Rpt.Esc(RptUtil.Status(o.Status)) + "</b> &middot; " + Rpt.Money(o.Total),
                    Color = Rpt.StatusColor(o.Status, 0)
                });
            }

            // table: oldest open orders
            var table = new StringBuilder();
            table.Append("<div class=\"rp-table-wrap\"><table class=\"rp-table\"><thead><tr>")
                 .Append("<th>ORDER NO.</th><th>CUSTOMER</th><th>PLACED</th><th>WAITING</th><th>STATUS</th><th>TOTAL</th></tr></thead><tbody>");
            var oldest = open.OrderBy(o => o.Date).Take(8).ToList();
            if (oldest.Count == 0)
            {
                table.Append("<tr><td colspan=\"6\" style=\"text-align:center;color:#78827f;padding:26px\">No open orders - everything is finished.</td></tr>");
            }
            foreach (OrderRow o in oldest)
            {
                int d = Math.Max(0, (today - o.Date.Date).Days);
                table.Append("<tr><td class=\"rp-strong\">").Append(Rpt.Esc(o.Id)).Append("</td>")
                     .Append("<td>").Append(Rpt.Esc(o.Customer)).Append("</td>")
                     .Append("<td>").Append(o.Date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture)).Append("</td>")
                     .Append("<td>").Append(d).Append(d == 1 ? " day" : " days").Append("</td>")
                     .Append("<td><span class=\"rp-badge\" style=\"background:").Append(Rpt.StatusColor(o.Status, 0)).Append("\">").Append(Rpt.Esc(RptUtil.Status(o.Status))).Append("</span></td>")
                     .Append("<td>").Append(Rpt.Money(o.Total)).Append("</td></tr>");
            }
            table.Append("</tbody></table></div>");

            var body = new StringBuilder();
            body.Append("<section class=\"rp-kpis\">")
                .Append(Rpt.Kpi("TOTAL ORDERS", Rpt.Int(orders.Count), "All orders recorded", "#2a2118", "#"))
                .Append(Rpt.Kpi("PENDING", Rpt.Int(pending), "Not yet started", "#d9a52c", "!"))
                .Append(Rpt.Kpi("IN PROGRESS", Rpt.Int(inProgress), "Currently being made", "#d9711f", "&#9881;"))
                .Append(Rpt.Kpi("COMPLETED", Rpt.Int(completed), "Fulfilled orders", "#2f8f5b", "&#10003;"))
                .Append(Rpt.Kpi("OPEN ORDER VALUE", Rpt.Money(openValue), Rpt.Int(open.Count) + " orders not finished yet", "#7a5c99", "R"))
                .Append("</section><div class=\"rp-grid\">")
                .Append(Rpt.ChartCard("cStatus", "Orders by Status", "Share of all orders in each stage", 4, 320))
                .Append(Rpt.ChartCard("cMonthly", "Orders per Month", "Orders placed each month, split by status", 8, 320))
                .Append(Rpt.ChartCard("cAge", "How Long Open Orders Have Waited", "Unfinished orders grouped by age", 4, 300))
                .Append(Rpt.ChartCard("cDay", "Orders by Day of the Week", "Which days customers order most", 4, 300))
                .Append(Rpt.ChartCard("cPay", "Payment Position of Orders", "Status of each order's latest payment", 4, 300))
                .Append(Rpt.HtmlCard("Order Timeline", "The latest orders, newest first", 6, Rpt.Timeline(timeline)))
                .Append(Rpt.HtmlCard("Oldest Open Orders", "Orders that have been waiting the longest - follow these up first", 6, table.ToString()))
                .Append("</div>");

            const string charts = @"
mk('cStatus', { type: 'doughnut', data: { labels: __SL__, datasets: [{ data: __SV__, backgroundColor: __SC__, borderColor: '#fff', borderWidth: 3 }] },
  options: { cutout: '62%', plugins: pieCount } });
mk('cMonthly', { type: 'bar', data: { labels: __ML__, datasets: [__DS__] },
  options: { interaction: { mode: 'index', intersect: false }, scales: { x: Object.assign({ stacked: true }, noGrid), y: Object.assign({ stacked: true }, countY) }, plugins: { legend: { position: 'top', align: 'end' } } } });
mk('cAge', { type: 'bar', data: { labels: __AL__, datasets: [{ label: 'Open orders', data: __AV__, backgroundColor: ['#2f8f5b', '#d9a52c', '#d9711f', '#c84b4b'], borderRadius: 8, maxBarThickness: 50 }] },
  options: { scales: { x: noGrid, y: countY }, plugins: { legend: { display: false } } } });
mk('cDay', { type: 'bar', data: { labels: __WL__, datasets: [{ label: 'Orders', data: __WV__, backgroundColor: P, borderRadius: 8, maxBarThickness: 36 }] },
  options: { scales: { x: noGrid, y: countY }, plugins: { legend: { display: false } } } });
mk('cPay', { type: 'pie', data: { labels: __PL__, datasets: [{ data: __PV__, backgroundColor: __PC__, borderColor: '#fff', borderWidth: 3 }] },
  options: { plugins: pieCount } });
";

            string js = RptUtil.Fill(charts,
                "__SL__", Rpt.JsArr(statuses.Select(x => x.Name)),
                "__SV__", Rpt.JsNums(statuses.Select(x => (decimal)x.Count)),
                "__SC__", Rpt.JsArr(statuses.Select((x, i) => Rpt.StatusColor(x.Name, i))),
                "__ML__", Rpt.JsArr(months.Select(m => Rpt.MonthLabel(m))),
                "__DS__", datasets.ToString(),
                "__AL__", Rpt.JsArr(ageLabels),
                "__AV__", Rpt.JsNums(age),
                "__WL__", Rpt.JsArr(RptUtil.DayNames),
                "__WV__", Rpt.JsNums(day),
                "__PL__", Rpt.JsArr(payPos.Select(x => x.Name)),
                "__PV__", Rpt.JsNums(payPos.Select(x => (decimal)x.Count)),
                "__PC__", Rpt.JsArr(payPos.Select((x, i) => Rpt.StatusColor(x.Name, i))));

            return new ReportView
            {
                Eyebrow = "MANAGER PORTAL",
                Heading = "Order Report",
                Intro = "Every order's status, age and payment position.",
                Active = "orders",
                Body = body.ToString(),
                Script = Rpt.Script(js)
            };
        }
    }

    // =====================================================================
    //  3. CUSTOMER REPORT
    // =====================================================================
    public static class CustomerReportBuilder
    {
        public static ReportView Build(List<CustomerRow> customers, List<OrderRow> orders, List<RatingRow> ratings, int range)
        {
            var sold = orders.Where(o => !Rpt.IsCancelled(o.Status) && o.CustomerId.HasValue).ToList();

            // orders / spend per customer
            var ordersBy = new Dictionary<int, int>();
            var spendBy = new Dictionary<int, decimal>();
            foreach (OrderRow o in sold)
            {
                int id = o.CustomerId.Value;
                ordersBy[id] = (ordersBy.ContainsKey(id) ? ordersBy[id] : 0) + 1;
                spendBy[id] = (spendBy.ContainsKey(id) ? spendBy[id] : 0m) + o.Total;
            }

            int active = customers.Count(c => ordersBy.ContainsKey(c.Id));
            int repeat = customers.Count(c => ordersBy.ContainsKey(c.Id) && ordersBy[c.Id] >= 2);
            int none = customers.Count - active;
            int once = active - repeat;
            decimal avgSpend = active > 0 ? sold.Sum(o => o.Total) / active : 0m;
            double avgRating = ratings.Count > 0 ? ratings.Average(r => r.Score) : 0;

            var types = customers.GroupBy(c => c.Type).Select(g => new { Name = g.Key, Count = g.Count() }).OrderByDescending(x => x.Count).ToList();
            var towns = customers.GroupBy(c => c.Town).Select(g => new { Name = g.Key, Count = g.Count() }).OrderByDescending(x => x.Count).Take(8).ToList();

            var top = customers.Where(c => spendBy.ContainsKey(c.Id))
                               .Select(c => new { c.Name, Value = spendBy[c.Id] })
                               .OrderByDescending(x => x.Value).Take(6).ToList();

            // ratings
            var dist = new decimal[5];
            foreach (RatingRow r in ratings) dist[r.Score - 1]++;

            var months = Rpt.Months(range, ratings.Select(r => r.Date));
            var avgByMonth = new List<decimal?>();
            foreach (DateTime m in months)
            {
                string key = Rpt.MonthKey(m);
                var inMonth = ratings.Where(r => Rpt.MonthKey(r.Date) == key).ToList();
                avgByMonth.Add(inMonth.Count > 0 ? (decimal?)Math.Round((decimal)inMonth.Average(r => r.Score), 2) : null);
            }

            // timeline: latest reviews
            var timeline = new List<TimelineItem>();
            foreach (RatingRow r in ratings.OrderByDescending(x => x.Date).Take(6))
            {
                timeline.Add(new TimelineItem
                {
                    Date = Rpt.DateText(r.Date),
                    Title = "<span style=\"color:#d9a52c\">" + Rpt.Stars(r.Score) + "</span> &nbsp;" + r.Score + " / 5",
                    Text = string.IsNullOrWhiteSpace(r.Review) ? "<i>No written review.</i>" : Rpt.Esc(r.Review),
                    Color = r.Score >= 4 ? "#2f8f5b" : r.Score == 3 ? "#d9a52c" : "#c84b4b"
                });
            }

            var body = new StringBuilder();
            body.Append("<section class=\"rp-kpis\">")
                .Append(Rpt.Kpi("TOTAL CUSTOMERS", Rpt.Int(customers.Count), "Registered accounts", "#2a2118", "&#9673;"))
                .Append(Rpt.Kpi("ACTIVE CUSTOMERS", Rpt.Int(active), "Have placed at least one order", "#2f8f5b", "&#10003;"))
                .Append(Rpt.Kpi("REPEAT CUSTOMERS", Rpt.Int(repeat), "Ordered two or more times", "#d9711f", "&#8635;"))
                .Append(Rpt.Kpi("AVERAGE SPEND", Rpt.Money(Math.Round(avgSpend, 2)), "Per customer who has ordered", "#d9a52c", "R"))
                .Append(Rpt.Kpi("AVERAGE RATING", ratings.Count > 0 ? avgRating.ToString("0.0", CultureInfo.InvariantCulture) + " / 5" : "No ratings", Rpt.Int(ratings.Count) + " customer reviews", "#7a5c99", "&#9733;"))
                .Append("</section><div class=\"rp-grid\">")
                .Append(Rpt.ChartCard("cType", "Customer Types", "Individual vs business accounts", 4, 300))
                .Append(Rpt.ChartCard("cLoyal", "Customer Loyalty", "How often customers come back", 4, 300))
                .Append(Rpt.ChartCard("cTown", "Where Customers Are", "Customers by town (top 8)", 4, 300))
                .Append(Rpt.ChartCard("cTop", "Top Customers by Spend", "Who spends the most with Avuna", 6, 320))
                .Append(Rpt.ChartCard("cRate", "Rating Breakdown", "How many reviews gave each star rating", 6, 320))
                .Append(Rpt.ChartCard("cTrend", "Average Rating Over Time", "Average review score per month", 6, 300))
                .Append(Rpt.HtmlCard("Review Timeline", "What customers said most recently", 6, Rpt.Timeline(timeline)))
                .Append("</div>");

            const string charts = @"
mk('cType', { type: 'doughnut', data: { labels: __TL__, datasets: [{ data: __TV__, backgroundColor: P, borderColor: '#fff', borderWidth: 3 }] },
  options: { cutout: '62%', plugins: pieCount } });
mk('cLoyal', { type: 'pie', data: { labels: ['Never ordered', 'Ordered once', 'Repeat customers'], datasets: [{ data: __LV__, backgroundColor: ['#c9d1cd', '#d9a52c', '#2f8f5b'], borderColor: '#fff', borderWidth: 3 }] },
  options: { plugins: pieCount } });
mk('cTown', { type: 'bar', data: { labels: __NL__, datasets: [{ label: 'Customers', data: __NV__, backgroundColor: P, borderRadius: 8, maxBarThickness: 26 }] },
  options: { indexAxis: 'y', scales: { x: countY, y: noGrid }, plugins: { legend: { display: false } } } });
mk('cTop', { type: 'bar', data: { labels: __PL__, datasets: [{ data: __PV__, backgroundColor: P, borderRadius: 8, maxBarThickness: 30 }] },
  options: { indexAxis: 'y', scales: { x: moneyY, y: noGrid }, plugins: { legend: { display: false }, tooltip: moneyTipH } } });
mk('cRate', { type: 'bar', data: { labels: ['1 star', '2 stars', '3 stars', '4 stars', '5 stars'], datasets: [{ label: 'Reviews', data: __RV__, backgroundColor: ['#c84b4b', '#e08a3c', '#d9a52c', '#8bb15b', '#2f8f5b'], borderRadius: 8, maxBarThickness: 56 }] },
  options: { scales: { x: noGrid, y: countY }, plugins: { legend: { display: false } } } });
mk('cTrend', { type: 'line', data: { labels: __ML__, datasets: [{ label: 'Average rating', data: __AV__, borderColor: '#7a5c99', backgroundColor: 'rgba(122,92,153,.15)', fill: true, tension: .35, borderWidth: 3, spanGaps: true, pointBackgroundColor: '#fff', pointBorderColor: '#7a5c99', pointBorderWidth: 2, pointRadius: 5 }] },
  options: { scales: { x: noGrid, y: { min: 0, max: 5, grid: { color: GRID }, ticks: { stepSize: 1 } } }, plugins: { legend: { display: false } } } });
";

            string js = RptUtil.Fill(charts,
                "__TL__", Rpt.JsArr(types.Select(x => x.Name)),
                "__TV__", Rpt.JsNums(types.Select(x => (decimal)x.Count)),
                "__LV__", Rpt.JsNums(new decimal[] { none, once, repeat }),
                "__NL__", Rpt.JsArr(towns.Select(x => x.Name)),
                "__NV__", Rpt.JsNums(towns.Select(x => (decimal)x.Count)),
                "__PL__", Rpt.JsArr(top.Select(x => x.Name)),
                "__PV__", Rpt.JsNums(top.Select(x => x.Value)),
                "__RV__", Rpt.JsNums(dist),
                "__ML__", Rpt.JsArr(months.Select(m => Rpt.MonthLabel(m))),
                "__AV__", Rpt.JsNumsN(avgByMonth));

            return new ReportView
            {
                Eyebrow = "MANAGER PORTAL",
                Heading = "Customer Report",
                Intro = "Who your customers are, how often they return and what they say.",
                Active = "customers",
                Body = body.ToString(),
                Script = Rpt.Script(js)
            };
        }
    }

    // =====================================================================
    //  4. STAFF REPORT
    // =====================================================================
    public static class StaffReportBuilder
    {
        public static ReportView Build(List<StaffRow> admin, List<StaffRow> production, List<PaymentRow> pays, int range)
        {
            int managers = admin.Count(s => string.Equals(s.Role, "Manager", StringComparison.OrdinalIgnoreCase));
            var handled = pays.Where(p => !string.IsNullOrEmpty(p.StaffId)).ToList();

            // staff by role (admin roles + production staff)
            var roles = admin.GroupBy(s => string.IsNullOrWhiteSpace(s.Role) ? "Staff" : s.Role)
                             .Select(g => new { Name = g.Key, Count = g.Count() }).ToList();
            if (production.Count > 0) roles.Add(new { Name = "Production Staff", Count = production.Count });

            // payments processed per staff member
            var nameById = new Dictionary<string, string>();
            foreach (StaffRow s in admin) nameById[s.Id] = string.IsNullOrWhiteSpace(s.Name) ? s.Id : s.Name;
            var perStaff = handled.GroupBy(p => p.StaffId)
                                  .Select(g => new { Name = nameById.ContainsKey(g.Key) ? nameById[g.Key] : g.Key, Count = g.Count(), Value = g.Sum(x => x.Amount) })
                                  .OrderByDescending(x => x.Value).Take(8).ToList();

            // payments per month
            var months = Rpt.Months(range, pays.Where(p => p.Date.HasValue).Select(p => p.Date.Value));
            var valueBy = new Dictionary<string, decimal>();
            var countBy = new Dictionary<string, int>();
            foreach (DateTime m in months) { valueBy[Rpt.MonthKey(m)] = 0m; countBy[Rpt.MonthKey(m)] = 0; }
            foreach (PaymentRow p in handled)
            {
                if (!p.Date.HasValue) continue;
                string k = Rpt.MonthKey(p.Date.Value);
                if (valueBy.ContainsKey(k)) { valueBy[k] += p.Amount; countBy[k]++; }
            }

            var body = new StringBuilder();
            body.Append("<section class=\"rp-kpis\">")
                .Append(Rpt.Kpi("ADMIN STAFF", Rpt.Int(admin.Count), "Managers and administrators", "#2a2118", "&#10003;"))
                .Append(Rpt.Kpi("MANAGERS", Rpt.Int(managers), "With manager access", "#d9711f", "&#9733;"))
                .Append(Rpt.Kpi("PRODUCTION STAFF", Rpt.Int(production.Count), "Making the orders", "#2f8f83", "&#9881;"))
                .Append(Rpt.Kpi("PAYMENTS PROCESSED", Rpt.Int(handled.Count), "Payments captured by staff", "#d9a52c", "#"))
                .Append(Rpt.Kpi("VALUE PROCESSED", Rpt.Money(handled.Sum(p => p.Amount)), "Total of those payments", "#7a5c99", "R"))
                .Append("</section><div class=\"rp-grid\">")
                .Append(Rpt.ChartCard("cRoles", "Team by Role", "How the team is made up", 4, 320))
                .Append(Rpt.ChartCard("cPerStaff", "Payments Processed per Staff Member", "Value (bars) and number of payments (line)", 8, 320))
                .Append(Rpt.ChartCard("cMonthly", "Payment Activity by Month", "Value and number of payments processed by staff", 12, 300))
                .Append(Rpt.HtmlCard("Admin Staff", "Managers and administrators", 6, Directory(admin)))
                .Append(Rpt.HtmlCard("Production Staff", "The team making the orders", 6, Directory(production)))
                .Append("</div>");

            const string charts = @"
mk('cRoles', { type: 'doughnut', data: { labels: __RL__, datasets: [{ data: __RV__, backgroundColor: P, borderColor: '#fff', borderWidth: 3 }] },
  options: { cutout: '62%', plugins: pieCount } });
mk('cPerStaff', { type: 'bar', data: { labels: __SL__, datasets: [
  { type: 'bar', label: 'Value', data: __SV__, backgroundColor: P, borderRadius: 8, maxBarThickness: 46, order: 2 },
  { type: 'line', label: 'Payments', data: __SC__, borderColor: '#2a2118', backgroundColor: '#2a2118', borderWidth: 3, tension: .15, pointRadius: 4, yAxisID: 'y1', order: 1 } ] },
  options: { scales: { x: noGrid, y: moneyY, y1: { position: 'right', beginAtZero: true, grid: { drawOnChartArea: false }, ticks: { precision: 0 } } },
    plugins: { legend: { display: false }, tooltip: { callbacks: { label: function(c){ return ' ' + c.dataset.label + ': ' + (c.dataset.yAxisID === 'y1' ? c.parsed.y : R(c.parsed.y)); } } } } } });
mk('cMonthly', { type: 'bar', data: { labels: __ML__, datasets: [
  { type: 'bar', label: 'Value', data: __MV__, backgroundColor: '#2f8f83', borderRadius: 8, maxBarThickness: 46, order: 2 },
  { type: 'line', label: 'Payments', data: __MC__, borderColor: '#d9711f', backgroundColor: '#d9711f', borderWidth: 3, tension: .15, pointRadius: 4, yAxisID: 'y1', order: 1 } ] },
  options: { interaction: { mode: 'index', intersect: false }, scales: { x: noGrid, y: moneyY, y1: { position: 'right', beginAtZero: true, grid: { drawOnChartArea: false }, ticks: { precision: 0 } } },
    plugins: { legend: { position: 'top', align: 'end' }, tooltip: { callbacks: { label: function(c){ return ' ' + c.dataset.label + ': ' + (c.dataset.yAxisID === 'y1' ? c.parsed.y : R(c.parsed.y)); } } } } } });
";

            string js = RptUtil.Fill(charts,
                "__RL__", Rpt.JsArr(roles.Select(x => x.Name)),
                "__RV__", Rpt.JsNums(roles.Select(x => (decimal)x.Count)),
                "__SL__", Rpt.JsArr(perStaff.Select(x => x.Name)),
                "__SV__", Rpt.JsNums(perStaff.Select(x => x.Value)),
                "__SC__", Rpt.JsNums(perStaff.Select(x => (decimal)x.Count)),
                "__ML__", Rpt.JsArr(months.Select(m => Rpt.MonthLabel(m))),
                "__MV__", Rpt.JsNums(months.Select(m => valueBy[Rpt.MonthKey(m)])),
                "__MC__", Rpt.JsNums(months.Select(m => (decimal)countBy[Rpt.MonthKey(m)])));

            return new ReportView
            {
                Eyebrow = "MANAGER PORTAL",
                Heading = "Staff Report",
                Intro = "Your team, their roles and the payments they process.",
                Active = "staff",
                Body = body.ToString(),
                Script = Rpt.Script(js)
            };
        }

        private static string Directory(List<StaffRow> staff)
        {
            var sb = new StringBuilder("<div class=\"rp-table-wrap\"><table class=\"rp-table\"><thead><tr>");
            sb.Append("<th>STAFF NO.</th><th>NAME</th><th>ROLE</th><th>EMAIL</th><th>PHONE</th></tr></thead><tbody>");
            if (staff.Count == 0)
            {
                sb.Append("<tr><td colspan=\"5\" style=\"text-align:center;color:#78827f;padding:26px\">No staff found.</td></tr>");
            }
            foreach (StaffRow s in staff)
            {
                sb.Append("<tr><td class=\"rp-strong\">").Append(Rpt.Esc(s.Id)).Append("</td>")
                  .Append("<td>").Append(Rpt.Esc(s.Name)).Append("</td>")
                  .Append("<td>").Append(Rpt.Esc(s.Role)).Append("</td>")
                  .Append("<td>").Append(Rpt.Esc(s.Email)).Append("</td>")
                  .Append("<td>").Append(Rpt.Esc(s.Phone)).Append("</td></tr>");
            }
            return sb.Append("</tbody></table></div>").ToString();
        }
    }

    // =====================================================================
    //  Loads the data for the requested report and builds it
    // =====================================================================
    public static class ReportPages
    {
        public static ReportView Build(string report, int range, List<string> problems)
        {
            using (var conn = Rpt.Open(problems))
            {
                switch (report)
                {
                    case "orders":
                        return OrderReportBuilder.Build(Rpt.LoadOrders(conn, problems), Rpt.LoadPayments(conn, problems), range);

                    case "customers":
                        return CustomerReportBuilder.Build(Rpt.LoadCustomers(conn, problems), Rpt.LoadOrders(conn, problems), Rpt.LoadRatings(conn, problems), range);

                    case "staff":
                        return StaffReportBuilder.Build(Rpt.LoadAdminStaff(conn, problems), Rpt.LoadProductionStaff(conn, problems), Rpt.LoadPayments(conn, problems), range);

                    default:
                        return SalesReportBuilder.Build(Rpt.LoadOrders(conn, problems), Rpt.LoadPayments(conn, problems), range);
                }
            }
        }
    }
}