using System;
using System.Web;

namespace AVUNA_COLLECTIVE
{
    public partial class ManagerLogOut : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // stop the browser keeping a copy, so the Back button cannot show manager pages again
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            // end the login: staff_ID, staff_Role, names etc. are all removed
            Session.Clear();
            Session.Abandon();
        }
    }
}