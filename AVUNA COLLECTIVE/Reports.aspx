<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="AVUNA_COLLECTIVE.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* =====================================================================
   AVUNA COLLECTIVE - REPORT PAGES (Sales / Orders / Customers / Staff)
   ===================================================================== */
.rp-page {
    --teal: #173c2c; --teal2: #173c2c; --orange: #9a7536; --gold: #c49a45;
    --green: #2f8f5b; --red: #c84b4b; --ink: #243333; --muted: #78827f; --line: #e1e7e3;
    background: #f4f7f5; min-height: 100vh; padding-bottom: 60px;
    font-family: var(--av-sans); color: var(--ink);
}
.rp-page * { box-sizing: border-box; }

/* ---------- HERO ---------- */
.rp-hero {
    position: relative; overflow: hidden; color: #fff;
    background: linear-gradient(120deg, #0d2b2c, #173c2c 60%, #1d5456);
    padding: 46px 7% 90px; border-radius: 0 0 35px 35px;
    display: flex; align-items: center; justify-content: space-between; gap: 30px;
}
.rp-hero:before { content: ""; position: absolute; width: 380px; height: 380px; border-radius: 50%;
    border: 52px solid rgba(217,165,44,.09); right: -140px; top: -160px; }
.rp-hero:after { content: ""; position: absolute; width: 240px; height: 240px; border-radius: 50%;
    border: 34px solid rgba(217,113,31,.10); left: -110px; bottom: -130px; }
.rp-hero-copy { position: relative; z-index: 2; max-width: 760px; }
.rp-eyebrow { display: block; color: var(--gold); font-size: 11px; font-weight: bold; letter-spacing: 2px; margin-bottom: 10px; }
.rp-hero h1 { color: #fff !important; font-size: 46px; line-height: 1.05; margin: 0 0 14px; }
.rp-hero p { color: rgba(255,255,255,.78); font-size: 15px; line-height: 1.7; margin: 0 0 24px; max-width: 680px; }
.rp-hero-actions { display: flex; gap: 12px; flex-wrap: wrap; }
.rp-btn { display: inline-block; padding: 12px 20px; border-radius: 10px; font-size: 13px; font-weight: bold;
    text-decoration: none; cursor: pointer; border: 0; transition: .25s ease; font-family: inherit; }
.rp-btn-primary { background: var(--orange); color: #fff; }
.rp-btn-primary:hover { background: #0f2a1f; color: #fff; transform: translateY(-3px); }
.rp-btn-ghost { background: rgba(255,255,255,.08); border: 1px solid rgba(255,255,255,.35); color: #fff; }
.rp-btn-ghost:hover { background: #fbf8f2; color: var(--teal); }
.rp-hero-badge { position: relative; z-index: 2; min-width: 170px; height: 170px; border-radius: 50%;
    border: 2px solid rgba(217,165,44,.65); background: rgba(255,255,255,.06); display: flex; align-items: center; justify-content: center; }
.rp-hero-badge-inner { width: 126px; height: 126px; border-radius: 50%; background: var(--gold); color: var(--teal);
    display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;
    box-shadow: 0 15px 35px rgba(0,0,0,.2); }
.rp-hero-badge-inner strong { font-size: 30px; line-height: 1; }
.rp-hero-badge-inner span { font-size: 9px; font-weight: bold; letter-spacing: 2px; margin-top: 6px; }

/* ---------- BODY ---------- */
.rp-body { width: 92%; max-width: 1450px; margin: -52px auto 0; position: relative; z-index: 5; }

/* report tabs */
.rp-tabs { display: flex; gap: 8px; flex-wrap: wrap; background: #fbf8f2; border: 1px solid var(--line); border-radius: 18px;
    padding: 8px; box-shadow: 0 12px 35px rgba(17,51,52,.10); margin-bottom: 18px; }
.rp-tab { flex: 1; min-width: 150px; text-align: center; padding: 13px 16px; border-radius: 12px; font-size: 13px; font-weight: bold;
    color: var(--teal); text-decoration: none; transition: .2s; }
.rp-tab:hover { background: #f7f3ea; color: var(--teal); text-decoration: none; }
.rp-tab.rp-active { background: var(--teal); color: #fff; }

/* toolbar */
.rp-toolbar { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; margin: 0 4px 20px; font-size: 12px; color: var(--muted); }
.rp-toolbar b { color: var(--teal); letter-spacing: 1px; font-size: 10px; }
.rp-pill { padding: 7px 14px; border-radius: 50px; background: #fbf8f2; border: 1px solid var(--line); color: var(--teal);
    font-weight: bold; text-decoration: none; font-size: 12px; transition: .2s; }
.rp-pill:hover { border-color: var(--orange); color: var(--orange); text-decoration: none; }
.rp-pill.rp-active { background: var(--orange); border-color: var(--orange); color: #fff; }
.rp-updated { margin-left: auto; }

/* notices */
.rp-notice { background: #fdeaea; border: 1px solid #f0c4c4; color: #8a2f2f; border-radius: 14px; padding: 12px 18px;
    font-size: 12px; margin-bottom: 20px; line-height: 1.6; }
.rp-nochart { display: none; background: #f2e2c9; border: 1px solid #e3d0ae; color: #6e5133; border-radius: 14px; padding: 12px 18px;
    font-size: 12px; margin-bottom: 20px; }

/* ---------- KPI CARDS ---------- */
.rp-kpis { display: grid; grid-template-columns: repeat(5, 1fr); gap: 18px; margin-bottom: 22px; }
.rp-kpi { --accent: #173c2c; background: #fbf8f2; border: 1px solid var(--line); border-radius: 20px; padding: 22px 20px;
    box-shadow: 0 12px 35px rgba(17,51,52,.10); display: flex; gap: 15px; align-items: center; position: relative; overflow: hidden; transition: .25s; }
.rp-kpi:before { content: ""; position: absolute; left: 0; top: 0; bottom: 0; width: 5px; background: var(--accent); }
.rp-kpi:after { content: ""; position: absolute; right: -30px; bottom: -30px; width: 90px; height: 90px; border-radius: 50%;
    background: var(--accent); opacity: .07; }
.rp-kpi:hover { transform: translateY(-5px); box-shadow: 0 20px 40px rgba(17,51,52,.15); }
.rp-kpi-icon { width: 46px; height: 46px; min-width: 46px; border-radius: 14px; background: var(--accent); color: #fff;
    display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 18px; }
.rp-kpi-label { display: block; font-size: 10px; font-weight: bold; letter-spacing: 1px; color: var(--muted); margin-bottom: 4px; }
.rp-kpi-value { display: block; font-size: 25px; color: var(--teal); line-height: 1.1; }
.rp-kpi-sub { display: block; font-size: 11px; color: var(--muted); margin-top: 4px; }
.rp-up { color: var(--green); font-weight: bold; }
.rp-down { color: var(--red); font-weight: bold; }

/* ---------- CARD GRID ---------- */
.rp-grid { display: grid; grid-template-columns: repeat(12, 1fr); gap: 22px; margin-bottom: 22px; }
.rp-span-12 { grid-column: span 12; } .rp-span-8 { grid-column: span 8; } .rp-span-6 { grid-column: span 6; }
.rp-span-4 { grid-column: span 4; } .rp-span-5 { grid-column: span 5; } .rp-span-7 { grid-column: span 7; }
.rp-card { background: #fbf8f2; border: 1px solid var(--line); border-radius: 22px; box-shadow: 0 12px 35px rgba(17,51,52,.10);
    overflow: hidden; min-width: 0; }
.rp-card-h { padding: 22px 26px 8px; }
.rp-card-h h3 { margin: 0 0 4px; font-size: 17px; color: var(--teal); }
.rp-card-h p { margin: 0; font-size: 12px; color: var(--muted); }
.rp-chart { position: relative; padding: 10px 22px 22px; }
.rp-nodata { height: 100%; display: flex; align-items: center; justify-content: center; color: #9aa39f; font-size: 13px;
    border: 2px dashed #e4e9e5; border-radius: 14px; }
.rp-card-body { padding: 8px 26px 24px; }
.rp-empty { color: #9aa39f; font-size: 13px; padding: 20px 0; }

/* ---------- TIMELINE ---------- */
.rp-timeline { list-style: none; margin: 0; padding: 6px 0 0 8px; position: relative; max-height: 420px; overflow-y: auto; }
.rp-timeline:before { content: ""; position: absolute; left: 17px; top: 14px; bottom: 14px; width: 2px; background: #e4e9e5; }
.rp-tl-item { position: relative; padding: 0 0 18px 36px; }
.rp-tl-dot { position: absolute; left: 4px; top: 3px; width: 14px; height: 14px; border-radius: 50%; border: 3px solid #fff;
    box-shadow: 0 0 0 2px var(--dot, #c49a45); background: var(--dot, #0f2a1f); }
.rp-tl-date { font-size: 10px; font-weight: bold; letter-spacing: 1px; color: var(--muted); }
.rp-tl-title { font-size: 13px; font-weight: bold; color: var(--teal); margin: 2px 0; }
.rp-tl-text { font-size: 12px; color: #5d6a67; line-height: 1.5; }

/* ---------- TABLES ---------- */
.rp-table-wrap { overflow-x: auto; }
.rp-table { width: 100%; border-collapse: collapse; }
.rp-table th { background: #f7f9f7; color: #737d79; padding: 12px 14px; text-align: left; font-size: 9px; letter-spacing: 1px; white-space: nowrap; }
.rp-table td { padding: 13px 14px; border-top: 1px solid #edf0ed; font-size: 12px; }
.rp-table tbody tr:hover { background: #fafcfb; }
.rp-strong { color: var(--teal); font-weight: bold; }
.rp-badge { display: inline-block; padding: 5px 10px; border-radius: 50px; font-size: 9px; font-weight: bold; color: #fff; background: var(--orange); }

/* ---------- RESPONSIVE ---------- */
@media (max-width: 1250px) { .rp-kpis { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 1100px) {
    .rp-span-8, .rp-span-7, .rp-span-5, .rp-span-4 { grid-column: span 12; }
    .rp-span-6 { grid-column: span 12; }
    .rp-kpis { grid-template-columns: repeat(2, 1fr); }
    .rp-hero-badge { display: none; }
}
@media (max-width: 700px) {
    .rp-hero { padding: 40px 25px 80px; }
    .rp-hero h1 { font-size: 34px; }
    .rp-body { width: 94%; }
    .rp-kpis { grid-template-columns: 1fr; }
    .rp-updated { margin-left: 0; }
}

/* ---------- PRINT ---------- */
@media print {
    nav, footer, .rp-hero-actions, .rp-tabs, .rp-toolbar { display: none !important; }
    .rp-page { background: #fbf8f2; }
    .rp-hero { padding: 20px 7%; border-radius: 0; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    .rp-body { margin-top: 10px; }
    .rp-card, .rp-kpi { box-shadow: none; break-inside: avoid; }
}

.av-logo-tile{position:relative;z-index:2;width:190px;height:190px;min-width:190px;flex:none;background:#fbf8f2;border:2px solid #c49a45;border-radius:50%;display:flex;align-items:center;justify-content:center;overflow:hidden}
.av-logo-tile img{width:100%;height:100%;object-fit:contain;display:block}
.avuna-manager-hero:before,.avuna-manager-hero:after,.customer-hero:before,.customer-hero:after,.rp-hero:before,.rp-hero:after,.rp-kpi:after,.customer-stat:after,.action-card:after,.avuna-modal-head:after,.edit-modal-head:before,.avuna-order .hero:before{display:none !important}
.avuna-modal-avatar,.edit-avatar,.customer-avatar{border-radius:50% !important;background:#fff url("avuna-logo.png") center/contain no-repeat !important;color:transparent !important;font-size:0 !important;border:1px solid #c49a45}
.avuna-modal-close,.edit-close,.design-viewer-close,.av-nav-btn{border-radius:50% !important}
@media (max-width:700px){.av-logo-tile{width:130px;height:130px;min-width:130px}}
</style>
    <asp:Literal ID="litReport" runat="server" />
</asp:Content>

