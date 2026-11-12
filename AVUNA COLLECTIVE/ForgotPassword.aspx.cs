using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

namespace AVUNA_COLLECTIVE
{
	public partial class ForgotPassword : System.Web.UI.Page
	{
		// ---- settings ----
		private const int CodeLifetimeMinutes = 5;     // the code stops working after 5 minutes
		private const int ResetLifetimeMinutes = 10;   // time allowed to type the new password after the code is accepted
		private const int ResendCooldownSeconds = 30;  // stops someone pressing Resend again and again
		private const int MaxWrongAttempts = 5;        // wrong guesses allowed per code

		// ---- what is remembered on the server for this visitor (never sent to the browser) ----
		private const string KId = "fp_customerId";
		private const string KEmail = "fp_email";
		private const string KName = "fp_name";
		private const string KSalt = "fp_salt";
		private const string KHash = "fp_hash";
		private const string KExpires = "fp_expires";
		private const string KAttempts = "fp_attempts";
		private const string KLastSent = "fp_lastSent";
		private const string KVerifiedUntil = "fp_verifiedUntil";

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				ClearState();
				ShowStep("email");
			}
		}

		// =====================================================================
		//  Step 1 - the customer types the email they registered with
		// =====================================================================
		protected void btnSendCode_Click(object sender, EventArgs e)
		{
			string email = (txtEmail.Text ?? "").Trim();

			if (email.Length == 0 || !IsValidEmail(email))
			{
				ShowStep("email");
				Error("Please enter a valid email address.");
				return;
			}

			int customerId = 0;
			string firstName = "";
			string savedEmail = "";
			try
			{
				int matches = 0;
				using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString))
				using (var cmd = new SqlCommand(
					"SELECT customer_ID, cust_First_Name, cust_Email FROM dbo.Customer WHERE LOWER(LTRIM(RTRIM(cust_Email))) = @email", conn))
				{
					cmd.Parameters.Add("@email", System.Data.SqlDbType.VarChar, 100).Value = email.ToLowerInvariant();
					conn.Open();
					using (var r = cmd.ExecuteReader())
					{
						while (r.Read())
						{
							matches++;
							customerId = Convert.ToInt32(r["customer_ID"]);
							firstName = Convert.ToString(r["cust_First_Name"]).Trim();
							savedEmail = Convert.ToString(r["cust_Email"]).Trim();
						}
					}
				}

				if (matches == 0)
				{
					ShowStep("email");
					Error("We could not find an account with that email address. Please enter the email you used when you created your profile.");
					return;
				}
				if (matches > 1)
				{
					ShowStep("email");
					Error("More than one account uses this email address. Please contact AVUNA COLLECTIVE for help.");
					return;
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Trace.TraceError("ForgotPassword lookup error: " + ex);
				ShowStep("email");
				Error("Something went wrong while checking your email. Please try again.");
				return;
			}

			ClearState();
			Session[KId] = customerId;
			Session[KEmail] = savedEmail;
			Session[KName] = firstName;

			string problem = IssueCode();
			if (problem != null)
			{
				ClearState();
				ShowStep("email");
				Error(problem);
				return;
			}

			ShowStep("code");
			Info("We sent a 6-digit verification code to " + Mask(savedEmail) + ". Enter it below. The code expires in " + CodeLifetimeMinutes + " minutes.");
		}

		// =====================================================================
		//  Step 2 - the customer types the code from the email
		// =====================================================================
		protected void btnVerify_Click(object sender, EventArgs e)
		{
			if (Session[KId] == null || Session[KHash] == null)
			{
				ClearState();
				ShowStep("email");
				Error("Your session has timed out. Please enter your email address again.");
				return;
			}

			ShowStep("code");

			DateTime expires = (DateTime)Session[KExpires];
			if (DateTime.UtcNow >= expires)
			{
				Error("This code has expired. Click Resend code to get a new one.");
				return;
			}

			int attempts = Session[KAttempts] == null ? 0 : (int)Session[KAttempts];
			if (attempts >= MaxWrongAttempts)
			{
				Error("Too many incorrect attempts. Click Resend code to get a new one.");
				return;
			}

			string typed = (txtCode.Text ?? "").Trim();
			if (!Regex.IsMatch(typed, @"^\d{6}$"))
			{
				Error("Please enter the 6-digit code from your email.");
				return;
			}

			if (!SameHash(Hash((string)Session[KSalt], typed), (string)Session[KHash]))
			{
				attempts++;
				Session[KAttempts] = attempts;
				int left = MaxWrongAttempts - attempts;
				txtCode.Text = "";
				Error(left > 0
					? "That code is not correct. You have " + left + (left == 1 ? " attempt" : " attempts") + " left."
					: "That code is not correct. Too many incorrect attempts - click Resend code to get a new one.");
				return;
			}

			// Code accepted: it can never be used again, and the customer may now choose a new password.
			Session.Remove(KHash);
			Session.Remove(KSalt);
			Session[KVerifiedUntil] = DateTime.UtcNow.AddMinutes(ResetLifetimeMinutes);
			ShowStep("reset");
			Success("Your email has been verified. Choose a new password below.");
		}

		protected void btnResend_Click(object sender, EventArgs e)
		{
			if (Session[KId] == null || Session[KEmail] == null)
			{
				ClearState();
				ShowStep("email");
				Error("Your session has timed out. Please enter your email address again.");
				return;
			}

			ShowStep("code");

			if (Session[KLastSent] != null)
			{
				double since = (DateTime.UtcNow - (DateTime)Session[KLastSent]).TotalSeconds;
				if (since < ResendCooldownSeconds)
				{
					int wait = (int)Math.Ceiling(ResendCooldownSeconds - since);
					Error("Please wait " + wait + " seconds before asking for another code.");
					return;
				}
			}

			string problem = IssueCode();
			if (problem != null) { Error(problem); return; }

			txtCode.Text = "";
			Info("A new verification code was sent to " + Mask((string)Session[KEmail]) + ". It expires in " + CodeLifetimeMinutes + " minutes. Any earlier code no longer works.");
		}

		protected void lnkChangeEmail_Click(object sender, EventArgs e)
		{
			ClearState();
			ShowStep("email");
		}

		// =====================================================================
		//  Step 3 - the customer chooses a new password
		// =====================================================================
		protected void btnReset_Click(object sender, EventArgs e)
		{
			if (Session[KId] == null || Session[KVerifiedUntil] == null || DateTime.UtcNow >= (DateTime)Session[KVerifiedUntil])
			{
				ClearState();
				ShowStep("email");
				Error("Your session has timed out. Please start again.");
				return;
			}

			ShowStep("reset");

			string pw = txtNewPassword.Text ?? "";
			string confirm = txtConfirmPassword.Text ?? "";

			// Same rule as the Register page
			if (!Regex.IsMatch(pw, @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$"))
			{
				Error("Password must be at least 8 characters and contain an uppercase letter, a lowercase letter, a number and a special character.");
				return;
			}
			if (pw != confirm)
			{
				Error("The two passwords do not match.");
				return;
			}

			try
			{
				int rows;
				using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString))
				using (var cmd = new SqlCommand("UPDATE dbo.Customer SET password = @password WHERE customer_ID = @id", conn))
				{
					cmd.Parameters.Add("@password", System.Data.SqlDbType.VarChar, 100).Value = pw;
					cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = (int)Session[KId];
					conn.Open();
					rows = cmd.ExecuteNonQuery();
				}

				if (rows != 1)
				{
					Error("Your password could not be changed. Please try again.");
					return;
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Trace.TraceError("ForgotPassword update error: " + ex);
				Error("Your password could not be changed right now. Please try again.");
				return;
			}

			ClearState();
			ShowStep("done");
			Success("Your password has been changed. You can now log in with your new password.");
		}

		// =====================================================================
		//  Helpers
		// =====================================================================

		// Makes a new 6-digit code, remembers only a salted hash of it, and emails it. Returns an error text, or null when it was sent.
		private string IssueCode()
		{
			string code;
			using (var rng = new RNGCryptoServiceProvider())
			{
				var bytes = new byte[4];
				rng.GetBytes(bytes);
				code = (BitConverter.ToUInt32(bytes, 0) % 1000000).ToString("D6");
			}

			string salt = Guid.NewGuid().ToString("N");
			Session[KSalt] = salt;
			Session[KHash] = Hash(salt, code);
			Session[KExpires] = DateTime.UtcNow.AddMinutes(CodeLifetimeMinutes);
			Session[KAttempts] = 0;

			try
			{
				SendCodeEmail((string)Session[KEmail], (string)Session[KName], code);
			}
			catch (InvalidOperationException ex)
			{
				System.Diagnostics.Trace.TraceError("ForgotPassword email not configured: " + ex);
				Session.Remove(KHash);
				return "Emailing is not set up on this server yet. Please contact AVUNA COLLECTIVE." + Detail(ex);
			}
			catch (Exception ex)
			{
				System.Diagnostics.Trace.TraceError("ForgotPassword email error: " + ex);
				Session.Remove(KHash);
				return "We could not send the email right now. Please try again in a moment." + Detail(ex);
			}

			Session[KLastSent] = DateTime.UtcNow;
			return null;
		}

		// While the project runs with debug="true" in Web.config, show the real reason so problems can be found.
		// Set debug="false" before the site goes live and this adds nothing.
		private static string Detail(Exception ex)
		{
			if (HttpContext.Current == null || !HttpContext.Current.IsDebuggingEnabled) return "";
			Exception root = ex;
			while (root.InnerException != null) root = root.InnerException;
			return " [Technical detail: " + root.Message + "]";
		}

		private void SendCodeEmail(string toAddress, string firstName, string code)
		{
			string greeting = string.IsNullOrWhiteSpace(firstName) ? "Hi there" : "Hi " + HttpUtility.HtmlEncode(firstName);
			string plain = "AVUNA COLLECTIVE - password reset\r\n\r\n" +
						   (string.IsNullOrWhiteSpace(firstName) ? "Hi there" : "Hi " + firstName) + ",\r\n\r\n" +
						   "Your verification code is: " + code + "\r\n\r\n" +
						   "It expires in " + CodeLifetimeMinutes + " minutes. If you did not ask to reset your password, you can ignore this email.";

			string html =
				"<div style=\"background:#f7f3ec;padding:24px 12px;font-family:Arial,Helvetica,sans-serif;color:#2a2118\">" +
				"<table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width:520px;margin:0 auto;background:#ffffff;border:1px solid #ece4d6;border-radius:14px;overflow:hidden\">" +
				"<tr><td style=\"background:#0a1a14;padding:20px 26px;color:#ffffff;font-size:22px;font-weight:bold\">Avuna Collective" +
				"<div style=\"color:#d9a52c;font-size:12px;letter-spacing:2px;margin-top:3px\">PASSWORD RESET</div></td></tr>" +
				"<tr><td style=\"padding:26px\">" +
				"<p style=\"margin:0 0 12px;font-size:16px\">" + greeting + ",</p>" +
				"<p style=\"margin:0 0 18px;color:#6b6055;font-size:14px;line-height:1.6\">Use this verification code to reset your password:</p>" +
				"<div style=\"background:#0a1a14;border-radius:10px;padding:18px;text-align:center;color:#f47b20;font-size:34px;font-weight:bold;letter-spacing:10px\">" + code + "</div>" +
				"<p style=\"margin:18px 0 0;color:#8a7f72;font-size:12px;line-height:1.6\">This code expires in " + CodeLifetimeMinutes + " minutes. If you did not ask to reset your password, you can safely ignore this email - your password has not been changed.</p>" +
				"</td></tr></table></div>";

			using (var msg = new MailMessage())
			{
				msg.To.Add(new MailAddress(toAddress));
				msg.Subject = "Your AVUNA COLLECTIVE verification code";
				msg.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(plain, null, "text/plain"));
				msg.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(html, null, "text/html"));

				// Sender and server come from <system.net><mailSettings> in Web.config (same as the quotation email).
				using (var smtp = new SmtpClient())
				{
					smtp.Timeout = 15000;
					smtp.Send(msg);
				}
			}
		}

		private static string Hash(string salt, string code)
		{
			using (var sha = SHA256.Create())
			{
				byte[] h = sha.ComputeHash(Encoding.UTF8.GetBytes(salt + ":" + code));
				return BitConverter.ToString(h).Replace("-", "");
			}
		}

		// Compares two hashes without stopping at the first difference.
		private static bool SameHash(string a, string b)
		{
			if (a == null || b == null || a.Length != b.Length) return false;
			int diff = 0;
			for (int i = 0; i < a.Length; i++) diff |= a[i] ^ b[i];
			return diff == 0;
		}

		private static bool IsValidEmail(string email)
		{
			try { var m = new MailAddress(email); return m.Address.Equals(email, StringComparison.OrdinalIgnoreCase); }
			catch (FormatException) { return false; }
		}

		private static string Mask(string address)
		{
			int at = address.IndexOf('@');
			if (at < 1) return address;
			string local = address.Substring(0, at);
			string shown = local.Length <= 2 ? local.Substring(0, 1) : local.Substring(0, 2);
			return shown + "****" + address.Substring(at);
		}

		private void ClearState()
		{
			foreach (string k in new[] { KId, KEmail, KName, KSalt, KHash, KExpires, KAttempts, KLastSent, KVerifiedUntil })
				Session.Remove(k);
		}

		// Shows only the panel for the current step and refreshes the countdown.
		private void ShowStep(string step)
		{
			pnlEmail.Visible = step == "email";
			pnlCode.Visible = step == "code";
			pnlReset.Visible = step == "reset";
			pnlDone.Visible = step == "done";

			switch (step)
			{
				case "email": litSub.Text = "Enter the email address you registered with"; break;
				case "code": litSub.Text = "Enter the verification code we emailed you"; break;
				case "reset": litSub.Text = "Choose a new password"; break;
				default: litSub.Text = "All done"; break;
			}

			int secondsLeft = 0;
			if (step == "code" && Session[KExpires] != null)
				secondsLeft = Math.Max(0, (int)Math.Ceiling(((DateTime)Session[KExpires] - DateTime.UtcNow).TotalSeconds));
			hfSecondsLeft.Value = secondsLeft.ToString();

			litMessage.Text = "";
		}

		private void Error(string text) { litMessage.Text = "<span class='avuna-auth-message'>" + HttpUtility.HtmlEncode(text) + "</span>"; }
		private void Info(string text) { litMessage.Text = "<span class='avuna-auth-info'>" + HttpUtility.HtmlEncode(text) + "</span>"; }
		private void Success(string text) { litMessage.Text = "<span class='avuna-auth-success'>" + HttpUtility.HtmlEncode(text) + "</span>"; }
	}
}
