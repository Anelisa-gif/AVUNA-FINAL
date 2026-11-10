
<%@ Page Title="" Language="C#"  MasterPageFile="~/Customer_master.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="AVUNA_COLLECTIVE.CUSTOMERDASHBOARD" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* =========================================================
   AVUNA MY ORDERS — shared page shell (same as Dashboard)
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
/* STATISTICS (reused for order-focused stats) */
.customer-stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 24px; }
.customer-stat { position: relative; overflow: hidden; background: white; border-radius: 17px; border: 1px solid var(--avuna-border); padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,.05); transition: all .25s ease; }
.customer-stat:hover { transform: translateY(-6px); box-shadow: 0 15px 35px rgba(0,0,0,.10); }
.customer-stat:after { content: ""; position: absolute; width: 90px; height: 90px; border-radius: 50%; right: -35px; bottom: -35px; background: rgba(244,123,32,.05); }
.customer-stat-icon { width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 18px; font-size: 20px; font-weight: 800; }
.stat-green .customer-stat-icon { background: #e6f5ed; color: var(--avuna-green); }
.stat-orange .customer-stat-icon { background: #fff0e4; color: var(--avuna-orange); }
.stat-gold .customer-stat-icon { background: #fff7dc; color: #a67a15; }
.stat-dark .customer-stat-icon { background: #eeeeee; color: #222; }
.customer-stat small { display: block; color: #858585; font-size: 10px; letter-spacing: 1.5px; font-weight: 800; margin-bottom: 5px; }
.customer-stat strong { display: block; font-size: 30px; color: #181818; margin-bottom: 4px; }
.customer-stat span { color: #777; font-size: 12px; }
/* CARD + ORDERS TABLE */
.customer-card { background: white; border: 1px solid var(--avuna-border); border-radius: 18px; padding: 28px; box-shadow: 0 6px 25px rgba(0,0,0,.05); margin-bottom: 24px; }
.customer-card-heading { display: flex; justify-content: space-between; align-items: flex-start; gap: 15px; margin-bottom: 25px; }
.customer-card-heading h2 { margin: 5px 0 7px; font-size: 24px; color: #181818; }
.customer-card-heading p { color: #777; margin: 0; font-size: 13px; }
.customer-dark-eyebrow { color: var(--avuna-orange); font-size: 10px; letter-spacing: 1.7px; font-weight: 800; }
.view-link { color: var(--avuna-orange) !important; font-weight: 800; font-size: 13px; text-decoration: none !important; }
.orders-table { width: 100%; border-collapse: collapse; }
.orders-table th { background: #f7f5f1; color: #666; padding: 14px; text-align: left; font-size: 10px; letter-spacing: 1px; }
.orders-table td { padding: 16px 14px; border-bottom: 1px solid #eeeeee; font-size: 13px; }
.orders-table tr:hover td { background: #fffaf5; }
.status { display: inline-block; padding: 6px 10px; border-radius: 20px; font-size: 10px; font-weight: 800; }
.status-processing { background: #fff0df; color: #c46715; }
.status-completed { background: #e4f5ec; color: #287a52; }
.status-pending { background: #fff4d7; color: #9a7416; }

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
</style>
<div class="customer-dashboard">
  <!-- ===================================================== HERO ===================================================== -->
  <section class="customer-hero">
    <div class="customer-hero-copy">
      <span class="customer-eyebrow">AVUNA COLLECTIVE · CUSTOMER PORTAL</span>
      <h1 style="color: white;">Your orders, tracked end to end.</h1>
      <p>Check the status, progress and value of everything you've ordered from AVUNA.</p>
      <div class="customer-hero-actions">
        <a href="~/CreateOrder.aspx" runat="server" class="customer-btn customer-btn-orange">Create a New Order</a>
        <a href="CustomerDashboard.aspx" class="customer-btn customer-btn-light">Back to Dashboard</a>
      </div>
    </div>
    <div class="customer-hero-badge">
      <strong>AV</strong>
      <span>Customer<br />Portal</span>
    </div>
  </section>
  <!-- ===================================================== ORDERS BODY ===================================================== -->
  <main class="customer-body">
    <!-- WELCOME -->
    <div class="customer-welcome">
      <div>
        <strong>Your order history</strong>
        <span>Here is the current state of everything you've ordered.</span>
      </div>
      <span class="customer-demo">DATA</span>
    </div>
    <!-- ORDER STATISTICS -->
    <section class="customer-stat-grid">
      <article class="customer-stat stat-green">
        <div class="customer-stat-icon">↗</div>
        <small>ACTIVE ORDERS</small>
        <strong>3</strong>
        <span>Currently in progress</span>
      </article>
      <article class="customer-stat stat-orange">
        <div class="customer-stat-icon">✓</div>
        <small>COMPLETED</small>
        <strong>12</strong>
        <span>Successfully delivered</span>
      </article>
      <article class="customer-stat stat-gold">
        <div class="customer-stat-icon">R</div>
        <small>OUTSTANDING</small>
        <strong>R2,450</strong>
        <span>Outstanding balance</span>
      </article>
      <article class="customer-stat stat-dark">
        <div class="customer-stat-icon">#</div>
        <small>TOTAL ORDERS</small>
        <strong>15</strong>
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
        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="orders-table" GridLines="None">
          <Columns>
            <asp:BoundField DataField="OrderNumber" HeaderText="Order No." />
            <asp:BoundField DataField="Product" HeaderText="Product" />
            <asp:BoundField DataField="Quantity" HeaderText="Qty" />
            <asp:TemplateField HeaderText="Status">
              <ItemTemplate>
                <span class="status status-processing"><%# Eval("Status") %></span>
              </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Total" HeaderText="Total" />
            <asp:BoundField DataField="Date" HeaderText="Purchase Date" />
          </Columns>
        </asp:GridView>
      </div>
    </section>
   
  </main>
</div>
</asp:Content>
