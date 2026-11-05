<%@ Page Title="" Language="C#"  MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="ManageStaff.aspx.cs" Inherits="AVUNA_COLLECTIVE.MANAGERDASHBOARD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  <style>
/* =========================================================
AVUNA STAFF PAGE — shared page shell (same as Dashboard)
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
.avuna-business-status {
background: #e8f4ec;
color: #267347;
border-radius: 50px;
padding: 8px 14px;
font-size: 10px;
font-weight: bold;
}
/* STATISTICS (reused for staff headcount stats) */
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
/* CARD (used to hold the staff table) */
.avuna-card { background: white; border: 1px solid #e1e7e3; border-radius: 22px; box-shadow: 0 12px 35px rgba(17,51,52,.10); overflow: hidden; margin-bottom: 25px; }
.avuna-card-header { padding: 25px 28px; border-bottom: 1px solid #e6ebe8; display: flex; justify-content: space-between; align-items: center; }
.avuna-card-header h2 { color: #113334; font-size: 22px; margin: 5px 0; }
.avuna-card-header p { color: #78827f; font-size: 12px; margin: 0; }
.avuna-view-all { color: #d9711f; font-size: 12px; font-weight: bold; text-decoration: none; }
/* STAFF TABLE (same structure/classes as the Orders table) */
.avuna-table-wrap { overflow-x: auto; }
.avuna-table { width: 100%; border-collapse: collapse; }
.avuna-table th { background: #f7f9f7; color: #737d79; padding: 14px 20px; text-align: left; font-size: 9px; letter-spacing: 1px; }
.avuna-table td { padding: 17px 20px; border-top: 1px solid #edf0ed; font-size: 12px; }
.avuna-table tbody tr:hover { background: #fafcfb; }
.avuna-order-number { color: #113334; font-weight: bold; }

/* STAFF STATUS PILLS (same visual language as order status pills) */
.avuna-status { display: inline-block; padding: 6px 10px; border-radius: 50px; font-size: 9px; font-weight: bold; }
.avuna-completed { background: #e7f4eb; color: #277446; } /* used here for "Active" */
.avuna-production { background: #fff0e5; color: #bb5c17; } /* used here for "On Shift" */
.avuna-pending { background: #fff5d8; color: #927017; } /* used here for "On Leave" */
/* RESPONSIVE */
@media(max-width:1100px) {
.avuna-stat-grid { grid-template-columns: repeat(2,1fr); }
}
@media(max-width:700px) {
.avuna-manager-hero { padding: 45px 25px; }
.avuna-manager-copy h1 { font-size: 42px; }
.avuna-manager-badge { display: none; }
.avuna-manager-body { width: 94%; margin-top: -25px; }
.avuna-stat-grid { grid-template-columns: 1fr; }
.avuna-welcome { flex-direction: column; align-items: flex-start; gap: 12px; }
.avuna-card-header { flex-direction: column; align-items: flex-start; gap: 12px; }
}
</style>
<div class="avuna-manager-page">
<!-- ===================================================== HERO ===================================================== -->
<section class="avuna-manager-hero">
<div class="avuna-manager-copy">
<span class="avuna-eyebrow">AVUNA COLLECTIVE MANAGEMENT PORTAL</span>
<h1 style="color: white;">Your team at a glance.</h1>
<p>Monitor your embroidery and production staff, shifts and workloads from one place.</p>
<div class="avuna-hero-buttons">
<a href="AddStaff.aspx" class="avuna-button avuna-button-orange">+ Add Staff Member</a>
<a href="Orders.aspx" class="avuna-button avuna-button-outline">View Orders</a>
</div>
</div>
<div class="avuna-manager-badge">
<div class="avuna-manager-badge-inner">
<strong>AVUNA</strong>
<span>MANAGER</span>
</div>
</div>
</section>
<!-- ===================================================== STAFF BODY ===================================================== -->
<main class="avuna-manager-body">
<!-- WELCOME -->
<div class="avuna-welcome">
<div>
<strong>Good Afternoon, Nkosingiphile Shangase.</strong>
<span>Here is an overview of your embroidery and production team.</span>
</div>
<div class="avuna-business-status">&#9679; Staff Data</div>
</div>
<!-- STAFF STATISTICS -->
<section class="avuna-stat-grid">
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-green-icon">&#9673;</div>
<span class="avuna-stat-label">TOTAL STAFF</span>
</div>
<h2>12</h2>
<span class="avuna-stat-description">Employed staff members</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-orange-icon">&#10003;</div>
<span class="avuna-stat-label">ON DUTY TODAY</span>
</div>
<h2>9</h2>
<span class="avuna-stat-description">Currently on shift</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-gold-icon">!</div>
<span class="avuna-stat-label">ON LEAVE</span>
</div>
<h2>2</h2>
<span class="avuna-stat-description">Away this week</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-red-icon">#</div>
<span class="avuna-stat-label">ORDERS IN PRODUCTION</span>
</div>
<h2>7</h2>
<span class="avuna-stat-description">Assigned to staff now</span>
</article>
</section>
<!-- STAFF LIST -->
<section class="avuna-card">
<div class="avuna-card-header">
<div>
<span class="avuna-eyebrow">TEAM DIRECTORY</span>
<h2>Staff Members</h2>
<p>A quick view of everyone currently working at AVUNA COLLECTIVE.</p>
</div>
<a href="Staff.aspx" class="avuna-view-all">View all staff &rarr;</a>
</div>
<div class="avuna-table-wrap">
<table class="avuna-table">
<thead>
<tr>
<th>STAFF NO.</th>
<th>NAME</th>
<th>ROLE</th>
<th>SHIFT</th>
<th>STATUS</th>

Orders.aspx

<th>ORDERS ASSIGNED</th>
</tr>
</thead>
<tbody>
<tr>
<td class="avuna-order-number">AVU-S001</td>
<td>Zanele Khumalo</td>
<td>Embroidery Operator</td>
<td>Day Shift</td>
<td><span class="avuna-status avuna-completed">Active</span></td>
<td>3</td>
</tr>
<tr>
<td class="avuna-order-number">AVU-S002</td>
<td>Sipho Ndlovu</td>
<td>Machine Technician</td>
<td>Day Shift</td>
<td><span class="avuna-status avuna-production">On Shift</span></td>
<td>2</td>
</tr>
<tr>
<td class="avuna-order-number">AVU-S003</td>
<td>Ayanda Zulu</td>
<td>Quality Control</td>
<td>Day Shift</td>
<td><span class="avuna-status avuna-completed">Active</span></td>
<td>4</td>
</tr>
<tr>
<td class="avuna-order-number">AVU-S004</td>
<td>Mandla Cele</td>
<td>Packaging &amp; Dispatch</td>
<td>Afternoon Shift</td>
<td><span class="avuna-status avuna-pending">On Leave</span></td>
<td>0</td>
</tr>
<tr>
<td class="avuna-order-number">AVU-S005</td>
<td>Nomvula Dube</td>
<td>Production Supervisor</td>
<td>Day Shift</td>
<td><span class="avuna-status avuna-completed">Active</span></td>
<td>5</td>
</tr>
</tbody>
</table>
</div>
</section>
</main>
</div>

</asp:Content>