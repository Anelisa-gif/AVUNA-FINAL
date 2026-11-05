
<%@ Page Title="" Language="C#"  MasterPageFile="~/Customer_master.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="AVUNA_COLLECTIVE.CUSTOMERDASHBOARD" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* =========================================================
   AVUNA MY PROFILE — shared page shell (same as Dashboard)
   ========================================================= */
.customer-dashboard {
  --avuna-orange: #f47b20;
  --avuna-orange-dark: #d95f0b;
  --avuna-gold: #d9a441;
  --avuna-black: #111111;
  --avuna-dark: #1c1c1c;
  --avuna-light: #f7f5f1;
  --avuna-white: #ffffff;
  --avuna-grey: #6f6f6f;
  --avuna-border: #e8e4dc;
  --avuna-green: #27845b;
  --avuna-red: #c94b45;
  --avuna-shadow: 0 10px 35px rgba(0,0,0,.08);
  width: 100%;
  min-height: 100vh;
  background: #f6f4ef;
  padding-bottom: 60px;
  color: #202020;
}
/* HERO */
.customer-hero {
  position: relative;
  overflow: hidden;
  min-height: 390px;
  padding: 70px 8%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: linear-gradient(120deg, #111111 0%, #191919 60%, #252525 100%);
  color: white;
}
.customer-hero:before {
  content: "";
  position: absolute;
  width: 380px; height: 380px;
  border: 70px solid rgba(244,123,32,.08);
}
  border-radius: 50%;
  right: -120px; top: -170px;
.customer-hero:after {
  content: "";
  position: absolute;
  width: 180px; height: 180px;
  background: rgba(217,164,65,.08);
  transform: rotate(45deg);
  left: -70px; bottom: -100px;
}
.customer-hero-copy { position: relative; z-index: 2; max-width: 720px; }
.customer-eyebrow { display: inline-block; color: #f47b20; font-size: 12px; font-weight: 800; letter-spacing: 2px; margin-bottom: 14px; }
.customer-hero h1 { font-size: clamp(38px, 5vw, 64px); line-height: 1; margin: 0 0 20px; font-weight: 800; letter-spacing: -2px; }
.customer-hero p { color: #d4d4d4; font-size: 17px; line-height: 1.7; max-width: 650px; margin-bottom: 30px; }
.customer-hero-actions { display: flex; gap: 14px; flex-wrap: wrap; }
.customer-btn { display: inline-flex; align-items: center; justify-content: center; padding: 13px 22px; border-radius: 10px; text-decoration: none !important; font-weight: 700; transition: all .25s ease; }
.customer-btn-orange { background: var(--avuna-orange); color: white !important; box-shadow: 0 8px 20px rgba(244,123,32,.25); }
.customer-btn-orange:hover { background: #ff8b32; transform: translateY(-3px); box-shadow: 0 12px 28px rgba(244,123,32,.35); }
.customer-btn-light { border: 1px solid rgba(255,255,255,.35); color: white !important; background: rgba(255,255,255,.06); }
.customer-btn-light:hover { background: white; color: #111 !important; transform: translateY(-3px); }
/* HERO BADGE */
.customer-hero-badge {
  position: relative; z-index: 2;
  width: 190px; height: 190px;
  border-radius: 50%;
  border: 2px solid rgba(244,123,32,.6);
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  background: radial-gradient(circle, rgba(244,123,32,.18), rgba(255,255,255,.02) 60%);
  box-shadow: 0 0 0 18px rgba(244,123,32,.03), 0 0 60px rgba(244,123,32,.12);
}
.customer-hero-badge strong { font-size: 42px; letter-spacing: 3px; color: white; }
.customer-hero-badge span { color: #f47b20; text-transform: uppercase; font-size: 10px; font-weight: 800; letter-spacing: 2px; text-align: center; margin-top: 5px; }
/* BODY */
.customer-body { width: 90%; max-width: 1400px; margin: -35px auto 0; position: relative; z-index: 5; }
/* WELCOME STRIP */
.customer-welcome { background: white; border: 1px solid var(--avuna-border); border-radius: 16px; padding: 20px 25px; display: flex; align-items: center; justify-content: space-between; box-shadow: var(--avuna-shadow); margin-bottom: 24px; }
.customer-welcome strong { display: block; font-size: 18px; margin-bottom: 4px; }
.customer-welcome span { color: var(--avuna-grey); font-size: 14px; }
.customer-demo { background: #fff4e9; color: var(--avuna-orange); padding: 8px 13px; border-radius: 20px; font-size: 11px; font-weight: 800; letter-spacing: 1px; }
/* CARD */
.customer-card { background: white; border: 1px solid var(--avuna-border); border-radius: 18px; padding: 28px; box-shadow: 0 6px 25px rgba(0,0,0,.05); }
.customer-card-heading { display: flex; justify-content: space-between; align-items: flex-start; gap: 15px; margin-bottom: 25px; }
.customer-card-heading h2 { margin: 5px 0 7px; font-size: 24px; color: #181818; }
.customer-card-heading p { color: #777; margin: 0; font-size: 13px; }
.customer-dark-eyebrow { color: var(--avuna-orange); font-size: 10px; letter-spacing: 1.7px; font-weight: 800; }
.orange-text { color: var(--avuna-orange); }
/* PROFILE SECTION */
.profile-section { margin-bottom: 30px; }
.profile-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 18px; }
.profile-box { background: #f8f7f4; border: 1px solid #ebe7df; border-radius: 12px; padding: 18px; }
.profile-box label { display: block; color: #888; font-size: 10px; text-transform: uppercase; letter-spacing: 1px; font-weight: 800; margin-bottom: 7px; }
.profile-box strong { font-size: 14px; color: #222; }
/* RESPONSIVE */
@media(max-width: 1000px) {
  .profile-grid { grid-template-columns: repeat(2,1fr); }
  .customer-hero { padding: 60px 6%; }
  .customer-card-heading { flex-direction: column; align-items: flex-start; gap: 12px; }
}
@media(max-width: 650px) {
  .customer-hero { padding: 50px 25px; min-height: auto; }
  .customer-hero-badge { display: none; }
  .customer-body { width: 94%; }
  .customer-welcome { flex-direction: column; align-items: flex-start; gap: 12px; }
  .customer-card { padding: 20px; }
  .profile-grid { grid-template-columns: 1fr; }
}
</style>
<div class="customer-dashboard">
  <!-- ===================================================== HERO ===================================================== -->
  <section class="customer-hero">
    <div class="customer-hero-copy">
      <span class="customer-eyebrow">AVUNA COLLECTIVE · CUSTOMER PORTAL</span>
      <h1 style="color: white;">Your details, your control.</h1>
      <p>Keep your contact information and account details up to date for a smoother AVUNA experience.</p>
      <div class="customer-hero-actions">
        <a href="CustomerDashboard.aspx" class="customer-btn customer-btn-light">Back to Dashboard</a>
      </div>
    </div>
    <div class="customer-hero-badge">
      <strong>AV</strong>
      <span>Customer<br />Portal</span>
    </div>
  </section>
  <!-- ===================================================== PROFILE BODY ===================================================== -->
  <main class="customer-body">
    <!-- WELCOME -->
    <div class="customer-welcome">
      <div>
        <strong>Your account details</strong>
        <span>Your information used for AVUNA COLLECTIVE orders.</span>
      </div>
      <span class="customer-demo">DATA</span>
    </div>
    <!-- PROFILE -->
    <section class="customer-card profile-section">
      <div class="customer-card-heading">
        <div>
          <span class="customer-dark-eyebrow">CUSTOMER DETAILS</span>
          <h2>My Profile</h2>
          <p>Your information used for AVUNA COLLECTIVE orders.</p>
        </div>
        
      </div>
      <asp:Label ID="lblProfileMessage" runat="server" CssClass="customer-inline-message" />
      <div class="profile-grid">
        <div class="profile-box">
          <label>Full Name</label>
          <strong>Luyolata Boyce</strong>
        </div>
        <div class="profile-box">
          <label>Email</label>
          <strong>luyolataBoyce2@gmail.com</strong>
        </div>
        <div class="profile-box">
          <label>Cell Number</label>
          <strong>071 234 5678</strong>
        </div>
        <div class="profile-box">
          <label>Customer Type</label>
          <strong>Individual</strong>
        </div>
        <div class="profile-box">
          <label>Address</label>
          <strong>12 Marine Parade, Durban</strong>
        </div>
        <div class="profile-box">
          <label>Loyalty Tier</label>
          <strong class="orange-text">Gold</strong>
        </div>
      </div>
    </section>
  </main>
</div>
</asp:Content>

