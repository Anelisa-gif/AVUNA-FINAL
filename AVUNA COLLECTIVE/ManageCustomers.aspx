<%@ Page Title="Customers" Language="C#" MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="ManageCustomers.aspx.cs" Inherits="AVUNA_COLLECTIVE.ManageCustomers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* ===== Customers page styling ===== */
.avuna-manager-page { background: #f7f3ec; color: #3a3028; min-height: 100vh; padding-bottom: 60px; font-family: "Segoe UI", Arial, Helvetica, sans-serif; }

/* hero */
.avuna-manager-hero {
    box-sizing: border-box; position: relative; overflow: hidden; color: white;
    background-color: #3a2c1e;
    background-image:
        linear-gradient(90deg, rgba(34,24,16,0.9) 0%, rgba(34,24,16,0.78) 40%, rgba(34,24,16,0.38) 72%, rgba(34,24,16,0.08) 100%),
        url("<%= ResolveUrl("~/images/Picture9.jpg") %>");
    background-size: auto, cover; background-position: center, center 52%; background-repeat: no-repeat;
    padding: 70px 7%; min-height: 470px; border-radius: 0 0 35px 35px;
    display: flex; align-items: center; justify-content: space-between;
}
.avuna-manager-copy { position: relative; z-index: 2; max-width: 900px; }
.avuna-eyebrow { display: block; color: #d9a52c; font-size: 15px; font-weight: bold; letter-spacing: 3px; margin-bottom: 16px; }
.avuna-manager-copy h1 { font-size: 76px; line-height: 1.02; font-weight: 700; margin: 0 0 22px; text-shadow: 0 2px 14px rgba(0,0,0,.45); }
.avuna-manager-copy p { max-width: 640px; color: rgba(255,255,255,.92); text-shadow: 0 1px 8px rgba(0,0,0,.45); font-size: 22px; line-height: 1.55; margin: 0 0 34px; }
.avuna-hero-buttons { display: flex; gap: 12px; flex-wrap: wrap; }
.avuna-button { display: inline-block; padding: 17px 30px; border-radius: 10px; font-size: 17px; font-weight: bold; text-decoration: none; transition: .25s ease; }
.avuna-button-orange { background: #d9711f; color: white; }
.avuna-button-orange:hover { background: #b85c18; color: white; transform: translateY(-3px); }
.avuna-button-outline { border: 1px solid rgba(255,255,255,.35); color: white; background: rgba(255,255,255,.12); }
.avuna-button-outline:hover { background: white; color: #2a2118; }
.avuna-manager-badge { position: relative; z-index: 2; width: 230px; height: 230px; border-radius: 50%; border: 2px solid rgba(217,165,44,.65); background: rgba(34,24,16,.35); display: flex; align-items: center; justify-content: center; }
.avuna-manager-badge-inner { width: 165px; height: 165px; border-radius: 50%; background: #d9a52c; color: #2a2118; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; box-shadow: 0 15px 35px rgba(0,0,0,.20); }
.avuna-manager-badge-inner strong { font-size: 30px; }
.avuna-manager-badge-inner span { font-size: 12px; font-weight: bold; letter-spacing: 2px; margin-top: 6px; }

/* body, welcome strip */
.avuna-manager-body { width: 92%; max-width: 1450px; margin: -40px auto 0; position: relative; z-index: 5; }
.avuna-welcome { background: white; border: 1px solid #ece4d6; border-radius: 18px; padding: 20px 25px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 12px 35px rgba(42,33,24,.10); margin-bottom: 25px; }
.avuna-welcome strong { color: #2a2118; font-size: 22px; }
.avuna-welcome span { color: #8a7f72; font-size: 16px; }
.avuna-db-notice { background: #fdeaea; border: 1px solid #f0c4c4; color: #8a2f2f; border-radius: 14px; padding: 12px 18px; font-size: 14px; margin-bottom: 20px; line-height: 1.6; }

/* stat cards */
.avuna-stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 25px; }
.avuna-stat-card { background: white; border: 1px solid #ece4d6; border-radius: 20px; padding: 25px; box-shadow: 0 12px 35px rgba(42,33,24,.10); transition: .25s ease; }
.avuna-stat-card:hover { transform: translateY(-6px); box-shadow: 0 20px 40px rgba(42,33,24,.15); }
.avuna-stat-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
.avuna-stat-icon { width: 48px; height: 48px; border-radius: 14px; display: flex; align-items: center; justify-content: center; }
.avuna-stat-icon svg { display: block; }
.avuna-green-icon { background: #f3ece0; color: #2a2118; }
.avuna-orange-icon { background: #fff0e5; color: #d9711f; }
.avuna-gold-icon { background: #fff5d8; color: #9c7814; }
.avuna-red-icon { background: #fdeaea; color: #c84b4b; }
.avuna-stat-label { font-size: 13px; font-weight: bold; letter-spacing: 1px; color: #8a7f72; }
.avuna-stat-card h2 { color: #2a2118; font-size: 42px; font-weight: 700; margin: 0 0 5px; }
.avuna-stat-description { color: #8a7f72; font-size: 14px; }

/* search bar */
.avuna-toolbar { display: flex; gap: 14px; flex-wrap: wrap; align-items: center; background: #fff; border: 1px solid #ece4d6; border-radius: 18px; padding: 16px 20px; box-shadow: 0 12px 35px rgba(42,33,24,.10); margin-bottom: 25px; }
.avuna-search { flex: 1; min-width: 280px; display: flex; gap: 10px; align-items: center; }
.avuna-search input { flex: 1; min-width: 0; padding: 14px 18px; border: 1.5px solid #e4dccd; border-radius: 12px; font-size: 16px; background: #faf7f1; color: #2a2118; font-family: inherit; outline: none; transition: .2s; }
.avuna-search input:focus { border-color: #d9711f; background: #fff; box-shadow: 0 0 0 4px rgba(217,113,31,.14); }
.avuna-search button { background: #d9711f; color: #fff; border: 0; border-radius: 12px; padding: 14px 28px; font-weight: bold; font-size: 16px; cursor: pointer; font-family: inherit; transition: .2s; }
.avuna-search button:hover { background: #b85c18; }
.avuna-clear { color: #8a7f72; font-size: 15px; text-decoration: none; font-weight: bold; white-space: nowrap; }
.avuna-clear:hover { color: #d9711f; }

/* customer table */
.avuna-card { background: white; border: 1px solid #ece4d6; border-radius: 22px; box-shadow: 0 12px 35px rgba(42,33,24,.10); overflow: hidden; margin-bottom: 25px; }
.avuna-orders-header { padding: 25px 28px; display: flex; justify-content: space-between; align-items: center; }
.avuna-orders-header h2 { color: #2a2118; font-size: 28px; margin: 5px 0; }
.avuna-orders-header p { color: #8a7f72; font-size: 15px; margin: 14px 0 16px; }
.avuna-table-wrap { overflow-x: auto; }
.avuna-table { width: 100%; border-collapse: collapse; }
.avuna-table th { background: #f7f3ec; color: #8a7f72; padding: 16px 20px; text-align: left; font-size: 12px; letter-spacing: 1px; }
.avuna-table td { padding: 17px 20px; border-top: 1px solid #efe7da; font-size: 15px; }
.avuna-table tbody tr:hover { background: #faf6ee; }
.avuna-name { font-weight: bold; color: #2a2118; }
.avuna-sub { display: block; color: #8a7f72; font-size: 13px; margin-top: 2px; }
.avuna-muted { color: #8a7f72; }
.avuna-money { white-space: nowrap; font-variant-numeric: tabular-nums; }
.avuna-owing { color: #b03a3a; font-weight: bold; }
.avuna-settled { color: #277446; font-weight: bold; }
.avuna-btn-sm { background: #2a2118; border: 1px solid #2a2118; color: #fff; border-radius: 9px; padding: 8px 16px; font-size: 13px; font-weight: bold; cursor: pointer; font-family: inherit; transition: .2s; white-space: nowrap; }
.avuna-btn-sm:hover { background: #4a3a2a; border-color: #4a3a2a; }

/* status pills and payment progress */
.avuna-status { display: inline-block; padding: 7px 12px; border-radius: 50px; font-size: 12px; font-weight: bold; }
.avuna-completed { background: #e7f4eb; color: #277446; }
.avuna-production { background: #fff0e5; color: #bb5c17; }
.avuna-pending { background: #fff5d8; color: #927017; }
.avuna-failed { background: #fdeaea; color: #b03a3a; }
.avuna-progress { height: 10px; background: #efe7da; border-radius: 20px; overflow: hidden; min-width: 120px; }
.avuna-progress > span { display: block; height: 100%; border-radius: 20px; background: #2f8f5b; }
.avuna-progress-amber > span { background: #d9a52c; }
.avuna-progress-red > span { background: #c84b4b; }
.avuna-progress-label { display: block; font-size: 12px; color: #8a7f72; margin-top: 5px; }

/* the Details row under a customer */
.avuna-detail-row td { background: #faf6ee; padding: 24px 28px !important; }
.avuna-detail-grid { display: grid; grid-template-columns: 280px 1fr; gap: 34px; }
.avuna-detail-grid h4 { font-size: 13px; letter-spacing: 1.5px; color: #8a7f72; margin: 0 0 12px; font-weight: bold; }
.avuna-dl { margin: 0; }
.avuna-dl div { display: flex; justify-content: space-between; gap: 14px; padding: 7px 0; border-bottom: 1px solid #efe7da; font-size: 15px; }
.avuna-dl dt { color: #8a7f72; font-weight: normal; }
.avuna-dl dd { margin: 0; color: #2a2118; font-weight: bold; text-align: right; }
.avuna-subtable { width: 100%; border-collapse: collapse; background: #fff; border: 1px solid #ece4d6; border-radius: 12px; overflow: hidden; margin-bottom: 18px; }
.avuna-subtable th { background: #f7f3ec; color: #8a7f72; font-size: 11px; letter-spacing: 1px; padding: 10px 14px; text-align: left; }
.avuna-subtable td { padding: 11px 14px; border-top: 1px solid #efe7da; font-size: 14px; }
.avuna-hit td { background: #fff7e0; }
.avuna-hit-tag { display: inline-block; margin-left: 8px; background: #d9a52c; color: #2a2118; border-radius: 50px; padding: 2px 9px; font-size: 11px; font-weight: bold; }

/* small screens */
@media (max-width: 1100px) { .avuna-stat-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 800px) { .avuna-detail-grid { grid-template-columns: 1fr; } .avuna-toolbar { padding: 14px; } }
@media (max-width: 700px) {
    .avuna-manager-hero { padding: 45px 25px; }
    .avuna-manager-copy h1 { font-size: 46px; }
    .avuna-manager-badge { display: none; }
    .avuna-manager-body { width: 94%; margin-top: -25px; }
    .avuna-stat-grid { grid-template-columns: 1fr; }
    .avuna-welcome { flex-direction: column; align-items: flex-start; gap: 12px; }
    .avuna-orders-header { flex-direction: column; align-items: flex-start; gap: 12px; }
}

.av-logo-tile{position:relative;z-index:2;width:190px;height:190px;min-width:190px;flex:none;background:#fff;border:2px solid #d9a52c;border-radius:50%;display:flex;align-items:center;justify-content:center;overflow:hidden}
.av-logo-tile img{width:100%;height:100%;object-fit:contain;display:block}
.avuna-manager-hero:before,.avuna-manager-hero:after,.customer-hero:before,.customer-hero:after,.rp-hero:before,.rp-hero:after,.rp-kpi:after,.customer-stat:after,.action-card:after,.avuna-modal-head:after,.edit-modal-head:before,.avuna-order .hero:before{display:none !important}
.avuna-modal-avatar,.edit-avatar,.customer-avatar{border-radius:50% !important;background:#fff url("avuna-logo.png") center/contain no-repeat !important;color:transparent !important;font-size:0 !important;border:1px solid #d9a52c}
.avuna-modal-close,.edit-close,.design-viewer-close,.av-nav-btn{border-radius:50% !important}
@media (max-width:700px){.av-logo-tile{width:130px;height:130px;min-width:130px}}
</style>
<div class="avuna-manager-page">
<!-- ===================================================== HERO ===================================================== -->
<section class="avuna-manager-hero">
<div class="avuna-manager-copy">
<span class="avuna-eyebrow">MANAGER PORTAL</span>
<h1 style="color: white;">Customers</h1>
<p>Every customer, their details, orders and payments. Search by name, contact details, order or payment number.</p>
<div class="avuna-hero-buttons">
<a href="ManageOrders.aspx" class="avuna-button avuna-button-orange">View Orders</a>
<a href="ManagerDashboard.aspx" class="avuna-button avuna-button-outline">Back to Dashboard</a>
</div>
</div>
<div class="av-logo-tile"><img runat="server" src="~/avuna-logo.png" alt="Avuna Collective" /></div>
</section>
<main class="avuna-manager-body">
<!-- WELCOME -->
<div class="avuna-welcome">
<div>
<strong>Welcome back, <asp:Literal ID="litManagerName" runat="server" />.</strong>
</div>
<span><%: DateTime.Now.ToString("dddd, d MMMM yyyy", System.Globalization.CultureInfo.InvariantCulture) %></span>
</div>
<asp:Literal ID="litDbNotice" runat="server" />
<asp:Literal ID="litFlash" runat="server" />
<!-- STATISTICS -->
<section class="avuna-stat-grid">
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-green-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c.6-3.6 3.2-5.5 6.5-5.5s5.9 1.9 6.5 5.5"/><path d="M16 4.7a3.5 3.5 0 0 1 0 6.6M18.5 14.8c1.7.7 2.8 2.3 3 5.2"/></svg></div>
<span class="avuna-stat-label">TOTAL CUSTOMERS</span>
</div>
<h2><asp:Literal ID="litTotalCustomers" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Registered accounts</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-orange-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 4h6l1 2h3v15H5V6h3z"/><path d="M9 12h6M9 16h6"/></svg></div>
<span class="avuna-stat-label">CUSTOMERS WITH ORDERS</span>
</div>
<h2><asp:Literal ID="litWithOrders" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Have placed an order</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-gold-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M14.5 9.2c-.5-.8-1.4-1.2-2.5-1.2-1.5 0-2.5.8-2.5 2s1 1.7 2.5 2 2.5.8 2.5 2-1 2-2.5 2c-1.1 0-2-.4-2.5-1.2M12 6.5V8M12 16v1.5"/></svg></div>
<span class="avuna-stat-label">TOTAL ORDERED</span>
</div>
<h2><asp:Literal ID="litTotalOrdered" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Excluding cancelled orders</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-red-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 7h14a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4z"/><path d="M4 7l11-3v3M16 14h2"/></svg></div>
<span class="avuna-stat-label">STILL OWING</span>
</div>
<h2><asp:Literal ID="litOutstanding" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Ordered but not yet paid</span>
</article>
</section>
<asp:Literal ID="litToolbar" runat="server" />
<section class="avuna-card">
<div class="avuna-orders-header">
<div>
<h2><asp:Literal ID="litTableTitle" runat="server" /></h2>
<p><asp:Literal ID="litTableSubtitle" runat="server" /></p>
</div>
</div>
<div class="avuna-table-wrap">
<table class="avuna-table">
<thead>
<tr>
<th>CUSTOMER</th>
<th>TYPE</th>
<th>CONTACT</th>
<th>LOCATION</th>
<th>ORDERS</th>
<th>ORDERED</th>
<th>PAID</th>
<th>BALANCE</th>
<th></th>
</tr>
</thead>
<tbody>
<asp:Literal ID="litCustomerRows" runat="server" />
</tbody>
</table>
</div>
</section>
</main>
</div>
<script>
    function toggleCust(id) {
        var row = document.getElementById('cd-' + id);
        var btn = document.getElementById('cb-' + id);
        if (!row) return;
        var open = row.style.display !== 'none';
        row.style.display = open ? 'none' : 'table-row';
        if (btn) btn.textContent = open ? 'Details' : 'Hide';
    }
    function doSearch() {
        var q = document.getElementById('custSearch').value.replace(/^\s+|\s+$/g, '');
        window.location.href = 'ManageCustomers.aspx' + (q ? '?q=' + encodeURIComponent(q) : '');
    }
    document.addEventListener('DOMContentLoaded', function () {
        var box = document.getElementById('custSearch');
        if (box) box.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); doSearch(); } });
    });
</script>
</asp:Content>
