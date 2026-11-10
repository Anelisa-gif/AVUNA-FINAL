<%@  Page Title="MANAGER DASHBOARD" Language="C#"  MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="MANAGERDASHBOARD.aspx.cs" Inherits="AVUNA_COLLECTIVE.MANAGERDASHBOARD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
/* =========================================================
AVUNA MANAGER DASHBOARD — shared page shell
========================================================= */
.avuna-manager-page {
background: #f7f3ec;
min-height: 100vh;
padding-bottom: 60px;
font-family: "Segoe UI", Arial, Helvetica, sans-serif;
color: #3a3028;
}
/* HERO — warm studio photo (same image family as the public home page) */
.avuna-manager-hero {
box-sizing: border-box;
position: relative;
overflow: hidden;
background-color: #3a2c1e;
background-image:
linear-gradient(90deg, rgba(34,24,16,.82) 0%, rgba(34,24,16,.62) 38%, rgba(34,24,16,.18) 70%, rgba(34,24,16,.04) 100%),
url("<%= ResolveUrl("~/images/avuna_collective_background.jpg") %>");
background-size: auto, max(2200px, 100%) auto;
background-position: center, center 31%;
background-repeat: no-repeat;
color: white;
padding: 70px 7%;
min-height: 470px;
display: flex;
align-items: center;
justify-content: space-between;
border-radius: 0 0 35px 35px;
}
.avuna-manager-copy { position: relative; z-index: 2; max-width: 900px; }
.avuna-eyebrow {
display: block;
color: #d9a52c;
font-size: 15px;
font-weight: bold;
letter-spacing: 3px;
margin-bottom: 16px;
}
.avuna-manager-copy h1 { font-size: 76px; line-height: 1.02; font-weight: 700; margin: 0 0 22px; text-shadow: 0 2px 14px rgba(0,0,0,.45); }
.avuna-manager-copy p {
max-width: 640px;
color: rgba(255,255,255,.92);
text-shadow: 0 1px 8px rgba(0,0,0,.45);
font-size: 22px;
line-height: 1.55;
margin-bottom: 34px;
}
.avuna-hero-buttons { display: flex; gap: 12px; flex-wrap: wrap; }
.avuna-button {
display: inline-block;
padding: 17px 30px;
border-radius: 10px;
font-size: 17px;
font-weight: bold;
text-decoration: none;
transition: .25s ease;
}
.avuna-button-orange { background: #d9711f; color: white; }
.avuna-button-orange:hover { background: #b85c18; color: white; transform: translateY(-3px); }
.avuna-button-outline {
border: 1px solid rgba(255,255,255,.35);
color: white;
background: rgba(255,255,255,.12);
}
.avuna-button-outline:hover { background: white; color: #2a2118; }
.avuna-button-main { padding: 17px 32px; font-size: 17px; box-shadow: 0 10px 24px rgba(217,113,31,.35); }
.avuna-button-main:hover { box-shadow: 0 14px 28px rgba(217,113,31,.45); }

/* MANAGER BADGE */
.avuna-manager-badge {
position: relative;
z-index: 2;
width: 230px;
height: 230px;
border-radius: 50%;
border: 2px solid rgba(217,165,44,.65);
background: rgba(34,24,16,.35);
display: flex;
align-items: center;
justify-content: center;
}
.avuna-manager-badge-inner {
width: 165px;
height: 165px;
border-radius: 50%;
background: #d9a52c;
color: #2a2118;
display: flex;
flex-direction: column;
justify-content: center;
align-items: center;
text-align: center;
box-shadow: 0 15px 35px rgba(0,0,0,.20);
}
.avuna-manager-badge-inner strong { font-size: 30px; }
.avuna-manager-badge-inner span { font-size: 12px; font-weight: bold; letter-spacing: 2px; margin-top: 6px; }
/* BODY */
.avuna-manager-body { width: 92%; max-width: 1450px; margin: -40px auto 0; position: relative; z-index: 5; }
/* WELCOME */
.avuna-welcome {
background: white;
border: 1px solid #ece4d6;
border-radius: 18px;
padding: 20px 25px;
display: flex;
justify-content: space-between;
align-items: center;
box-shadow: 0 12px 35px rgba(42,33,24,.10);
margin-bottom: 25px;
}
.avuna-welcome strong { color: #2a2118; font-size: 22px; }
.avuna-welcome span { color: #8a7f72; font-size: 16px; }
.avuna-db-notice { background: #fdeaea; border: 1px solid #f0c4c4; color: #8a2f2f; border-radius: 14px; padding: 12px 18px; font-size: 12px; margin-bottom: 20px; line-height: 1.6; }
.avuna-business-status {
background: #e8f4ec;
color: #267347;
border-radius: 50px;
padding: 8px 14px;
font-size: 10px;
font-weight: bold;
}
.avuna-stat-icon svg, .avuna-report-icon svg, .avuna-alert-icon svg { display: block; }
.avuna-report-arrow svg { display: block; }
/* STATISTICS */
.avuna-stat-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 20px; margin-bottom: 25px; }
.avuna-stat-card {
background: white;
border: 1px solid #ece4d6;
border-radius: 20px;
padding: 25px;
box-shadow: 0 12px 35px rgba(42,33,24,.10);
position: relative;
overflow: hidden;
transition: .25s ease;
}
.avuna-stat-card:hover { transform: translateY(-6px); box-shadow: 0 20px 40px rgba(42,33,24,.15); }
.avuna-stat-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
.avuna-stat-icon {
width: 48px; height: 48px; border-radius: 14px;
display: flex; align-items: center; justify-content: center;
font-weight: bold; font-size: 18px;
}
.avuna-green-icon { background: #f3ece0; color: #2a2118; }
.avuna-orange-icon { background: #fff0e5; color: #d9711f; }
.avuna-gold-icon { background: #fff5d8; color: #9c7814; }
.avuna-red-icon { background: #fdeaea; color: #c84b4b; }
.avuna-stat-label { font-size: 13px; font-weight: bold; letter-spacing: 1px; color: #8a7f72; }
.avuna-stat-card h2 { color: #2a2118; font-size: 42px; font-weight: 700; margin: 0 0 5px; }
.avuna-stat-description { color: #8a7f72; font-size: 14px; }
/* MAIN GRID */
.avuna-manager-grid { display: grid; grid-template-columns: 1.7fr 1fr; gap: 25px; margin-bottom: 25px; }
.avuna-card { background: white; border: 1px solid #ece4d6; border-radius: 22px; box-shadow: 0 12px 35px rgba(42,33,24,.10); overflow: hidden; }
.avuna-card-header { padding: 25px 28px; border-bottom: 1px solid #efe7da; }
.avuna-card-header h2 { color: #2a2118; font-size: 28px; margin: 5px 0; }
.avuna-card-header p { color: #8a7f72; font-size: 15px; margin: 0; }
.avuna-sample {
float: right;
background: #f7f3ea;
color: #8b6b1a;
border-radius: 50px;
padding: 7px 10px;
font-size: 9px;
font-weight: bold;
}
/* SALES CHART */
.avuna-chart { padding: 30px; height: 320px; display: flex; gap: 15px; }
.avuna-chart-y { height: 230px; display: flex; flex-direction: column; justify-content: space-between; color: #8a7f72; font-size: 12px; }
.avuna-bars {
flex: 1; height: 260px; display: flex; align-items: flex-end; justify-content: space-around;
gap: 15px; border-left: 1px solid #e8dfd0; border-bottom: 1px solid #e8dfd0; padding: 10px 15px 0;
}
.avuna-bar-column { height: 100%; flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: flex-end; position: relative; }
.avuna-bar { width: 100%; max-width: 48px; background: linear-gradient(180deg, #d9711f, #d9a52c); border-radius: 8px 8px 2px 2px; transition: .3s ease; }
.avuna-bar-column:hover .avuna-bar { transform: scaleX(1.1); }
.avuna-bar-value {
position: absolute; top: -5px; background: #2a2118; color: white;
padding: 5px 7px; border-radius: 5px; font-size: 9px; opacity: 0; transition: .2s;

}
.avuna-bar-column:hover .avuna-bar-value { opacity: 1; top: -28px; }
.avuna-month { margin-top: 10px; color: #8a7f72; font-size: 13px; }
/* REPORTS */
.avuna-reports { padding: 12px; }
.avuna-report {
display: flex; align-items: center; gap: 14px; padding: 15px; border-radius: 13px;
text-decoration: none; color: #2a2118; transition: .2s;
}
.avuna-report:hover { background: #f7f3ea; transform: translateX(5px); }
.avuna-report-icon {
width: 47px; height: 47px; min-width: 47px; border-radius: 13px;
background: #2a2118; color: white; display: flex; align-items: center; justify-content: center; font-weight: bold;
}
.avuna-report:nth-child(2) .avuna-report-icon { background: #d9711f; }
.avuna-report:nth-child(3) .avuna-report-icon { background: #d9a52c; color: #2a2118; }
.avuna-report:nth-child(4) .avuna-report-icon { background: #8a7a66; }
.avuna-report-info { flex: 1; }
.avuna-report-info strong { display: block; font-size: 17px; margin-bottom: 4px; }
.avuna-report-info small { color: #8a7f72; font-size: 13px; }
.avuna-report-arrow { color: #d9711f; font-size: 20px; }
/* ALERT */
.avuna-alert {
display: flex; align-items: center; gap: 18px; background: #fff8ed;
border: 1px solid #f1d7b5; border-radius: 20px; padding: 20px 25px; margin-bottom: 25px;
}
.avuna-alert-icon {
width: 52px; height: 52px; min-width: 52px; border-radius: 15px; background: #d9711f;
color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 20px;
}
.avuna-alert-content { flex: 1; }
.avuna-alert-content strong { display: block; font-size: 20px; margin-bottom: 5px; color: #2a2118; }
.avuna-alert-content span { color: #8a7f72; font-size: 15px; }
/* BOTTOM SHORTCUT CARDS */
.avuna-action-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; margin-top: 25px; }
.avuna-action-card {
position: relative; overflow: hidden; min-height: 180px; border-radius: 20px; padding: 28px;
background: #2a2118; color: white; transition: .25s ease; text-decoration: none;
}
.avuna-action-card:nth-child(2) { background: #d9711f; }
.avuna-action-card:nth-child(3) { background: #d9a52c; color: #2a2118; }
.avuna-action-card:hover { transform: translateY(-6px); box-shadow: 0 20px 35px rgba(42,33,24,.18); }
.avuna-action-card small { font-weight: bold; letter-spacing: 2px; opacity: .7; }
.avuna-action-card h3 { margin-top: 22px; font-size: 21px; }
.avuna-action-card p { margin-top: 8px; font-size: 11px; line-height: 1.6; max-width: 280px; opacity: .75; }
.avuna-action-arrow { position: absolute; right: 25px; bottom: 20px; font-size: 28px; }
/* RESPONSIVE */
@media(max-width:1100px) {
.avuna-stat-grid { grid-template-columns: repeat(2,1fr); }
.avuna-manager-grid { grid-template-columns: 1fr; }
.avuna-action-grid { grid-template-columns: 1fr; }
}
@media(max-width:700px) {
.avuna-manager-hero { padding: 45px 25px; }
.avuna-manager-copy h1 { font-size: 46px; }
.avuna-manager-badge { display: none; }
.avuna-manager-body { width: 94%; margin-top: -25px; }
.avuna-stat-grid { grid-template-columns: 1fr; }
.avuna-welcome { flex-direction: column; align-items: flex-start; gap: 12px; }
.avuna-alert { flex-direction: column; align-items: flex-start; }
}
</style>
<div class="avuna-manager-page">
<!-- ===================================================== HERO ===================================================== -->
<section class="avuna-manager-hero">
<div class="avuna-manager-copy">
<span class="avuna-eyebrow">MANAGER PORTAL</span>
<h1 style="color: white;">Manager Dashboard</h1>
<p>Sales, orders and customers at Avuna Collective.</p>
<div class="avuna-hero-buttons">
<a href="ManageOrders.aspx" class="avuna-button avuna-button-orange">Manage Orders</a>
<a href="Reports.aspx?report=sales" class="avuna-button avuna-button-outline">View Reports</a>
</div>
</div>
<div class="avuna-manager-badge">
<div class="avuna-manager-badge-inner">
<strong>AVUNA</strong>
<span>MANAGER</span>
</div>
</div>
</section>
<!-- ===================================================== DASHBOARD BODY ===================================================== -->
<main class="avuna-manager-body">
<!-- WELCOME -->
<div class="avuna-welcome">
<div>
<strong>Welcome back, <asp:Literal ID="litManagerName" runat="server" />.</strong>

</div>
<span><%: DateTime.Now.ToString("dddd, d MMMM yyyy", System.Globalization.CultureInfo.InvariantCulture) %></span>
</div>
<asp:Literal ID="litDbNotice" runat="server" />
<!-- STATISTICS -->
<section class="avuna-stat-grid">
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-green-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="2" y="6" width="20" height="12" rx="2"/><circle cx="12" cy="12" r="3"/></svg></div>
<span class="avuna-stat-label">TOTAL SALES</span>
</div>
<h2><asp:Literal ID="litTotalSales" runat="server" Text="R0" /></h2>
<span class="avuna-stat-description">Till date</span>
</article>
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
<div class="avuna-stat-icon avuna-gold-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c.6-3.6 3.2-5.5 6.5-5.5s5.9 1.9 6.5 5.5"/><path d="M16 4.7a3.5 3.5 0 0 1 0 6.6M18.5 14.8c1.7.7 2.8 2.3 3 5.2"/></svg></div>
<span class="avuna-stat-label">CUSTOMERS</span>
</div>
<h2><asp:Literal ID="litCustomers" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Customer accounts</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-red-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></div>
<span class="avuna-stat-label">PENDING ORDERS</span>
</div>
<h2><asp:Literal ID="litPendingOrders" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Require attention</span>
</article>
</section>
<!-- SALES CHART + REPORTS -->
<div class="avuna-manager-grid">
<!-- SALES CHART -->
<section class="avuna-card">
<div class="avuna-card-header">
<h2>Sales Overview</h2>
<p>Last six months</p>
</div>
<div class="avuna-chart">
<div class="avuna-chart-y">
<asp:Literal ID="litChartAxis" runat="server" />
</div>
<div class="avuna-bars">
<asp:Literal ID="litChartBars" runat="server" />
</div>
</div>
</section>
<!-- REPORTS -->
<section class="avuna-card">
<div class="avuna-card-header">
<h2>Reports</h2>
<p>Sales, orders, customers and staff</p>
</div>
<div class="avuna-reports">
<a href="Reports.aspx?report=sales" class="avuna-report">
<span class="avuna-report-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 20V4M4 20h16"/><path d="M8 16v-4M12 16V8M16 16v-6"/></svg></span>
<span class="avuna-report-info"><strong>Sales Reports</strong><small>Revenue by month</small></span>
<span class="avuna-report-arrow"><svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 5l7 7-7 7"/></svg></span>
</a>
<a href="Reports.aspx?report=orders" class="avuna-report">
<span class="avuna-report-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 4h6l1 2h3v15H5V6h3z"/><path d="M9 12h6M9 16h6"/></svg></span>
<span class="avuna-report-info"><strong>Order Reports</strong><small>Orders by status</small></span>
<span class="avuna-report-arrow"><svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 5l7 7-7 7"/></svg></span>
</a>
<a href="Reports.aspx?report=customers" class="avuna-report">
<span class="avuna-report-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c.6-3.6 3.2-5.5 6.5-5.5s5.9 1.9 6.5 5.5"/><path d="M16 4.7a3.5 3.5 0 0 1 0 6.6M18.5 14.8c1.7.7 2.8 2.3 3 5.2"/></svg></span>
<span class="avuna-report-info"><strong>Customer Reports</strong><small>Registered customers</small></span>
<span class="avuna-report-arrow"><svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 5l7 7-7 7"/></svg></span>
</a>
<a href="Reports.aspx?report=staff" class="avuna-report">
<span class="avuna-report-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="8" r="3.5"/><path d="M5 20c.8-4 3.5-6 7-6s6.2 2 7 6"/></svg></span>
<span class="avuna-report-info"><strong>Staff Management</strong><small>Team members</small></span>
<span class="avuna-report-arrow"><svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 5l7 7-7 7"/></svg></span>
</a>
</div>
</section>
</div>
<!-- ALERT -->
<section class="avuna-alert">
<div class="avuna-alert-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></div>
<div class="avuna-alert-content">
<strong><asp:Literal ID="litPendingAlert" runat="server" /></strong>
<span>Update order statuses as production progresses.</span>
</div>
<a href="ManageOrders.aspx?view=pending" class="avuna-button avuna-button-orange">View Orders</a>
</section>

</main>
</div>



</asp:Content>