<%@ Page Title="Logged out" Language="C#" MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="ManagerLogOut.aspx.cs" Inherits="AVUNA_COLLECTIVE.ManagerLogOut" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
.logout-page {
    width: 100%;
    min-height: 100vh;
    background: linear-gradient(135deg, #f7f3ec 0%, #f3ece0 60%, #ece4d6 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
    box-sizing: border-box;
}
.logout-card {
    background: white;
    border-radius: 20px;
    padding: 50px 40px;
    max-width: 420px;
    width: 100%;
    text-align: center;
    box-shadow: 0 20px 50px rgba(42,33,24,.14); border: 1px solid #ece4d6;
}
.logout-badge {
    width: 70px; height: 70px; border-radius: 50%;
    background: #fff0e4; color: #f47b20;
    display: flex; align-items: center; justify-content: center;
    font-size: 30px; font-weight: 900; margin: 0 auto 22px;
}
.logout-card h1 { font-size: 24px; margin: 0 0 12px; color: #181818; }
.logout-card p { color: #777; font-size: 14px; line-height: 1.6; margin-bottom: 28px; }
.customer-btn {
    display: inline-flex; align-items: center; justify-content: center;
    padding: 13px 26px; border-radius: 10px;
    text-decoration: none !important; font-weight: 700;
    background: #f47b20; color: white !important;
    box-shadow: 0 8px 20px rgba(244,123,32,.25);
    transition: all .25s ease;
}
.customer-btn:hover { background: #ff8b32; transform: translateY(-3px); }
</style>

<div class="logout-page">
    <div class="logout-card">
        <img runat="server" src="~/avuna-logo.png" alt="Avuna Collective" style="width:150px;height:150px;object-fit:contain;display:block;margin:0 auto 14px;border-radius:50%" />
        <h1>You've been logged out</h1>
        <p>Thanks for managing Avuna Collective. Log back in anytime to review orders, staff and reports.</p>
        <a href="Default.aspx" class="customer-btn">Back to Homepage</a>
    </div>
</div>

</asp:Content>