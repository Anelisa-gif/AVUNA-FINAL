using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;

namespace AVUNA_COLLECTIVE
{
    public partial class RegisterBusiness : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                litMessage.Text = string.Empty;
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // GET DATABASE CONNECTION STRING
            string connectionString = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;

            // GET VALUES FROM THE REGISTRATION FORM
            string businessName = txtBusinessName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string cellCode = txtCellCode.Text.Trim();
            string cellMid = txtCellMid.Text.Trim();
            string cellLast = txtCellLast.Text.Trim();
            const string customerType = "Business";
            string houseNumber = txtHouseNumber.Text.Trim();
            string streetName = txtStreetName.Text.Trim();
            string suburb = txtSuburb.Text.Trim();
            string town = txtTown.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            // ---------------- VALIDATION ----------------

            if (string.IsNullOrEmpty(businessName) ||
                string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(cellCode) ||
                string.IsNullOrEmpty(cellMid) ||
                string.IsNullOrEmpty(cellLast) ||
                string.IsNullOrEmpty(houseNumber) ||
                string.IsNullOrEmpty(streetName) ||
                string.IsNullOrEmpty(suburb) ||
                string.IsNullOrEmpty(town) ||
                string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(username) ||
                string.IsNullOrEmpty(confirmPassword))
            {
                ShowMessage("Please fill in all fields.");
                return;
            }

            // VALIDATE EMAIL
            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                ShowMessage("Please enter a valid email address.");
                return;
            }

            // VALIDATE BUSINESS NUMBER
            if (!Regex.IsMatch(cellCode, @"^\d{2,3}$") ||
                !Regex.IsMatch(cellMid, @"^\d{3}$") ||
                !Regex.IsMatch(cellLast, @"^\d{4}$"))
            {
                ShowMessage("Please enter a valid business number.");
                return;
            }

            // VALIDATE PASSWORD STRENGTH (matches the rules shown on the page)
            if (!Regex.IsMatch(password, @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$"))
            {
                ShowMessage("Password must be at least 8 characters and contain an uppercase letter, a lowercase letter, a number and a special character.");
                return;
            }

            // CONFIRM PASSWORD
            if (password != confirmPassword)
            {
                ShowMessage("Passwords do not match.");
                return;
            }

            // CREATE FULL BUSINESS NUMBER
            string cellNumber = "(" + cellCode + ") " + cellMid + "-" + cellLast;

            // DATABASE OPERATIONS
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // CHECK IF EMAIL ALREADY EXISTS
                    string checkQuery =
                        "SELECT COUNT(1) FROM Customer WHERE cust_Email = @cust_Email";

                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@cust_Email", email);

                        int existing = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (existing > 0)
                        {
                            ShowMessage("An account with that email already exists.");
                            return;
                        }
                    }

                    // CHECK IF USERNAME ALREADY EXISTS
                    string checkUserQuery =
                        "SELECT COUNT(1) FROM Customer WHERE username = @username";

                    using (SqlCommand checkUserCmd = new SqlCommand(checkUserQuery, conn))
                    {
                        checkUserCmd.Parameters.AddWithValue("@username", username);

                        int existingUser = Convert.ToInt32(checkUserCmd.ExecuteScalar());

                        if (existingUser > 0)
                        {
                            ShowMessage("That username is already taken.");
                            return;
                        }
                    }

                    // INSERT NEW CUSTOMER
                    string insertQuery = @"
                        INSERT INTO Customer
                        (
                            cust_First_Name,
                            cust_Last_Name,
                            cust_Email,
                            cust_Phone_Number,
                            cust_Type,
                            cust_House_Number,
                            cust_Street_Name,
                            cust_Suburb,
                            cust_Town,
                            password,
                            username
                        )
                        VALUES
                        (
                            @cust_First_Name,
                            @cust_Last_Name,
                            @cust_Email,
                            @cust_Phone_Number,
                            @cust_Type,
                            @cust_House_Number,
                            @cust_Street_Name,
                            @cust_Suburb,
                            @cust_Town,
                            @password,
                            @username
                        )";

                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        // The business name is saved in the customer name column.
                        // The last name column is left empty for businesses.
                        insertCmd.Parameters.AddWithValue("@cust_First_Name", businessName);
                        insertCmd.Parameters.AddWithValue("@cust_Last_Name", "");
                        insertCmd.Parameters.AddWithValue("@cust_Email", email);

                        // The business number is saved in the phone number column
                        insertCmd.Parameters.AddWithValue("@cust_Phone_Number", cellNumber);
                        insertCmd.Parameters.AddWithValue("@cust_Type", customerType);
                        insertCmd.Parameters.AddWithValue("@cust_House_Number", houseNumber);
                        insertCmd.Parameters.AddWithValue("@cust_Street_Name", streetName);
                        insertCmd.Parameters.AddWithValue("@cust_Suburb", suburb);
                        insertCmd.Parameters.AddWithValue("@cust_Town", town);
                        insertCmd.Parameters.AddWithValue("@password", password);
                        insertCmd.Parameters.AddWithValue("@username", username);

                        // EXECUTE INSERT
                        insertCmd.ExecuteNonQuery();
                    }
                }

                // REGISTRATION SUCCESSFUL - show the Avuna message box,
                // then go to the login page when the user clicks OK
                ShowSuccessModal();
            }
            catch (SqlException)
            {
                ShowMessage("Something went wrong while creating your account. Please try again.");
            }
        }

        // SHOW THE STYLED AVUNA SUCCESS BOX (defined in Site.Master)
        private void ShowSuccessModal()
        {
            string message = "Welcome to Avuna Collective. Your business account has been created successfully. You can now log in using your username and password.";
            string loginUrl = ResolveUrl("~/Login?registered=1");

            string script =
                "window.addEventListener('load', function () {" +
                "  showAvunaModal(" +
                     HttpUtility.JavaScriptStringEncode(message, true) + ", " +
                     HttpUtility.JavaScriptStringEncode("Registration Successful!", true) + ", " +
                "    function () { window.location.href = " +
                     HttpUtility.JavaScriptStringEncode(loginUrl, true) + "; }" +
                "  );" +
                "});";

            ClientScript.RegisterStartupScript(this.GetType(), "avunaBusinessSuccess", script, true);
        }

        // DISPLAY MESSAGE TO USER
        private void ShowMessage(string message)
        {
            litMessage.Text =
                "<span class=\"avuna-auth-message\">"
                + Server.HtmlEncode(message)
                + "</span>";
        }
    }
}