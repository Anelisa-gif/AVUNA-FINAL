<%@ Page Title="" Language="C#"  MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="AVUNA_COLLECTIVE.ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
/* =========================================================
AVUNA ORDERS PAGE — shared page shell (same as Dashboard)
========================================================= */
.avuna-manager-page {
background: #f4f7f5;
min-height: 100vh;
padding-bottom: 60px;
font-family: var(--av-sans);
color: #243333;
}
/* HERO */
.avuna-manager-hero {
position: relative;
overflow: hidden;
background: linear-gradient(120deg, #0d2b2c, #173c2c);
color: white;
padding: 55px 7%;
min-height: 380px;
display: flex;
align-items: center;
justify-content: space-between;
border-radius: 0 0 35px 35px;
}
.avuna-manager-hero:before {
content: "";
position: absolute;
width: 400px;
height: 400px;
border-radius: 50%;
border: 55px solid rgba(217,165,44,0.08);
right: -150px;
top: -170px;
}
.avuna-manager-hero:after {
content: "";
position: absolute;
width: 260px;
height: 260px;
border-radius: 50%;
border: 35px solid rgba(217,165,44,0.06);
left: -130px;
bottom: -150px;
}
.avuna-manager-copy { position: relative; z-index: 2; max-width: 700px; }

.avuna-eyebrow {
display: block;
color: #c49a45;
font-size: 11px;
font-weight: bold;
letter-spacing: 2px;
margin-bottom: 12px;
}
.avuna-manager-copy h1 { font-size: 55px; line-height: 1; margin: 0 0 20px; }
.avuna-manager-copy p {
max-width: 650px;
color: rgba(255,255,255,.76);
font-size: 16px;
line-height: 1.7;
margin-bottom: 28px;
}
.avuna-hero-buttons { display: flex; gap: 12px; flex-wrap: wrap; }
.avuna-button {
display: inline-block;
padding: 14px 22px;
border-radius: 10px;
font-size: 13px;
font-weight: bold;
text-decoration: none;
transition: .25s ease;
}
.avuna-button-orange { background: #0f2a1f; color: white; }
.avuna-button-orange:hover { background: #0f2a1f; color: white; transform: translateY(-3px); }
.avuna-button-outline {
border: 1px solid rgba(255,255,255,.35);
color: white;
background: rgba(255,255,255,.05);
}
.avuna-button-outline:hover { background: #fbf8f2; color: #173c2c; }
/* MANAGER BADGE */
.avuna-manager-badge {
position: relative;
z-index: 2;
width: 205px;
height: 205px;
border-radius: 50%;
border: 2px solid rgba(217,165,44,.65);
background: rgba(255,255,255,.06);
display: flex;
align-items: center;
justify-content: center;
}
.avuna-manager-badge-inner {
width: 145px;
height: 145px;
border-radius: 50%;
background: #c49a45;
color: #173c2c;
display: flex;
flex-direction: column;
justify-content: center;
align-items: center;
text-align: center;
box-shadow: 0 15px 35px rgba(0,0,0,.20);
}
.avuna-manager-badge-inner strong { font-size: 23px; }
.avuna-manager-badge-inner span { font-size: 9px; font-weight: bold; letter-spacing: 2px; margin-top: 6px; }
/* BODY */
.avuna-manager-body { width: 92%; max-width: 1450px; margin: -40px auto 0; position: relative; z-index: 5; }
/* WELCOME */
.avuna-welcome {
background: #fbf8f2;
border: 1px solid #e1e7e3;
border-radius: 18px;
padding: 20px 25px;
display: flex;
justify-content: space-between;
align-items: center;
box-shadow: 0 12px 35px rgba(17,51,52,.10);
margin-bottom: 25px;
}
.avuna-welcome strong { color: #173c2c; font-size: 16px; }
.avuna-welcome span { color: #78827f; font-size: 13px; }
.avuna-business-status {
background: #e8f4ec;
color: #267347;
border-radius: 50px;
padding: 8px 14px;
font-size: 10px;
font-weight: bold;
}
/* STATISTICS (reused for order-focused stats) */
.avuna-stat-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 20px; margin-bottom: 25px; }
.avuna-stat-card {
background: #fbf8f2;
border: 1px solid #e1e7e3;
border-radius: 20px;
padding: 25px;
box-shadow: 0 12px 35px rgba(17,51,52,.10);
position: relative;
overflow: hidden;
transition: .25s ease;
}
.avuna-stat-card:hover { transform: translateY(-6px); box-shadow: 0 20px 40px rgba(17,51,52,.15); }
.avuna-stat-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
.avuna-stat-icon {
width: 48px; height: 48px; border-radius: 14px;
display: flex; align-items: center; justify-content: center;
font-weight: bold; font-size: 18px;
}
.avuna-green-icon { background: #e8f1ef; color: #173c2c; }
.avuna-orange-icon { background: #f2e2c9; color: #8a6a35; }
.avuna-gold-icon { background: #f2e2c9; color: #6e5133; }

.avuna-red-icon { background: #fdeaea; color: #c84b4b; }
.avuna-stat-label { font-size: 10px; font-weight: bold; letter-spacing: 1px; color: #78827f; }
.avuna-stat-card h2 { color: #173c2c; font-size: 31px; margin: 0 0 5px; }
.avuna-stat-description { color: #78827f; font-size: 11px; }
/* ALERT */
.avuna-alert {
display: flex; align-items: center; gap: 18px; background: #f2e2c9;
border: 1px solid #e3d0ae; border-radius: 20px; padding: 20px 25px; margin-bottom: 25px;
}
.avuna-alert-icon {
width: 52px; height: 52px; min-width: 52px; border-radius: 15px; background: #0f2a1f;
color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 20px;
}
.avuna-alert-content { flex: 1; }
.avuna-alert-content strong { display: block; font-size: 16px; margin-bottom: 5px; color: #173c2c; }
.avuna-alert-content span { color: #78827f; font-size: 12px; }
/* CARD + ORDERS TABLE */
.avuna-card { background: #fbf8f2; border: 1px solid #e1e7e3; border-radius: 22px; box-shadow: 0 12px 35px rgba(17,51,52,.10); overflow: hidden; margin-bottom: 25px; }
.avuna-orders-header { padding: 25px 28px; display: flex; justify-content: space-between; align-items: center; }
.avuna-orders-header h2 { color: #173c2c; margin: 5px 0; }
.avuna-orders-header p { color: #78827f; font-size: 12px; }
.avuna-eyebrow-inline { color: #c49a45; font-size: 11px; font-weight: bold; letter-spacing: 2px; }
.avuna-view-all { color: #8a6a35; font-size: 12px; font-weight: bold; text-decoration: none; }
.avuna-table-wrap { overflow-x: auto; }
.avuna-table { width: 100%; border-collapse: collapse; }
.avuna-table th { background: #f7f9f7; color: #737d79; padding: 14px 20px; text-align: left; font-size: 9px; letter-spacing: 1px; }
.avuna-table td { padding: 17px 20px; border-top: 1px solid #edf0ed; font-size: 12px; }
.avuna-table tbody tr:hover { background: #fafcfb; }
.avuna-order-number { color: #173c2c; font-weight: bold; }
.avuna-status { display: inline-block; padding: 6px 10px; border-radius: 50px; font-size: 9px; font-weight: bold; }
.avuna-completed { background: #e7f4eb; color: #277446; }
.avuna-production { background: #f2e2c9; color: #6e5133; }
.avuna-pending { background: #f2e2c9; color: #6e5133; }
.avuna-db-notice { background: #fdeaea; border: 1px solid #f0c4c4; color: #8a2f2f; border-radius: 14px; padding: 12px 18px; font-size: 12px; margin-bottom: 20px; line-height: 1.6; }
/* SHORTCUT CARD */
.avuna-action-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; margin-top: 25px; }
.avuna-action-card {
position: relative; overflow: hidden; min-height: 180px; border-radius: 20px; padding: 28px;
background: #173c2c; color: white; transition: .25s ease; text-decoration: none;
}
.avuna-action-card:hover { transform: translateY(-6px); box-shadow: 0 20px 35px rgba(17,51,52,.18); }
.avuna-action-card small { font-weight: bold; letter-spacing: 2px; opacity: .7; }
.avuna-action-card h3 { margin-top: 22px; font-size: 21px; }
.avuna-action-card p { margin-top: 8px; font-size: 11px; line-height: 1.6; max-width: 280px; opacity: .75; }
.avuna-action-arrow { position: absolute; right: 25px; bottom: 20px; font-size: 28px; }
/* RESPONSIVE */
@media(max-width:1100px) {
.avuna-stat-grid { grid-template-columns: repeat(2,1fr); }
.avuna-action-grid { grid-template-columns: 1fr; }
}
@media(max-width:700px) {
.avuna-manager-hero { padding: 45px 25px; }
.avuna-manager-copy h1 { font-size: 42px; }
.avuna-manager-badge { display: none; }
.avuna-manager-body { width: 94%; margin-top: -25px; }
.avuna-stat-grid { grid-template-columns: 1fr; }
.avuna-welcome { flex-direction: column; align-items: flex-start; gap: 12px; }
.avuna-alert { flex-direction: column; align-items: flex-start; }
.avuna-orders-header { flex-direction: column; align-items: flex-start; gap: 12px; }
}

.av-logo-tile{position:relative;z-index:2;width:190px;height:190px;min-width:190px;flex:none;background:#fbf8f2;border:2px solid #c49a45;border-radius:50%;display:flex;align-items:center;justify-content:center;overflow:hidden}
.av-logo-tile img{width:100%;height:100%;object-fit:contain;display:block}
.avuna-manager-hero:before,.avuna-manager-hero:after,.customer-hero:before,.customer-hero:after,.rp-hero:before,.rp-hero:after,.rp-kpi:after,.customer-stat:after,.action-card:after,.avuna-modal-head:after,.edit-modal-head:before,.avuna-order .hero:before{display:none !important}
.avuna-modal-avatar,.edit-avatar,.customer-avatar{border-radius:50% !important;background:#fff url("avuna-logo.png") center/contain no-repeat !important;color:transparent !important;font-size:0 !important;border:1px solid #c49a45}
.avuna-modal-close,.edit-close,.design-viewer-close,.av-nav-btn{border-radius:50% !important}
@media (max-width:700px){.av-logo-tile{width:130px;height:130px;min-width:130px}}
</style>
<style>
/* =========================================================
MANAGER PAGES — photo hero, larger type, warm palette
========================================================= */
.avuna-manager-page { background: #f5efe6; color: #3a3028; font-family: "Segoe UI", Arial, Helvetica, sans-serif; }
.avuna-manager-hero {
box-sizing: border-box;
background-color: #1b2a22;
background-image:
linear-gradient(90deg, rgba(34,24,16,0.93) 0%, rgba(34,24,16,0.82) 40%, rgba(34,24,16,0.4) 72%, rgba(34,24,16,0.1) 100%),
url("<%= ResolveUrl("~/images/golf tshirt.jpg") %>");
background-size: auto, cover;
background-position: center, center 42%;
background-repeat: no-repeat;
padding: 70px 7%;
min-height: 470px;
}
.avuna-manager-hero:before, .avuna-manager-hero:after { display: none; }
.avuna-manager-copy { max-width: 900px; }
.avuna-eyebrow { font-size: 15px; letter-spacing: 3px; margin-bottom: 16px; }
.avuna-manager-copy h1 { font-size: 76px; line-height: 1.02; font-weight: 700; margin: 0 0 22px; text-shadow: 0 2px 14px rgba(0,0,0,.45); }
.avuna-manager-copy p { max-width: 640px; color: rgba(255,255,255,.92); text-shadow: 0 1px 8px rgba(0,0,0,.45); font-size: 22px; line-height: 1.55; margin-bottom: 34px; }
.avuna-button { padding: 17px 30px; font-size: 17px; }
.avuna-button-outline { background: rgba(255,255,255,.12); }
.avuna-button-outline:hover { color: #1b2a22; }
.avuna-manager-badge { width: 230px; height: 230px; background: rgba(34,24,16,.35); }
.avuna-manager-badge-inner { width: 165px; height: 165px; color: #1b2a22; }
.avuna-manager-badge-inner strong { font-size: 30px; }
.avuna-manager-badge-inner span { font-size: 12px; }
.avuna-welcome { border-color: #e5dccd; box-shadow: 0 12px 35px rgba(42,33,24,.10); }
.avuna-welcome strong { color: #1b2a22; font-size: 22px; }
.avuna-welcome span { color: #6c736d; font-size: 16px; }
.avuna-stat-card, .avuna-card { border-color: #e5dccd; box-shadow: 0 12px 35px rgba(42,33,24,.10); }
.avuna-stat-icon svg { display: block; }
.avuna-green-icon { background: #f3ece0; color: #1b2a22; }
.avuna-stat-label { font-size: 13px; color: #6c736d; }
.avuna-stat-card h2 { color: #1b2a22; font-size: 42px; font-weight: 700; }
.avuna-stat-description { color: #6c736d; font-size: 14px; }
.avuna-card-header { border-bottom-color: #e5dccd; }
.avuna-card-header h2, .avuna-orders-header h2 { color: #1b2a22; font-size: 28px; }
.avuna-card-header p, .avuna-orders-header p { color: #6c736d; font-size: 15px; }
.avuna-view-all { font-size: 15px; }
.avuna-table th { background: #f5efe6; color: #6c736d; font-size: 12px; padding: 16px 20px; }
.avuna-table td { border-top-color: #e5dccd; font-size: 15px; }
.avuna-table tbody tr:hover { background: #f5efe6; }
.avuna-order-number { color: #1b2a22; }
.avuna-status { font-size: 12px; padding: 7px 12px; }
@media(max-width:700px) { .avuna-manager-copy h1 { font-size: 46px; } .avuna-manager-hero { padding: 45px 25px; } }
.avuna-orders-header { }
.avuna-eyebrow-inline { font-size: 14px; }
</style>
<div class="avuna-manager-page">
<!-- ===================================================== HERO ===================================================== -->
<section class="avuna-manager-hero" style="--hero-img:url('images/GG-0653_PinksInks_29_lg.jpg');--hero-size:cover;--hero-pos:center">
<div class="avuna-manager-copy">
<span class="avuna-eyebrow">MANAGER PORTAL</span>
<h1 style="color: white;">Orders</h1>
<p>Every customer order and its current status.</p>
<div class="avuna-hero-buttons">
<a href="ManageOrders.aspx?view=pending" class="avuna-button avuna-button-orange">Pending Orders</a>
<a href="ManagerDashboard.aspx" class="avuna-button avuna-button-outline">Back to Dashboard</a>
</div>
</div>
<div class="av-logo-tile"><img runat="server" src="~/avuna-logo.png" alt="Avuna Collective" /></div>
</section>
<!-- ===================================================== ORDERS BODY ===================================================== -->
<main class="avuna-manager-body">
<!-- WELCOME -->
<div class="avuna-welcome">
<div>
<strong>Welcome back, <asp:Literal ID="litManagerName" runat="server" />.</strong>
</div>
<span><%: DateTime.Now.ToString("dddd, d MMMM yyyy", System.Globalization.CultureInfo.InvariantCulture) %></span>
</div>
<asp:Literal ID="litDbNotice" runat="server" />
<!-- ORDER STATISTICS -->
<section class="avuna-stat-grid">
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-orange-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 4h6l1 2h3v15H5V6h3z"/><path d="M9 12h6M9 16h6"/></svg></div>
<span class="avuna-stat-label">TOTAL ORDERS</span>
</div>
<h2><asp:Literal ID="litTotalOrders" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Orders recorded</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-red-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></div>
<span class="avuna-stat-label">PENDING</span>
</div>
<h2><asp:Literal ID="litPendingCount" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Not yet started</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-gold-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14.5 6.5a4 4 0 0 0-5 5L3 18l3 3 6.5-6.5a4 4 0 0 0 5-5l-2.5 2.5-2.5-.5-.5-2.5z"/></svg></div>
<span class="avuna-stat-label">IN PROGRESS</span>
</div>
<h2><asp:Literal ID="litInProgressCount" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">In production</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-green-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M8 12.5l3 3 5-6"/></svg></div>
<span class="avuna-stat-label">COMPLETED</span>
</div>
<h2><asp:Literal ID="litCompletedCount" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Fulfilled orders</span>
</article>
</section>
<!-- ORDERS TABLE -->
<section class="avuna-card" id="orders-table">
<div class="avuna-orders-header">
<div>
<h2><asp:Literal ID="litTableTitle" runat="server" /></h2>
<p><asp:Literal ID="litTableSubtitle" runat="server" /></p>
</div>
<asp:Literal ID="litToggleLink" runat="server" />
</div>
<div class="avuna-table-wrap">
<table class="avuna-table">
<thead>
<tr>
<th>ORDER NO.</th>
<th>CUSTOMER</th>
<th>PHONE</th>
<th>DATE</th>
<th>STATUS</th>
<th>TOTAL</th>
<th>PAYMENT</th>
</tr>
</thead>
<tbody>
<asp:Literal ID="litOrderRows" runat="server" />
</tbody>
</table>
</div>
</section>
</main>
</div>
</asp:Content>

