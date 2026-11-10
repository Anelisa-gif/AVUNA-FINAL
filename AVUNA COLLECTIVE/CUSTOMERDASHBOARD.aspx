
<%@ Page Title="CUSTOMERDASHBOARD" Language="C#"  MasterPageFile="~/Customer_master.Master" AutoEventWireup="true" CodeBehind="CUSTOMERDASHBOARD.aspx.cs" Inherits="AVUNA_COLLECTIVE.CUSTOMERDASHBOARD" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* =========================================================
AVUNA CUSTOMER DASHBOARD — shared page shell
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
.customer-eyebrow {
display: inline-block;
color: #f47b20;
font-size: 12px;
font-weight: 800;

letter-spacing: 2px;
margin-bottom: 14px;
}
.customer-hero h1 { font-size: clamp(38px, 5vw, 64px); line-height: 1; margin: 0 0 20px; font-weight: 800; letter-spacing: -2px; }
.customer-hero p { color: #d4d4d4; font-size: 17px; line-height: 1.7; max-width: 650px; margin-bottom: 30px; }
.customer-hero-actions { display: flex; gap: 14px; flex-wrap: wrap; }
.customer-btn {
display: inline-flex; align-items: center; justify-content: center;
padding: 13px 22px; border-radius: 10px;
text-decoration: none !important; font-weight: 700; transition: all .25s ease;
}
.customer-btn-orange { background: var(--avuna-orange); color: white !important; box-shadow: 0 8px 20px rgba(244,123,32,.25); }
.customer-btn-orange:hover { background: #ff8b32; transform: translateY(-3px); box-shadow: 0 12px 28px rgba(244,123,32,.35); }
.customer-btn-light { border: 1px solid rgba(255,255,255,.35); color: white !important; background: rgba(255,255,255,.06); }
.customer-btn-light:hover { background: white; color: #111 !important; transform: translateY(-3px); }
.customer-outline { border: 1px solid #d8d4cd; color: #222 !important; background: white; }
.customer-outline:hover { border-color: var(--avuna-orange); color: var(--avuna-orange) !important; transform: translateY(-2px); }
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
.customer-welcome {
background: white; border: 1px solid var(--avuna-border); border-radius: 16px;
padding: 20px 25px; display: flex; align-items: center; justify-content: space-between;
box-shadow: var(--avuna-shadow); margin-bottom: 24px;
}
.customer-welcome strong { display: block; font-size: 18px; margin-bottom: 4px; }
.customer-welcome span { color: var(--avuna-grey); font-size: 14px; }
.customer-demo { background: #fff4e9; color: var(--avuna-orange); padding: 8px 13px; border-radius: 20px; font-size: 11px; font-weight: 800; letter-spacing: 1px; }
/* STATISTICS */
.customer-stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 24px; }
.customer-stat {
position: relative; overflow: hidden;
background: white; border-radius: 17px; border: 1px solid var(--avuna-border);
padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,.05); transition: all .25s ease;
}

.customer-stat:hover { transform: translateY(-6px); box-shadow: 0 15px 35px rgba(0,0,0,.10); }
.customer-stat:after {
content: ""; position: absolute; width: 90px; height: 90px; border-radius: 50%;
right: -35px; bottom: -35px; background: rgba(244,123,32,.05);
}
.customer-stat-icon { width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 18px; font-size: 20px; font-weight: 800; }
.stat-green .customer-stat-icon { background: #e6f5ed; color: var(--avuna-green); }
.stat-orange .customer-stat-icon { background: #fff0e4; color: var(--avuna-orange); }
.stat-gold .customer-stat-icon { background: #fff7dc; color: #a67a15; }
.stat-dark .customer-stat-icon { background: #eeeeee; color: #222; }
.customer-stat small { display: block; color: #858585; font-size: 10px; letter-spacing: 1.5px; font-weight: 800; margin-bottom: 5px; }
.customer-stat strong { display: block; font-size: 30px; color: #181818; margin-bottom: 4px; }
.customer-stat span { color: #777; font-size: 12px; }
/* MAIN GRID */
.customer-main-grid { display: grid; grid-template-columns: 1.7fr 1fr; gap: 22px; margin-bottom: 24px; }
.customer-card { background: white; border: 1px solid var(--avuna-border); border-radius: 18px; padding: 28px; box-shadow: 0 6px 25px rgba(0,0,0,.05); }
.customer-card-heading { display: flex; justify-content: space-between; align-items: flex-start; gap: 15px; margin-bottom: 25px; }
.customer-card-heading h2 { margin: 5px 0 7px; font-size: 24px; color: #181818; }
.customer-card-heading p { color: #777; margin: 0; font-size: 13px; }
.customer-dark-eyebrow { color: var(--avuna-orange); font-size: 10px; letter-spacing: 1.7px; font-weight: 800; }
.view-link { color: var(--avuna-orange) !important; font-weight: 800; font-size: 13px; text-decoration: none !important; }
/* LOYALTY */
.loyalty-tier { background: #fff3d7; color: #9c7213; border-radius: 30px; padding: 8px 15px; font-size: 11px; font-weight: 900; letter-spacing: 1px; }
.loyalty-number { display: flex; align-items: baseline; gap: 10px; margin-bottom: 18px; }
.loyalty-number strong { font-size: 48px; line-height: 1; }
.loyalty-number span { color: #777; font-size: 14px; }
.loyalty-progress { height: 12px; background: #eeeeee; border-radius: 20px; overflow: hidden; }
.loyalty-progress span { display: block; height: 100%; width: 80%; border-radius: 20px; background: linear-gradient(90deg, #d99a27, #f4c75b); }
.loyalty-meta { display: flex; justify-content: space-between; margin-top: 10px; font-size: 12px; }
.loyalty-meta strong { color: var(--avuna-orange); }
.tier-track { display: grid; grid-template-columns: repeat(4,1fr); gap: 8px; margin-top: 25px; }
.tier-track span { padding: 12px 5px; border-radius: 10px; background: #f5f5f5; text-align: center; font-size: 11px; color: #777; }
.tier-track .done { background: #f2ead7; color: #8d6b20; }
.tier-track .current { background: #111; color: white; box-shadow: 0 5px 15px rgba(0,0,0,.15); }
.tier-track b { font-size: 10px; opacity: .7; }
/* PROFILE MINI (summary card) */
.profile-row { display: flex; align-items: center; gap: 14px; margin-bottom: 20px; }
.customer-avatar { width: 55px; height: 55px; border-radius: 50%; background: linear-gradient(135deg, #111, #f47b20); color: white; display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 17px; }
.profile-row strong { display: block; font-size: 16px; }
.profile-row span { display: block; color: #777; font-size: 12px; margin-top: 4px; }
.profile-details { border-top: 1px solid #eee; }
.profile-detail { display: flex; justify-content: space-between; gap: 10px; padding: 13px 0; border-bottom: 1px solid #eee; font-size: 12px; }
.profile-detail span { color: #888; }
.profile-detail strong { text-align: right; }
.orange-text { color: var(--avuna-orange); }
.full-btn { width: 100%; margin-top: 20px; }
/* ACTION CARDS */

.action-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; margin-bottom: 24px; }
.action-card { position: relative; overflow: hidden; transition: all .25s ease; }
.action-card:hover { transform: translateY(-6px); box-shadow: 0 18px 35px rgba(0,0,0,.10); }
.action-card:after { content: ""; position: absolute; width: 130px; height: 130px; border-radius: 50%; right: -60px; top: -60px; background: rgba(244,123,32,.06); }
.action-icon { width: 52px; height: 52px; border-radius: 14px; background: #fff0e4; color: var(--avuna-orange); display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: 900; margin-bottom: 20px; }
.action-card h3 { margin: 7px 0; font-size: 20px; }
.action-card p { color: #777; font-size: 13px; line-height: 1.6; min-height: 60px; }
/* RESPONSIVE */
@media(max-width: 1000px) {
.customer-stat-grid { grid-template-columns: repeat(2,1fr); }
.customer-main-grid { grid-template-columns: 1fr; }
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
.tier-track { grid-template-columns: repeat(2,1fr); }
}

.action-cards {
  display: flex;
  gap: 24px;          /* space between the two cards */
  margin-top: 24px;   /* space between these and the loyalty card above */
}

.action-cards .action-card {
  flex: 1;            /* both cards share the width equally */
}

@media (max-width: 768px) {
  .action-cards {
    flex-direction: column;
  }
}

</style>
<div class="customer-dashboard">
<!-- ===================================================== HERO ===================================================== -->
<section class="customer-hero">
<div class="customer-hero-copy">
<span class="customer-eyebrow">AVUNA COLLECTIVE · CUSTOMER PORTAL</span>
<h1 style="color: white;">Welcome back</h1>
<p>Your AVUNA space for orders, payments, designs and account information all in one place.</p>
<div class="customer-hero-actions">
<a href="~/CreateOrder.aspx" runat="server" class="customer-btn customer-btn-orange">Create a New Order</a>
<a href="MyOrders.aspx" class="customer-btn customer-btn-light">View My Orders</a>
</div>
</div>
<div class="customer-hero-badge">
<strong>AV</strong>
<span>Customer<br />Portal</span>
</div>
</section>
<!-- ===================================================== DASHBOARD BODY ===================================================== -->
<main class="customer-body">
<!-- WELCOME -->
<div class="customer-welcome">
<div>
<strong>Your account at a glance</strong>

<span>Here is what is happening with your AVUNA orders.</span>
</div>
<span class="customer-demo">DATA</span>
</div>
<!-- STATISTICS -->
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
<span>Outstanding Balance</span>
</article>
<article class="customer-stat stat-dark">
<div class="customer-stat-icon">★</div>
<small>LOYALTY TIER</small>
<strong>GOLD</strong>
<span>8 purchases · 2 to Platinum</span>
</article>
</section>
<!-- LOYALTY + PROFILE -->
<div class="customer-main-grid">
<!-- LOYALTY -->
<section class="customer-card">
<div class="customer-card-heading">
<div>
<span class="customer-dark-eyebrow">REWARDS</span>
<h2>Your Loyalty Journey</h2>
<p>Keep shopping with AVUNA to unlock your next tier.</p>
</div>
<span class="loyalty-tier">GOLD</span>
</div>
<div class="loyalty-number">
<strong>8</strong>
<span>purchases</span>
</div>

<div class="loyalty-progress"><span></span></div>
<div class="loyalty-meta">
<span>Gold</span>
<strong>2 more purchases → Platinum</strong>
</div>
<div class="tier-track">
<span class="done">Bronze<br /><b>0-2</b></span>
<span class="done">Silver<br /><b>3-5</b></span>
<span class="current">Gold<br /><b>6-9</b></span>
<span>Platinum<br /><b>10+</b></span>
</div>
</section>
<!-- PROFILE SUMMARY -->
<section class="customer-card">
<div class="customer-card-heading">
<div>
<span class="customer-dark-eyebrow">ACCOUNT</span>
<h2>My Profile</h2>
</div>
<a href="MyProfile.aspx" class="view-link">View details →</a>
</div>
<div class="profile-row">
<span class="customer-avatar">TM</span>
<div>
<strong>Thando Mthembu</strong>
<span>Individual Customer</span>
</div>
</div>
<div class="profile-details">
<div class="profile-detail">
<span>Email</span>
<strong>thando@example.com</strong>
</div>
<div class="profile-detail">
<span>Cell</span>
<strong>071 234 5678</strong>
</div>
<div class="profile-detail">
<span>Loyalty</span>
<strong class="orange-text">Gold Member</strong>
</div>
</div>

    <a href="~/Profile.aspx" runat="server" class="customer-btn customer-outline full-btn">Manage Profile</a>
</section>
</div>
<!-- ACTION CARDS -->

    <div class="action-cards">

<!-- DESIGN -->
<section class="customer-card action-card">
<div class="action-icon">✦</div>
<span class="customer-dark-eyebrow">WANT TO CREATE A NEW ORDER?</span>
<h3>Create a New Order</h3>
<p>Have a new concept? Send us your design, product and requirements.</p>
<a href="~/CreateOrder.aspx" runat="server" class="customer-btn customer-btn-orange">Create a New Order</a>
</section>

<!-- PAYMENTS -->
<section class="customer-card action-card">
<div class="action-icon">R</div>
<span class="customer-dark-eyebrow">PAYMENTS</span>
<h3>Payment History</h3>
<p>View your previous payments, balances, methods and payment status.</p>
<a href="~/MyOrders.aspx" runat="server" class="customer-btn customer-outline">View Payments</a>
</section>

</div>
</main>
</div>
</asp:Content>