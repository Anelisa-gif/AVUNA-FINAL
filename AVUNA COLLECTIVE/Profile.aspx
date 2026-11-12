<%@ Page Title="" Language="C#" MasterPageFile="~/Customer_master.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AVUNA_COLLECTIVE.ProfilePage" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
.customer-dashboard {
  --avuna-orange: #f47b20;
  --avuna-orange-dark: #d95f0b;
  --avuna-gold: #d9a441;
  --avuna-grey: #6f6f6f;
  --avuna-border: #e8e4dc;
  --avuna-shadow: 0 10px 35px rgba(0,0,0,.08);
  width: 100%;
  min-height: 100vh;
  background: #f6f4ef;
  padding-bottom: 100px;
  color: #202020;
}

/* hero */
.customer-hero {
  position: relative;
  overflow: hidden;
  min-height: 260px;
  padding: 40px 8% 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: white;
  background-color: #2a2118;
  background-image: linear-gradient(90deg, rgba(24,17,10,.90) 0%, rgba(24,17,10,.74) 42%, rgba(24,17,10,.28) 100%), url("<%= ResolveUrl("~/images/customer-hero.jpg") %>");
  background-size: auto, cover;
  background-position: center, center;
  background-repeat: no-repeat;
}
.customer-hero-copy { position: relative; z-index: 2; max-width: 720px; }
.customer-hero h1 { font-size: clamp(32px, 4vw, 48px); line-height: 1.05; margin: 0 0 12px; font-weight: 800; letter-spacing: -1.5px; }
.customer-hero p { color: #d4d4d4; font-size: 17px; line-height: 1.7; max-width: 650px; margin-bottom: 20px; }
.customer-hero-actions { display: flex; gap: 14px; flex-wrap: wrap; }
.customer-btn { display: inline-flex; align-items: center; justify-content: center; padding: 13px 22px; border-radius: 10px; text-decoration: none !important; font-weight: 700; transition: all .25s ease; }
.customer-btn-light { border: 1px solid rgba(255,255,255,.35); color: white !important; background: rgba(255,255,255,.06); }
.customer-btn-light:hover { background: white; color: #111 !important; transform: translateY(-3px); }

.av-logo-tile { position: relative; z-index: 2; width: 130px; height: 130px; min-width: 130px; flex: none; background: #fff; border: 2px solid #d9a52c; border-radius: 50%; display: flex; align-items: center; justify-content: center; overflow: hidden; }
.av-logo-tile img { width: 100%; height: 100%; object-fit: contain; display: block; }

/* body */
.customer-body { width: 90%; max-width: 1400px; margin: -35px auto 0; position: relative; z-index: 5; }
.customer-card { background: white; border: 1px solid var(--avuna-border); border-radius: 18px; padding: 28px; box-shadow: 0 6px 25px rgba(0,0,0,.05); }
.customer-card-heading { display: flex; justify-content: space-between; align-items: flex-start; gap: 15px; margin-bottom: 20px; }
.customer-card-heading h2 { margin: 5px 0 7px; font-size: 24px; color: #181818; }
.customer-card-heading p { color: #777; margin: 0; font-size: 13px; }

/* profile fields */
.profile-group-title { margin: 26px 0 12px; font-size: 11px; font-weight: 800; letter-spacing: 2px; text-transform: uppercase; color: var(--avuna-orange); }
.profile-group-title.first { margin-top: 0; }
.profile-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; }
.profile-grid.cols-2 { grid-template-columns: repeat(2, 1fr); }
.profile-box { background: #f8f7f4; border: 1px solid #ebe7df; border-radius: 12px; padding: 18px; transition: box-shadow .2s ease, transform .2s ease; }
.profile-box:hover { box-shadow: 0 6px 18px rgba(0,0,0,.07); transform: translateY(-1px); }
.profile-box label { display: block; color: #5f5f5f; font-size: 11px; text-transform: uppercase; letter-spacing: 1px; font-weight: 800; margin-bottom: 7px; }
.profile-box strong { font-size: 16px; font-weight: 600; color: #222; word-break: break-word; }
.profile-box a { color: #222; text-decoration: none; }
.profile-box a:hover { color: var(--avuna-orange-dark); text-decoration: underline; }
.profile-link { display: inline-block; margin-top: 6px; font-size: 13px; font-weight: 700; color: var(--avuna-orange-dark) !important; }
.type-pill { display: inline-block; padding: 4px 14px; border-radius: 999px; background: #fff4e9; color: var(--avuna-orange-dark); font-size: 13px; font-weight: 700; }

.profile-edit-btn { padding: 12px 22px; border: none; border-radius: 10px; background: var(--avuna-orange); color: #fff; font-weight: 700; font-size: 14px; cursor: pointer; box-shadow: 0 8px 20px rgba(244,123,32,.25); transition: all .25s ease; white-space: nowrap; }
.profile-edit-btn:hover { background: #ff8b32; transform: translateY(-2px); }

/* toasts */
.av-toast-host { position: fixed; top: 24px; left: 50%; transform: translateX(-50%); z-index: 100000; display: flex; flex-direction: column; gap: 10px; width: 460px; max-width: calc(100% - 32px); pointer-events: none; }
.av-toast { pointer-events: auto; display: flex; align-items: flex-start; gap: 14px; background: #fff; border-radius: 14px; padding: 16px 18px; box-shadow: 0 20px 55px rgba(0,0,0,.35); border-left: 6px solid #c94b45; animation: avToastIn .3s ease; }
.av-toast-success { border-left-color: #27845b; }
.av-toast-out { opacity: 0; transform: translateY(-12px); transition: all .25s ease; }
.av-toast-icon { flex: 0 0 30px; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 800; font-size: 16px; background: #c94b45; }
.av-toast-success .av-toast-icon { background: #27845b; }
.av-toast-text { flex: 1; min-width: 0; }
.av-toast-text strong { display: block; font-size: 14px; color: #181818; margin-bottom: 3px; }
.av-toast-text span { display: block; font-size: 14px; line-height: 1.45; color: #444; word-wrap: break-word; }
.av-toast-close { flex: 0 0 auto; border: none; background: transparent; color: #999; font-size: 22px; line-height: 1; cursor: pointer; padding: 0 2px; }
.av-toast-close:hover { color: #222; }
@keyframes avToastIn { from { opacity: 0; transform: translateY(-16px); } to { opacity: 1; transform: translateY(0); } }

/* edit modal */
.edit-overlay { position: fixed; inset: 0; z-index: 9999; background: rgba(17,17,17,.62); backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; padding: 20px; }
.edit-overlay.open { display: flex; }
.edit-modal { background: #fff; width: 680px; max-width: 100%; max-height: 95vh; overflow-y: auto; border-radius: 24px; box-shadow: 0 30px 80px rgba(0,0,0,.4); }
.edit-modal-head { position: relative; overflow: hidden; display: flex; align-items: center; gap: 18px; padding: 30px 32px; color: #fff; background: linear-gradient(120deg, #111 0%, #191919 60%, #252525 100%); }
.edit-avatar { position: relative; z-index: 2; flex: 0 0 62px; width: 62px; height: 62px; border-radius: 50%; background: var(--avuna-orange); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 22px; }
.edit-modal-title { position: relative; z-index: 2; }
.edit-eyebrow { display: block; color: var(--avuna-orange); font-size: 11px; font-weight: 800; letter-spacing: 2px; margin-bottom: 4px; }
.edit-modal-title h3 { margin: 0; font-size: 24px; font-weight: 800; color: #fff; }
.edit-close { position: absolute; z-index: 3; top: 16px; right: 16px; width: 32px; height: 32px; border: none; border-radius: 50%; background: rgba(255,255,255,.18); color: #fff; font-size: 18px; line-height: 1; cursor: pointer; }
.edit-close:hover { background: rgba(255,255,255,.3); }
.edit-modal-body { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; padding: 30px 32px 10px; }
.edit-field label { display: block; font-size: 10px; letter-spacing: 1.2px; color: #888; font-weight: 800; text-transform: uppercase; margin-bottom: 8px; }
.edit-field .edit-input { width: 100%; box-sizing: border-box; padding: 14px 16px; border: 1px solid var(--avuna-border); border-radius: 12px; background: #f8f7f4; font-size: 15px; color: #222; }
.edit-field .edit-input:focus { outline: none; border-color: var(--avuna-orange); background: #fff; box-shadow: 0 0 0 3px rgba(244,123,32,.15); }
.edit-field .edit-input[readonly] { opacity: .65; cursor: not-allowed; }
.edit-field-full { grid-column: 1 / -1; }
.edit-note { grid-column: 1 / -1; margin: -6px 0 0; font-size: 12px; color: #888; }
.edit-section-title { grid-column: 1 / -1; margin-top: 8px; padding-top: 20px; border-top: 1px solid var(--avuna-border); }
.edit-section-title span { display: block; color: var(--avuna-orange); font-size: 11px; font-weight: 800; letter-spacing: 2px; margin-bottom: 4px; }
.edit-section-title p { margin: 0; font-size: 12px; color: #888; }
.edit-section-title p.pw-hint { margin-top: 8px; }
.pw-hint.ok { color: #27845b; font-weight: 700; }
.pw-hint.bad { color: #c94b45; font-weight: 700; }
.edit-modal-foot { display: flex; justify-content: flex-end; gap: 12px; padding: 20px 32px 30px; }
.edit-btn-cancel { padding: 14px 26px; border: 1px solid var(--avuna-border); background: #fff; border-radius: 12px; font-weight: 700; cursor: pointer; color: #222; }
.edit-btn-cancel:hover { background: #f6f4ef; }
.edit-btn-save { padding: 14px 26px; border: none; background: var(--avuna-orange); color: #fff; border-radius: 12px; font-weight: 800; cursor: pointer; box-shadow: 0 8px 20px rgba(244,123,32,.25); }
.edit-btn-save:hover { background: var(--avuna-orange-dark); }

@media (max-width: 1000px) {
  .profile-grid { grid-template-columns: repeat(2, 1fr); }
  .customer-hero { padding: 40px 6% 60px; }
  .customer-card-heading { flex-direction: column; align-items: flex-start; gap: 12px; }
}
@media (max-width: 650px) {
  .customer-hero { padding: 40px 25px 60px; min-height: auto; }
  .av-logo-tile { display: none; }
  .customer-body { width: 94%; }
  .customer-card { padding: 20px; }
  .profile-grid, .profile-grid.cols-2 { grid-template-columns: 1fr; }
  .edit-modal-body { grid-template-columns: 1fr; padding: 24px 22px 6px; }
  .edit-modal-head { padding: 26px 22px; }
  .edit-modal-foot { padding: 16px 22px 24px; }
}
</style>

<div class="customer-dashboard">
  <section class="customer-hero">
    <div class="customer-hero-copy">
      <h1 style="color: white;">Your personal details, your control.</h1>
      <p>Keep your contact information and account details up to date.</p>
      <div class="customer-hero-actions">
        <a href="CustomerDashboard.aspx" class="customer-btn customer-btn-light">Back to Dashboard</a>
      </div>
    </div>
    <div class="av-logo-tile"><img runat="server" src="~/avuna-logo.png" alt="Avuna Collective" /></div>
  </section>

  <main class="customer-body">
    <section class="customer-card">
      <div class="customer-card-heading">
        <div>
          <h2>My Profile</h2>
          <p>Your information used for your Avuna Collective orders.</p>
        </div>
        <button type="button" class="profile-edit-btn" onclick="openEditProfile()">Edit profile</button>
      </div>

      <div class="profile-group-title first">Personal</div>
      <div class="profile-grid cols-2">
        <div class="profile-box">
          <label>Full Name</label>
          <strong><asp:Label ID="lblFullName" runat="server" /></strong>
        </div>
        <div class="profile-box">
          <label>Customer Type</label>
          <strong><asp:Label ID="lblType" runat="server" CssClass="type-pill" /></strong>
        </div>
      </div>

      <div class="profile-group-title">Contact</div>
      <div class="profile-grid">
        <div class="profile-box">
          <label>Email</label>
          <strong><asp:Label ID="lblEmail" runat="server" /></strong>
        </div>
        <div class="profile-box">
          <label>Cell Number</label>
          <strong><asp:Label ID="lblPhone" runat="server" /></strong>
        </div>
        <div class="profile-box">
          <label>Address</label>
          <strong><asp:Label ID="lblAddress" runat="server" /></strong>
        </div>
      </div>

      <div class="profile-group-title">Account</div>
      <div class="profile-grid cols-2">
        <div class="profile-box">
          <label>Username</label>
          <strong><asp:Label ID="lblUsername" runat="server" /></strong>
        </div>
        <div class="profile-box">
          <label>Password</label>
          <strong><asp:Label ID="lblPassword" runat="server" /></strong><br />
          <a href="#" class="profile-link" onclick="openEditProfile(); return false;">Change password</a>
        </div>
      </div>
    </section>
  </main>
</div>

<div class="edit-overlay" id="editProfileOverlay">
  <div class="edit-modal">
    <div class="edit-modal-head">
      <div class="edit-avatar"><asp:Label ID="lblAvatar" runat="server" /></div>
      <div class="edit-modal-title">
        <span class="edit-eyebrow">EDIT YOUR DETAILS</span>
        <h3><asp:Label ID="lblModalName" runat="server" /></h3>
      </div>
      <button type="button" class="edit-close" onclick="closeEditProfile()" aria-label="Close">&times;</button>
    </div>

    <div class="edit-modal-body">
      <div class="edit-field">
        <label for="<%= txtFirstName.ClientID %>">First name</label>
        <asp:TextBox ID="txtFirstName" runat="server" CssClass="edit-input" ReadOnly="true" />
      </div>
      <div class="edit-field">
        <label for="<%= txtLastName.ClientID %>">Last name</label>
        <asp:TextBox ID="txtLastName" runat="server" CssClass="edit-input" MaxLength="100" />
      </div>

      <div class="edit-field">
        <label for="<%= txtPhone.ClientID %>">Phone number</label>
        <asp:TextBox ID="txtPhone" runat="server" CssClass="edit-input" MaxLength="30" TextMode="Phone" />
      </div>
      <div class="edit-field">
        <label for="<%= txtEmail.ClientID %>">Email address</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="edit-input" MaxLength="150" TextMode="Email" />
      </div>

      <div class="edit-field">
        <label for="<%= txtHouse.ClientID %>">House number</label>
        <asp:TextBox ID="txtHouse" runat="server" CssClass="edit-input" MaxLength="20" />
      </div>
      <div class="edit-field">
        <label for="<%= txtStreet.ClientID %>">Street name</label>
        <asp:TextBox ID="txtStreet" runat="server" CssClass="edit-input" MaxLength="100" />
      </div>

      <div class="edit-field">
        <label for="<%= txtSuburb.ClientID %>">Suburb</label>
        <asp:TextBox ID="txtSuburb" runat="server" CssClass="edit-input" MaxLength="100" />
      </div>
      <div class="edit-field">
        <label for="<%= txtTown.ClientID %>">Town</label>
        <asp:TextBox ID="txtTown" runat="server" CssClass="edit-input" MaxLength="100" />
      </div>

      <p class="edit-note">Your first name can't be changed here. Contact AVUNA support if it needs correcting.</p>

      <div class="edit-section-title">
        <span>LOGIN DETAILS</span>
        <p>Leave the password fields empty if you don't want to change your password.</p>
        <p class="pw-hint" id="pwHint">New passwords must be at least 8 characters and contain an uppercase letter, a lowercase letter, a number and a special character.</p>
      </div>

      <div class="edit-field edit-field-full">
        <label for="<%= txtUsername.ClientID %>">Username</label>
        <asp:TextBox ID="txtUsername" runat="server" CssClass="edit-input" MaxLength="50" autocomplete="off" />
      </div>

      <div class="edit-field">
        <label for="<%= txtNewPassword.ClientID %>">New password</label>
        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="edit-input" TextMode="Password" MaxLength="100" autocomplete="new-password" onkeyup="updatePasswordHint()" oninput="updatePasswordHint()" />
      </div>
      <div class="edit-field">
        <label for="<%= txtConfirmPassword.ClientID %>">Confirm new password</label>
        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="edit-input" TextMode="Password" MaxLength="100" autocomplete="new-password" />
      </div>
    </div>

    <div class="edit-modal-foot">
      <button type="button" class="edit-btn-cancel" onclick="closeEditProfile()">Cancel</button>
      <asp:Button ID="btnSaveProfile" runat="server" Text="Save changes" CssClass="edit-btn-save" OnClick="btnSaveProfile_Click" OnClientClick="return checkPasswordBeforeSave();" />
    </div>
  </div>
</div>

<div class="av-toast-host" id="avToastHost"></div>

<script>
  var PW_RULE = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$/;
  var PW_MESSAGE = 'Password must be at least 8 characters and contain an uppercase letter, a lowercase letter, a number and a special character.';

  function openEditProfile() {
    document.getElementById('editProfileOverlay').classList.add('open');
  }

  function closeEditProfile() {
    document.getElementById('editProfileOverlay').classList.remove('open');
  }

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeEditProfile();
  });

  function showToast(message, type) {
    var host = document.getElementById('avToastHost');
    var ok = type === 'success';
    var toast = document.createElement('div');
    toast.className = 'av-toast' + (ok ? ' av-toast-success' : '');
    toast.innerHTML =
      '<div class="av-toast-icon">' + (ok ? '&#10003;' : '!') + '</div>' +
      '<div class="av-toast-text"><strong>' + (ok ? 'Success' : 'Please check') + '</strong><span></span></div>' +
      '<button type="button" class="av-toast-close" aria-label="Close">&times;</button>';
    toast.querySelector('span').textContent = message;

    function dismiss() {
      toast.classList.add('av-toast-out');
      setTimeout(function () { toast.remove(); }, 250);
    }

    toast.querySelector('.av-toast-close').onclick = dismiss;
    host.appendChild(toast);
    setTimeout(dismiss, 6000);
  }

  function updatePasswordHint() {
    var pw = document.getElementById('<%= txtNewPassword.ClientID %>').value;
    var hint = document.getElementById('pwHint');
    hint.classList.remove('ok', 'bad');
    if (pw.length === 0) return;
    hint.classList.add(PW_RULE.test(pw) ? 'ok' : 'bad');
  }

  function checkPasswordBeforeSave() {
    var pw = document.getElementById('<%= txtNewPassword.ClientID %>').value;
    var confirm = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;

        if (pw.length === 0 && confirm.length === 0) return true;

        if (!PW_RULE.test(pw)) {
            showToast(PW_MESSAGE, 'error');
            return false;
        }
        if (pw !== confirm) {
            showToast('The new password and confirmation do not match.', 'error');
            return false;
        }
        return true;
    }
</script>
</asp:Content>