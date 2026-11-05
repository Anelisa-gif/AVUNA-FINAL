<%@  Page Title="MANAGER DASHBOARD" Language="C#"  MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="MANAGERDASHBOARD.aspx.cs" Inherits="AVUNA_COLLECTIVE.MANAGERDASHBOARD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
/* =========================================================
AVUNA MANAGER DASHBOARD — shared page shell
========================================================= */
.avuna-manager-page {
background: #f4f7f5;
min-height: 100vh;
padding-bottom: 60px;
font-family: Arial, Helvetica, sans-serif;
color: #243333;
}
/* HERO */
.avuna-manager-hero {
position: relative;
overflow: hidden;
background: linear-gradient(120deg, #0d2b2c, #174243);
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
color: #d9a52c;
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
.avuna-button-orange { background: #d9711f; color: white; }
.avuna-button-orange:hover { background: #b85c18; color: white; transform: translateY(-3px); }
.avuna-button-outline {
border: 1px solid rgba(255,255,255,.35);
color: white;
background: rgba(255,255,255,.05);
}
.avuna-button-outline:hover { background: white; color: #113334; }

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
background: #d9a52c;
color: #113334;
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
background: white;
border: 1px solid #e1e7e3;
border-radius: 18px;
padding: 20px 25px;
display: flex;
justify-content: space-between;
align-items: center;
box-shadow: 0 12px 35px rgba(17,51,52,.10);
margin-bottom: 25px;
}
.avuna-welcome strong { color: #113334; font-size: 16px; }
.avuna-welcome span { color: #78827f; font-size: 13px; }
.avuna-db-notice { background: #fdeaea; border: 1px solid #f0c4c4; color: #8a2f2f; border-radius: 14px; padding: 12px 18px; font-size: 12px; margin-bottom: 20px; line-height: 1.6; }
.avuna-business-status {
background: #e8f4ec;
color: #267347;
border-radius: 50px;
padding: 8px 14px;
font-size: 10px;
font-weight: bold;
}
/* STATISTICS */
.avuna-stat-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 20px; margin-bottom: 25px; }
.avuna-stat-card {
background: white;
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
.avuna-green-icon { background: #e8f1ef; color: #113334; }
.avuna-orange-icon { background: #fff0e5; color: #d9711f; }
.avuna-gold-icon { background: #fff5d8; color: #9c7814; }
.avuna-red-icon { background: #fdeaea; color: #c84b4b; }
.avuna-stat-label { font-size: 10px; font-weight: bold; letter-spacing: 1px; color: #78827f; }
.avuna-stat-card h2 { color: #113334; font-size: 31px; margin: 0 0 5px; }
.avuna-stat-description { color: #78827f; font-size: 11px; }
/* MAIN GRID */
.avuna-manager-grid { display: grid; grid-template-columns: 1.7fr 1fr; gap: 25px; margin-bottom: 25px; }
.avuna-card { background: white; border: 1px solid #e1e7e3; border-radius: 22px; box-shadow: 0 12px 35px rgba(17,51,52,.10); overflow: hidden; }
.avuna-card-header { padding: 25px 28px; border-bottom: 1px solid #e6ebe8; }
.avuna-card-header h2 { color: #113334; font-size: 22px; margin: 5px 0; }
.avuna-card-header p { color: #78827f; font-size: 12px; margin: 0; }
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
.avuna-chart-y { height: 230px; display: flex; flex-direction: column; justify-content: space-between; color: #9aa39f; font-size: 10px; }
.avuna-bars {
flex: 1; height: 260px; display: flex; align-items: flex-end; justify-content: space-around;
gap: 15px; border-left: 1px solid #e4e9e5; border-bottom: 1px solid #e4e9e5; padding: 10px 15px 0;
}
.avuna-bar-column { height: 100%; flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: flex-end; position: relative; }
.avuna-bar { width: 100%; max-width: 48px; background: linear-gradient(180deg, #d9711f, #d9a52c); border-radius: 8px 8px 2px 2px; transition: .3s ease; }
.avuna-bar-column:hover .avuna-bar { transform: scaleX(1.1); }
.avuna-bar-value {
position: absolute; top: -5px; background: #113334; color: white;
padding: 5px 7px; border-radius: 5px; font-size: 9px; opacity: 0; transition: .2s;

}
.avuna-bar-column:hover .avuna-bar-value { opacity: 1; top: -28px; }
.avuna-month { margin-top: 10px; color: #78827f; font-size: 10px; }
/* REPORTS */
.avuna-reports { padding: 12px; }
.avuna-report {
display: flex; align-items: center; gap: 14px; padding: 15px; border-radius: 13px;
text-decoration: none; color: #113334; transition: .2s;
}
.avuna-report:hover { background: #f7f3ea; transform: translateX(5px); }
.avuna-report-icon {
width: 47px; height: 47px; min-width: 47px; border-radius: 13px;
background: #113334; color: white; display: flex; align-items: center; justify-content: center; font-weight: bold;
}
.avuna-report:nth-child(2) .avuna-report-icon { background: #d9711f; }
.avuna-report:nth-child(3) .avuna-report-icon { background: #d9a52c; color: #113334; }
.avuna-report:nth-child(4) .avuna-report-icon { background: #687d71; }
.avuna-report-info { flex: 1; }
.avuna-report-info strong { display: block; font-size: 13px; margin-bottom: 4px; }
.avuna-report-info small { color: #78827f; font-size: 10px; }
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
.avuna-alert-content strong { display: block; font-size: 16px; margin-bottom: 5px; color: #113334; }
.avuna-alert-content span { color: #78827f; font-size: 12px; }
/* BOTTOM SHORTCUT CARDS */
.avuna-action-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; margin-top: 25px; }
.avuna-action-card {
position: relative; overflow: hidden; min-height: 180px; border-radius: 20px; padding: 28px;
background: #113334; color: white; transition: .25s ease; text-decoration: none;
}
.avuna-action-card:nth-child(2) { background: #d9711f; }
.avuna-action-card:nth-child(3) { background: #d9a52c; color: #113334; }
.avuna-action-card:hover { transform: translateY(-6px); box-shadow: 0 20px 35px rgba(17,51,52,.18); }
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
.avuna-manager-copy h1 { font-size: 42px; }
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
<span class="avuna-eyebrow">AVUNA COLLECTIVE MANAGEMENT PORTAL</span>
<h1 style="color: white;">Business at a glance.</h1>
<p>Monitor sales, orders, customers and operational activity from one professional management workspace.</p>
<div class="avuna-hero-buttons">
<a href="ManageOrders.aspx" class="avuna-button avuna-button-orange">Manage Orders &rarr;</a>
<a href="SalesReports.aspx" class="avuna-button avuna-button-outline">View Reports</a>
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
<span>Review the key numbers and activity that need your attention.</span>
</div>
<div class="avuna-business-status">&#9679; Business Data</div>
</div>
<asp:Literal ID="litDbNotice" runat="server" />
<!-- STATISTICS -->
<section class="avuna-stat-grid">
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-green-icon">R</div>
<span class="avuna-stat-label">TOTAL SALES</span>
</div>
<h2><asp:Literal ID="litTotalSales" runat="server" Text="R0" /></h2>
<span class="avuna-stat-description">Till date</span>
</article>
<article class="avuna-stat-card">

<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-orange-icon">#</div>
<span class="avuna-stat-label">TOTAL ORDERS</span>
</div>
<h2><asp:Literal ID="litTotalOrders" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Orders recorded</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-gold-icon">&#9673;</div>
<span class="avuna-stat-label">CUSTOMERS</span>
</div>
<h2><asp:Literal ID="litCustomers" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Customer accounts</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-red-icon">!</div>
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
<span class="avuna-sample">AVUNA COLLECTIVE DATA</span>
<span class="avuna-eyebrow">PERFORMANCE</span>
<h2>Sales Overview</h2>
<p>Sales recorded for each of the last six months. Hover a bar to see its exact figure.</p>
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
<span class="avuna-eyebrow">MANAGEMENT TOOLS</span>
<h2>Reports &amp; Actions</h2>
<p>Quickly access management information.</p>
</div>
<div class="avuna-reports">
<a href="SalesReports.aspx" class="avuna-report">
<span class="avuna-report-icon">R</span>
<span class="avuna-report-info"><strong>Sales Reports</strong><small>Revenue and sales trends</small></span>
<span class="avuna-report-arrow">&rarr;</span>
</a>
<a href="OrderReports.aspx" class="avuna-report">
<span class="avuna-report-icon">#</span>
<span class="avuna-report-info"><strong>Order Reports</strong><small>Status and order activity</small></span>
<span class="avuna-report-arrow">&rarr;</span>
</a>
<a href="CustomerReports.aspx" class="avuna-report">
<span class="avuna-report-icon">&#9673;</span>
<span class="avuna-report-info"><strong>Customer Reports</strong><small>Customer and loyalty insights</small></span>
<span class="avuna-report-arrow">&rarr;</span>
</a>
<a href="Staff.aspx" class="avuna-report">
<span class="avuna-report-icon">&#10003;</span>
<span class="avuna-report-info"><strong>Staff Management</strong><small>View and manage your team</small></span>
<span class="avuna-report-arrow">&rarr;</span>
</a>
</div>
</section>
</div>
<!-- ALERT -->
<section class="avuna-alert">
<div class="avuna-alert-icon">!</div>
<div class="avuna-alert-content">
<strong><asp:Literal ID="litPendingAlert" runat="server" /></strong>
<span>Review pending orders and update their status as production progresses.</span>
</div>
<a href="ManageOrders.aspx?view=pending" class="avuna-button avuna-button-orange">Review Orders &rarr;</a>
</section>

</main>
</div>



</asp:Content>