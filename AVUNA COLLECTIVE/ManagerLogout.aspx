<%@ Page Title="Logged out" Language="C#" MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="ManagerLogOut.aspx.cs" Inherits="AVUNA_COLLECTIVE.ManagerLogOut" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
.logout-page {
    width: 100%;
    min-height: 100vh;
    background: linear-gradient(135deg, #f5efe6 0%, #f3ece0 60%, #e5dccd 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
    box-sizing: border-box;
}
.logout-card {
    background: #fbf8f2;
    border-radius: 20px;
    padding: 50px 40px;
    max-width: 420px;
    width: 100%;
    text-align: center;
    box-shadow: 0 20px 50px rgba(42,33,24,.14); border: 1px solid #e5dccd;
}
.logout-badge {
    width: 70px; height: 70px; border-radius: 50%;
    background: #f2e2c9; color: #8a6a35;
    display: flex; align-items: center; justify-content: center;
    font-size: 30px; font-weight: 900; margin: 0 auto 22px;
}
.logout-card h1 { font-size: 24px; margin: 0 0 12px; color: #181818; }
.logout-card p { color: #777; font-size: 14px; line-height: 1.6; margin-bottom: 28px; }
.customer-btn {
    display: inline-flex; align-items: center; justify-content: center;
    padding: 13px 26px; border-radius: 10px;
    text-decoration: none !important; font-weight: 700;
    background: #0f2a1f; color: white !important;
    box-shadow: 0 8px 20px rgba(196,154,69,.25);
    transition: all .25s ease;
}
.customer-btn:hover { background: #173c2c; transform: translateY(-3px); }

/* faint photo background: the first photo shows instantly, the others fade over it */
.logout-page { position: relative; overflow: hidden; }
.logout-bg { position: absolute; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; background: #efe7d9; }
.logout-bg img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; display: block; }
.logout-bg .bg-b, .logout-bg .bg-c { opacity: 0; animation: logoutFade 16s infinite; }
.logout-bg .bg-b { animation-delay: 4s; }
.logout-bg .bg-c { animation-delay: 12s; }
@keyframes logoutFade {
    0% { opacity: 0; transform: scale(1); }
    12% { opacity: 1; }
    40% { opacity: 1; }
    52% { opacity: 0; transform: scale(1.08); }
    100% { opacity: 0; transform: scale(1.08); }
}
.logout-bg:after { content: ""; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(243,236,224,.46); }
.logout-card { position: relative; z-index: 1; }
@media (prefers-reduced-motion: reduce) { .logout-bg .bg-b, .logout-bg .bg-c { animation: none; } }
</style>

<div class="logout-page">
<div class="logout-bg" aria-hidden="true">
<img runat="server" class="bg-a" src="~/images/GG-0653_PinksInks_29_lg.jpg" alt="" />
<img runat="server" class="bg-b" src="~/images/customer-hero.jpg" alt="" />
<img runat="server" class="bg-c" src="~/images/tshirt.jpg" alt="" />
</div>
    <div class="logout-card">
        <img runat="server" src="~/avuna-logo.png" alt="Avuna Collective" style="width:150px;height:150px;object-fit:contain;display:block;margin:0 auto 14px;border-radius:50%" />
        <h1>You've been logged out</h1>
        <p>Thanks for managing Avuna Collective. Log back in anytime to review orders, staff and reports.</p>
        <a href="Default.aspx" class="customer-btn">Back to Homepage</a>
    </div>
</div>

</asp:Content>
