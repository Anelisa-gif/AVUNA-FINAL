using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace AVUNA_COLLECTIVE
{
    // One staff member, as shown in the directory and in the edit form
    public class StaffPerson
    {
        public string Kind;      // "admin" or "production"
        public string Id;
        public string First;
        public string Last;
        public string Phone;
        public string Email;
        public string Role;
        public string Username;

        public string FullName
        {
            get { return ((First ?? "") + " " + (Last ?? "")).Trim(); }
        }
    }

    // The real column names of the productionStaff table (found automatically)
    public class ProductionColumns
    {
        public string Id;
        public string First;
        public string Last;
        public string Phone;
        public string Email;
        public string Password;
    }

    public partial class ManageStaff : System.Web.UI.Page
    {
        // ---- the live tables and the tables that staff are moved into when archived ----
        // If your archive tables have different names in SQL Server, change these two lines.
        private const string AdminTable = "AdminStaff";
        private const string ArchivedAdminTable = "ArchivedAdminStaff";
        private const string ProductionTable = "productionStaff";
        private const string ArchivedProductionTable = "ArchivedProductionStaff";

        private bool CanArchive
        {
            get { return Session["staff_Role"] != null && Session["staff_Role"].ToString() == "Manager"; }
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

            LoadStaff();
        }

        // ---------- Archive button ----------
        protected void btnArchive_Click(object sender, EventArgs e)
        {
            string kind = (hfKind.Value ?? "").Trim();
            string id = (hfId.Value ?? "").Trim();
            hfKind.Value = "";
            hfId.Value = "";

            string message;
            bool ok = false;

            if (!CanArchive)
            {
                message = "Only a manager can archive staff.";
            }
            else if (id.Length == 0 || (kind != "admin" && kind != "production"))
            {
                message = "No staff member was selected.";
            }
            else if (kind == "admin" && string.Equals(id, Convert.ToString(Session["staff_ID"]), StringComparison.OrdinalIgnoreCase))
            {
                message = "You cannot archive the account you are logged in with.";
            }
            else
            {
                message = ArchiveStaff(kind, id, out ok);
            }

            litActionMessage.Text = "<div style=\"background:" + (ok ? "#e8f4ec;border:1px solid #bfe0c9;color:#267347" : "#fdeaea;border:1px solid #f0c4c4;color:#8a2f2f") +
                                    ";border-radius:14px;padding:12px 18px;font-size:13px;margin-bottom:22px;line-height:1.6\">" + HttpUtility.HtmlEncode(message) + "</div>";

            LoadStaff();
        }

        // Copies the staff record into the archive table and removes it from the live table (all or nothing).
        private string ArchiveStaff(string kind, string id, out bool ok)
        {
            ok = false;
            string live = kind == "admin" ? AdminTable : ProductionTable;
            string archive = kind == "admin" ? ArchivedAdminTable : ArchivedProductionTable;

            try
            {
                using (var conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString))
                {
                    conn.Open();
                    // name for the message (read before the transaction starts)
                    string who = id;
                    foreach (StaffRow s in (kind == "admin" ? Rpt.LoadAdminStaff(conn, new List<string>()) : Rpt.LoadProductionStaff(conn, new List<string>())))
                    {
                        if (string.Equals((s.Id ?? "").Trim(), id, StringComparison.OrdinalIgnoreCase) && s.Name.Length > 0) { who = s.Name; break; }
                    }

                    using (SqlTransaction tx = conn.BeginTransaction())
                    {
                        // the live table's own columns (first column = the staff ID)
                        var cols = new List<string>();
                        using (var cmd = new SqlCommand("SELECT TOP 0 * FROM [" + live + "]", conn, tx))
                        using (var r = cmd.ExecuteReader(CommandBehavior.SchemaOnly))
                        {
                            for (int i = 0; i < r.FieldCount; i++) cols.Add(r.GetName(i));
                        }

                        string idCol = cols[0];
                        string list = string.Join(", ", cols.Select(c => "[" + c + "]").ToArray());

                        int copied;
                        using (var ins = new SqlCommand("INSERT INTO [" + archive + "] (" + list + ") SELECT " + list + " FROM [" + live + "] WHERE [" + idCol + "] = @id", conn, tx))
                        {
                            ins.Parameters.AddWithValue("@id", id);
                            copied = ins.ExecuteNonQuery();
                        }

                        if (copied == 0)
                        {
                            tx.Rollback();
                            return "That staff member could not be found (they may already have been archived).";
                        }

                        using (var del = new SqlCommand("DELETE FROM [" + live + "] WHERE [" + idCol + "] = @id", conn, tx))
                        {
                            del.Parameters.AddWithValue("@id", id);
                            del.ExecuteNonQuery();
                        }

                        tx.Commit();
                        ok = true;
                        return who + " (" + id + ") has been archived.";
                    }
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 547)
                    return "This staff member cannot be removed because other records (for example payments) still refer to them. Nothing was changed.";
                if (ex.Number == 2627 || ex.Number == 2601)
                    return "A staff member with this number is already in the archive. Nothing was changed.";
                return "The staff member could not be archived: " + ex.Message;
            }
            catch (Exception ex)
            {
                return "The staff member could not be archived: " + ex.Message;
            }
        }

        private void LoadStaff()
        {
            var problems = new List<string>();
            List<StaffPerson> admin;
            List<StaffPerson> production;
            List<PaymentRow> pays;
            List<OrderRow> orders;
            string nextAdminId = "ADM001";
            string nextProductionId = "PRD001";

            // Rpt (in Reports.aspx.cs) reads payments and orders. Passwords are never read.
            using (var conn = Rpt.Open(problems))
            {
                admin = LoadAdminPeople(conn, problems);
                production = LoadProductionPeople(conn, problems);
                pays = Rpt.LoadPayments(conn, problems);
                orders = Rpt.LoadOrders(conn, problems);

                // the staff numbers the next new people will get (archived staff numbers are never reused)
                if (conn != null)
                {
                    try
                    {
                        nextAdminId = NextId(admin.Select(x => x.Id).Concat(ReadIds(conn, null, ArchivedAdminTable, "staff_ID")), "ADM");
                        ProductionColumns pc = GetProductionColumns(conn, null);
                        nextProductionId = NextId(production.Select(x => x.Id).Concat(ReadIds(conn, null, ArchivedProductionTable, pc.Id)), "PRD");
                    }
                    catch (Exception ex)
                    {
                        problems.Add("Staff numbers: " + ex.Message);
                    }
                }
            }

            litNextIds.Text = "<script>var NEXT_ADMIN_ID = " + Rpt.JsStr(nextAdminId) + "; var NEXT_PRODUCTION_ID = " + Rpt.JsStr(nextProductionId) +
                              "; var CAN_MANAGE = " + (CanArchive ? "true" : "false") + ";</script>";

            int inProduction = orders.Count(o => string.Equals((o.Status ?? "").Trim(), "In Progress", StringComparison.OrdinalIgnoreCase));

            litTotalStaff.Text = Rpt.Int(admin.Count + production.Count);
            litAdminCount.Text = Rpt.Int(admin.Count);
            litProductionCount.Text = Rpt.Int(production.Count);
            litInProduction.Text = Rpt.Int(inProduction);
            litDirectorySubtitle.Text = Rpt.Int(admin.Count + production.Count) + " people currently on the AVUNA COLLECTIVE staff records.";

            if (problems.Count > 0)
            {
                var n = new StringBuilder("<div style=\"background:#fdeaea;border:1px solid #f0c4c4;color:#8a2f2f;border-radius:14px;padding:12px 18px;font-size:12px;margin-bottom:22px;line-height:1.6\"><strong>Some information could not be loaded from SQL Server.</strong><br />");
                foreach (string p in problems) n.Append(HttpUtility.HtmlEncode(p)).Append("<br />");
                n.Append("</div>");
                litDbNotice.Text = n.ToString();
            }

            // roles offered in the edit and add forms (whatever roles exist in the database + the two standard ones)
            var roles = new List<string> { "Manager", "Admin Staff" };
            foreach (StaffPerson a in admin)
            {
                if (!string.IsNullOrWhiteSpace(a.Role) && !roles.Contains(a.Role, StringComparer.OrdinalIgnoreCase)) roles.Add(a.Role);
            }
            var opts = new StringBuilder();
            foreach (string r in roles) opts.Append("<option value=\"").Append(HttpUtility.HtmlAttributeEncode(r)).Append("\">").Append(HttpUtility.HtmlEncode(r)).Append("</option>");
            litRoleOptions.Text = opts.ToString();

            // the Add pop-up offers all three: Manager, Admin Staff and Production Staff
            var addOpts = new StringBuilder();
            addOpts.Append("<option value=\"Manager\">Manager</option><option value=\"Admin Staff\">Admin Staff</option><option value=\"Production Staff\">Production Staff</option>");
            foreach (string r in roles)
            {
                if (r.Equals("Manager", StringComparison.OrdinalIgnoreCase) || r.Equals("Admin Staff", StringComparison.OrdinalIgnoreCase)) continue;
                addOpts.Append("<option value=\"").Append(HttpUtility.HtmlAttributeEncode(r)).Append("\">").Append(HttpUtility.HtmlEncode(r)).Append("</option>");
            }
            litAddRoleOptions.Text = addOpts.ToString();

            // payments handled per admin staff member
            var handled = pays.Where(p => !string.IsNullOrEmpty(p.StaffId))
                              .GroupBy(p => p.StaffId.Trim())
                              .ToDictionary(g => g.Key, g => g.Count());

            var rows = new StringBuilder();

            foreach (StaffPerson s in admin.OrderBy(x => x.FullName))
            {
                string id = (s.Id ?? "").Trim();
                bool isManager = string.Equals(s.Role, "Manager", StringComparison.OrdinalIgnoreCase);
                rows.Append(Row(s, isManager ? "avuna-pending" : "avuna-completed", handled.ContainsKey(id) ? handled[id].ToString() : "0"));
            }
            foreach (StaffPerson s in production.OrderBy(x => x.FullName))
            {
                rows.Append(Row(s, "avuna-production", "&mdash;"));
            }

            if (rows.Length == 0)
            {
                rows.Append("<tr><td colspan=\"7\" style=\"text-align:center;color:#78827f;padding:30px\">No staff were found in the database.</td></tr>");
            }

            litStaffRows.Text = rows.ToString();
        }

        // ---------- reading staff (names, phone, email, role, username - never passwords) ----------
        private static string Text(SqlDataReader r, int i)
        {
            return r.IsDBNull(i) ? "" : Convert.ToString(r.GetValue(i)).Trim();
        }

        private static List<StaffPerson> LoadAdminPeople(SqlConnection conn, List<string> problems)
        {
            var list = new List<StaffPerson>();
            if (conn == null) return list;
            try
            {
                const string sql = "SELECT staff_ID, staff_First_Name, staff_Last_Name, staff_Phone_Number, staff_Email, staff_Role, staff_username FROM " + AdminTable;
                using (var cmd = new SqlCommand(sql, conn))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new StaffPerson
                        {
                            Kind = "admin",
                            Id = Text(r, 0),
                            First = Text(r, 1),
                            Last = Text(r, 2),
                            Phone = Text(r, 3),
                            Email = Text(r, 4),
                            Role = Text(r, 5),
                            Username = Text(r, 6)
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

        private static ProductionColumns GetProductionColumns(SqlConnection conn, SqlTransaction tx)
        {
            var c = new ProductionColumns();
            using (var cmd = new SqlCommand("SELECT TOP 0 * FROM [" + ProductionTable + "]", conn, tx))
            using (var r = cmd.ExecuteReader(CommandBehavior.SchemaOnly))
            {
                for (int i = 0; i < r.FieldCount; i++)
                {
                    string name = r.GetName(i);
                    string n = name.ToLowerInvariant();
                    if (i == 0) c.Id = name;                      // the first column is the staff number
                    else if (n.Contains("password")) c.Password = name;
                    else if (n.Contains("first")) c.First = name;
                    else if (n.Contains("last")) c.Last = name;
                    else if (n.Contains("phone")) c.Phone = name;
                    else if (n.Contains("email")) c.Email = name;
                }
            }
            return c;
        }

        private static string Pick(string column)
        {
            return column == null ? "''" : "[" + column + "]";
        }

        private static List<StaffPerson> LoadProductionPeople(SqlConnection conn, List<string> problems)
        {
            var list = new List<StaffPerson>();
            if (conn == null) return list;
            try
            {
                ProductionColumns c = GetProductionColumns(conn, null);
                string sql = "SELECT " + Pick(c.Id) + ", " + Pick(c.First) + ", " + Pick(c.Last) + ", " + Pick(c.Phone) + ", " + Pick(c.Email) + " FROM [" + ProductionTable + "]";
                using (var cmd = new SqlCommand(sql, conn))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new StaffPerson
                        {
                            Kind = "production",
                            Id = Text(r, 0),
                            First = Text(r, 1),
                            Last = Text(r, 2),
                            Phone = Text(r, 3),
                            Email = Text(r, 4),
                            Role = "Production Staff",
                            Username = ""
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

        // ---------- Save button in the edit pop-up ----------
        protected void btnSave_Click(object sender, EventArgs e)
        {
            string kind = (Request.Form["edKind"] ?? "").Trim();
            string id = (Request.Form["edId"] ?? "").Trim();
            string first = (Request.Form["edFirst"] ?? "").Trim();
            string last = (Request.Form["edLast"] ?? "").Trim();
            string phone = (Request.Form["edPhone"] ?? "").Trim();
            string email = (Request.Form["edEmail"] ?? "").Trim();
            string role = (Request.Form["edRole"] ?? "").Trim();
            string username = (Request.Form["edUsername"] ?? "").Trim();
            string password = Request.Form["edPassword"] ?? "";

            bool isSelf = kind == "admin" && string.Equals(id, Convert.ToString(Session["staff_ID"]), StringComparison.OrdinalIgnoreCase);

            string error = Validate(kind, id, first, last, phone, email, username, password);
            if (error == null && !CanArchive) error = "Only a manager can edit staff details.";

            if (error == null)
            {
                error = SaveStaff(kind, id, first, last, phone, email, role, username, password, isSelf);
            }

            if (error == null)
            {
                string fullName = (first + " " + last).Trim();

                if (isSelf)
                {
                    Session["staff_First_Name"] = first;
                    Session["staff_Last_Name"] = last;
                    litManagerName.Text = HttpUtility.HtmlEncode(fullName);
                }

                litActionMessage.Text = Notice(true, fullName + "'s details were saved to the database.");
                LoadStaff();
                return;
            }

            // something was wrong: show the message and re-open the pop-up with what was typed
            litEditError.Text = "<div class=\"avuna-modal-error\">" + HttpUtility.HtmlEncode(error) + "</div>";
            LoadStaff();

            string js = "openEdit({kind:" + Rpt.JsStr(kind) + ",id:" + Rpt.JsStr(id) + ",first:" + Rpt.JsStr(first) + ",last:" + Rpt.JsStr(last) +
                        ",phone:" + Rpt.JsStr(phone) + ",email:" + Rpt.JsStr(email) + ",role:" + Rpt.JsStr(role) + ",username:" + Rpt.JsStr(username) +
                        ",self:" + (isSelf ? "true" : "false") + "});";
            ClientScript.RegisterStartupScript(GetType(), "reopenEdit", js, true);
        }

        private static string Validate(string kind, string id, string first, string last, string phone, string email, string username, string password)
        {
            if (id.Length == 0 || (kind != "admin" && kind != "production")) return "No staff member was selected.";
            if (first.Length == 0) return "Please enter the first name.";
            if (last.Length == 0) return "Please enter the last name.";
            if (first.Length > 50 || last.Length > 50) return "Names can be at most 50 characters.";
            if (phone.Length == 0) return "Please enter a phone number.";
            if (!System.Text.RegularExpressions.Regex.IsMatch(phone, @"^[0-9+()\- ]{7,20}$")) return "Please enter a valid phone number (digits only, up to 20 characters).";
            if (email.Length == 0) return "Please enter an email address.";
            if (email.Length > 50 || !System.Text.RegularExpressions.Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$")) return "Please enter a valid email address (at most 50 characters).";
            if (kind == "admin" && username.Length == 0) return "Please enter a username - the staff member needs it to log in.";
            if (username.Length > 100) return "The username can be at most 100 characters.";
            if (password.Length > 50) return "The password can be at most 50 characters.";
            return null;
        }

        private static string Notice(bool ok, string message)
        {
            return "<div style=\"background:" + (ok ? "#e8f4ec;border:1px solid #bfe0c9;color:#267347" : "#fdeaea;border:1px solid #f0c4c4;color:#8a2f2f") +
                   ";border-radius:14px;padding:12px 18px;font-size:13px;margin-bottom:22px;line-height:1.6\">" + HttpUtility.HtmlEncode(message) + "</div>";
        }

        // Writes the changes to the staff table. Returns null when it worked, otherwise a message.
        private string SaveStaff(string kind, string id, string first, string last, string phone, string email, string role, string username, string password, bool isSelf)
        {
            try
            {
                using (var conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString))
                {
                    conn.Open();
                    using (SqlTransaction tx = conn.BeginTransaction())
                    {
                        int changed;

                        if (kind == "admin")
                        {
                            // the username must be unique
                            using (var dup = new SqlCommand("SELECT COUNT(*) FROM [" + AdminTable + "] WHERE staff_username = @u AND staff_ID <> @id", conn, tx))
                            {
                                dup.Parameters.AddWithValue("@u", username);
                                dup.Parameters.AddWithValue("@id", id);
                                if (Convert.ToInt32(dup.ExecuteScalar()) > 0)
                                {
                                    tx.Rollback();
                                    return "That username is already used by another staff member. Please choose a different one.";
                                }
                            }

                            var sql = new StringBuilder("UPDATE [" + AdminTable + "] SET staff_First_Name = @f, staff_Last_Name = @l, staff_Phone_Number = @p, staff_Email = @e, staff_username = @u");
                            if (!isSelf && role.Length > 0) sql.Append(", staff_Role = @r");      // you cannot change your own role
                            if (password.Length > 0) sql.Append(", staff_Password = @pw");
                            sql.Append(" WHERE staff_ID = @id");

                            using (var cmd = new SqlCommand(sql.ToString(), conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@f", first);
                                cmd.Parameters.AddWithValue("@l", last);
                                cmd.Parameters.AddWithValue("@p", phone);
                                cmd.Parameters.AddWithValue("@e", email);
                                cmd.Parameters.AddWithValue("@u", username);
                                cmd.Parameters.AddWithValue("@id", id);
                                if (!isSelf && role.Length > 0) cmd.Parameters.AddWithValue("@r", role);
                                if (password.Length > 0) cmd.Parameters.AddWithValue("@pw", password);
                                changed = cmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            ProductionColumns c = GetProductionColumns(conn, tx);
                            if (c.First == null || c.Last == null || c.Phone == null || c.Email == null)
                            {
                                tx.Rollback();
                                return "The production staff table's columns could not be recognised, so nothing was changed.";
                            }

                            var sql = new StringBuilder("UPDATE [" + ProductionTable + "] SET [" + c.First + "] = @f, [" + c.Last + "] = @l, [" + c.Phone + "] = @p, [" + c.Email + "] = @e");
                            if (password.Length > 0 && c.Password != null) sql.Append(", [" + c.Password + "] = @pw");
                            sql.Append(" WHERE [" + c.Id + "] = @id");

                            using (var cmd = new SqlCommand(sql.ToString(), conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@f", first);
                                cmd.Parameters.AddWithValue("@l", last);
                                cmd.Parameters.AddWithValue("@p", phone);
                                cmd.Parameters.AddWithValue("@e", email);
                                cmd.Parameters.AddWithValue("@id", id);
                                if (password.Length > 0 && c.Password != null) cmd.Parameters.AddWithValue("@pw", password);
                                changed = cmd.ExecuteNonQuery();
                            }
                        }

                        if (changed == 0)
                        {
                            tx.Rollback();
                            return "That staff member could not be found (they may have been archived).";
                        }

                        tx.Commit();
                        return null;
                    }
                }
            }
            catch (Exception ex)
            {
                return "The details could not be saved: " + ex.Message;
            }
        }

        // ---------- Staff numbers: carry on from the existing ones ----------
        // Looks at the numbers already in use (for example AVU-A004, AVU-A005) and returns the next one (AVU-A006).
        private static string NextId(IEnumerable<string> ids, string fallbackPrefix)
        {
            var groups = new Dictionary<string, List<string[]>>(StringComparer.OrdinalIgnoreCase);
            foreach (string raw in ids)
            {
                string id = (raw ?? "").Trim();
                var m = System.Text.RegularExpressions.Regex.Match(id, @"^(.*?)(\d{1,9})$");
                if (!m.Success) continue;
                string prefix = m.Groups[1].Value;
                if (!groups.ContainsKey(prefix)) groups[prefix] = new List<string[]>();
                groups[prefix].Add(new[] { prefix, m.Groups[2].Value });
            }

            if (groups.Count == 0) return fallbackPrefix + "001";

            // the most used pattern wins
            List<string[]> best = groups.OrderByDescending(g => g.Value.Count).First().Value;
            int max = best.Max(x => int.Parse(x[1]));
            int width = best.Max(x => x[1].Length);
            string pre = best[0][0];
            return pre + (max + 1).ToString().PadLeft(width, '0');
        }

        // Reads every staff number in a table. For the archive tables a missing table is simply ignored.
        private static List<string> ReadIds(SqlConnection conn, SqlTransaction tx, string table, string idColumn)
        {
            var list = new List<string>();
            try
            {
                string hint = tx != null ? " WITH (UPDLOCK, HOLDLOCK)" : "";
                using (var cmd = new SqlCommand("SELECT [" + idColumn + "] FROM [" + table + "]" + hint, conn, tx))
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read()) list.Add(r.IsDBNull(0) ? "" : Convert.ToString(r.GetValue(0)).Trim());
                }
            }
            catch
            {
                if (tx != null) throw;       // the live table must be readable; an archive table is optional
            }
            return list;
        }

        // ---------- Add staff pop-up ----------
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string kind = (Request.Form["adKind"] ?? "").Trim();
            string first = (Request.Form["adFirst"] ?? "").Trim();
            string last = (Request.Form["adLast"] ?? "").Trim();
            string phone = (Request.Form["adPhone"] ?? "").Trim();
            string email = (Request.Form["adEmail"] ?? "").Trim();
            string role = (Request.Form["adRole"] ?? "").Trim();
            string username = (Request.Form["adUsername"] ?? "").Trim();
            string password = Request.Form["adPassword"] ?? "";
            // the role chosen in the drop-down decides which table the person goes into
            if (role.Equals("Production Staff", StringComparison.OrdinalIgnoreCase)) kind = "production";
            else if (role.Length > 0) kind = "admin";

            string error;
            if (!CanArchive)
            {
                error = "Only a manager can add staff.";
            }
            else
            {
                error = Validate(kind, "new", first, last, phone, email, username, password);
                if (error == null && password.Length == 0) error = "Please set a password for the new staff member.";
                if (error == null && kind == "admin" && role.Length == 0) error = "Please choose a role.";
            }

            string newId = null;
            if (error == null) error = AddStaffMember(kind, first, last, phone, email, role, username, password, out newId);

            if (error == null)
            {
                litActionMessage.Text = Notice(true, (first + " " + last).Trim() + " was added as " + (kind == "admin" ? "Admin Staff" : "Production Staff") +
                                                     " with staff number " + newId + ".");
                LoadStaff();
                return;
            }

            litAddError.Text = "<div class=\"avuna-modal-error\">" + HttpUtility.HtmlEncode(error) + "</div>";
            LoadStaff();

            string js = "openAddForm(" + Rpt.JsStr(kind) + ",{first:" + Rpt.JsStr(first) + ",last:" + Rpt.JsStr(last) + ",phone:" + Rpt.JsStr(phone) +
                        ",email:" + Rpt.JsStr(email) + ",role:" + Rpt.JsStr(role) + ",username:" + Rpt.JsStr(username) + ",password:" + Rpt.JsStr(password) + "});";
            ClientScript.RegisterStartupScript(GetType(), "reopenAdd", js, true);
        }

        // Adds the new person to the staff table with the next staff number. Returns null when it worked, otherwise a message.
        private string AddStaffMember(string kind, string first, string last, string phone, string email, string role, string username, string password, out string newId)
        {
            newId = null;
            try
            {
                using (var conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString))
                {
                    conn.Open();

                    ProductionColumns pc = null;
                    if (kind == "production")
                    {
                        pc = GetProductionColumns(conn, null);
                        if (pc.First == null || pc.Last == null || pc.Phone == null || pc.Email == null || pc.Password == null)
                            return "The production staff table's columns could not be recognised, so nobody was added.";
                    }

                    string idColumn = kind == "admin" ? "staff_ID" : pc.Id;
                    string liveTable = kind == "admin" ? AdminTable : ProductionTable;
                    string archiveTable = kind == "admin" ? ArchivedAdminTable : ArchivedProductionTable;

                    // numbers of archived staff are never reused
                    List<string> archivedIds = ReadIds(conn, null, archiveTable, idColumn);

                    using (SqlTransaction tx = conn.BeginTransaction())
                    {
                        if (kind == "admin")
                        {
                            // the role must be one that exists
                            var allowed = new List<string> { "Manager", "Admin Staff" };
                            using (var rc = new SqlCommand("SELECT DISTINCT staff_Role FROM [" + AdminTable + "]", conn, tx))
                            using (var rr = rc.ExecuteReader())
                            {
                                while (rr.Read()) { if (!rr.IsDBNull(0)) allowed.Add(rr.GetString(0).Trim()); }
                            }
                            if (!allowed.Contains(role, StringComparer.OrdinalIgnoreCase))
                            {
                                tx.Rollback();
                                return "Please choose a role from the list.";
                            }

                            // the username must be unique
                            using (var dup = new SqlCommand("SELECT COUNT(*) FROM [" + AdminTable + "] WHERE staff_username = @u", conn, tx))
                            {
                                dup.Parameters.AddWithValue("@u", username);
                                if (Convert.ToInt32(dup.ExecuteScalar()) > 0)
                                {
                                    tx.Rollback();
                                    return "That username is already used by another staff member. Please choose a different one.";
                                }
                            }
                        }

                        // next staff number (read inside the transaction so two people cannot get the same one)
                        List<string> ids = ReadIds(conn, tx, liveTable, idColumn);
                        ids.AddRange(archivedIds);
                        newId = NextId(ids, kind == "admin" ? "ADM" : "PRD");

                        if (kind == "admin")
                        {
                            using (var ins = new SqlCommand("INSERT INTO [" + AdminTable + "] (staff_ID, staff_First_Name, staff_Last_Name, staff_Phone_Number, staff_Email, staff_Role, staff_Password, staff_username) " +
                                                            "VALUES (@id, @f, @l, @p, @e, @r, @pw, @u)", conn, tx))
                            {
                                ins.Parameters.AddWithValue("@id", newId);
                                ins.Parameters.AddWithValue("@f", first);
                                ins.Parameters.AddWithValue("@l", last);
                                ins.Parameters.AddWithValue("@p", phone);
                                ins.Parameters.AddWithValue("@e", email);
                                ins.Parameters.AddWithValue("@r", role);
                                ins.Parameters.AddWithValue("@pw", password);
                                ins.Parameters.AddWithValue("@u", username);
                                ins.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            using (var ins = new SqlCommand("INSERT INTO [" + ProductionTable + "] ([" + pc.Id + "], [" + pc.First + "], [" + pc.Last + "], [" + pc.Phone + "], [" + pc.Email + "], [" + pc.Password + "]) " +
                                                            "VALUES (@id, @f, @l, @p, @e, @pw)", conn, tx))
                            {
                                ins.Parameters.AddWithValue("@id", newId);
                                ins.Parameters.AddWithValue("@f", first);
                                ins.Parameters.AddWithValue("@l", last);
                                ins.Parameters.AddWithValue("@p", phone);
                                ins.Parameters.AddWithValue("@e", email);
                                ins.Parameters.AddWithValue("@pw", password);
                                ins.ExecuteNonQuery();
                            }
                        }

                        tx.Commit();
                        return null;
                    }
                }
            }
            catch (Exception ex)
            {
                newId = null;
                return "The staff member could not be added: " + ex.Message;
            }
        }

        private string Row(StaffPerson s, string pill, string payments)
        {
            string action = "&mdash;";
            if (CanArchive)
            {
                string data = " data-kind=\"" + s.Kind + "\" data-id=\"" + Rpt.Esc(s.Id) + "\" data-name=\"" + Rpt.Esc(s.FullName) + "\"" +
                              " data-first=\"" + Rpt.Esc(s.First) + "\" data-last=\"" + Rpt.Esc(s.Last) + "\" data-phone=\"" + Rpt.Esc(s.Phone) + "\"" +
                              " data-email=\"" + Rpt.Esc(s.Email) + "\" data-role=\"" + Rpt.Esc(s.Role) + "\" data-username=\"" + Rpt.Esc(s.Username) + "\"";
                action = "<div class=\"avuna-actions\">" +
                         "<button type=\"button\" class=\"avuna-edit-btn\"" + data + " onclick=\"editStaff(this)\">Edit</button>" +
                         "<button type=\"button\" class=\"avuna-archive-btn\"" + data + " onclick=\"archiveStaff(this)\">Archive</button>" +
                         "</div>";
            }

            return "<tr><td class=\"avuna-order-number\">" + Rpt.Esc(s.Id) + "</td>" +
                   "<td>" + Rpt.Esc(s.FullName) + "</td>" +
                   "<td><span class=\"avuna-status " + pill + "\">" + Rpt.Esc(s.Role) + "</span></td>" +
                   "<td>" + Rpt.Esc(s.Email) + "</td>" +
                   "<td>" + Rpt.Esc(s.Phone) + "</td>" +
                   "<td>" + payments + "</td>" +
                   "<td>" + action + "</td></tr>";
        }
    }
}