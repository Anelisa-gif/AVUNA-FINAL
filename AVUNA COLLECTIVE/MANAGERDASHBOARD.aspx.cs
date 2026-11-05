using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AVUNA_COLLECTIVE
{
    public partial class MANAGERDASHBOARD : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["staff_Role"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            // Optional: only allow Manager/Admin Staff, not customers
            string role = Session["staff_Role"].ToString();
            if (role != "Manager" && role != "Admin Staff")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }
        }
    }
}