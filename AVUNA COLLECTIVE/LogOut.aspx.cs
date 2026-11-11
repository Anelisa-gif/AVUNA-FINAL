using System;
using System.Web;

namespace AVUNA_COLLECTIVE
{
    public partial class Log_Out : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // stop the browser keeping a copy, so the Back button cannot show customer pages again
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            // end the login: customer_ID and everything else in the session is removed
            Session.Clear();
            Session.Abandon();
        }
    }
}

