<%@ Page Title="Create Order" Language="C#" MasterPageFile="~/Customer_master.Master" AutoEventWireup="true" CodeBehind="CreateOrder.aspx.cs" Inherits="AVUNA_COLLECTIVE.CreateOrder" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
.avuna-order{background:#f5efe6;color:#191919;min-height:100vh;padding-bottom:65px;font-family:Arial,sans-serif}
.avuna-order *{box-sizing:border-box}.avuna-order .hero{background:linear-gradient(120deg,#111,#262626);color:white;padding:70px max(5%,30px) 95px;display:flex;justify-content:space-between;align-items:center;gap:20px;position:relative;overflow:hidden}
.avuna-order .hero:before{content:"";position:absolute;width:370px;height:370px;border:60px solid #c49a4514;border-radius:50%;right:-130px;top:-200px}
.avuna-order .hero-copy{position:relative;z-index:1}.avuna-order .eyebrow,.avuna-order .tag{color:#8a6a35;font-size:11px;font-weight:800;letter-spacing:2px}
.avuna-order h1{font-size:clamp(40px,5vw,66px);line-height:1.06;letter-spacing:-2px;font-weight:800;margin:20px 0;color:#fff}.avuna-order .hero p{color:#ddd;font-size:16px;line-height:1.8;max-width:640px}
.avuna-order .back{display:inline-block;border:1px solid #777;background:#ffffff12;color:white!important;text-decoration:none;border-radius:10px;padding:13px 20px;font-weight:700;margin-top:12px}
.avuna-order .hero-mark{border:2px solid #c49a45;border-radius:50%;width:170px;height:170px;flex:none;display:flex;flex-direction:column;justify-content:center;align-items:center;box-shadow:0 0 0 18px #c49a4509;position:relative}
.avuna-order .hero-mark strong{font-size:43px;color:white}.avuna-order .hero-mark small{color:#8a6a35;text-align:center;font-size:10px;font-weight:800;letter-spacing:2px}
.avuna-order .hero-mark-logo{position:relative;z-index:2;width:190px;height:190px;min-width:190px;flex:none;background:#fbf8f2;border:2px solid #c49a45;border-radius:50%;display:flex;align-items:center;justify-content:center;overflow:hidden;box-shadow:0 0 0 18px #c49a4509}
.avuna-order .hero-mark-logo img{width:100%;height:100%;object-fit:contain;display:block}
.avuna-order .wrap{max-width:1280px;width:calc(100% - 40px);margin:-35px auto 0;position:relative;z-index:2}.avuna-order .intro,.avuna-order .panel{background:#fbf8f2;border:1px solid #e5dccd;border-radius:16px;padding:26px;box-shadow:0 10px 30px #00000010}
.avuna-order .intro{display:flex;justify-content:space-between;align-items:center;margin-bottom:22px}.avuna-order .muted{font-size:13px;color:#777;margin:8px 0}.avuna-order .pill{border-radius:30px;padding:10px 14px;background:#f2e2c9;color:#8b6147;font-size:11px;letter-spacing:1px;font-weight:800}
.avuna-order .layout{display:grid;grid-template-columns:minmax(0,1.65fr) minmax(300px,1fr);gap:22px;align-items:start}.avuna-order h2{font-size:24px;font-weight:700;margin:9px 0;color:#171717}.avuna-order h3{font-size:19px;font-weight:700;margin:22px 0 12px}
.avuna-order .fields{display:grid;grid-template-columns:1fr 1fr;gap:0 20px;margin-top:24px}.avuna-order .field{margin-bottom:21px}.avuna-order label{display:block;font-size:11px;font-weight:800;letter-spacing:1px;color:#666;margin-bottom:9px}
.avuna-order select,.avuna-order input[type=number]{width:100%;height:52px;border:1px solid #e5dccd;border-radius:10px;background:#fbf8f2;padding:12px;color:#222;font-size:15px}.avuna-order select:focus,.avuna-order input:focus{outline:2px solid #c49a4580;outline-offset:1px}.avuna-order select:disabled{opacity:.6;cursor:not-allowed}
.avuna-order .auto-package{padding:15px 12px;background:#f2e2c9;border:1px solid #e3d0ae;border-radius:10px;color:#6e5133;font-size:14px;font-weight:700;min-height:52px}.avuna-order .hint{color:#777;font-size:12px;margin:8px 0 0}.avuna-order .stock{font-size:13px;padding:11px 14px;border-radius:9px;background:#f3f6f3;color:#2e6844;margin-bottom:20px}.avuna-order .stock.warn{background:#fff2ec;color:#af4d22}
.avuna-order .upload{border:2px dashed #dcd3ca;border-radius:12px;background:#fbf8f2;text-align:center;padding:26px 14px}.avuna-order .upload-icon{font-size:35px;color:#8a6a35}.avuna-order .upload strong{display:block;margin:8px 0}.avuna-order .upload input{max-width:100%;margin:14px 0 0}.avuna-order #designPreview{display:none;max-width:100%;max-height:220px;object-fit:contain;margin:18px auto 0;border-radius:9px}
.avuna-order .submit{background:#0f2a1f;color:#fff;border:0;border-radius:10px;width:100%;padding:16px;font-weight:800;box-shadow:0 8px 22px #c49a4535;cursor:pointer}.avuna-order .submit:hover{background:#173c2c}
.avuna-order .rowline{display:flex;align-items:start;justify-content:space-between;gap:14px;border-bottom:1px solid #eee;padding:14px 0;font-size:14px}.avuna-order .rowline span{color:#777}.avuna-order .rowline strong{text-align:right;overflow-wrap:anywhere}.avuna-order .total{border-radius:12px;background:#191919;color:#fff;padding:22px;margin-top:20px}.avuna-order .total span{color:#bbb;font-size:11px;letter-spacing:1px}.avuna-order .total strong{display:block;color:#8a6a35;font-size:30px;margin-top:8px}.avuna-order .note{background:#f2e2c9;color:#81542f;padding:15px;border-radius:10px;font-size:12px;line-height:1.6;margin-top:20px}
.avuna-order .colour-picker{background:#fbf8f2;border:1px solid #e5dccd;border-radius:10px;padding:12px;min-height:52px}.avuna-order .colour-option{display:flex;align-items:center;gap:12px;flex-wrap:wrap;padding:10px 6px;border-bottom:1px solid #ece8e2}.avuna-order .colour-option:last-child{border-bottom:0}.avuna-order .colour-option label{display:inline-flex;align-items:center;gap:8px;margin:0;font-size:13px;letter-spacing:0;color:#222;text-transform:none;flex:1;min-width:110px}.avuna-order .colour-option input[type=checkbox]{width:17px;height:17px;accent-color:#0f2a1f}.avuna-order .colour-option input[type=number]{width:112px;height:42px}.avuna-order input[readonly]{background:#f0eeeb;color:#666}.avuna-order .feedback{margin-top:17px;border-radius:10px;padding:14px;display:none;font-size:13px;line-height:1.7}.avuna-order .feedback.error{display:block;background:#fff0ed;color:#a52c21;border:1px solid #efc7bf}.avuna-order .feedback.success{display:block;background:#edfaef;color:#256339;border:1px solid #b5ddbd}.avuna-order .feedback ul{margin:5px 0 0;padding-left:20px}
@media(max-width:850px){.avuna-order .layout{grid-template-columns:1fr}.avuna-order .hero-mark,.avuna-order .hero-mark-logo{display:none}}@media(max-width:550px){.avuna-order .fields{grid-template-columns:1fr}.avuna-order .intro{gap:10px}.avuna-order .pill{font-size:9px}}

/* Confirmation popup displayed after successful database commit */
.avuna-confirm-overlay{position:fixed;inset:0;z-index:2147483000;background:rgba(0,0,0,.66);display:flex;align-items:center;justify-content:center;padding:20px}
.avuna-confirm-dialog{box-sizing:border-box;background:#fbf8f2;color:#202020;border-radius:18px;box-shadow:0 22px 70px #0006;text-align:center;width:min(100%,440px);padding:36px 28px;font-family:Arial,sans-serif}
.avuna-confirm-icon{width:66px;height:66px;border-radius:50%;background:#e7f8eb;color:#24733d;margin:0 auto 18px;display:flex;align-items:center;justify-content:center;font-size:34px;font-weight:900}
.avuna-confirm-dialog h2{font-size:25px;color:#173c2c;margin:0 0 12px}
.avuna-confirm-dialog p{line-height:1.6;font-size:15px;margin:8px 0;overflow-wrap:anywhere}
.avuna-confirm-muted{color:#666}
.avuna-confirm-close{margin-top:20px;border:0;background:#0f2a1f;color:#fff;border-radius:10px;padding:13px 36px;font-size:15px;font-weight:700;cursor:pointer}
.avuna-confirm-close:hover,.avuna-confirm-close:focus{background:#173c2c}
.avuna-choose-buttons{display:flex;gap:12px;margin-top:25px}.avuna-choose-buttons button{flex:1;border:0;border-radius:10px;padding:14px 10px;font-weight:800;cursor:pointer;background:#173c2c;color:white}.avuna-choose-buttons button+button{background:#0f2a1f}.avuna-cancel-choice{border:0;background:transparent;color:#666;padding:12px;margin-top:10px;cursor:pointer}
.avuna-order .quote-head{display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap;margin:22px 0 4px}.avuna-order .quote-head h3{margin:0}
.avuna-order .quote-actions{display:flex;gap:8px;flex-wrap:wrap}
.avuna-order .qbtn{border:1.5px solid #c49a45;background:#fbf8f2;color:#8a6a35;border-radius:10px;padding:9px 14px;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap;font-family:inherit}.avuna-order .qbtn:hover{background:#f2e2c9}
.avuna-order .qbtn-alt{background:#0f2a1f;color:#fff}.avuna-order .qbtn-alt:hover{background:#173c2c}.avuna-order .qbtn:disabled{opacity:.6;cursor:wait}
.avuna-order .quote-msg{display:none;margin:8px 0 2px;padding:10px 12px;border-radius:10px;font-size:13px;line-height:1.5}
.avuna-order .quote-msg.ok{display:block;background:#e7f4eb;color:#277446}.avuna-order .quote-msg.bad{display:block;background:#fdeaea;color:#b03a3a}
.avuna-cart{margin:18px 0 12px;border:1px solid #e8dcc4;border-radius:12px;background:#fffdf8;padding:14px 16px}
.avuna-cart h3{margin:0 0 8px;font-size:15px;color:#0f2a1f}
.avuna-cart-empty{color:#7a7a6e;font-size:13px;margin:0}
.avuna-cart-row{display:flex;gap:10px;align-items:center;justify-content:space-between;padding:9px 0;border-top:1px solid #f0e6d0;font-size:13px}
.avuna-cart-row:first-of-type{border-top:0}
.avuna-cart-row small{display:block;color:#6b6b60;margin-top:2px}
.avuna-cart-row button{background:none;border:1px solid #d9b8b0;color:#a33a2a;border-radius:8px;padding:5px 10px;cursor:pointer;font-weight:700;font-size:12px}
.avuna-cart-total{display:flex;justify-content:space-between;border-top:2px solid #e8dcc4;margin-top:6px;padding-top:10px;font-weight:800;color:#0f2a1f}
.avuna-order .addcart{background:#fff;color:#0f2a1f;border:2px solid #0f2a1f;border-radius:10px;width:100%;padding:14px;font-weight:800;cursor:pointer;margin-top:6px}
.avuna-order .addcart:hover{background:#0f2a1f;color:#fff}
.cart-sum-item{border:1px solid #e8dcc4;border-radius:12px;background:#fffdf8;padding:8px 14px 4px;margin:0 0 12px}
.cart-sum-item summary{display:flex;justify-content:space-between;gap:10px;cursor:pointer;padding:8px 0;font-size:14px;list-style:none}
.cart-sum-item summary::-webkit-details-marker{display:none}
.cart-sum-item summary::before{content:"\25B8";margin-right:6px;color:#8a6a2f}
.cart-sum-item[open] summary::before{content:"\25BE"}
.cart-sum-item summary span{flex:1}
#summaryCartList{max-height:260px;overflow-y:auto;padding-right:4px}
.cart-sum-item .rowline strong{text-align:right;max-width:60%;word-break:break-word}
</style>

<div class="avuna-order" id="createOrderPage">
<section class="hero"><div class="hero-copy"><h1>Your vision,<br />our creation.</h1><p>Choose an item, size and multiple available colours, upload your design and review your quotation.</p><a runat="server" href="~/CustomerDashboard" class="back">Back to Dashboard</a></div><div class="hero-mark-logo"><img runat="server" src="~/avuna-logo.png" alt="Avuna Collective" /></div></section>
<div class="wrap">
<div class="layout"><div class="panel"><span class="tag">ORDER DETAILS</span><h2>Customize Your Order</h2><p class="muted">Only available inventory combinations can be selected.</p>
<div class="fields">
<div class="field"><label for="itemName">ITEM NAME *</label><select id="itemName"><option value="">Select an item</option></select></div>
<div class="field"><label for="quantity">TOTAL QUANTITY</label><input type="number" id="quantity" min="1" step="1" readonly placeholder="Calculated from colours" /><div class="hint" id="quantityHint">Enter quantities next to the colours you select.</div></div>
<div class="field"><label for="itemSize">SIZE *</label><select id="itemSize" disabled><option value="">Select an item first</option></select></div>
<div class="field"><label>COLOURS AND QUANTITIES *</label><div id="colourPicker" class="colour-picker"><span class="hint">Select an item and size first.</span></div><p class="hint">Tick each available colour and enter the number of garments for that colour.</p></div>
<div class="field"><label>AUTOMATIC DESIGN PACKAGE</label><div class="auto-package" id="detectedPackage">Select colours to calculate the package</div><p class="hint">Based on the number of colours found in your uploaded design: 1 colour: Bronze · 2: Silver · 3: Gold · 4+: Platinum. Design fee charged once per item.</p></div>
</div>
<div id="stockMessage" class="stock warn" role="status">Select an item and size, then choose colours and quantities.</div>
<div class="field"><label for="designFile">UPLOAD YOUR DESIGN *</label><div class="upload"><div class="upload-icon">&#8682;</div><strong>Upload your custom design</strong><p class="hint">PNG, JPG, JPEG or WEBP, maximum 5 MB</p><input type="file" id="designFile" name="designFile" accept=".png,.jpg,.jpeg,.webp,image/png,image/jpeg,image/webp" /><img id="designPreview" alt="Uploaded design preview" /></div></div>
    <style>
.avuna-order .mock-wrap{margin:4px 0 24px;border:1px solid #e5dccd;border-radius:12px;background:#fbf8f2;padding:16px}
.avuna-order .mock-wrap h3{margin:0 0 4px;font-size:17px}
.avuna-order .mock-note{color:#777;font-size:12px;margin:0 0 12px}
.avuna-order .mock-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:14px}
.avuna-order .mock-card{background:#fbf8f2;border:1px solid #ece8e2;border-radius:10px;padding:8px 8px 10px;text-align:center}
.avuna-order .mock-photo{width:100%;height:auto;max-height:300px;object-fit:contain;display:block;filter:drop-shadow(0 8px 10px rgba(0,0,0,.22))}
.avuna-order .mock-card svg{width:100%;height:auto;max-height:230px;display:block}
.avuna-order .mock-cap{font-size:11px;font-weight:800;letter-spacing:1px;color:#666;margin-top:4px}
.avuna-order .mock-cap b{color:#8a6a35}
.avuna-order .mock-colour{font-size:13px;font-weight:700;margin:0 0 6px;color:#222}
.avuna-order .mock-empty{font-size:13px;color:#777;margin:0}
</style>
<div class="field mock-wrap" id="mockupSection">
    <h3>Before and after preview</h3>
    <p class="mock-note">An approximate preview of how your item will look. The final print position is confirmed by our team.</p>
    <div id="mockupBody"><p class="mock-empty">Select an item, size and colour to see your item here.</p></div>
</div>
<script>
    (function () {
        "use strict";
        function el(id) { return document.getElementById(id); }
        var item = el("itemName"), picker = el("colourPicker"), file = el("designFile"), body = el("mockupBody");
        if (!item || !picker || !file || !body) return;
        var designUrl = null, uid = 0;

        var COLOURS = [["white", "#ffffff"], ["black", "#1f1f1f"], ["navy", "#16243f"], ["royal", "#2250a8"], ["light blue", "#8dbbe8"],
        ["sky", "#8dbbe8"], ["blue", "#2b5fb3"], ["maroon", "#6d1a2a"], ["burgundy", "#6d1a2a"], ["red", "#c62d2d"], ["orange", "#f08a24"],
        ["gold", "#c49a45"], ["yellow", "#f2cf4a"], ["lime", "#8fc93a"], ["bottle", "#1f5a3a"], ["forest", "#25573a"], ["green", "#2f8a4a"],
        ["teal", "#1f8a8a"], ["purple", "#6b3fa0"], ["pink", "#ec7fa9"], ["brown", "#6b4a32"], ["beige", "#d9c7a3"], ["cream", "#f1e8d2"],
        ["khaki", "#b9a877"], ["charcoal", "#454545"], ["silver", "#c4c4c4"], ["grey", "#9a9a9a"], ["gray", "#9a9a9a"]];

        function colourHex(name) {
            var n = String(name || "").toLowerCase();
            for (var i = 0; i < COLOURS.length; i++) if (n.indexOf(COLOURS[i][0]) !== -1) return COLOURS[i][1];
            return "#d9d4cc";
        }
        function shade(hex, amount) {
            var n = parseInt(hex.slice(1), 16), r = n >> 16, g = (n >> 8) & 255, b = n & 255;
            function f(c) { return Math.max(0, Math.min(255, Math.round(c + amount))); }
            return "rgb(" + f(r) + "," + f(g) + "," + f(b) + ")";
        }
        function kind() {
            var n = String(item.value || "").toLowerCase();
            if (/cap|hat|beanie/.test(n)) return "cap";
            if (/hood|jacket|sweat|jersey/.test(n) && !/t-?shirt|tee/.test(n)) return /jersey/.test(n) ? "tee" : "hoodie";
            return "tee";
        }
        var BODY = {
            tee: "M70 20 L40 32 L8 70 L34 92 L52 76 L52 202 L148 202 L148 76 L166 92 L192 70 L160 32 L130 20 Q100 46 70 20 Z",
            hoodie: "M68 26 L36 42 L14 134 L40 140 L52 96 L52 206 L148 206 L148 96 L160 140 L186 134 L164 42 L132 26 Q100 56 68 26 Z",
            cap: "M38 124 Q32 48 100 43 Q168 48 162 124 Q100 134 38 124 Z"
        };
        var FOLDS = {
            tee: [["M60 92 Q74 138 62 198", "#000", 8, .14], ["M140 96 Q128 142 140 198", "#000", 8, .12], ["M100 108 Q94 150 102 200", "#fff", 11, .12],
            ["M72 70 Q100 96 128 70", "#000", 6, .10], ["M22 76 L42 90", "#000", 6, .14], ["M178 76 L158 90", "#000", 6, .14], ["M58 160 Q100 172 142 160", "#000", 6, .08]],
            hoodie: [["M58 100 Q72 150 60 204", "#000", 9, .15], ["M142 100 Q128 150 140 204", "#000", 9, .13], ["M100 112 Q94 160 102 204", "#fff", 12, .11],
            ["M26 60 Q34 100 24 132", "#000", 7, .14], ["M174 60 Q166 100 176 132", "#000", 7, .14], ["M72 76 Q100 100 128 76", "#000", 6, .10]],
            cap: [["M62 60 Q52 96 54 124", "#000", 9, .16], ["M138 60 Q148 96 146 124", "#000", 9, .16], ["M100 56 Q98 90 100 124", "#fff", 14, .10]]
        };
        function details(type, fill, edge, dark) {
            var st = 'fill="none" stroke="' + shade(fill, -55) + '" stroke-width="1.1" stroke-dasharray="2.5 2" opacity=".75"';
            if (type === "tee")
                return '<path d="M72 21 Q100 40 128 21 Q100 58 72 21 Z" fill="' + shade(fill, -70) + '"/>' +
                    '<path d="M70 20 Q100 48 130 20" fill="none" stroke="' + dark + '" stroke-width="5.5" stroke-linecap="round"/>' +
                    '<path d="M71 24 Q100 52 129 24" ' + st + '/>' +
                    '<path d="M54 194 L146 194" ' + st + '/><path d="M12 72 L35 90" ' + st + '/><path d="M188 72 L165 90" ' + st + '/>' +
                    '<path d="M52 78 Q60 96 56 112" fill="none" stroke="' + edge + '" stroke-width="1.2" opacity=".55"/>' +
                    '<path d="M148 78 Q140 96 144 112" fill="none" stroke="' + edge + '" stroke-width="1.2" opacity=".55"/>';
            if (type === "hoodie")
                return '<path d="M62 34 Q100 -16 138 34 Q100 66 62 34 Z" fill="' + dark + '" stroke="' + edge + '" stroke-width="2" stroke-linejoin="round"/>' +
                    '<path d="M74 34 Q100 62 126 34 Q100 12 74 34 Z" fill="' + shade(fill, -75) + '"/>' +
                    '<path d="M92 56 L90 92" stroke="#f3efe8" stroke-width="2.2" stroke-linecap="round"/><path d="M108 56 L110 92" stroke="#f3efe8" stroke-width="2.2" stroke-linecap="round"/>' +
                    '<circle cx="90" cy="94" r="2.4" fill="#e8e2d6"/><circle cx="110" cy="94" r="2.4" fill="#e8e2d6"/>' +
                    '<path d="M66 152 L134 152 L142 194 L58 194 Z" fill="' + shade(fill, -8) + '" stroke="' + edge + '" stroke-width="1.6" stroke-linejoin="round"/>' +
                    '<path d="M54 198 L146 198" ' + st + '/><path d="M17 126 L41 132" ' + st + '/><path d="M183 126 L159 132" ' + st + '/>';
            return '<path d="M40 122 Q100 132 160 122" fill="none" stroke="' + shade(fill, -45) + '" stroke-width="2"/>' +
                '<path d="M100 44 L100 124" fill="none" stroke="' + edge + '" stroke-width="1.2" opacity=".6"/>' +
                '<path d="M68 52 Q60 90 58 123" fill="none" stroke="' + edge + '" stroke-width="1.1" opacity=".55"/>' +
                '<path d="M132 52 Q140 90 142 123" fill="none" stroke="' + edge + '" stroke-width="1.1" opacity=".55"/>' +
                '<path d="M44 118 Q100 128 156 118" ' + st + '/>' +
                '<circle cx="100" cy="44" r="4.5" fill="' + dark + '" stroke="' + edge + '" stroke-width="1.2"/>' +
                '<circle cx="62" cy="82" r="1.8" fill="' + shade(fill, -60) + '"/><circle cx="138" cy="82" r="1.8" fill="' + shade(fill, -60) + '"/>';
        }
        function brim(fill, edge, id) {
            return '<defs><linearGradient id="br' + id + '" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="' + shade(fill, -35) + '"/><stop offset=".6" stop-color="' + shade(fill, -8) + '"/><stop offset="1" stop-color="' + shade(fill, -30) + '"/></linearGradient></defs>' +
                '<path d="M28 124 Q100 106 172 124 Q188 154 100 162 Q12 154 28 124 Z" fill="url(#br' + id + ')" stroke="' + edge + '" stroke-width="2" stroke-linejoin="round"/>' +
                '<path d="M34 130 Q100 116 166 130" fill="none" stroke="#fff" stroke-width="2.2" opacity=".18"/>' +
                '<path d="M30 126 Q100 109 170 126" fill="none" stroke="' + shade(fill, -60) + '" stroke-width="1" stroke-dasharray="2.5 2" opacity=".7"/>';
        }
        function area(type) { return type === "cap" ? { x: 70, y: 60, w: 60, h: 48 } : type === "hoodie" ? { x: 68, y: 62, w: 64, h: 70 } : { x: 66, y: 58, w: 68, h: 76 }; }
        function foldLayer(type, op) {
            return FOLDS[type].map(function (f) {
                return '<path d="' + f[0] + '" fill="none" stroke="' + f[1] + '" stroke-width="' + f[2] + '" stroke-linecap="round" opacity="' + (f[3] * op) + '"/>';
            }).join("");
        }
        function svg(type, fill, withDesign) {
            var id = ++uid, a = area(type), edge = shade(fill, -48), dark = shade(fill, -26), body = BODY[type];
            var out = '<svg viewBox="' + (type === "cap" ? "10 30 180 150" : "0 0 200 220") + '" role="img" aria-labelledby="t' + id + '"><title id="t' + id + '">' + (withDesign ? "Item with your design" : "Plain item") + '</title>' +
                '<defs><clipPath id="c' + id + '"><path d="' + body + '"/></clipPath>' +
                '<filter id="b' + id + '" x="-20%" y="-20%" width="140%" height="140%"><feGaussianBlur stdDeviation="2.4"/></filter>' +
                '<filter id="s' + id + '" x="-20%" y="-20%" width="140%" height="150%"><feDropShadow dx="0" dy="4" stdDeviation="3.5" flood-color="#000" flood-opacity=".28"/></filter>' +
                '<linearGradient id="g' + id + '" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#000" stop-opacity=".26"/><stop offset=".22" stop-color="#000" stop-opacity=".02"/>' +
                '<stop offset=".5" stop-color="#fff" stop-opacity=".12"/><stop offset=".78" stop-color="#000" stop-opacity=".03"/><stop offset="1" stop-color="#000" stop-opacity=".3"/></linearGradient>' +
                '<linearGradient id="v' + id + '" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".14"/><stop offset="1" stop-color="#000" stop-opacity=".14"/></linearGradient></defs>';
            out += '<g filter="url(#s' + id + ')">' + (type === "cap" ? brim(fill, edge, id) : "") +
                '<path d="' + body + '" fill="' + fill + '" stroke="' + edge + '" stroke-width="2" stroke-linejoin="round"/></g>';
            out += '<g clip-path="url(#c' + id + ')"><rect width="200" height="220" fill="url(#g' + id + ')"/><rect width="200" height="220" fill="url(#v' + id + ')"/>' +
                '<g filter="url(#b' + id + ')">' + foldLayer(type, 1) + '</g></g>';
            out += details(type, fill, edge, dark);
            if (withDesign && designUrl) {
                out += '<g clip-path="url(#c' + id + ')"><image href="' + designUrl + '" x="' + a.x + '" y="' + a.y + '" width="' + a.w + '" height="' + a.h + '" preserveAspectRatio="xMidYMid meet" opacity=".96"/></g>' +
                    '<g clip-path="url(#c' + id + ')"><rect width="200" height="220" fill="url(#g' + id + ')" opacity=".6"/><g filter="url(#b' + id + ')">' + foldLayer(type, .75) + '</g></g>';
            } else if (withDesign) {
                out += '<rect x="' + a.x + '" y="' + a.y + '" width="' + a.w + '" height="' + a.h + '" rx="4" fill="none" stroke="' + shade(fill, -70) + '" stroke-width="1.5" stroke-dasharray="4 3" opacity=".7"/>';
            }
            return out + '</svg>';
        }
        function chosenColours() {
            var out = [];
            Array.prototype.forEach.call(picker.querySelectorAll(".colour-option"), function (row) {
                var cb = row.querySelector("input[type=checkbox]");
                if (cb && cb.checked) out.push(row.textContent.trim());
            });
            return out;
        }
        function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]; }); }

        // ---------- Photo-realistic mode (used when the item photos exist in ~/images/mockups/) ----------
        var PHOTO_BASE = "<%= ResolveUrl("~/images/mockups/") %>";
        var PHOTOS = {
            tee: { file: "tshirt.png", area: { x: .30, y: .22, w: .40, h: .38 } },
            hoodie: { file: "hoodie.png", area: { x: .31, y: .27, w: .38, h: .30 } },
            cap: { file: "cap.png", area: { x: .31, y: .22, w: .38, h: .30 } }
        };
        var photoCache = {}, designImg = null;
        function loadImg(src) {
            return new Promise(function (ok) { var i = new Image(); i.onload = function () { ok(i); }; i.onerror = function () { ok(null); }; i.src = src; });
        }
        function photoFor(type) {
            if (!photoCache[type]) photoCache[type] = loadImg(PHOTO_BASE + PHOTOS[type].file);
            return photoCache[type];
        }
        function rgbOf(hex) { var n = parseInt(hex.slice(1), 16); return [n >> 16, (n >> 8) & 255, n & 255]; }
        function drawPhoto(canvas, photo, hex, withDesign, area) {
            var W = 560, H = Math.round(W * photo.height / photo.width);
            canvas.width = W; canvas.height = H;
            var ctx = canvas.getContext("2d");
            ctx.drawImage(photo, 0, 0, W, H);
            var img = ctx.getImageData(0, 0, W, H), d = img.data, n = W * H, lum = new Float32Array(n), hist = new Uint32Array(256), count = 0, i;
            for (i = 0; i < n; i++) {
                if (d[i * 4 + 3] < 8) continue;
                var l = (0.299 * d[i * 4] + 0.587 * d[i * 4 + 1] + 0.114 * d[i * 4 + 2]);
                lum[i] = l; hist[l | 0]++; count++;
            }
            var acc = 0, ref = 255, target = count * 0.92;
            for (i = 0; i < 256; i++) { acc += hist[i]; if (acc >= target) { ref = Math.max(i, 60); break; } }
            var c = rgbOf(hex), k;
            for (i = 0; i < n; i++) {
                if (d[i * 4 + 3] < 8) continue;
                var f = Math.min(1.08, lum[i] / ref); lum[i] = f;
                var glow = Math.max(0, f - 0.94) * 255 * 1.4;
                for (k = 0; k < 3; k++) d[i * 4 + k] = Math.max(0, Math.min(255, c[k] * f + glow));
            }
            if (withDesign && designImg) {
                var off = document.createElement("canvas"); off.width = W; off.height = H;
                var oc = off.getContext("2d"), ax = area.x * W, ay = area.y * H, aw = area.w * W, ah = area.h * H;
                var sc = Math.min(aw / designImg.width, ah / designImg.height), dw = designImg.width * sc, dh = designImg.height * sc;
                oc.drawImage(designImg, ax + (aw - dw) / 2, ay + (ah - dh) / 2, dw, dh);
                var dd = oc.getImageData(0, 0, W, H).data;
                for (i = 0; i < n; i++) {
                    var da = dd[i * 4 + 3] / 255;
                    if (da <= 0 || d[i * 4 + 3] < 8) continue;
                    var fold = Math.max(0.55, Math.min(1, 1 - (1 - lum[i]) * 1.5)) * 0.98;
                    for (k = 0; k < 3; k++) d[i * 4 + k] = d[i * 4 + k] * (1 - da) + dd[i * 4 + k] * fold * da;
                }
            }
            ctx.putImageData(img, 0, 0);
        }
        var renderToken = 0;
        function fillSlot(slot, type, hex, withDesign) {
            var tok = renderToken;
            photoFor(type).then(function (photo) {
                if (tok !== renderToken) return;
                if (photo) {
                    var cv = document.createElement("canvas");
                    cv.className = "mock-photo";
                    drawPhoto(cv, photo, hex, withDesign, PHOTOS[type].area);
                    slot.innerHTML = ""; slot.appendChild(cv);
                } else {
                    slot.innerHTML = svg(type, hex, withDesign);
                }
            });
        }

        function render() {
            renderToken++;
            if (!item.value) { body.innerHTML = '<p class="mock-empty">Select an item, size and colour to see your item here.</p>'; return; }
            var type = kind(), colours = chosenColours();
            if (!colours.length) colours = [""];
            var html = "", shown = colours.slice(0, 4);
            shown.forEach(function (c) {
                html += (c ? '<p class="mock-colour">' + esc(c) + '</p>' : "") + '<div class="mock-row">' +
                    '<div class="mock-card"><div class="mock-slot"></div><div class="mock-cap"><b>BEFORE</b> &middot; plain item</div></div>' +
                    '<div class="mock-card"><div class="mock-slot"></div><div class="mock-cap"><b>AFTER</b> &middot; ' + (designUrl ? "with your design" : "upload your design below") + '</div></div></div>';
            });
            if (colours.length > shown.length) html += '<p class="mock-empty">Showing the first 4 of ' + colours.length + ' selected colours.</p>';
            body.innerHTML = html;
            var slots = body.querySelectorAll(".mock-slot");
            shown.forEach(function (c, idx) {
                var hex = colourHex(c || "white");
                fillSlot(slots[idx * 2], type, hex, false);
                fillSlot(slots[idx * 2 + 1], type, hex, true);
            });
        }
        file.addEventListener("change", function () {
            if (designUrl) { URL.revokeObjectURL(designUrl); designUrl = null; }
            var f = file.files[0];
            designImg = null;
            if (f && ["image/png", "image/jpeg", "image/webp"].indexOf(f.type) !== -1 && f.size > 0 && f.size <= 5 * 1024 * 1024) {
                designUrl = URL.createObjectURL(f);
                loadImg(designUrl).then(function (im) { designImg = im; render(); });
                render();
            } else render();
        });
        item.addEventListener("change", render);
        new MutationObserver(render).observe(picker, { childList: true, subtree: true });
        picker.addEventListener("change", render);
        render();
    })();
</script>

<button type="button" class="addcart" id="addToCart">+ Add to Cart</button>
<div class="avuna-cart" id="cartPanel" aria-live="polite">
  <h3>Your Cart (<span id="cartCount">0</span>)</h3>
  <div id="cartList"><p class="avuna-cart-empty">Your cart is empty. Fill in the form above and press &ldquo;Add to Cart&rdquo; to order several items at once.</p></div>
  <div class="avuna-cart-total" id="cartTotalRow" style="display:none"><span>CART TOTAL</span><strong id="cartTotal">R 0.00</strong></div>
</div>
<input type="hidden" id="checkoutPayload" name="checkoutPayload" />
<input type="hidden" id="checkoutSubmit" name="checkoutSubmit" value="" />
<input type="hidden" id="checkoutIntent" name="checkoutIntent" value="later" />
<button type="submit" class="submit" id="submitOrder">Submit Order</button>
<div id="orderMessage" class="feedback" role="alert" aria-live="polite"></div>
<div id="choosePaymentOverlay" class="avuna-confirm-overlay" role="presentation" style="display:none">
 <div class="avuna-confirm-dialog" role="dialog" aria-modal="true" aria-labelledby="choosePaymentTitle">
  <h2 id="choosePaymentTitle">How would you like to pay?</h2>
  <p>Your order will be saved and stock deducted when you select an option.</p>
  <p class="avuna-confirm-muted">Pay Later keeps your order Pending. Pay Now opens the payment page after saving.</p>
  <div class="avuna-choose-buttons"><button type="button" id="payLaterChoice">Pay Later</button><button type="button" id="payNowChoice">Pay Now</button></div>
  <button type="button" class="avuna-cancel-choice" id="cancelPaymentChoice">Cancel</button>
 </div>
</div>
<%= ServerFeedbackHtml %>
</div>
<div class="panel"><span class="tag">ORDER OVERVIEW</span><h2>Order Summary</h2><p class="muted">Quotation based on current database inventory.</p>
<div id="summaryCartBlock" style="display:none">
<div class="quote-head"><h3>Items in your order</h3></div>
<div id="summaryCartList"></div>
</div>
<div class="quote-head" id="summaryCurrentHead" style="display:none"><h3>Item you are adding</h3></div>
<div class="rowline"><span>Item</span><strong id="summaryItem">Not selected</strong></div>
<div class="rowline"><span>Size</span><strong id="summarySize">Not selected</strong></div>
<div class="rowline"><span>Colours</span><strong id="summaryColour">Not selected</strong></div>
<div class="rowline"><span>Quantity</span><strong id="summaryQuantity">-</strong></div>
<div class="rowline"><span>Design package</span><strong id="summaryPackage">Not selected</strong></div>
<div class="rowline"><span>Design file</span><strong id="summaryDesign">Not uploaded</strong></div>
<div class="quote-head"><h3>Your Quotation</h3><div class="quote-actions"><button type="button" class="qbtn" id="printQuote" title="Print the quotation or save it as a PDF">Print / PDF</button><button type="button" class="qbtn qbtn-alt" id="emailQuote" title="Send the quotation to the email address on your profile">Email me</button></div></div>
<div id="quoteMessage" class="quote-msg" role="status" aria-live="polite"></div>
<div class="rowline"><span>Unit cost(s)</span><strong id="quoteUnit">R 0.00</strong></div>
<div class="rowline"><span>Item cost (quantity × unit cost)</span><strong id="quoteItemCost">R 0.00</strong></div>
<div class="rowline"><span id="quoteFeeLabel">Design fee (once)</span><strong id="quoteFee">R 0.00</strong></div>
<div class="rowline"><span>Amount before VAT</span><strong id="quoteBeforeVat">R 0.00</strong></div>
<div class="rowline"><span>VAT (15%)</span><strong id="quoteVat">R 0.00</strong></div>
<div class="rowline"><span>Subtotal including VAT</span><strong id="quoteSubtotal">R 0.00</strong></div>
<div class="rowline"><span>Markup (10% after VAT)</span><strong id="quoteMarkup">R 0.00</strong></div>
<div class="total"><span id="quoteTotalLabel">ESTIMATED ORDER TOTAL</span><strong id="quoteTotal">R 0.00</strong></div>
</div></div></div></div>
<script>
    (function () {
        "use strict";
        var records = <%= InventoryJson %>;
        var fees = { Bronze: 15000, Silver: 25000, Gold: 35000, Platinum: 40000 };
        var currentPackage = "";
        var designColours = 0, designAnalysing = false, designToken = 0;   // colours found in the uploaded design
        var colourQuantities = {};
        var previewUrl = null;
        function el(id) { return document.getElementById(id); }
        var item = el("itemName"), size = el("itemSize"), qty = el("quantity"),
            picker = el("colourPicker"), file = el("designFile"), preview = el("designPreview"),
            feedback = el("orderMessage"), submit = el("submitOrder");
        function money(cents) { return "R " + (cents / 100).toLocaleString("en-ZA", { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }
        function fill(select, values, prompt) {
            select.replaceChildren(new Option(prompt, ""));
            values.forEach(function (v) { select.add(new Option(v, v)); });
            select.disabled = values.length === 0;
        }
        function variants() { return records.filter(function (v) { return v.item === item.value && v.stock > 0; }); }
        function availableColours() {
            var map = new Map();
            variants().filter(function (v) { return v.size === size.value; }).forEach(function (v) {
                var entry = map.get(v.colour);
                if (!entry) map.set(v.colour, { colour: v.colour, stock: v.stock, unitCents: v.unitCents, conflict: false });
                else { entry.stock += v.stock; if (entry.unitCents !== v.unitCents) entry.conflict = true; }
            });
            return Array.from(map.values()).sort(function (a, b) { return a.colour.localeCompare(b.colour); });
        }
        function selections() {
            return availableColours().filter(function (v) { return Object.prototype.hasOwnProperty.call(colourQuantities, v.colour); })
                .map(function (v) {
                    var raw = String(colourQuantities[v.colour]), n = Number(raw);
                    return {
                        colour: v.colour, stock: v.stock, unitCents: v.unitCents, conflict: v.conflict, raw: raw,
                        quantity: n, valid: raw.trim() !== "" && Number.isSafeInteger(n) && n >= 1 && n <= v.stock
                    };
                });
        }
        function packageFor(n) { return n >= 4 ? "Platinum" : n === 3 ? "Gold" : n === 2 ? "Silver" : n === 1 ? "Bronze" : ""; }
        // Colours that decide the design package: those found in the design image (falls back to garment colours).
        function pkgCount(chosenLen) { return designColours > 0 ? designColours : chosenLen; }
        function clearFeedback() { feedback.className = "feedback"; feedback.replaceChildren(); }
        function errorsDisplay(errors) {
            feedback.replaceChildren(); feedback.className = "feedback error";
            var title = document.createElement("strong"); title.textContent = "Please correct the following:"; feedback.appendChild(title);
            var list = document.createElement("ul"); errors.forEach(function (e) { var li = document.createElement("li"); li.textContent = e; list.appendChild(li); }); feedback.appendChild(list);
            feedback.scrollIntoView({ behavior: "smooth", block: "nearest" });
        }
        function renderColours() {
            picker.replaceChildren();
            var colours = availableColours();
            if (!colours.length) {
                var hint = document.createElement("span"); hint.className = "hint";
                hint.textContent = size.value ? "No colours currently available for this item and size." : "Select an item and size first.";
                picker.appendChild(hint); return;
            }
            colours.forEach(function (v) {
                var line = document.createElement("div"); line.className = "colour-option";
                var label = document.createElement("label"), cb = document.createElement("input");
                cb.type = "checkbox"; cb.checked = Object.prototype.hasOwnProperty.call(colourQuantities, v.colour);
                label.appendChild(cb); label.appendChild(document.createTextNode(v.colour)); line.appendChild(label);
                var number = document.createElement("input"); number.type = "number"; number.min = "1"; number.step = "1";
                number.placeholder = "Quantity"; number.disabled = !cb.checked; number.value = cb.checked ? colourQuantities[v.colour] : "";
                number.setAttribute("aria-label", v.colour + " quantity");
                cb.addEventListener("change", function () { if (cb.checked) colourQuantities[v.colour] = "1"; else delete colourQuantities[v.colour]; renderColours(); update(); clearFeedback(); });
                number.addEventListener("input", function () { colourQuantities[v.colour] = number.value; update(); clearFeedback(); });
                line.appendChild(number); picker.appendChild(line);
            });
        }
        function update() {
            var chosen = selections(), valid = chosen.length > 0 && chosen.every(function (v) { return v.valid && !v.conflict; });
            currentPackage = packageFor(pkgCount(chosen.length));
            var sum = chosen.reduce(function (n, v) { return n + (Number.isSafeInteger(v.quantity) && v.quantity > 0 ? v.quantity : 0); }, 0);
            qty.value = chosen.length ? String(sum) : "";
            el("summaryItem").textContent = item.value || "Not selected";
            el("summarySize").textContent = size.value || "Not selected";
            el("summaryColour").textContent = chosen.length ? chosen.map(function (v) { return v.colour + " (" + (v.raw || "0") + ")"; }).join(", ") : "Not selected";
            el("summaryQuantity").textContent = chosen.length ? String(sum) : "-";
            el("summaryPackage").textContent = designAnalysing ? "Analysing design..." : (currentPackage || "Awaiting design");
            el("detectedPackage").textContent = designAnalysing ? "Analysing the colours in your design..." :
                !file.files.length ? "Upload your design to calculate the package" :
                designColours > 0 ? currentPackage + " \u2014 " + money(fees[currentPackage]) + " (" + designColours + (designColours >= 4 ? "+" : "") + " colour" + (designColours === 1 ? "" : "s") + " found in your design)" :
                currentPackage ? currentPackage + " \u2014 " + money(fees[currentPackage]) + " (design colours could not be read; based on garment colours)" : "Select colours to calculate the package";
            el("summaryDesign").textContent = file.files.length ? file.files[0].name : "Not uploaded";
            var stock = el("stockMessage"); stock.className = "stock" + (valid ? "" : " warn");
            stock.textContent = !size.value ? "Select an item and size first." : !chosen.length ? "Choose at least one available colour and its quantity." :
                !valid ? "One or more quantities are invalid or exceed current available stock." : "Your selected quantities fit the most recently loaded inventory. Stock is checked again when submitting.";
            var cur = valid ? calc(chosen, pkgCount(chosen.length)) : null;
            var parts = cart.map(function (c) { return c.calc; }).concat(cur ? [cur] : []);
            function tot(k) { return parts.reduce(function (n, p) { return n + p[k]; }, 0); }
            var priceList = Array.from(new Set(cart.reduce(function (a, c) { return a.concat(c.calc.units); }, []).concat(cur ? cur.units : [])));
            el("quoteUnit").textContent = priceList.length ? priceList.map(money).join(" / ") : money(0);
            el("quoteFeeLabel").textContent = parts.length > 1 ? "Design fees (once per item)" : "Design fee (once)";
            el("quoteTotalLabel").textContent = parts.length > 1 ? "ESTIMATED TOTAL (" + parts.length + " ITEMS)" : "ESTIMATED ORDER TOTAL";
            [["quoteItemCost", tot("cost")], ["quoteFee", tot("fee")], ["quoteBeforeVat", tot("before")], ["quoteVat", tot("vat")], ["quoteSubtotal", tot("subtotal")], ["quoteMarkup", tot("total") - tot("subtotal")], ["quoteTotal", tot("total")]].forEach(function (row) { el(row[0]).textContent = money(row[1]); });
            el("summaryCurrentHead").style.display = cart.length ? "" : "none";
            renderSummaryCart();
        }
        function calc(chosen, n) {
            var cost = chosen.reduce(function (n, v) { return n + v.quantity * v.unitCents; }, 0);
            var fee = fees[packageFor(n)], before = cost + fee, vat = Math.round(before * .15), subtotal = before + vat;
            return { cost: cost, fee: fee, before: before, vat: vat, subtotal: subtotal, total: Math.round(subtotal * 1.1),
                     units: Array.from(new Set(chosen.map(function (v) { return v.unitCents; }))) };
        }
        function renderSummaryCart() {
            var box = el("summaryCartList");
            box.replaceChildren();
            el("summaryCartBlock").style.display = cart.length ? "" : "none";
            cart.forEach(function (c, i) {
                var card = document.createElement("details"); card.className = "cart-sum-item";
                var h = document.createElement("summary");
                var hl = document.createElement("span"); hl.textContent = (i + 1) + ". " + c.req.item + " (" + c.req.size + ") \u00B7 " + c.qty + " pcs";
                var hr = document.createElement("strong"); hr.textContent = money(c.calc.total);
                h.appendChild(hl); h.appendChild(hr); card.appendChild(h);
                [["Item", c.req.item], ["Size", c.req.size], ["Colours", c.colourText], ["Quantity", String(c.qty)],
                 ["Design package", c.pkg], ["Design file", c.file.name],
                 ["Unit cost(s)", c.calc.units.map(money).join(" / ")], ["Item cost", money(c.calc.cost)],
                 ["Design fee", money(c.calc.fee)], ["Item total (incl. VAT & markup)", money(c.calc.total)]].forEach(function (r) {
                    var row = document.createElement("div"); row.className = "rowline";
                    var l = document.createElement("span"); l.textContent = r[0];
                    var v = document.createElement("strong"); v.textContent = r[1];
                    row.appendChild(l); row.appendChild(v); card.appendChild(row);
                });
                box.appendChild(card);
            });
        }
        function refreshSizes() {
            var sizes = Array.from(new Set(variants().map(function (v) { return v.size; }))).sort();
            fill(size, sizes, item.value ? "Select a size" : "Select an item first");
            colourQuantities = {}; renderColours(); update();
        }
        item.addEventListener("change", function () { refreshSizes(); clearFeedback(); });
        size.addEventListener("change", function () { colourQuantities = {}; renderColours(); update(); clearFeedback(); });
        file.addEventListener("change", function () {
            if (previewUrl) { URL.revokeObjectURL(previewUrl); previewUrl = null; }
            preview.style.display = "none"; preview.removeAttribute("src");
            var f = file.files[0];
            if (f && ["image/png", "image/jpeg", "image/webp"].includes(f.type) && f.size > 0 && f.size <= 5 * 1024 * 1024) {
                previewUrl = URL.createObjectURL(f); preview.src = previewUrl; preview.style.display = "block";
            }
            designColours = 0; designAnalysing = false; designToken++;
            if (f && ["image/png", "image/jpeg", "image/webp"].includes(f.type) && f.size > 0 && f.size <= 5 * 1024 * 1024) {
                var token = designToken, fd = new FormData();
                designAnalysing = true;
                fd.append("avunaAction", "analyzeDesign"); fd.append("designFile", f, f.name);
                fetch(window.location.pathname + window.location.search, {
                    method: "POST", credentials: "same-origin", headers: { "X-Requested-With": "XMLHttpRequest" }, body: fd
                }).then(function (r) { return r.json(); })
                    .then(function (j) { if (token === designToken) { designColours = (j && j.ok) ? (j.colours || 0) : 0; } })
                    .catch(function () { if (token === designToken) designColours = 0; })
                    .then(function () { if (token === designToken) { designAnalysing = false; update(); } });
            }
            update(); clearFeedback();
        });
        var submissionInProgress = false;
        var cart = [];
        function totalFor(chosen, n) { return calc(chosen, n).total; }
        function isFormBlank() {
            return !item.value && !file.files.length;
        }
        // Validates the form; returns { errors, line } where line is a cart entry when valid.
        function currentLine() {
            var errors = [], chosen = selections(), f = file.files[0];
            if (!item.value || !variants().length) errors.push("Select an available item.");
            if (!size.value || !variants().some(function (v) { return v.size === size.value; })) errors.push("Select an available size.");
            if (!chosen.length) errors.push("Select at least one colour.");
            chosen.forEach(function (v) {
                if (v.conflict) errors.push("Multiple prices exist for " + v.colour + ". Please contact staff.");
                if (v.raw.trim() === "" || !Number.isSafeInteger(v.quantity) || v.quantity < 1) errors.push("Enter a positive whole-number quantity for " + v.colour + ".");
                else if (v.quantity > v.stock) errors.push("The requested quantity of " + v.colour + " is not available.");
            });
            if (designAnalysing) errors.push("Please wait a moment while your design is analysed.");
            if (!f) errors.push("Upload a design image.");
            else if (!["image/png", "image/jpeg", "image/webp"].includes(f.type) || f.size <= 0 || f.size > 5 * 1024 * 1024) errors.push("Upload a non-empty PNG, JPG, JPEG or WEBP image up to 5 MB.");
            if (errors.length) return { errors: errors };
            return {
                errors: [],
                line: {
                    req: { item: item.value, size: size.value, colours: chosen.map(function (v) { return { colour: v.colour, quantity: v.quantity }; }), designFileName: f.name, designColours: designColours },
                    file: f, totalCents: totalFor(chosen, pkgCount(chosen.length)), calc: calc(chosen, pkgCount(chosen.length)),
                    qty: chosen.reduce(function (n, v) { return n + v.quantity; }, 0),
                    colourText: chosen.map(function (v) { return v.colour + " x" + v.quantity; }).join(", "),
                    pkg: packageFor(pkgCount(chosen.length)), designColours: designColours
                }
            };
        }
        function renderCart() {
            var list = el("cartList");
            list.replaceChildren();
            el("cartCount").textContent = String(cart.length);
            if (!cart.length) {
                var p = document.createElement("p"); p.className = "avuna-cart-empty";
                p.textContent = "Your cart is empty. Fill in the form above and press \u201CAdd to Cart\u201D to order several items at once.";
                list.appendChild(p); el("cartTotalRow").style.display = "none"; return;
            }
            cart.forEach(function (c, i) {
                var row = document.createElement("div"); row.className = "avuna-cart-row";
                var info = document.createElement("div");
                var strong = document.createElement("strong"); strong.textContent = (i + 1) + ". " + c.req.item + " (" + c.req.size + ") \u2014 " + c.qty + " pcs";
                var small = document.createElement("small"); small.textContent = c.colourText + " \u00B7 " + c.pkg + " design \u00B7 " + c.file.name;
                info.appendChild(strong); info.appendChild(small);
                var right = document.createElement("div"); right.style.textAlign = "right";
                var price = document.createElement("div"); price.textContent = money(c.totalCents); price.style.fontWeight = "800";
                var rm = document.createElement("button"); rm.type = "button"; rm.textContent = "Remove";
                rm.addEventListener("click", function () { cart.splice(i, 1); renderCart(); update(); clearFeedback(); });
                right.appendChild(price); right.appendChild(rm);
                row.appendChild(info); row.appendChild(right); list.appendChild(row);
            });
            el("cartTotal").textContent = money(cart.reduce(function (n, c) { return n + c.totalCents; }, 0));
            el("cartTotalRow").style.display = "flex";
        }
        function resetForm() {
            item.value = ""; refreshSizes();
            file.value = ""; designColours = 0; designAnalysing = false; designToken++;
            if (previewUrl) { URL.revokeObjectURL(previewUrl); previewUrl = null; }
            preview.style.display = "none"; preview.removeAttribute("src");
            update();
        }
        function addCurrentToCart() {
            var r = currentLine();
            if (r.errors.length) { errorsDisplay(r.errors); return false; }
            if (cart.length >= 10) { errorsDisplay(["You can order up to 10 items at once."]); return false; }
            cart.push(r.line); clearFeedback(); resetForm(); renderCart(); update();
            return true;
        }
        el("addToCart").addEventListener("click", function () { addCurrentToCart(); });
        submit.addEventListener("click", function (event) {
            event.preventDefault();
            if (submissionInProgress) return;
            // A filled-in form is added to the cart automatically; a blank form just uses the cart.
            if (!isFormBlank() || !cart.length) { if (!addCurrentToCart()) return; }
            if (!cart.length) { errorsDisplay(["Your cart is empty."]); return; }
            el("choosePaymentOverlay").style.display = "flex";
        });
        function finishOrder(intent) {
            if (submissionInProgress || !cart.length) return;
            submissionInProgress = true;
            el("choosePaymentOverlay").style.display = "none";
            submit.disabled = true;
            submit.textContent = "Saving your order" + (cart.length > 1 ? "s" : "") + "...";
            var fd = new FormData();
            fd.append("avunaAction", "cartCheckout");
            fd.append("checkoutIntent", intent);
            fd.append("cart", JSON.stringify(cart.map(function (c) { return c.req; })));
            cart.forEach(function (c, i) { fd.append("designFile" + i, c.file, c.file.name); });
            function fail(msg) {
                submissionInProgress = false; submit.disabled = false; submit.textContent = "Submit Order";
                errorsDisplay([msg]);
            }
            fetch(window.location.pathname + window.location.search, {
                method: "POST", credentials: "same-origin",
                headers: { "X-Requested-With": "XMLHttpRequest" }, body: fd
            }).then(function (r) { return r.json(); })
                .then(function (j) {
                    if (j && j.ok && j.redirect) { window.location.href = j.redirect; }
                    else fail((j && j.message) || "Your orders were not saved. Please try again.");
                })
                .catch(function () { fail("Could not reach the server. Nothing was saved. Please check your connection and try again."); });
        }
        el("payLaterChoice").addEventListener("click", function () { finishOrder("later"); });
        el("payNowChoice").addEventListener("click", function () { finishOrder("now"); });
        el("cancelPaymentChoice").addEventListener("click", function () { el("choosePaymentOverlay").style.display = "none"; });
        // ---- Print / save as PDF and email the quotation ----
        var quoteMsg = el("quoteMessage");
        function showQuoteMessage(text, ok) { quoteMsg.textContent = text; quoteMsg.className = "quote-msg " + (ok ? "ok" : "bad"); }
        // Items covered by the quotation: everything in the cart plus the item on the form (when it is valid).
        function quoteSelection() {
            var lines = cart.map(function (c) {
                return { item: c.req.item, size: c.req.size, pkg: c.pkg, designColours: c.designColours,
                         colours: c.req.colours.map(function (x) { return { colour: x.colour, quantity: x.quantity, unitCents: unitFor(c.req.item, c.req.size, x.colour) }; }),
                         calc: c.calc };
            });
            var chosen = selections();
            var formValid = item.value && size.value && chosen.length && chosen.every(function (v) { return v.valid && !v.conflict; });
            if (formValid) {
                lines.push({ item: item.value, size: size.value, pkg: packageFor(pkgCount(chosen.length)), designColours: designColours,
                             colours: chosen.map(function (v) { return { colour: v.colour, quantity: v.quantity, unitCents: v.unitCents }; }),
                             calc: calc(chosen, pkgCount(chosen.length)) });
            } else if (!lines.length) {
                showQuoteMessage("Choose an item, size, colours and quantities first (or add items to your cart), so there is a quotation to print or email.", false);
                return null;
            }
            quoteMsg.className = "quote-msg";
            return lines;
        }
        function unitFor(it, sz, col) {
            var m = records.filter(function (v) { return v.item === it && v.size === sz && v.colour === col; })[0];
            return m ? m.unitCents : 0;
        }
        function esc(s) { return String(s).replace(/[&<>"']/g, function (c) { return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]; }); }
        function printDocument(lines) {
            var logo = new URL("<%= ResolveUrl("~/avuna-logo.png") %>", window.location.href).href;
            var today = new Date().toLocaleDateString("en-ZA", { day: "numeric", month: "long", year: "numeric" });
            var itemSections = lines.map(function (l, i) {
                var rows = l.colours.map(function (v) {
                    return "<tr><td>" + esc(v.colour) + "</td><td class='r'>" + v.quantity + "</td><td class='r'>" + esc(money(v.unitCents)) + "</td><td class='r'>" + esc(money(v.unitCents * v.quantity)) + "</td></tr>";
                }).join("");
                var qtyTotal = l.colours.reduce(function (n, v) { return n + v.quantity; }, 0);
                return "<h2>" + (lines.length > 1 ? "ITEM " + (i + 1) + " \u2013 " : "") + "ORDER DETAILS</h2><table class='k'><tr><td>Item</td><td>" + esc(l.item) + "</td></tr><tr><td>Size</td><td>" + esc(l.size) + "</td></tr>" +
                    "<tr><td>Design package</td><td>" + esc(l.pkg) + "</td></tr><tr><td>Total quantity</td><td>" + qtyTotal + "</td></tr>" +
                    (lines.length > 1 ? "<tr><td>Item total</td><td>" + esc(money(l.calc.total)) + "</td></tr>" : "") + "</table>" +
                    "<table style='margin-top:10px'><thead><tr><th>COLOUR</th><th class='r'>QTY</th><th class='r'>UNIT COST</th><th class='r'>TOTAL</th></tr></thead><tbody>" + rows + "</tbody></table>";
            }).join("");
            function line(label, id, strong) { return "<tr" + (strong ? " class='s'" : "") + "><td>" + label + "</td><td class='r'>" + esc(el(id).textContent) + "</td></tr>"; }
            return "<!DOCTYPE html><html><head><meta charset='utf-8'><title>Avuna Collective quotation</title><style>" +
                "@page{margin:16mm}*{box-sizing:border-box}body{font-family: var(--av-sans);color:#1b2a22;margin:0;font-size:13px}" +
                ".head{display:flex;align-items:center;gap:16px;border-bottom:3px solid #c49a45;padding-bottom:14px;margin-bottom:20px}" +
                ".head img{width:70px;height:70px;border-radius:50%;border:2px solid #c49a45;object-fit:contain}" +
                ".head h1{margin:0;font-size:24px;color:#0f2a1f}.head p{margin:3px 0 0;color:#6c736d;font-size:12px;letter-spacing:2px;font-weight:bold}.head .d{margin-left:auto;text-align:right;color:#6b6055;font-size:12px}" +
                "h2{font-size:12px;letter-spacing:1.5px;color:#6c736d;margin:22px 0 8px}table{width:100%;border-collapse:collapse}" +
                "td,th{padding:9px 10px;border-bottom:1px solid #e5dccd;text-align:left}th{background:#f5efe6;color:#6c736d;font-size:11px;letter-spacing:1px}.r{text-align:right}" +
                ".k td:first-child{color:#6c736d;width:38%}.k td:last-child{font-weight:bold}.s td{font-weight:bold}" +
                ".total{margin-top:18px;background:#0f2a1f;color:#fff;border-radius:10px;padding:16px 20px;display:flex;justify-content:space-between;align-items:center;-webkit-print-color-adjust:exact;print-color-adjust:exact}" +
                ".total small{color:#cfc9a0;letter-spacing:1.5px;font-size:11px}.total strong{color:#8a6a35;font-size:26px}" +
                ".note{margin-top:20px;color:#6c736d;font-size:11px;line-height:1.6}.foot{margin-top:26px;padding-top:12px;border-top:1px solid #e5dccd;text-align:center;color:#6c736d;font-size:11px}" +
                "</style></head><body>" +
                "<div class='head'><img src='" + esc(logo) + "' alt='Avuna Collective'><div><h1>Avuna Collective</h1><p>QUOTATION</p></div><div class='d'>Date<br><strong>" + esc(today) + "</strong></div></div>" +
                itemSections +
                "<h2>QUOTATION</h2><table class='k'>" + line("Item cost (quantity &times; unit cost)", "quoteItemCost") + line(esc(el("quoteFeeLabel").textContent), "quoteFee") + line("Amount before VAT", "quoteBeforeVat") +
                line("VAT (15%)", "quoteVat") + line("Subtotal including VAT", "quoteSubtotal") + line("Markup (10% after VAT)", "quoteMarkup") + "</table>" +
                "<div class='total'><small>" + esc(el("quoteTotalLabel").textContent) + "</small><strong>" + esc(el("quoteTotal").textContent) + "</strong></div>" +
                "<p class='note'>This is an estimate based on current inventory and prices. Stock is checked again when the order is submitted, so the final amount may change if stock or prices change.</p>" +
                "<div class='foot'>Avuna Collective &middot; 127 Victoria Embankment, Astron Garage, Durban</div></body></html>";
        }
        el("printQuote").addEventListener("click", function () {
            var chosen = quoteSelection();
            if (!chosen) return;
            var frame = document.createElement("iframe");
            frame.setAttribute("aria-hidden", "true");
            frame.style.cssText = "position:fixed;right:0;bottom:0;width:0;height:0;border:0";
            document.body.appendChild(frame);
            var doc = frame.contentWindow.document;
            doc.open(); doc.write(printDocument(chosen)); doc.close();
            var started = false;
            function go() {
                if (started) return; started = true;
                try { frame.contentWindow.focus(); frame.contentWindow.print(); } catch (e) { showQuoteMessage("Printing is not available in this browser.", false); }
                setTimeout(function () { if (frame.parentNode) frame.parentNode.removeChild(frame); }, 60000);
            }
            var img = doc.querySelector("img");
            if (img && !img.complete) { img.onload = go; img.onerror = go; setTimeout(go, 2000); } else { go(); }
        });
        el("emailQuote").addEventListener("click", function () {
            var chosen = quoteSelection();
            if (!chosen) return;
            var btn = this, label = btn.textContent;
            btn.disabled = true; btn.textContent = "Sending...";
            var body = new URLSearchParams();
            body.set("avunaAction", "emailQuote");
            body.set("payload", JSON.stringify(chosen.map(function (l) { return { item: l.item, size: l.size, designColours: l.designColours || 0, colours: l.colours.map(function (v) { return { colour: v.colour, quantity: v.quantity }; }) }; })));
            fetch(window.location.pathname + window.location.search, {
                method: "POST", credentials: "same-origin",
                headers: { "X-Requested-With": "XMLHttpRequest", "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
                body: body.toString()
            }).then(function (r) { return r.json(); })
                .then(function (j) { showQuoteMessage(j.message, !!j.ok); })
                .catch(function () { showQuoteMessage("The quotation could not be emailed right now. Please try Print / PDF instead.", false); })
                .then(function () { btn.disabled = false; btn.textContent = label; });
        });
        window.addEventListener("pageshow", function (e) {
            if (e.persisted) {
                submissionInProgress = false;
                if (records.length) { submit.disabled = false; submit.textContent = "Submit Order"; }
            }
        });
        if (records.length) {
            var unique = Array.from(new Set(records.map(function (v) { return v.item; }))).sort();
            fill(item, unique, "Select an item"); refreshSizes();
            submit.disabled = false;
        } else {
            item.disabled = true; size.disabled = true; submit.disabled = true;
            el("stockMessage").textContent = "Inventory could not be loaded. Please try again.";
        }
    })();
</script>
</asp:Content>

