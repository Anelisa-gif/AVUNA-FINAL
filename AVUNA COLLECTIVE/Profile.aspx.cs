using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;
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
                                        cust_Town, cust_Suburb
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

                    // Profile cards
                    lblFullName.Text = Server.HtmlEncode((first + " " + last).Trim());
                    lblEmail.Text = Server.HtmlEncode(email);
                    lblPhone.Text = Server.HtmlEncode(phone);
                    lblType.Text = Server.HtmlEncode(type);
                    lblAddress.Text = Server.HtmlEncode(BuildAddress(house, street, suburb, town));

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

            // ---- validation (server side) ----
            if (last.Length == 0)
            { Fail("Please enter your last name."); return; }

            if (!Regex.IsMatch(phone, @"^[0-9+()\-\s]{7,20}$"))
            { Fail("Please enter a valid phone number."); return; }

            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            { Fail("Please enter a valid email address."); return; }

            // ---- update ----
            const string sql = @"UPDATE dbo.Customer
                                 SET cust_Last_Name    = @last,
                                     cust_Phone_Number = @phone,
                                     cust_Email        = @email,
                                     cust_House_Number = @house,
                                     cust_Street_Name  = @street,
                                     cust_Suburb       = @suburb,
                                     cust_Town         = @town
                                 WHERE customer_ID = @id";

            try
            {
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
                    cmd.Parameters.AddWithValue("@id", CurrentCustomerId.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadProfile(); // refresh the cards with the saved values
                ShowMessage("Your details were updated successfully.", true);
            }
            catch (SqlException)
            {
                Fail("Something went wrong while saving. Please try again.");
            }
        }

        // ------------------------------------------------------------------
        // helpers
        // ------------------------------------------------------------------
        private void Fail(string message)
        {
            // Show the error and keep the popup open so nothing the user typed is lost
            ShowMessage(message, false);
            ScriptManager.RegisterStartupScript(this, GetType(), "reopenEdit", "openEditProfile();", true);
        }

        private void ShowMessage(string text, bool success)
        {
            lblProfileMessage.Text = Server.HtmlEncode(text);
            lblProfileMessage.CssClass = "customer-inline-message " + (success ? "msg-success" : "msg-error");
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
