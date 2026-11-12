<%@ Page Title="Inventory" Language="C#" MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="AVUNA_COLLECTIVE.Inventory" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* ===== Inventory page styling ===== */
.avuna-manager-page { background: #f5efe6; color: #3a3028; min-height: 100vh; padding-bottom: 60px; font-family: "Segoe UI", Arial, Helvetica, sans-serif; }

/* hero */
.avuna-manager-hero {
    box-sizing: border-box; position: relative; overflow: hidden; color: white;
    background-color: #1b2a22;
    background-image:
        linear-gradient(90deg, rgba(34,24,16,0.9) 0%, rgba(34,24,16,0.78) 40%, rgba(34,24,16,0.38) 72%, rgba(34,24,16,0.08) 100%),
        url("<%= ResolveUrl("~/images/tshirt.jpg") %>");
    background-size: auto, cover; background-position: center, center 40%; background-repeat: no-repeat;
    padding: 70px 7%; min-height: 470px; border-radius: 0 0 35px 35px;
    display: flex; align-items: center; justify-content: space-between;
}
.avuna-manager-copy { position: relative; z-index: 2; max-width: 900px; }
.avuna-eyebrow { display: block; color: #c49a45; font-size: 15px; font-weight: bold; letter-spacing: 3px; margin-bottom: 16px; }
.avuna-manager-copy h1 { font-size: 76px; line-height: 1.02; font-weight: 700; margin: 0 0 22px; text-shadow: 0 2px 14px rgba(0,0,0,.45); }
.avuna-manager-copy p { max-width: 640px; color: rgba(255,255,255,.92); text-shadow: 0 1px 8px rgba(0,0,0,.45); font-size: 22px; line-height: 1.55; margin: 0 0 34px; }
.avuna-hero-buttons { display: flex; gap: 12px; flex-wrap: wrap; }
.avuna-button { display: inline-block; padding: 17px 30px; border-radius: 10px; font-size: 17px; font-weight: bold; text-decoration: none; transition: .25s ease; }
.avuna-button-orange { background: #0f2a1f; color: white; }
.avuna-button-orange:hover { background: #0f2a1f; color: white; transform: translateY(-3px); }
.avuna-button-outline { border: 1px solid rgba(255,255,255,.35); color: white; background: rgba(255,255,255,.12); }
.avuna-button-outline:hover { background: #fbf8f2; color: #1b2a22; }

/* body, welcome strip */
.avuna-manager-body { width: 92%; max-width: 1450px; margin: -40px auto 0; position: relative; z-index: 5; }
.avuna-welcome { background: #fbf8f2; border: 1px solid #e5dccd; border-radius: 18px; padding: 20px 25px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 12px 35px rgba(42,33,24,.10); margin-bottom: 25px; }
.avuna-welcome strong { color: #1b2a22; font-size: 22px; }
.avuna-welcome span { color: #6c736d; font-size: 16px; }
.avuna-db-notice { background: #fdeaea; border: 1px solid #f0c4c4; color: #8a2f2f; border-radius: 14px; padding: 12px 18px; font-size: 14px; margin-bottom: 20px; line-height: 1.6; }

/* stat cards */
.avuna-stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 25px; }
.avuna-stat-card { background: #fbf8f2; border: 1px solid #e5dccd; border-radius: 20px; padding: 25px; box-shadow: 0 12px 35px rgba(42,33,24,.10); transition: .25s ease; }
.avuna-stat-card:hover { transform: translateY(-6px); box-shadow: 0 20px 40px rgba(42,33,24,.15); }
.avuna-stat-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
.avuna-stat-icon { width: 48px; height: 48px; border-radius: 14px; display: flex; align-items: center; justify-content: center; }
.avuna-stat-icon svg { display: block; }
.avuna-green-icon { background: #f3ece0; color: #1b2a22; }
.avuna-orange-icon { background: #f2e2c9; color: #8a6a35; }
.avuna-gold-icon { background: #f2e2c9; color: #6e5133; }
.avuna-red-icon { background: #fdeaea; color: #c84b4b; }
.avuna-stat-label { font-size: 13px; font-weight: bold; letter-spacing: 1px; color: #6c736d; }
.avuna-stat-card h2 { color: #1b2a22; font-size: 42px; font-weight: 700; margin: 0 0 5px; }
.avuna-stat-description { color: #6c736d; font-size: 14px; }

/* search bar and filters */
.avuna-toolbar { display: flex; gap: 14px; flex-wrap: wrap; align-items: center; background: #fbf8f2; border: 1px solid #e5dccd; border-radius: 18px; padding: 16px 20px; box-shadow: 0 12px 35px rgba(42,33,24,.10); margin-bottom: 25px; }
.avuna-search { flex: 1; min-width: 280px; display: flex; gap: 10px; align-items: center; }
.avuna-search input { flex: 1; min-width: 0; padding: 14px 18px; border: 1.5px solid #e4dccd; border-radius: 12px; font-size: 16px; background: #f5efe6; color: #1b2a22; font-family: inherit; outline: none; transition: .2s; }
.avuna-search input:focus { border-color: #c49a45; background: #fbf8f2; box-shadow: 0 0 0 4px rgba(217,113,31,.14); }
.avuna-search button { background: #0f2a1f; color: #fff; border: 0; border-radius: 12px; padding: 14px 28px; font-weight: bold; font-size: 16px; cursor: pointer; font-family: inherit; transition: .2s; }
.avuna-search button:hover { background: #0f2a1f; }
.avuna-clear { color: #6c736d; font-size: 15px; text-decoration: none; font-weight: bold; white-space: nowrap; }
.avuna-clear:hover { color: #8a6a35; }
.avuna-filters { display: flex; gap: 8px; flex-wrap: wrap; }
.avuna-chip { display: inline-block; padding: 10px 16px; border-radius: 50px; border: 1.5px solid #e4dccd; background: #f5efe6; color: #5a4d40; font-size: 14px; font-weight: bold; text-decoration: none; transition: .2s; white-space: nowrap; }
.avuna-chip:hover { border-color: #c49a45; color: #8a6a35; }
.avuna-chip.active { background: #1b2a22; border-color: #1b2a22; color: #fff; }

/* stock table */
.avuna-card { background: #fbf8f2; border: 1px solid #e5dccd; border-radius: 22px; box-shadow: 0 12px 35px rgba(42,33,24,.10); overflow: hidden; margin-bottom: 25px; }
.avuna-orders-header { padding: 25px 28px; display: flex; justify-content: space-between; align-items: center; }
.avuna-orders-header h2 { color: #1b2a22; font-size: 28px; margin: 5px 0; }
.avuna-orders-header p { color: #6c736d; font-size: 15px; margin: 14px 0 16px; }
.avuna-table-wrap { overflow-x: auto; }
.avuna-table { width: 100%; border-collapse: collapse; }
.avuna-table th { background: #f5efe6; color: #6c736d; padding: 16px 20px; text-align: left; font-size: 12px; letter-spacing: 1px; white-space: nowrap; }
.avuna-table th.num, .avuna-table td.num { text-align: right; }
.avuna-table td { padding: 15px 20px; border-top: 1px solid #e5dccd; font-size: 15px; }
.avuna-table tbody tr:hover { background: #f5efe6; }
.avuna-name { font-weight: bold; color: #1b2a22; }
.avuna-sub { display: block; color: #6c736d; font-size: 13px; margin-top: 2px; }
.avuna-muted { color: #6c736d; }
.avuna-money { white-space: nowrap; font-variant-numeric: tabular-nums; }
.avuna-qty { font-weight: bold; font-variant-numeric: tabular-nums; }
.avuna-swatch { display: inline-block; width: 14px; height: 14px; border-radius: 50%; border: 1px solid #cfc6b6; vertical-align: -2px; margin-right: 8px; }
.avuna-size { display: inline-block; min-width: 42px; text-align: center; padding: 5px 10px; border-radius: 8px; background: #f3ece0; color: #1b2a22; font-weight: bold; font-size: 13px; }
.avuna-est { display: inline-block; margin-left: 8px; background: #f2e2c9; color: #6e5133; border-radius: 50px; padding: 2px 9px; font-size: 11px; font-weight: bold; }

/* stock status pills */
.avuna-status { display: inline-block; padding: 7px 12px; border-radius: 50px; font-size: 12px; font-weight: bold; white-space: nowrap; }
.avuna-completed { background: #e7f4eb; color: #277446; }
.avuna-pending { background: #f2e2c9; color: #6e5133; }
.avuna-failed { background: #fdeaea; color: #b03a3a; }
.avuna-stockbar { height: 8px; background: #e5dccd; border-radius: 20px; overflow: hidden; min-width: 90px; margin-top: 6px; }
.avuna-stockbar > span { display: block; height: 100%; border-radius: 20px; background: #2f8f5b; }
.avuna-stockbar-amber > span { background: #c49a45; }
.avuna-stockbar-red > span { background: #c84b4b; }

/* small screens */
@media (max-width: 1100px) { .avuna-stat-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 800px) { .avuna-toolbar { padding: 14px; } }
@media (max-width: 700px) {
    .avuna-manager-hero { padding: 45px 25px; }
    .avuna-manager-copy h1 { font-size: 46px; }
    .avuna-manager-body { width: 94%; margin-top: -25px; }
    .avuna-stat-grid { grid-template-columns: 1fr; }
    .avuna-welcome { flex-direction: column; align-items: flex-start; gap: 12px; }
    .avuna-orders-header { flex-direction: column; align-items: flex-start; gap: 12px; }
}

.av-logo-tile{position:relative;z-index:2;width:190px;height:190px;min-width:190px;flex:none;background:#fbf8f2;border:2px solid #c49a45;border-radius:50%;display:flex;align-items:center;justify-content:center;overflow:hidden}
.av-logo-tile img{width:100%;height:100%;object-fit:contain;display:block}
.avuna-manager-hero:before,.avuna-manager-hero:after{display:none !important}
@media (max-width:700px){.av-logo-tile{width:130px;height:130px;min-width:130px}}
</style>
<div class="avuna-manager-page">
<!-- ===================================================== HERO ===================================================== -->
<section class="avuna-manager-hero" style="--hero-img:url('images/GG-0653_PinksInks_29_lg.jpg');--hero-size:cover;--hero-pos:center">
<div class="avuna-manager-copy">
<span class="avuna-eyebrow">MANAGER PORTAL</span>
<h1 style="color: white;">Inventory</h1>
<p>Every product variant in stock, with its size, colour, quantity and cost. Search by product, size, colour or variant number.</p>
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
<!-- STATISTICS -->
<section class="avuna-stat-grid">
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-green-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 3l8 4.5v9L12 21l-8-4.5v-9z"/><path d="M4 7.5L12 12l8-4.5M12 12v9"/></svg></div>
<span class="avuna-stat-label">PRODUCT VARIANTS</span>
</div>
<h2><asp:Literal ID="litTotalVariants" runat="server" Text="0" /></h2>
<span class="avuna-stat-description"><asp:Literal ID="litItemsNote" runat="server" Text="Across 0 products" /></span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-orange-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 7h16v13H4z"/><path d="M8 7V4h8v3M9 12h6"/></svg></div>
<span class="avuna-stat-label">UNITS IN STOCK</span>
</div>
<h2><asp:Literal ID="litTotalUnits" runat="server" Text="0" /></h2>
<span class="avuna-stat-description">Total quantity available</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-gold-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M14.5 9.2c-.5-.8-1.4-1.2-2.5-1.2-1.5 0-2.5.8-2.5 2s1 1.7 2.5 2 2.5.8 2.5 2-1 2-2.5 2c-1.1 0-2-.4-2.5-1.2M12 6.5V8M12 16v1.5"/></svg></div>
<span class="avuna-stat-label">STOCK VALUE</span>
</div>
<h2><asp:Literal ID="litStockValue" runat="server" Text="R0" /></h2>
<span class="avuna-stat-description">Quantity x unit cost</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-red-icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 3l10 18H2z"/><path d="M12 10v5M12 18v.5"/></svg></div>
<span class="avuna-stat-label">NEEDS ATTENTION</span>
</div>
<h2><asp:Literal ID="litAttention" runat="server" Text="0" /></h2>
<span class="avuna-stat-description"><asp:Literal ID="litAttentionNote" runat="server" Text="Low or out of stock" /></span>
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
<th>VARIANT</th>
<th>PRODUCT</th>
<th>SIZE</th>
<th>COLOUR</th>
<th class="num">QUANTITY</th>
<th class="num">UNIT COST</th>
<th class="num">STOCK VALUE</th>
<th>STATUS</th>
</tr>
</thead>
<tbody>
<asp:Literal ID="litRows" runat="server" />
</tbody>
</table>
</div>
</section>
</main>
</div>
<script>
    function doSearch() {
        var q = document.getElementById('invSearch').value.replace(/^\s+|\s+$/g, '');
        var status = document.getElementById('invStatus').value;
        var parts = [];
        if (q) parts.push('q=' + encodeURIComponent(q));
        if (status) parts.push('status=' + encodeURIComponent(status));
        window.location.href = 'Inventory.aspx' + (parts.length ? '?' + parts.join('&') : '');
    }
    document.addEventListener('DOMContentLoaded', function () {
        var box = document.getElementById('invSearch');
        if (box) box.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); doSearch(); } });
    });
</script>
</asp:Content>

