<%@ Page Title="" Language="C#" MasterPageFile="~/Customer_master.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="AVUNA_COLLECTIVE.MyOrders" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* =========================================================
   AVUNA MY ORDERS — shared page shell (same as Dashboard)
   ========================================================= */
.customer-dashboard {
  --avuna-orange: #9a7536;
  --avuna-orange-dark: #6f5428;
  --avuna-gold: #c49a45;
  --avuna-black: #111111;
  --avuna-dark: #1c1c1c;
  --avuna-light: #f5efe6;
  --avuna-white: #ffffff;
  --avuna-grey: #6f6f6f;
  --avuna-border: #e5dccd;
  --avuna-green: #27845b;
  --avuna-red: #c94b45;
  --avuna-shadow: 0 10px 35px rgba(0,0,0,.08);
  width: 100%;
  min-height: 100vh;
  background: #f5efe6;
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
  border: 70px solid rgba(196,154,69,.08);
  border-radius: 50%;
  right: -120px; top: -170px;
}
.customer-hero:after {
  content: "";
  position: absolute;
  width: 180px; height: 180px;
  background: rgba(217,164,65,.08);
  transform: rotate(45deg);
  left: -70px; bottom: -100px;
}
.customer-hero-copy { position: relative; z-index: 2; max-width: 720px; }
.customer-eyebrow { display: inline-block; color: #8a6a35; font-size: 12px; font-weight: 800; letter-spacing: 2px; margin-bottom: 14px; }
.customer-hero h1 { font-size: clamp(38px, 5vw, 64px); line-height: 1; margin: 0 0 20px; font-weight: 800; letter-spacing: -2px; }
.customer-hero p { color: #d4d4d4; font-size: 17px; line-height: 1.7; max-width: 650px; margin-bottom: 30px; }
.customer-hero-actions { display: flex; gap: 14px; flex-wrap: wrap; }
.customer-btn { display: inline-flex; align-items: center; justify-content: center; padding: 13px 22px; border-radius: 10px; text-decoration: none !important; font-weight: 700; transition: all .25s ease; }
.customer-btn-orange { background: var(--avuna-orange); color: white !important; box-shadow: 0 8px 20px rgba(196,154,69,.25); }
.customer-btn-orange:hover { background: #173c2c; transform: translateY(-3px); box-shadow: 0 12px 28px rgba(196,154,69,.35); }
.customer-btn-light { border: 1px solid rgba(255,255,255,.35); color: white !important; background: rgba(255,255,255,.06); }
.customer-btn-light:hover { background: #fbf8f2; color: #111 !important; transform: translateY(-3px); }
/* HERO BADGE */
.customer-hero-badge {
  position: relative; z-index: 2;
  width: 190px; height: 190px;
  border-radius: 50%;
  border: 2px solid rgba(196,154,69,.6);
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  background: radial-gradient(circle, rgba(196,154,69,.18), rgba(255,255,255,.02) 60%);
  box-shadow: 0 0 0 18px rgba(196,154,69,.03), 0 0 60px rgba(196,154,69,.12);
}
.customer-hero-badge strong { font-size: 42px; letter-spacing: 3px; color: white; }
.customer-hero-badge span { color: #8a6a35; text-transform: uppercase; font-size: 10px; font-weight: 800; letter-spacing: 2px; text-align: center; margin-top: 5px; }
/* BODY */
.customer-body { width: 90%; max-width: 1400px; margin: -35px auto 0; position: relative; z-index: 5; }
/* WELCOME STRIP */
.customer-welcome { background: #fbf8f2; border: 1px solid var(--avuna-border); border-radius: 16px; padding: 20px 25px; display: flex; align-items: center; justify-content: space-between; box-shadow: var(--avuna-shadow); margin-bottom: 24px; }
.customer-welcome strong { display: block; font-size: 18px; margin-bottom: 4px; }
.customer-welcome span { color: var(--avuna-grey); font-size: 14px; }
.customer-demo { background: #f2e2c9; color: var(--avuna-orange); padding: 8px 13px; border-radius: 20px; font-size: 11px; font-weight: 800; letter-spacing: 1px; }
/* STATISTICS (reused for order-focused stats) */
.customer-stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 24px; }
.customer-stat { position: relative; overflow: hidden; background: #fbf8f2; border-radius: 17px; border: 1px solid var(--avuna-border); padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,.05); transition: all .25s ease; }
.customer-stat:hover { transform: translateY(-6px); box-shadow: 0 15px 35px rgba(0,0,0,.10); }
.customer-stat:after { content: ""; position: absolute; width: 90px; height: 90px; border-radius: 50%; right: -35px; bottom: -35px; background: rgba(196,154,69,.05); }
.customer-stat-icon { width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 18px; font-size: 20px; font-weight: 800; }
.stat-green .customer-stat-icon { background: #e6f5ed; color: var(--avuna-green); }
.stat-orange .customer-stat-icon { background: #f2e2c9; color: var(--avuna-orange); }
.stat-gold .customer-stat-icon { background: #f2e2c9; color: #6e5133; }
.stat-dark .customer-stat-icon { background: #eeeeee; color: #222; }
.customer-stat small { display: block; color: #858585; font-size: 10px; letter-spacing: 1.5px; font-weight: 800; margin-bottom: 5px; }
.customer-stat strong { display: block; font-size: 30px; color: #181818; margin-bottom: 4px; }
.customer-stat span { color: #777; font-size: 12px; }
/* CARD + ORDERS TABLE */
.customer-card { background: #fbf8f2; border: 1px solid var(--avuna-border); border-radius: 18px; padding: 28px; box-shadow: 0 6px 25px rgba(0,0,0,.05); margin-bottom: 24px; }
.customer-card-heading { display: flex; justify-content: space-between; align-items: flex-start; gap: 15px; margin-bottom: 25px; }
.customer-card-heading h2 { margin: 5px 0 7px; font-size: 24px; color: #181818; }
.customer-card-heading p { color: #777; margin: 0; font-size: 13px; }
.customer-dark-eyebrow { color: var(--avuna-orange); font-size: 10px; letter-spacing: 1.7px; font-weight: 800; }
.view-link { color: var(--avuna-orange) !important; font-weight: 800; font-size: 13px; text-decoration: none !important; }
.orders-table { width: 100%; border-collapse: collapse; }
.orders-table th { background: #f5efe6; color: #666; padding: 14px; text-align: left; font-size: 10px; letter-spacing: 1px; }
.orders-table td { padding: 16px 14px; border-bottom: 1px solid #eeeeee; font-size: 13px; }
.orders-table tr:hover td { background: #fffaf5; }
/* refined stat cards */
.customer-stat-grid .customer-stat{padding:24px 26px 22px;border-radius:16px;background:#fbf8f2;border:1px solid #e5dccd;box-shadow:0 1px 2px rgba(15,42,31,.04),0 10px 28px rgba(15,42,31,.06);min-height:150px;display:flex;flex-direction:column}
.customer-stat-grid .customer-stat:hover{transform:translateY(-3px);box-shadow:0 14px 34px rgba(15,42,31,.12)}
.customer-stat-grid .customer-stat:before{content:"";position:absolute;left:0;right:0;top:0;height:4px;background:#b98a3e}
.customer-stat-grid .customer-stat:after{display:none}
.customer-stat-grid .customer-stat-icon{position:absolute;top:22px;right:22px;width:42px;height:42px;margin:0;border-radius:50%;background:#f2e8d6;color:#8a6a35}
.customer-stat-grid .customer-stat-icon svg{width:21px;height:21px;fill:none;stroke:currentColor;stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round}
.customer-stat-grid .customer-stat small{order:1;color:#8a6a35;font-size:10.5px;letter-spacing:2px;font-weight:700;margin:2px 0 14px;padding-right:56px}
.customer-stat-grid .customer-stat strong{order:2;font-family:"Playfair Display",Georgia,serif;font-size:36px;line-height:1.05;font-weight:700;color:#0f2a1f;margin:0 0 8px}
.customer-stat-grid .customer-stat span{order:3;color:#6c736d;font-size:13px;margin-top:auto}
.customer-stat-grid .stat-green{background:#0f2a1f;border-color:#0f2a1f}
.customer-stat-grid .stat-green small{color:#d8b36a}
.customer-stat-grid .stat-green strong{color:#f5efe6}
.customer-stat-grid .stat-green span{color:#b9c4bb}
.customer-stat-grid .stat-green .customer-stat-icon{background:rgba(255,255,255,.1);color:#d8b36a}
.customer-stat-grid .stat-gold:before{background:#0f2a1f}
.customer-stat-grid .stat-dark:before{background:#6b8f71}
.customer-stat-grid .stat-orange:before{background:#6b8f71}
.status { display: inline-block; padding: 6px 10px; border-radius: 20px; font-size: 10px; font-weight: 800; }
.status-processing { background: #fff0df; color: #c46715; }
.status-completed { background: #e4f5ec; color: #287a52; }
.status-pending { background: #fff4d7; color: #9a7416; }
.status-delivered { background: #e4f5ec; color: #287a52; }
.status-cancelled { background: #fbe5e3; color: #c94b45; }

.view-design-btn { display: inline-block; padding: 8px 14px; border-radius: 8px; border: 1px solid var(--avuna-orange); background: #f2e2c9; color: var(--avuna-orange); font-size: 11px; font-weight: 800; letter-spacing: .5px; cursor: pointer; white-space: nowrap; transition: all .2s ease; }
.view-design-btn:hover { background: var(--avuna-orange); color: white; transform: translateY(-2px); box-shadow: 0 6px 14px rgba(196,154,69,.3); }
.no-design { color: #aaa; font-size: 12px; }
/* IMAGE VIEWER (lightbox) */
.design-viewer { display: none; position: fixed; inset: 0; z-index: 99999; background: rgba(0,0,0,.82); align-items: center; justify-content: center; padding: 30px; }
.design-viewer.open { display: flex; }
.design-viewer-box { position: relative; max-width: 92vw; max-height: 90vh; }
.design-viewer-box img { display: block; max-width: 92vw; max-height: 85vh; border-radius: 12px; background: #fbf8f2; box-shadow: 0 20px 60px rgba(0,0,0,.5); }
.design-viewer-caption { margin-top: 12px; text-align: center; color: #f1f1f1; font-size: 13px; font-weight: 700; letter-spacing: .5px; }
.design-viewer-close { position: absolute; top: -14px; right: -14px; width: 38px; height: 38px; border-radius: 50%; border: none; background: var(--avuna-orange); color: white; font-size: 22px; font-weight: 800; line-height: 1; cursor: pointer; box-shadow: 0 6px 16px rgba(0,0,0,.35); }
.design-viewer-close:hover { background: #173c2c; }

/* RESPONSIVE */
@media(max-width: 1000px) {
  .customer-stat-grid { grid-template-columns: repeat(2,1fr); }
  .action-grid { grid-template-columns: 1fr; }
  .customer-hero { padding: 60px 6%; }
}
@media(max-width: 650px) {
  .customer-hero { padding: 50px 25px; min-height: auto; }
  .customer-hero-badge { display: none; }
  .customer-body { width: 94%; }
  .customer-stat-grid { grid-template-columns: 1fr; }
  .customer-welcome { flex-direction: column; align-items: flex-start; gap: 12px; }
  .customer-card { padding: 20px; }
}

.customer-hero{background-color:#1b2a22;background-image:linear-gradient(90deg,rgba(24,17,10,.90) 0%,rgba(24,17,10,.74) 42%,rgba(24,17,10,.28) 100%),url("<%= ResolveUrl("~/images/customer-hero.jpg") %>");background-size:auto,cover;background-position:center,center;background-repeat:no-repeat}
.av-logo-tile{position:relative;z-index:2;width:190px;height:190px;min-width:190px;flex:none;background:#fbf8f2;border:2px solid #c49a45;border-radius:50%;display:flex;align-items:center;justify-content:center;overflow:hidden}
.av-logo-tile img{width:100%;height:100%;object-fit:contain;display:block}
.avuna-manager-hero:before,.avuna-manager-hero:after,.customer-hero:before,.customer-hero:after,.rp-hero:before,.rp-hero:after,.rp-kpi:after,.customer-stat:after,.action-card:after,.avuna-modal-head:after,.edit-modal-head:before,.avuna-order .hero:before{~/images/avuna_collective_background.jpg}
.avuna-modal-avatar,.edit-avatar,.customer-avatar{border-radius:50% !important;background:#fff url("avuna-logo.png") center/contain no-repeat !important;color:transparent !important;font-size:0 !important;border:1px solid #c49a45}
.avuna-modal-close,.edit-close,.design-viewer-close,.av-nav-btn{border-radius:50% !important}
@media (max-width:700px){.av-logo-tile{width:130px;height:130px;min-width:130px}}

/* ORDER CANCELLATION */
.cancel-order-btn{padding:9px 14px;border:1px solid #c94b45;background:#fff1ef;color:#b22d28;border-radius:8px;font-size:11px;font-weight:800;cursor:pointer;white-space:nowrap}
.cancel-order-btn:hover{background:#c94b45;color:#fff}
.avuna-cancel-overlay{display:none;position:fixed;inset:0;z-index:100001;align-items:center;justify-content:center;background:rgba(0,0,0,.65);padding:18px}
.avuna-cancel-overlay.open{display:flex}
.avuna-cancel-dialog{width:100%;max-width:440px;background:#fbf8f2;color:#222;border-radius:18px;padding:32px;text-align:center;box-shadow:0 25px 90px rgba(0,0,0,.25)}
.avuna-cancel-dialog h2{font-size:25px;margin:0 0 14px}
.avuna-cancel-dialog p{color:#555;line-height:1.6;margin:0 0 16px}
.avuna-cancel-actions{display:flex;gap:12px;justify-content:center;margin-top:24px;flex-wrap:wrap}
.avuna-cancel-keep,.avuna-cancel-confirm,.avuna-notice-ok{border:0;border-radius:9px;padding:12px 22px;font-weight:800;cursor:pointer}
.avuna-cancel-keep{background:#f1f1f1;color:#333}
.avuna-cancel-confirm{background:#c94b45;color:#fff}
.avuna-notice-ok{background:#0f2a1f;color:#fff;min-width:130px}

/* ORDER RATING */
.rate-order-btn{display:inline-block;padding:9px 14px;border:1px solid #9a7536;background:#f2e2c9;color:#6f5428;border-radius:8px;font-size:11px;font-weight:800;letter-spacing:.5px;cursor:pointer;white-space:nowrap;transition:all .2s ease}
.rate-order-btn:hover{background:#9a7536;color:#fff;transform:translateY(-2px);box-shadow:0 6px 14px rgba(196,154,69,.3)}
.avuna-stars{display:flex;flex-direction:row-reverse;justify-content:center;gap:4px;margin:4px 0 18px}
.avuna-stars input{position:absolute;opacity:0;width:0;height:0}
.avuna-stars label{font-size:42px;line-height:1;color:#d9d3c5;cursor:pointer;transition:color .15s ease,transform .15s ease}
.avuna-stars label:hover{transform:scale(1.12)}
.avuna-stars input:checked ~ label,.avuna-stars label:hover,.avuna-stars label:hover ~ label{color:#c49a45}
.avuna-stars input:focus-visible + label{outline:2px solid #9a7536;border-radius:6px}
.avuna-rate-text{display:block;width:100%;box-sizing:border-box;padding:12px;border:1px solid #e5dccd;border-radius:10px;font:inherit;font-size:14px;resize:none;background:#fff;color:#222}
.avuna-rate-text:focus{outline:2px solid #c49a45;border-color:#c49a45}
.avuna-rate-count{text-align:right;font-size:12px;color:#888;margin:6px 0 0}
.avuna-rate-submit{border:0;border-radius:9px;padding:12px 22px;font-weight:800;cursor:pointer;background:#9a7536;color:#fff}
.avuna-rate-submit:hover{background:#173c2c}
.avuna-rate-error{display:none;color:#c94b45;font-size:13px;font-weight:700;margin:10px 0 0}
</style>
<div class="customer-dashboard">
  <!-- ===================================================== HERO ===================================================== -->
  <section class="customer-hero" style="--hero-img:url('images/GG-0653_PinksInks_29_lg.jpg');--hero-size:cover;--hero-pos:center">
    <div class="customer-hero-copy">

      <h1 style="color: white;">Your orders, tracked end to end.</h1>
      <p>Check the status, progress and value of everything you've ordered from AVUNA.</p>
      <div class="customer-hero-actions">
        <a href="~/CreateOrder.aspx" runat="server" class="customer-btn customer-btn-orange">Create a New Order</a>
        <a href="CustomerDashboard.aspx" class="customer-btn customer-btn-light">Back to Dashboard</a>
      </div>
    </div>
    <div class="av-logo-tile"><img runat="server" src="~/avuna-logo.png" alt="Avuna Collective" /></div>
  </section>
  <!-- ===================================================== ORDERS BODY ===================================================== -->
  <main class="customer-body">

    
    <!-- ORDER STATISTICS -->
    <section class="customer-stat-grid">
      <article class="customer-stat stat-green">
        <div class="customer-stat-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 17 17 7"/><path d="M9 7h8v8"/></svg></div>
        <small>ACTIVE ORDERS</small>
        <strong><asp:Literal ID="litActive" runat="server" /></strong>
        <span>Currently in progress</span>
      </article>
      <article class="customer-stat stat-orange">
        <div class="customer-stat-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="8.5"/><path d="m8.3 12.3 2.7 2.7 4.8-5.3"/></svg></div>
        <small>COMPLETED</small>
        <strong><asp:Literal ID="litCompleted" runat="server" /></strong>
        <span>Successfully delivered</span>
      </article>
      <article class="customer-stat stat-gold">
        <div class="customer-stat-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3.5" y="6.5" width="17" height="11" rx="2"/><circle cx="12" cy="12" r="2.6"/><path d="M7 9.5v.01M17 14.5v.01"/></svg></div>
        <small>OUTSTANDING</small>
        <strong><asp:Literal ID="litOutstanding" runat="server" /></strong>
        <span>Outstanding balance</span>
      </article>
      <article class="customer-stat stat-dark">
        <div class="customer-stat-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8.5 4 7 20M17 4l-1.5 16M4.5 9h15M4 15h15"/></svg></div>
        <small>TOTAL ORDERS</small>
        <strong><asp:Literal ID="litTotal" runat="server" /></strong>
        <span>Placed all-time</span>
      </article>
    </section>
    <!-- ORDERS TABLE -->
    <section class="customer-card">
      <div class="customer-card-heading">
        <div>
          <span class="customer-dark-eyebrow">ORDER ACTIVITY</span>
          <h2>All My Orders</h2>
          <p>Track the progress and value of every order you've placed.</p>
        </div>
      </div>
      <div style="overflow-x:auto;">
        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="orders-table" GridLines="None"
            EmptyDataText="You haven't placed any orders yet.">
          <Columns>
            <asp:BoundField DataField="order_ID" HeaderText="Order No." />
            <asp:BoundField DataField="order_Date" HeaderText="Order Date" DataFormatString="{0:dd MMM yyyy}" />
            <asp:BoundField DataField="item" HeaderText="Item" />
            <asp:BoundField DataField="DesignPackage" HeaderText="Package" />
            <asp:BoundField DataField="orderItem_Quantity" HeaderText="Qty" />
            <asp:BoundField DataField="orderItem_Size" HeaderText="Size" />
            <asp:BoundField DataField="orderItem_Colour" HeaderText="Colour" />
            <asp:TemplateField HeaderText="Design">
              <ItemTemplate>
                <%# RenderDesign(Eval("designFile_ID"), Eval("order_ID"), Eval("item")) %>
              </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Status">
              <ItemTemplate>
                <span class='status <%# GetStatusClass(Eval("order_Status")) %>'><%# FormatStatus(Eval("order_Status")) %></span>
              </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="orderItem_Subtotal" HeaderText="Subtotal" DataFormatString="R {0:N2}" />
            <asp:TemplateField HeaderText="Action">
              <ItemTemplate>
                <%# RenderAction(Eval("order_Status"), Eval("order_ID"), Eval("ItemRowNumber"), Eval("RatingCount"), Eval("RatingScore")) %>
              </ItemTemplate>
            </asp:TemplateField>
          </Columns>
        </asp:GridView>
      </div>
    </section>

  </main>
</div>

<!-- DESIGN PHOTOS (loaded from the database with the page, so they are ready instantly) -->
<div style="display:none" aria-hidden="true"><%= DesignStoreHtml %></div>

<!-- DESIGN IMAGE VIEWER -->
<div id="designViewer" class="design-viewer" aria-hidden="true">
  <div class="design-viewer-box">
    <button type="button" id="designViewerClose" class="design-viewer-close" aria-label="Close">&times;</button>
    <img id="designViewerImg" src="" alt="Design preview" />
    <div id="designViewerCaption" class="design-viewer-caption"></div>
  </div>
</div>
<script>
    (function () {
        var viewer = document.getElementById('designViewer');
        var img = document.getElementById('designViewerImg');
        var caption = document.getElementById('designViewerCaption');

        function openViewer(src, title) {
            img.src = src;
            caption.textContent = title || '';
            viewer.classList.add('open');
            viewer.setAttribute('aria-hidden', 'false');
        }
        function closeViewer() {
            viewer.classList.remove('open');
            viewer.setAttribute('aria-hidden', 'true');
            img.removeAttribute('src');
        }

        document.addEventListener('click', function (e) {
            var btn = e.target.closest ? e.target.closest('.view-design-btn') : null;
            if (btn) {
                var source = document.getElementById(btn.getAttribute('data-img'));
                if (source && source.src) openViewer(source.src, btn.getAttribute('data-title'));
                return;
            }
            if (e.target === viewer || e.target.id === 'designViewerClose') closeViewer();
        });
        document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeViewer(); });
    })();
</script>

<!-- CONFIRM CANCEL: the ASP.NET button performs the server-side cancellation -->
<input type="hidden" id="avunaCancelOrderId" name="avunaCancelOrderId" value="" />
<div id="avunaCancelModal" class="avuna-cancel-overlay" role="dialog" aria-modal="true" aria-labelledby="avunaCancelHeading" aria-hidden="true">
  <div class="avuna-cancel-dialog">
    <h2 id="avunaCancelHeading">Cancel this order?</h2>
    <p id="avunaCancelMessage"></p>
    <p>Only <strong>Pending</strong> orders can be cancelled. The reserved quantities will be returned to inventory.</p>
    <div class="avuna-cancel-actions">
      <button type="button" id="avunaCancelKeep" class="avuna-cancel-keep">No, Keep Order</button>
      <asp:Button ID="btnConfirmCancel" runat="server" Text="Yes, Cancel Order"
          CssClass="avuna-cancel-confirm" CausesValidation="false"
          OnClick="btnConfirmCancel_Click" />
    </div>
  </div>
</div>
<div id="avunaNoticeModal" class="avuna-cancel-overlay" role="alertdialog" aria-modal="true" aria-labelledby="avunaNoticeHeading" aria-hidden="true">
  <div class="avuna-cancel-dialog">
    <h2 id="avunaNoticeHeading"></h2>
    <p id="avunaNoticeMessage"></p>
    <button type="button" id="avunaNoticeOkay" class="avuna-notice-ok">OK</button>
  </div>
</div>
<script>
    (function () {
        var modal = document.getElementById('avunaCancelModal');
        var keep = document.getElementById('avunaCancelKeep');
        var hidden = document.getElementById('avunaCancelOrderId');
        function closeCancel() { modal.classList.remove('open'); modal.setAttribute('aria-hidden', 'true'); hidden.value = ''; }
        document.addEventListener('click', function (e) {
            var button = e.target.closest ? e.target.closest('.cancel-order-btn') : null;
            if (button) {
                hidden.value = button.getAttribute('data-order');
                document.getElementById('avunaCancelMessage').textContent = 'Are you sure you want to cancel order ' + hidden.value + '?';
                modal.classList.add('open'); modal.setAttribute('aria-hidden', 'false'); keep.focus();
            }
            if (e.target === modal) closeCancel();
        });
        keep.addEventListener('click', closeCancel);
        document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeCancel(); });
    })();
    window.avunaShowNotice = function (title, message, success) {
        var modal = document.getElementById('avunaNoticeModal');
        document.getElementById('avunaNoticeHeading').textContent = title;
        document.getElementById('avunaNoticeMessage').textContent = message;
        modal.classList.add('open'); modal.setAttribute('aria-hidden', 'false');
        document.getElementById('avunaNoticeOkay').focus();
    };
    document.getElementById('avunaNoticeOkay').addEventListener('click', function () {
        var modal = document.getElementById('avunaNoticeModal');
        modal.classList.remove('open'); modal.setAttribute('aria-hidden', 'true');
    });
</script>

<!-- RATE ORDER: the ASP.NET button saves the rating into dbo.Rating -->
<input type="hidden" id="avunaRateOrderId" name="avunaRateOrderId" value="" />
<div id="avunaRateModal" class="avuna-cancel-overlay" role="dialog" aria-modal="true" aria-labelledby="avunaRateHeading" aria-hidden="true">
  <div class="avuna-cancel-dialog">
    <h2 id="avunaRateHeading">Rate your order</h2>
    <p id="avunaRateMessage"></p>
    <div class="avuna-stars" role="radiogroup" aria-label="Star rating">
      <input type="radio" id="avStar5" name="avunaRatingScore" value="5" /><label for="avStar5" title="5 - Excellent">&#9733;</label>
      <input type="radio" id="avStar4" name="avunaRatingScore" value="4" /><label for="avStar4" title="4 - Good">&#9733;</label>
      <input type="radio" id="avStar3" name="avunaRatingScore" value="3" /><label for="avStar3" title="3 - Average">&#9733;</label>
      <input type="radio" id="avStar2" name="avunaRatingScore" value="2" /><label for="avStar2" title="2 - Poor">&#9733;</label>
      <input type="radio" id="avStar1" name="avunaRatingScore" value="1" /><label for="avStar1" title="1 - Terrible">&#9733;</label>
    </div>
    <textarea id="avunaRatingReview" name="avunaRatingReview" class="avuna-rate-text" rows="3" maxlength="50"
        placeholder="Tell us about your order (max 50 characters)"></textarea>
    <div class="avuna-rate-count"><span id="avunaRateCount">0</span>/50</div>
    <div id="avunaRateError" class="avuna-rate-error" role="alert"></div>
    <div class="avuna-cancel-actions">
      <button type="button" id="avunaRateCancel" class="avuna-cancel-keep">Cancel</button>
      <asp:Button ID="btnSubmitRating" runat="server" Text="Submit Rating"
          CssClass="avuna-rate-submit" CausesValidation="false"
          OnClientClick="return avunaCheckRating();"
          OnClick="btnSubmitRating_Click" />
    </div>
  </div>
</div>
<script>
    (function () {
        var modal = document.getElementById('avunaRateModal');
        var hidden = document.getElementById('avunaRateOrderId');
        var review = document.getElementById('avunaRatingReview');
        var count = document.getElementById('avunaRateCount');
        var error = document.getElementById('avunaRateError');

        function closeRate() { modal.classList.remove('open'); modal.setAttribute('aria-hidden', 'true'); hidden.value = ''; }
        function selectedScore() {
            var checked = modal.querySelector('input[name="avunaRatingScore"]:checked');
            return checked ? checked.value : '';
        }

        document.addEventListener('click', function (e) {
            var button = e.target.closest ? e.target.closest('.rate-order-btn') : null;
            if (button) {
                hidden.value = button.getAttribute('data-order');
                document.getElementById('avunaRateMessage').textContent = 'How was order ' + hidden.value + '?';
                var radios = modal.querySelectorAll('input[name="avunaRatingScore"]');
                for (var i = 0; i < radios.length; i++) radios[i].checked = false;
                review.value = '';
                count.textContent = '0';
                error.style.display = 'none';
                modal.classList.add('open'); modal.setAttribute('aria-hidden', 'false');
                return;
            }
            if (e.target === modal || e.target.id === 'avunaRateCancel') closeRate();
        });
        document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeRate(); });
        review.addEventListener('input', function () { count.textContent = review.value.length; });

        // Runs before the postback; returning false stops the submit.
        window.avunaCheckRating = function () {
            var message = '';
            if (!selectedScore()) message = 'Please choose a star rating.';
            else if (!review.value.replace(/\s+/g, '')) message = 'Please write a short comment.';
            if (message) { error.textContent = message; error.style.display = 'block'; return false; }
            return true;
        };
    })();
</script>

</asp:Content>
