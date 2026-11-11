using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.Web;

namespace AVUNA_COLLECTIVE
{
    public partial class Register : System.Web.UI.Page
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
            string FirstName = txtFirstName.Text.Trim();
            string LastName = txtLastName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string cellCode = txtCellCode.Text.Trim();
            string cellMid = txtCellMid.Text.Trim();
            string cellLast = txtCellLast.Text.Trim();
            const string customerType = "Individual";
            string houseNumber = txtHouseNumber.Text.Trim();
            string streetName = txtStreetName.Text.Trim();
            string suburb = txtSuburb.Text.Trim();
            string town = txtTown.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;
            string username = txtUsername.Text.Trim();

            // ---------------- VALIDATION ----------------

            if (string.IsNullOrEmpty(FirstName) ||
                string.IsNullOrEmpty(LastName) ||
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


            // VALIDATE CELL NUMBER
            if (!Regex.IsMatch(cellCode, @"^\d{2,3}$") ||
                !Regex.IsMatch(cellMid, @"^\d{3}$") ||
                !Regex.IsMatch(cellLast, @"^\d{4}$"))
            {
                ShowMessage("Please enter a valid cell number.");
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

            // CREATE FULL CELL NUMBER
            string cellNumber = "(" + cellCode + ") "
                              + cellMid + "-"
                              + cellLast;


            //  DATABASE OPERATIONS 

            try
            {
                using (SqlConnection conn =
                       new SqlConnection(connectionString))
                {
                    conn.Open();


                    // CHECK IF EMAIL ALREADY EXISTS
                    string checkQuery =
                        "SELECT COUNT(1) FROM Customer WHERE cust_Email = @cust_Email";

                    using (SqlCommand checkCmd =
                           new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue(
                            "@cust_Email", email);

                        int existing =
                            (int)checkCmd.ExecuteScalar();

                        if (existing > 0)
                        {
                            ShowMessage(
                                "An account with that email already exists.");

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


                    using (SqlCommand insertCmd =
                           new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue(
                            "@cust_First_Name", FirstName);

                        insertCmd.Parameters.AddWithValue(
                            "@cust_Last_Name", LastName);

                        insertCmd.Parameters.AddWithValue(
                            "@cust_Email", email);

                        insertCmd.Parameters.AddWithValue(
                            "@cust_Phone_Number", cellNumber);

                        insertCmd.Parameters.AddWithValue(
                            "@cust_Type", customerType);

                        insertCmd.Parameters.AddWithValue(
                            "@cust_House_Number", houseNumber);

                        insertCmd.Parameters.AddWithValue(
                            "@cust_Street_Name", streetName);

                        insertCmd.Parameters.AddWithValue(
                            "@cust_Suburb", suburb);

                        insertCmd.Parameters.AddWithValue(
                            "@cust_Town", town);

                        insertCmd.Parameters.AddWithValue(
                            "@password", password);

                        insertCmd.Parameters.AddWithValue(
                           "@username",username);


                        // EXECUTE INSERT AND CHECK THE RESULT
                        int rowsAffected = insertCmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            string message = "Welcome to Avuna Collective. Your account has been created successfully. You can now log in using your username and password.";

                            string script =
                                "window.addEventListener('load', function () {" +
                                "  showAvunaModal(" +
                                     HttpUtility.JavaScriptStringEncode(message, true) + ", " +
                                     HttpUtility.JavaScriptStringEncode("Registration Successful!", true) + ", " +
                                "    function () { window.location.href = 'Login.aspx'; }" +
                                "  );" +
                                "});";

                            ClientScript.RegisterStartupScript(this.GetType(), "avunaSuccess", script, true);

                            // Clear the registration form after successful registration
                            txtFirstName.Text = "";
                            txtLastName.Text = "";
                            txtEmail.Text = "";
                            txtCellCode.Text = "";
                            txtCellMid.Text = "";
                            txtCellLast.Text = "";
                            txtHouseNumber.Text = "";
                            txtStreetName.Text = "";
                            txtSuburb.Text = "";
                            txtTown.Text = "";
                            txtUsername.Text = "";
                            txtPassword.Text = "";
                            txtConfirmPassword.Text = "";
                        }
                        else
                        {
                            ShowMessage("Registration was unsuccessful. Please try again.");
                        }

                    }
                }


                
            }
            catch (SqlException ex)
            {
                ShowMessage("Database error: " + ex.Message);
            }
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