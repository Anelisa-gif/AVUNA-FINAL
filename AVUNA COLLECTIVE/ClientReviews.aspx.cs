using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace AVUNA_COLLECTIVE
{
    public partial class ClientReviews : System.Web.UI.Page
    {
        private class ReviewDisplay
        {
            public string Name { get; set; }
            public string Initial { get; set; }
            public string AvatarColor { get; set; }
            public int Score { get; set; }
            public string StarsHtml { get; set; }
            public string StarClass { get; set; }
            public string Comment { get; set; }
            public string DateText { get; set; }
        }

        private static readonly string[] AvatarColors =
            { "#7b2fa3", "#3b6ea5", "#4a4a4a", "#0f766e", "#2e7d32", "#0e4d3c", "#c2185b", "#00796b" };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindReviews();
            }
        }

        private void BindReviews()
        {
            var reviews = new List<ReviewDisplay>();

            string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;

            string sql = @"
    SELECT TOP 50
        rating_Date,
        rating_Review,
        rating_Score,
        'Verified Customer' AS customer_Name
    FROM Rating
    ORDER BY rating_Date DESC";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        DateTime date = reader.GetDateTime(0);
                        string comment = reader.IsDBNull(1) ? "" : reader.GetString(1);
                        int score = Math.Max(1, Math.Min(5, reader.GetInt32(2)));
                        string name = reader.IsDBNull(3) ? "Customer" : reader.GetString(3);

                        int days = Math.Max(0, (DateTime.Now.Date - date.Date).Days);

                        reviews.Add(new ReviewDisplay
                        {
                            Name = HttpUtility.HtmlEncode(name),
                            Initial = name.Substring(0, 1).ToUpper(),
                            AvatarColor = AvatarColors[Math.Abs(name.GetHashCode()) % AvatarColors.Length],
                            Score = score,
                            StarsHtml = BuildStarsHtml(score),
                            StarClass = score >= 4 ? "" : (score == 3 ? "mid" : "low"),
                            Comment = HttpUtility.HtmlEncode(comment),
                            DateText = days == 0 ? "Reviewed today"
                                     : "Reviewed " + days + " day" + (days == 1 ? "" : "s") + " ago"
                        });
                    }
                }
            }

            rptReviews.DataSource = reviews;
            rptReviews.DataBind();
        }

        private string BuildStarsHtml(int score)
        {
            string html = "";
            for (int i = 0; i < 5; i++)
            {
                html += i < score ? "<span>&#9733;</span>" : "<span style='opacity:0.4'>&#9733;</span>";
            }
            return html;
        }
    }
}