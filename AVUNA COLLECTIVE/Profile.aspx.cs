using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace AVUNA_COLLECTIVE
{
    public partial class ProfilePage : System.Web.UI.Page
    {
        // ------------------------------------------------------------------
        // CHECK THESE TWO AGAINST YOUR PROJECT:
        //  1. The connection string name must exist in Web.config.
        //  2. The Session key must match what your login page stores.
        // ------------------------------------------------------------------
        private const string ConnectionStringName = "GroupWst2";
        private const string SessionKey = "customer_ID";

        // Password rule (change if you want it stricter / looser)
        private const string PasswordPattern = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$";
        private const string PasswordRuleMessage = "Password must be at least 8 characters and contain an uppercase letter, a lowercase letter, a number and a special character.";

        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings[ConnectionStringName].ConnectionString; }
        }

        private int? CurrentCustomerId
        {
            get
            {
                if (Session[SessionKey] == null) return null;
                int id;
                return int.TryParse(Session[SessionKey].ToString(), out id) ? id : (int?)null;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (CurrentCustomerId == null)
            {
                Response.Redirect("Login.aspx"); // change to your login page name
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        // ------------------------------------------------------------------
        // LOAD: read the logged-in customer's row and fill the page + modal
        // ------------------------------------------------------------------
        private void LoadProfile()
        {
            const string sql = @"SELECT cust_First_Name, cust_Last_Name, cust_Type, cust_Email,
                                        cust_Phone_Number, cust_House_Number, cust_Street_Name,
                                        cust_Town, cust_Suburb, [username], [password]
                                 FROM dbo.Customer
                                 WHERE customer_ID = @id";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", CurrentCustomerId.Value);
                conn.Open();

                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        ShowMessage("We couldn't find your account details.", false);
                        return;
                    }

                    string first = Str(r["cust_First_Name"]);
                    string last = Str(r["cust_Last_Name"]);
                    string type = Str(r["cust_Type"]);
                    string email = Str(r["cust_Email"]);
                    string phone = Str(r["cust_Phone_Number"]);
                    string house = Str(r["cust_House_Number"]);
                    string street = Str(r["cust_Street_Name"]);
                    string town = Str(r["cust_Town"]);
                    string suburb = Str(r["cust_Suburb"]);
                    string username = Str(r["username"]);
                    string password = Str(r["password"]);

                    // Profile cards
                    lblFullName.Text = Server.HtmlEncode((first + " " + last).Trim());
                    lblEmail.Text = Server.HtmlEncode(email);
                    lblPhone.Text = Server.HtmlEncode(phone);
                    lblType.Text = Server.HtmlEncode(type);
                    lblAddress.Text = Server.HtmlEncode(BuildAddress(house, street, suburb, town));
                    lblUsername.Text = username.Length > 0 ? Server.HtmlEncode(username) : "Not set";

                    // Never display the real password - only whether one exists
                    lblPassword.Text = password.Length > 0
                        ? "\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022"
                        : "Not set";

                    // Modal header
                    lblModalName.Text = Server.HtmlEncode((first + " " + last).Trim());
                    lblAvatar.Text = Server.HtmlEncode(Initials(first, last));

                    // Modal fields
                    txtFirstName.Text = first;
                    txtLastName.Text = last;
                    txtPhone.Text = phone;
                    txtEmail.Text = email;
                    txtHouse.Text = house;
                    txtStreet.Text = street;
                    txtSuburb.Text = suburb;
                    txtTown.Text = town;
                    txtUsername.Text = username;
                    // Password boxes are intentionally left empty
                }
            }
        }

        // ------------------------------------------------------------------
        // SAVE: validate, then UPDATE the Customer table
        // ------------------------------------------------------------------
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (CurrentCustomerId == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string last = txtLastName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string email = txtEmail.Text.Trim();
            string house = txtHouse.Text.Trim();
            string street = txtStreet.Text.Trim();
            string suburb = txtSuburb.Text.Trim();
            string town = txtTown.Text.Trim();
            string username = txtUsername.Text.Trim();
            string newPassword = txtNewPassword.Text;       // not trimmed on purpose
            string confirmPassword = txtConfirmPassword.Text;

            // ---- validation (server side) ----
            if (last.Length == 0)
            { Fail("Please enter your last name."); return; }

            if (!Regex.IsMatch(phone, @"^[0-9+()\-\s]{7,20}$"))
            { Fail("Please enter a valid phone number."); return; }

            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            { Fail("Please enter a valid email address."); return; }

            if (!Regex.IsMatch(username, @"^[A-Za-z0-9._@\-]{3,50}$"))
            { Fail("Your username must be 3-50 characters and can only contain letters, numbers and . _ @ -"); return; }

            try
            {
                // Username must be unique across all customers
                if (UsernameTaken(username))
                { Fail("That username is already taken. Please choose another one."); return; }

                // Work out whether the password is being changed
                bool changePassword = newPassword.Length > 0 || confirmPassword.Length > 0;

                if (!changePassword && !HasExistingPassword())
                { Fail("Please set a password for your account."); return; }

                if (changePassword)
                {
                    if (!Regex.IsMatch(newPassword, PasswordPattern))
                    { Fail(PasswordRuleMessage); return; }

                    if (newPassword != confirmPassword)
                    { Fail("The new password and confirmation do not match."); return; }
                }

                // ---- update ----
                string sql = @"UPDATE dbo.Customer
                               SET cust_Last_Name    = @last,
                                   cust_Phone_Number = @phone,
                                   cust_Email        = @email,
                                   cust_House_Number = @house,
                                   cust_Street_Name  = @street,
                                   cust_Suburb       = @suburb,
                                   cust_Town         = @town,
                                   [username]        = @username"
                             + (changePassword ? ",\n [password] = @password" : "")
                             + "\n WHERE customer_ID = @id";

                int rowsAffected;

                using (var conn = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@last", last);
                    cmd.Parameters.AddWithValue("@phone", phone);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@house", house);
                    cmd.Parameters.AddWithValue("@street", street);
                    cmd.Parameters.AddWithValue("@suburb", suburb);
                    cmd.Parameters.AddWithValue("@town", town);
                    cmd.Parameters.AddWithValue("@username", username);
                    if (changePassword)
                        cmd.Parameters.AddWithValue("@password", newPassword);
                    cmd.Parameters.AddWithValue("@id", CurrentCustomerId.Value);

                    conn.Open();
                    rowsAffected = cmd.ExecuteNonQuery();
                }

                if (rowsAffected == 0)
                { Fail("Nothing was saved because your account could not be found. Please log in again."); return; }

                // If your login page stores the username in Session, keep it in sync:
                // Session["username"] = username;

                LoadProfile(); // refresh the cards with the saved values
                ShowMessage(changePassword
                    ? "Your details and password were updated successfully."
                    : "Your details were updated successfully.", true);
            }
            catch (SqlException ex)
            {
                // 8152 / 2628 = a value is longer than its database column allows
                if (ex.Number == 8152 || ex.Number == 2628)
                    Fail("One of your entries is longer than the database allows, so nothing was saved. (error " + ex.Number + ")");
                // 2601 / 2627 = duplicate value in a unique column
                else if (ex.Number == 2601 || ex.Number == 2627)
                    Fail("That username is already taken. Please choose another one.");
                else
                    Fail("Something went wrong while saving. Please try again. (error " + ex.Number + ")");
            }
        }

        // ------------------------------------------------------------------
        // helpers
        // ------------------------------------------------------------------
        private bool UsernameTaken(string username)
        {
            const string sql = @"SELECT COUNT(*) FROM dbo.Customer
                                 WHERE [username] = @username AND customer_ID <> @id";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@id", CurrentCustomerId.Value);
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        private bool HasExistingPassword()
        {
            const string sql = "SELECT [password] FROM dbo.Customer WHERE customer_ID = @id";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", CurrentCustomerId.Value);
                conn.Open();
                return Str(cmd.ExecuteScalar()).Length > 0;
            }
        }

        // Error: show the popup AND keep the edit window open so nothing typed is lost
        // (browsers never refill password boxes, so those two must be retyped)
        private void Fail(string message)
        {
            ShowMessage(message, false);
            ScriptManager.RegisterStartupScript(this, GetType(), "reopenEdit", "openEditProfile();", true);
        }

        // Shows a popup (toast) that appears on top of everything, including the edit window
        private void ShowMessage(string text, bool success)
        {
            string js = "showToast(" + new JavaScriptSerializer().Serialize(text)
                      + ", '" + (success ? "success" : "error") + "');";

            // unique key so several messages in one postback all show
            ScriptManager.RegisterStartupScript(this, GetType(), "toast_" + Guid.NewGuid().ToString("N"), js, true);
        }

        private static string Str(object o)
        {
            return (o == null || o == DBNull.Value) ? "" : o.ToString().Trim();
        }

        private static string Initials(string first, string last)
        {
            string a = first.Length > 0 ? first.Substring(0, 1) : "";
            string b = last.Length > 0 ? last.Substring(0, 1) : "";
            return (a + b).ToUpper();
        }

        private static string BuildAddress(string house, string street, string suburb, string town)
        {
            string line1 = (house + " " + street).Trim();
            var parts = new System.Collections.Generic.List<string>();
            if (line1.Length > 0) parts.Add(line1);
            if (suburb.Length > 0) parts.Add(suburb);
            if (town.Length > 0 && !string.Equals(town, suburb, StringComparison.OrdinalIgnoreCase)) parts.Add(town);
            return string.Join(", ", parts);
        }
    }
}