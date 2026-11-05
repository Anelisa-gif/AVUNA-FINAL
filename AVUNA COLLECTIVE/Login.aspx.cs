using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace AVUNA_COLLECTIVE
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {

            string con = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            using (SqlConnection conn = new SqlConnection(con))
            {
                conn.Open();

                //1. Check the staff table first (covers both Admin Staff and Manager)
                string staffQuery = "SELECT staff_ID, staff_First_Name, staff_Role, staff_Password FROM AdminStaff WHERE staff_username = @staff_username";
                using (SqlCommand staffCmd = new SqlCommand(staffQuery, conn))
                {
                    staffCmd.Parameters.AddWithValue("@staff_username", username);

                    using (SqlDataReader reader = staffCmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string storedStaffPassword = reader["staff_Password"].ToString();

                            if (password != storedStaffPassword)
                            {
                                litMessage.Text = "<span class='avuna-auth-message'>Incorrect username or password.</span>";
                                return;
                            }

                            string role = reader["staff_Role"].ToString();
                            string staffId = reader["staff_ID"].ToString();
                            string firstName = reader["staff_First_Name"].ToString();
                            reader.Close();

                            Session["staff_ID"] = staffId;
                            Session["staff_First_Name"] = firstName;
                            Session["staff_Role"] = role;

                            // Both Manager and Admin Staff land on ManagerDashboard for now.
                            Response.Redirect("~/ManagerDashboard.aspx");
                            return;
                        }
                    }
                }

                // 2. Not staff — check the Customer table
                string query = "SELECT customer_ID, cust_First_Name, password FROM Customer WHERE username = @username";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@username", username);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string storedPassword = reader["password"].ToString();
                            if (password == storedPassword)
                            {
                                // Success — set session, redirect, etc.
                                Session["customer_ID"] = reader["customer_ID"].ToString();
                                Response.Redirect("~/CustomerDashboard.aspx");
                            }
                            else
                            {
                                litMessage.Text = "<span class='avuna-auth-message'>Incorrect username or password.</span>";
                            }
                        }
                        else
                        {
                            litMessage.Text = "<span class='avuna-auth-message'>Incorrect username or password.</span>";
                        }
                    }
                }
            }
        }
    }
}
