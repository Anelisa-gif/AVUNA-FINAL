<%@ Page Title="" Language="C#" MasterPageFile="~/Manager_master.Master" AutoEventWireup="true" CodeBehind="ManageStaff.aspx.cs" Inherits="AVUNA_COLLECTIVE.ManageStaff" %>

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
.avuna-archive-btn { background: #fff; border: 1px solid #d9711f; color: #d9711f; border-radius: 8px; padding: 6px 14px; font-size: 11px; font-weight: bold; cursor: pointer; font-family: inherit; transition: .2s; }
.avuna-archive-btn:hover { background: #d9711f; color: #fff; }
.avuna-actions { display: flex; gap: 8px; align-items: center; }
.avuna-edit-btn { background: #113334; border: 1px solid #113334; color: #fff; border-radius: 8px; padding: 6px 14px; font-size: 11px; font-weight: bold; cursor: pointer; font-family: inherit; transition: .2s; }
.avuna-edit-btn:hover { background: #1d5456; border-color: #1d5456; transform: translateY(-1px); }

/* ---------- EDIT POP-UP ---------- */
.avuna-modal-back { position: fixed; inset: 0; background: rgba(9,31,32,.62); backdrop-filter: blur(5px); -webkit-backdrop-filter: blur(5px);
    display: none; align-items: center; justify-content: center; padding: 20px; z-index: 5000; opacity: 0; transition: opacity .25s ease; }
.avuna-modal-back.avuna-open { display: flex; }
.avuna-modal-back.avuna-show { opacity: 1; }
.avuna-modal { width: 100%; max-width: 680px; max-height: 94vh; overflow: auto; background: #fff; border-radius: 26px; box-shadow: 0 35px 90px rgba(0,0,0,.40);
    transform: translateY(28px) scale(.97); transition: transform .3s cubic-bezier(.2,.8,.2,1); font-family: Arial, Helvetica, sans-serif; color: #243333; }
.avuna-modal-back.avuna-show .avuna-modal { transform: none; }
.avuna-modal, .avuna-modal * { box-sizing: border-box; }
.avuna-modal-head { position: relative; overflow: hidden; color: #fff; padding: 28px 32px; display: flex; align-items: center; gap: 18px;
    background: linear-gradient(120deg, #0d2b2c, #174243 70%, #1d5456); }
.avuna-modal-head:after { content: ""; position: absolute; right: -70px; top: -90px; width: 230px; height: 230px; border-radius: 50%; border: 36px solid rgba(217,165,44,.10); }
.avuna-modal-avatar { position: relative; z-index: 1; width: 62px; height: 62px; min-width: 62px; border-radius: 50%; background: #d9a52c; color: #113334;
    display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: bold; box-shadow: 0 8px 20px rgba(0,0,0,.25); }
.avuna-modal-title { position: relative; z-index: 1; min-width: 0; }
.avuna-modal-title small { display: block; color: #d9a52c; font-size: 10px; font-weight: bold; letter-spacing: 2px; margin-bottom: 5px; }
.avuna-modal-title h3 { margin: 0; color: #fff; font-size: 24px; line-height: 1.15; }
.avuna-modal-title span { display: inline-block; margin-top: 8px; background: rgba(255,255,255,.14); border-radius: 50px; padding: 4px 12px; font-size: 10px; font-weight: bold; letter-spacing: 1px; }
.avuna-modal-close { position: absolute; z-index: 2; right: 18px; top: 16px; width: 34px; height: 34px; border-radius: 50%; border: 0; cursor: pointer;
    background: rgba(255,255,255,.12); color: #fff; font-size: 20px; line-height: 1; transition: .2s; }
.avuna-modal-close:hover { background: #fff; color: #113334; }
.avuna-modal-body { padding: 28px 32px 8px; }
.avuna-modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px 20px; }
.avuna-field { display: flex; flex-direction: column; gap: 7px; }
.avuna-field-wide { grid-column: span 2; }
.avuna-field label { font-size: 10px; font-weight: bold; letter-spacing: 1px; color: #78827f; }
.avuna-field input, .avuna-field select { width: 100%; padding: 13px 15px; border: 1.5px solid #dfe6e2; border-radius: 12px; background: #f9fbfa; color: #113334;
    font-size: 14px; font-family: inherit; transition: .2s; outline: none; }
.avuna-field input:focus, .avuna-field select:focus { border-color: #d9711f; background: #fff; box-shadow: 0 0 0 4px rgba(217,113,31,.14); }
.avuna-field input[readonly], .avuna-field select:disabled { background: #eef2ef; color: #78827f; cursor: not-allowed; }
.avuna-field small { color: #8a948f; font-size: 11px; line-height: 1.5; }
.avuna-modal-error { background: #fdeaea; border: 1px solid #f0c4c4; color: #8a2f2f; border-radius: 12px; padding: 11px 15px; font-size: 13px; margin-bottom: 18px; line-height: 1.5; }
.avuna-modal-foot { display: flex; justify-content: flex-end; gap: 12px; padding: 22px 32px 28px; }
.avuna-modal-cancel { background: #fff; border: 1.5px solid #dfe6e2; color: #113334; border-radius: 12px; padding: 13px 24px; font-size: 13px; font-weight: bold; cursor: pointer; font-family: inherit; transition: .2s; }
.avuna-modal-cancel:hover { border-color: #113334; }
.avuna-modal-save { background: #d9711f; border: 0; color: #fff; border-radius: 12px; padding: 13px 30px; font-size: 13px; font-weight: bold; cursor: pointer; font-family: inherit;
    box-shadow: 0 10px 24px rgba(217,113,31,.32); transition: .2s; }
.avuna-modal-save:hover { background: #b85c18; transform: translateY(-2px); }
@media (max-width: 640px) {
    .avuna-modal-grid { grid-template-columns: 1fr; }
    .avuna-field-wide { grid-column: span 1; }
    .avuna-modal-head, .avuna-modal-body, .avuna-modal-foot { padding-left: 22px; padding-right: 22px; }
    .avuna-modal-foot { flex-direction: column-reverse; }
}
/* ---------- ADD STAFF POP-UP ---------- */
.avuna-type-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; padding: 28px 32px 10px; }
.avuna-type-card { text-align: left; background: #f9fbfa; border: 1.5px solid #dfe6e2; border-radius: 20px; padding: 24px 22px; cursor: pointer; font-family: inherit;
    transition: .25s ease; display: flex; flex-direction: column; gap: 10px; position: relative; overflow: hidden; }
.avuna-type-card:hover { border-color: #d9711f; background: #fff; transform: translateY(-5px); box-shadow: 0 18px 38px rgba(17,51,52,.14); }
.avuna-type-icon { width: 54px; height: 54px; border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; color: #fff; }
.avuna-type-admin .avuna-type-icon { background: #113334; }
.avuna-type-production .avuna-type-icon { background: #d9711f; }
.avuna-type-card strong { color: #113334; font-size: 17px; }
.avuna-type-card span { color: #78827f; font-size: 12px; line-height: 1.6; }
.avuna-type-card em { margin-top: 4px; color: #d9711f; font-size: 12px; font-style: normal; font-weight: bold; }
.avuna-idbox { display: flex; align-items: center; justify-content: space-between; gap: 14px; background: #fff8ed; border: 1px dashed #e9c58f; border-radius: 14px; padding: 12px 16px; margin-bottom: 18px; }
.avuna-idbox small { color: #8a5a17; font-size: 10px; font-weight: bold; letter-spacing: 1px; }
.avuna-idbox strong { color: #113334; font-size: 18px; letter-spacing: 1px; }
.avuna-pw-row { display: flex; gap: 10px; }
.avuna-pw-row input { flex: 1; min-width: 0; }
.avuna-gen-btn { background: #fff; border: 1.5px solid #dfe6e2; color: #113334; border-radius: 12px; padding: 0 16px; font-size: 12px; font-weight: bold; cursor: pointer; font-family: inherit; white-space: nowrap; transition: .2s; }
.avuna-gen-btn:hover { border-color: #d9711f; color: #d9711f; }
.avuna-modal-back-link { margin-right: auto; background: none; border: 0; color: #78827f; font-size: 13px; font-weight: bold; cursor: pointer; font-family: inherit; padding: 13px 4px; }
.avuna-modal-back-link:hover { color: #113334; }
@media (max-width: 640px) { .avuna-type-grid { grid-template-columns: 1fr; padding-left: 22px; padding-right: 22px; } .avuna-modal-back-link { margin-right: 0; text-align: center; } }
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
<a href="#" onclick="return openAddChooser();" class="avuna-button avuna-button-orange avuna-button-main">+ Add Staff Member</a>
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
<strong>Welcome back, <asp:Literal ID="litManagerName" runat="server" />.</strong>
<span>Here is an overview of your embroidery and production team.</span>
</div>
<div class="avuna-business-status">&#9679; Staff Data</div>
</div>
<!-- STAFF STATISTICS -->
    <asp:Literal ID="litDbNotice" runat="server" />
<asp:Literal ID="Literal1" runat="server" />
<asp:HiddenField ID="HiddenField1" runat="server" />
<asp:HiddenField ID="HiddenField2" runat="server" />
<asp:Button ID="Button1" runat="server" Text="Archive" OnClick="btnArchive_Click" style="display:none" />

<!-- EDIT STAFF POP-UP -->
<div id="edModal" class="avuna-modal-back" onclick="if (event.target === this) closeEdit();">
<div class="avuna-modal" role="dialog" aria-modal="true" aria-labelledby="edTitle">
<div class="avuna-modal-head">
<div class="avuna-modal-avatar" id="edAvatar">AV</div>
<div class="avuna-modal-title">
<small>EDIT STAFF MEMBER</small>
<h3 id="edTitle">Staff member</h3>
<span id="edMeta">STAFF NO.</span>
</div>
<button type="button" class="avuna-modal-close" onclick="closeEdit()" aria-label="Close">&times;</button>
</div>
<div class="avuna-modal-body">
<asp:Literal ID="litEditError" runat="server" />
<div id="edClientError" class="avuna-modal-error" style="display:none"></div>
<input type="hidden" name="edKind" id="edKind" />
<input type="hidden" name="edId" id="edId" />
<div class="avuna-modal-grid">
<div class="avuna-field"><label for="edFirst">FIRST NAME</label><input type="text" name="edFirst" id="edFirst" maxlength="50" autocomplete="off" /></div>
<div class="avuna-field"><label for="edLast">LAST NAME</label><input type="text" name="edLast" id="edLast" maxlength="50" autocomplete="off" /></div>
<div class="avuna-field"><label for="edPhone">PHONE NUMBER</label><input type="text" name="edPhone" id="edPhone" maxlength="20" autocomplete="off" /></div>
<div class="avuna-field"><label for="edEmail">EMAIL ADDRESS</label><input type="text" name="edEmail" id="edEmail" maxlength="50" autocomplete="off" /></div>
<div class="avuna-field ed-admin"><label for="edRole">ROLE</label>
<select name="edRole" id="edRole"><asp:Literal ID="litRoleOptions" runat="server" /></select>
<small id="edRoleNote" style="display:none">You cannot change your own role.</small></div>
<div class="avuna-field ed-admin"><label for="edUsername">USERNAME (LOGIN)</label><input type="text" name="edUsername" id="edUsername" maxlength="100" autocomplete="off" /></div>
<div class="avuna-field avuna-field-wide"><label for="edPassword">NEW PASSWORD (OPTIONAL)</label>
<input type="text" name="edPassword" id="edPassword" maxlength="50" autocomplete="off" placeholder="Leave blank to keep the current password" />
<small>Only fill this in if you want to change the password.</small></div>
</div>
</div>
<div class="avuna-modal-foot">
<button type="button" class="avuna-modal-cancel" onclick="closeEdit()">Cancel</button>
<asp:Button ID="btnSave" runat="server" Text="Save changes" CssClass="avuna-modal-save" OnClick="btnSave_Click" OnClientClick="return validateEdit();" />
</div>
</div>
</div>

<script>
    function archiveStaff(btn) {
        var name = btn.getAttribute('data-name') || btn.getAttribute('data-id');
        if (!confirm('Archive ' + name + '?\n\nThey will be moved out of the active staff list into the archive.')) return;
        document.getElementById('<%= hfKind.ClientID %>').value = btn.getAttribute('data-kind');
    document.getElementById('<%= hfId.ClientID %>').value = btn.getAttribute('data-id');
    document.getElementById('<%= btnArchive.ClientID %>').click();
}

function $ed(id) { return document.getElementById(id); }

function openEdit(d) {
    $ed('edKind').value = d.kind;
    $ed('edId').value = d.id;
    $ed('edFirst').value = d.first || '';
    $ed('edLast').value = d.last || '';
    $ed('edPhone').value = d.phone || '';
    $ed('edEmail').value = d.email || '';
    $ed('edUsername').value = d.username || '';
    $ed('edPassword').value = '';

    var isAdmin = d.kind === 'admin';
    var fields = document.querySelectorAll('.ed-admin');
    for (var i = 0; i < fields.length; i++) fields[i].style.display = isAdmin ? '' : 'none';

    var role = $ed('edRole');
    if (isAdmin) {
        var found = false;
        for (var j = 0; j < role.options.length; j++) { if (role.options[j].value.toLowerCase() === (d.role || '').toLowerCase()) { role.selectedIndex = j; found = true; } }
        if (!found && d.role) { role.add(new Option(d.role, d.role)); role.value = d.role; }
    }
    role.disabled = !!d.self;                                   // you cannot change your own role
    $ed('edRoleNote').style.display = d.self ? 'block' : 'none';

    var name = ((d.first || '') + ' ' + (d.last || '')).trim();
    $ed('edTitle').textContent = name || 'Staff member';
    $ed('edMeta').textContent = (isAdmin ? 'ADMIN STAFF' : 'PRODUCTION STAFF') + '  \u00B7  ' + d.id;
    $ed('edAvatar').textContent = (((d.first || '').charAt(0)) + ((d.last || '').charAt(0))).toUpperCase() || 'AV';
    $ed('edClientError').style.display = 'none';

    var m = $ed('edModal');
    m.classList.add('avuna-open');
    document.body.style.overflow = 'hidden';
    setTimeout(function () { m.classList.add('avuna-show'); $ed('edFirst').focus(); }, 20);
}

function editStaff(btn) {
    var selfId = '<%= Session["staff_ID"] == null ? "" : System.Web.HttpUtility.JavaScriptStringEncode(Session["staff_ID"].ToString()) %>';
    var id = btn.getAttribute('data-id');
    openEdit({
        kind: btn.getAttribute('data-kind'), id: id,
        first: btn.getAttribute('data-first'), last: btn.getAttribute('data-last'),
        phone: btn.getAttribute('data-phone'), email: btn.getAttribute('data-email'),
        role: btn.getAttribute('data-role'), username: btn.getAttribute('data-username'),
        self: btn.getAttribute('data-kind') === 'admin' && id === selfId
    });
}

function closeEdit() {
    var m = $ed('edModal');
    m.classList.remove('avuna-show');
    document.body.style.overflow = '';
    setTimeout(function () { m.classList.remove('avuna-open'); }, 250);
}

function validateEdit() {
    var msg = '';
    var isAdmin = $ed('edKind').value === 'admin';
    if (!$ed('edFirst').value.trim()) msg = 'Please enter the first name.';
    else if (!$ed('edLast').value.trim()) msg = 'Please enter the last name.';
    else if (!/^[0-9+()\- ]{7,20}$/.test($ed('edPhone').value.trim())) msg = 'Please enter a valid phone number (digits only).';
    else if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test($ed('edEmail').value.trim())) msg = 'Please enter a valid email address.';
    else if (isAdmin && !$ed('edUsername').value.trim()) msg = 'Please enter a username - the staff member needs it to log in.';
    if (msg) { var b = $ed('edClientError'); b.textContent = msg; b.style.display = 'block'; return false; }
    return true;
}

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeEdit();
    // Enter inside the pop-up saves (instead of submitting the hidden Archive button)
    if (e.key === 'Enter' && e.target && e.target.closest && e.target.closest('#edModal') && e.target.tagName === 'INPUT') {
        e.preventDefault();
        document.getElementById('<%= btnSave.ClientID %>').click();
    }
});
</script>
    <asp:Literal ID="litNextIds" runat="server" />

<!-- ADD STAFF POP-UP -->
<div id="adModal" class="avuna-modal-back" onclick="if (event.target === this) closeAdd();">
<div class="avuna-modal" role="dialog" aria-modal="true" aria-labelledby="adTitle">
<div class="avuna-modal-head">
<div class="avuna-modal-avatar" id="adIcon">+</div>
<div class="avuna-modal-title">
<small>NEW STAFF MEMBER</small>
<h3 id="adTitle">Add a staff member</h3>
<span id="adMeta">STEP 1 OF 2</span>
</div>
<button type="button" class="avuna-modal-close" onclick="closeAdd()" aria-label="Close">&times;</button>
</div>

<!-- step 1: who are you adding? -->
<div id="adStep1">
<div class="avuna-type-grid">
<button type="button" class="avuna-type-card avuna-type-admin" onclick="openAddForm('admin')">
<div class="avuna-type-icon">&#9733;</div>
<strong>Admin Staff</strong>
<span>Managers and administrators who log in to the manager portal.</span>
<em>Choose &rarr;</em>
</button>
<button type="button" class="avuna-type-card avuna-type-production" onclick="openAddForm('production')">
<div class="avuna-type-icon">&#9881;</div>
<strong>Production Staff</strong>
<span>The team that makes the embroidery orders.</span>
<em>Choose &rarr;</em>
</button>
</div>
<div class="avuna-modal-foot"><button type="button" class="avuna-modal-cancel" onclick="closeAdd()">Cancel</button></div>
</div>

<!-- step 2: the details -->
<div id="adStep2" style="display:none">
<div class="avuna-modal-body">
<asp:Literal ID="litAddError" runat="server" />
<div id="adClientError" class="avuna-modal-error" style="display:none"></div>
<input type="hidden" name="adKind" id="adKind" />
<div class="avuna-idbox"><small>STAFF NUMBER (ASSIGNED AUTOMATICALLY)</small><strong id="adNewId">-</strong></div>
<div class="avuna-modal-grid">
<div class="avuna-field"><label for="adFirst">FIRST NAME</label><input type="text" name="adFirst" id="adFirst" maxlength="50" autocomplete="off" /></div>
<div class="avuna-field"><label for="adLast">LAST NAME</label><input type="text" name="adLast" id="adLast" maxlength="50" autocomplete="off" /></div>
<div class="avuna-field"><label for="adPhone">PHONE NUMBER</label><input type="text" name="adPhone" id="adPhone" maxlength="20" autocomplete="off" placeholder="e.g. 0821234567" /></div>
<div class="avuna-field"><label for="adEmail">EMAIL ADDRESS</label><input type="text" name="adEmail" id="adEmail" maxlength="50" autocomplete="off" placeholder="name@example.com" /></div>
<div class="avuna-field"><label for="adRole">ROLE</label>
<select name="adRole" id="adRole" onchange="roleChanged()"><asp:Literal ID="litAddRoleOptions" runat="server" /></select></div>
<div class="avuna-field ad-admin"><label for="adUsername">USERNAME (LOGIN)</label><input type="text" name="adUsername" id="adUsername" maxlength="100" autocomplete="off" /></div>
<div class="avuna-field avuna-field-wide"><label for="adPassword">PASSWORD</label>
<div class="avuna-pw-row"><input type="text" name="adPassword" id="adPassword" maxlength="50" autocomplete="off" placeholder="Set a password for this staff member" />
<button type="button" class="avuna-gen-btn" onclick="genPassword()">Generate</button></div>
<small>Share this password with the staff member. They can ask a manager to change it later.</small></div>
</div>
</div>
<div class="avuna-modal-foot">
<button type="button" class="avuna-modal-back-link" onclick="showAddStep(1)">&larr; Back</button>
<button type="button" class="avuna-modal-cancel" onclick="closeAdd()">Cancel</button>
<asp:Button ID="btnAdd" runat="server" Text="Add staff member" CssClass="avuna-modal-save" OnClick="btnAdd_Click" OnClientClick="return validateAdd();" />
</div>
</div>
</div>
</div>

<script>
    function $ad(id) { return document.getElementById(id); }

    function showAddStep(n) {
        $ad('adStep1').style.display = n === 1 ? '' : 'none';
        $ad('adStep2').style.display = n === 2 ? '' : 'none';
        $ad('adMeta').textContent = n === 1 ? 'STEP 1 OF 2' : 'STEP 2 OF 2';
        if (n === 1) { $ad('adTitle').textContent = 'Add a staff member'; $ad('adIcon').textContent = '+'; }
    }

    function showAddModal() {
        var m = $ad('adModal');
        m.classList.add('avuna-open');
        document.body.style.overflow = 'hidden';
        setTimeout(function () { m.classList.add('avuna-show'); }, 20);
    }

    // the "+ Add Staff Member" button
    function openAddChooser() {
        if (typeof CAN_MANAGE !== 'undefined' && !CAN_MANAGE) { alert('Only a manager can add staff.'); return false; }
        $ad('adClientError').style.display = 'none';
        showAddStep(1);
        showAddModal();
        return false;
    }

    // step 2 - kind is 'admin' or 'production'; d (optional) refills the form after a problem
    // switches the form between admin and production (called when the role changes)
    function applyAddKind(kind) {
        var isAdmin = kind === 'admin';
        $ad('adKind').value = kind;
        var fields = document.querySelectorAll('.ad-admin');
        for (var i = 0; i < fields.length; i++) fields[i].style.display = isAdmin ? '' : 'none';
        $ad('adNewId').textContent = isAdmin ? NEXT_ADMIN_ID : NEXT_PRODUCTION_ID;
        $ad('adTitle').textContent = isAdmin ? 'New admin staff member' : 'New production staff member';
        $ad('adIcon').textContent = isAdmin ? '★' : '⚙';
    }

    function roleChanged() {
        applyAddKind($ad('adRole').value === 'Production Staff' ? 'production' : 'admin');
    }

    // step 2 - kind is 'admin' or 'production'; d (optional) refills the form after a problem
    function openAddForm(kind, d) {
        d = d || {};
        $ad('adFirst').value = d.first || '';
        $ad('adLast').value = d.last || '';
        $ad('adPhone').value = d.phone || '';
        $ad('adEmail').value = d.email || '';
        $ad('adUsername').value = d.username || '';
        $ad('adPassword').value = d.password || '';
        $ad('adRole').value = kind === 'production' ? 'Production Staff' : (d.role && d.role !== 'Production Staff' ? d.role : 'Admin Staff');
        applyAddKind(kind);
        $ad('adClientError').style.display = 'none';
        showAddStep(2);
        showAddModal();
        setTimeout(function () { $ad('adFirst').focus(); }, 60);
    }

    function closeAdd() {
        var m = $ad('adModal');
        m.classList.remove('avuna-show');
        document.body.style.overflow = '';
        setTimeout(function () { m.classList.remove('avuna-open'); }, 250);
    }

    function genPassword() {
        var chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';
        var p = '';
        for (var i = 0; i < 10; i++) p += chars.charAt(Math.floor(Math.random() * chars.length));
        $ad('adPassword').value = p;
    }

    function validateAdd() {
        var msg = '';
        var isAdmin = $ad('adKind').value === 'admin';
        if (!$ad('adFirst').value.trim()) msg = 'Please enter the first name.';
        else if (!$ad('adLast').value.trim()) msg = 'Please enter the last name.';
        else if (!/^[0-9+()\- ]{7,20}$/.test($ad('adPhone').value.trim())) msg = 'Please enter a valid phone number (digits only).';
        else if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test($ad('adEmail').value.trim())) msg = 'Please enter a valid email address.';
        else if (isAdmin && !$ad('adUsername').value.trim()) msg = 'Please enter a username - the staff member needs it to log in.';
        else if (!$ad('adPassword').value) msg = 'Please set a password for the new staff member.';
        if (msg) { var b = $ad('adClientError'); b.textContent = msg; b.style.display = 'block'; return false; }
        return true;
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeAdd();
        // Enter inside the Add form adds the person (instead of submitting another button)
        if (e.key === 'Enter' && e.target && e.target.closest && e.target.closest('#adStep2') && e.target.tagName === 'INPUT') {
            e.preventDefault();
            document.getElementById('<%= btnAdd.ClientID %>').click();
    }
});
</script>
<asp:Literal ID="litActionMessage" runat="server" />
<asp:HiddenField ID="hfKind" runat="server" />
<asp:HiddenField ID="hfId" runat="server" />
<asp:Button ID="btnArchive" runat="server" Text="Archive" OnClick="btnArchive_Click" style="display:none" />
<script>
function archiveStaff(btn) {
    var name = btn.getAttribute('data-name') || btn.getAttribute('data-id');
    if (!confirm('Archive ' + name + '?\n\nThey will be moved out of the active staff list into the archive.')) return;
    document.getElementById('<%= hfKind.ClientID %>').value = btn.getAttribute('data-kind');
    document.getElementById('<%= hfId.ClientID %>').value = btn.getAttribute('data-id');
    document.getElementById('<%= btnArchive.ClientID %>').click();
}
</script>
<!-- STAFF STATISTICS -->
<section class="avuna-stat-grid">
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-green-icon">&#9673;</div>
<span class="avuna-stat-label">TOTAL STAFF</span>
</div>
<h2><asp:Literal ID="litTotalStaff" runat="server" /></h2>
<span class="avuna-stat-description">Admin and production staff combined</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-orange-icon">&#10003;</div>
<span class="avuna-stat-label">ADMIN &amp; MANAGERS</span>
</div>
<h2><asp:Literal ID="litAdminCount" runat="server" /></h2>
<span class="avuna-stat-description">Managers and administrators</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-gold-icon">&#9881;</div>
<span class="avuna-stat-label">PRODUCTION STAFF</span>
</div>
<h2><asp:Literal ID="litProductionCount" runat="server" /></h2>
<span class="avuna-stat-description">Making the orders</span>
</article>
<article class="avuna-stat-card">
<div class="avuna-stat-top">
<div class="avuna-stat-icon avuna-red-icon">#</div>
<span class="avuna-stat-label">ORDERS IN PRODUCTION</span>
</div>
<h2><asp:Literal ID="litInProduction" runat="server" /></h2>
<span class="avuna-stat-description">Orders with status In Progress</span>
</article>
</section>
<!-- STAFF LIST -->
<section class="avuna-card">
<div class="avuna-card-header">
<div>
<span class="avuna-eyebrow">TEAM DIRECTORY</span>
<h2>Staff Members</h2>
<p><asp:Literal ID="litDirectorySubtitle" runat="server" /></p>
</div>
<a href="Reports.aspx?report=staff" class="avuna-view-all">View staff report &rarr;</a>
</div>
<div class="avuna-table-wrap">
<table class="avuna-table">
<thead>
<tr>
<th>STAFF NO.</th>
<th>NAME</th>
<th>ROLE</th>
<th>EMAIL</th>
<th>PHONE</th>
<th>ACTION</th>
<th>ACTION</th>
</tr>
</thead>
<tbody>
<asp:Literal ID="litStaffRows" runat="server" />
</tbody>
</table>
</div>
</section>
</main>
</div>

</asp:Content>