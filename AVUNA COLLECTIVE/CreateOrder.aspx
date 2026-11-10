<%@ Page Title="Create Order" Language="C#" MasterPageFile="~/Customer_master.Master" AutoEventWireup="true" CodeBehind="CreateOrder.aspx.cs" Inherits="AVUNA_COLLECTIVE.CreateOrder" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
.avuna-order{background:#f6f4ef;color:#191919;min-height:100vh;padding-bottom:65px;font-family:Arial,sans-serif}
.avuna-order {box-sizing:border-box}.avuna-order .hero{background:linear-gradient(120deg,#111,#262626);color:white;padding:70px max(5%,30px) 95px;display:flex;justify-content:space-between;align-items:center;gap:20px;position:relative;overflow:hidden}
.avuna-order .hero:before{content:"";position:absolute;width:370px;height:370px;border:60px solid #f47b2014;border-radius:50%;right:-130px;top:-200px}
.avuna-order .hero-copy{position:relative;z-index:1}.avuna-order .eyebrow,.avuna-order .tag{color:#f47b20;font-size:11px;font-weight:800;letter-spacing:2px}
.avuna-order h1{font-size:clamp(40px,5vw,66px);line-height:1.06;letter-spacing:-2px;font-weight:800;margin:20px 0;color:#fff}.avuna-order .hero p{color:#ddd;font-size:16px;line-height:1.8;max-width:640px}
.avuna-order .back{display:inline-block;border:1px solid #777;background:#ffffff12;color:white!important;text-decoration:none;border-radius:10px;padding:13px 20px;font-weight:700;margin-top:12px}
.avuna-order .hero-mark{border:2px solid #b75e1b;border-radius:50%;width:170px;height:170px;flex:none;display:flex;flex-direction:column;justify-content:center;align-items:center;box-shadow:0 0 0 18px #f47b2009;position:relative}
.avuna-order .hero-mark strong{font-size:43px;color:white}.avuna-order .hero-mark small{color:#f47b20;text-align:center;font-size:10px;font-weight:800;letter-spacing:2px}
.avuna-order .wrap{max-width:1280px;width:calc(100% - 40px);margin:-35px auto 0;position:relative;z-index:2}.avuna-order .intro,.avuna-order .panel{background:white;border:1px solid #e9e4dd;border-radius:16px;padding:26px;box-shadow:0 10px 30px #00000010}
.avuna-order .intro{display:flex;justify-content:space-between;align-items:center;margin-bottom:22px}.avuna-order .muted{font-size:13px;color:#777;margin:8px 0}.avuna-order .pill{border-radius:30px;padding:10px 14px;background:#fff0e4;color:#8b6147;font-size:11px;letter-spacing:1px;font-weight:800}
.avuna-order .layout{display:grid;grid-template-columns:minmax(0,1.65fr) minmax(300px,1fr);gap:22px;align-items:start}.avuna-order h2{font-size:24px;font-weight:700;margin:9px 0;color:#171717}.avuna-order h3{font-size:19px;font-weight:700;margin:22px 0 12px}
.avuna-order .fields{display:grid;grid-template-columns:1fr 1fr;gap:0 20px;margin-top:24px}.avuna-order .field{margin-bottom:21px}.avuna-order label{display:block;font-size:11px;font-weight:800;letter-spacing:1px;color:#666;margin-bottom:9px}
.avuna-order select,.avuna-order input[type=number]{width:100%;height:52px;border:1px solid #e5dfd8;border-radius:10px;background:#faf9f7;padding:12px;color:#222;font-size:15px}.avuna-order select:focus,.avuna-order input:focus{outline:2px solid #f47b2080;outline-offset:1px}.avuna-order select:disabled{opacity:.6;cursor:not-allowed}
.avuna-order .auto-package{padding:15px 12px;background:#fff5eb;border:1px solid #f5d9bd;border-radius:10px;color:#8a4b16;font-size:14px;font-weight:700;min-height:52px}.avuna-order .hint{color:#777;font-size:12px;margin:8px 0 0}.avuna-order .stock{font-size:13px;padding:11px 14px;border-radius:9px;background:#f3f6f3;color:#2e6844;margin-bottom:20px}.avuna-order .stock.warn{background:#fff2ec;color:#af4d22}
.avuna-order .upload{border:2px dashed #dcd3ca;border-radius:12px;background:#faf9f7;text-align:center;padding:26px 14px}.avuna-order .upload-icon{font-size:35px;color:#f47b20}.avuna-order .upload strong{display:block;margin:8px 0}.avuna-order .upload input{max-width:100%;margin:14px 0 0}.avuna-order #designPreview{display:none;max-width:100%;max-height:220px;object-fit:contain;margin:18px auto 0;border-radius:9px}
.avuna-order .submit{background:#f47b20;color:#fff;border:0;border-radius:10px;width:100%;padding:16px;font-weight:800;box-shadow:0 8px 22px #f47b2035;cursor:pointer}.avuna-order .submit:hover{background:#d9650e}
.avuna-order .rowline{display:flex;align-items:start;justify-content:space-between;gap:14px;border-bottom:1px solid #eee;padding:14px 0;font-size:14px}.avuna-order .rowline span{color:#777}.avuna-order .rowline strong{text-align:right;overflow-wrap:anywhere}.avuna-order .total{border-radius:12px;background:#191919;color:#fff;padding:22px;margin-top:20px}.avuna-order .total span{color:#bbb;font-size:11px;letter-spacing:1px}.avuna-order .total strong{display:block;color:#f47b20;font-size:30px;margin-top:8px}.avuna-order .note{background:#fff4e9;color:#81542f;padding:15px;border-radius:10px;font-size:12px;line-height:1.6;margin-top:20px}
.avuna-order .colour-picker{background:#faf9f7;border:1px solid #e5dfd8;border-radius:10px;padding:12px;min-height:52px}.avuna-order .colour-option{display:flex;align-items:center;gap:12px;flex-wrap:wrap;padding:10px 6px;border-bottom:1px solid #ece8e2}.avuna-order .colour-option:last-child{border-bottom:0}.avuna-order .colour-option label{display:inline-flex;align-items:center;gap:8px;margin:0;font-size:13px;letter-spacing:0;color:#222;text-transform:none;flex:1;min-width:110px}.avuna-order .colour-option input[type=checkbox]{width:17px;height:17px;accent-color:#f47b20}.avuna-order .colour-option input[type=number]{width:112px;height:42px}.avuna-order input[readonly]{background:#f0eeeb;color:#666}.avuna-order .feedback{margin-top:17px;border-radius:10px;padding:14px;display:none;font-size:13px;line-height:1.7}.avuna-order .feedback.error{display:block;background:#fff0ed;color:#a52c21;border:1px solid #efc7bf}.avuna-order .feedback.success{display:block;background:#edfaef;color:#256339;border:1px solid #b5ddbd}.avuna-order .feedback ul{margin:5px 0 0;padding-left:20px}
@media(max-width:850px){.avuna-order .layout{grid-template-columns:1fr}.avuna-order .hero-mark{display:none}}@media(max-width:550px){.avuna-order .fields{grid-template-columns:1fr}.avuna-order .intro{gap:10px}.avuna-order .pill{font-size:9px}}
</style>
<div class="avuna-order" id="createOrderPage">
<section class="hero"><div class="hero-copy"><div class="eyebrow">AVUNA COLLECTIVE · CUSTOMER PORTAL</div><h1>Your vision,<br />our creation.</h1><p>Choose an item, size and multiple available colours, upload your design and review your quotation.</p><a runat="server" href="~/CustomerDashboard" class="back">Back to Dashboard</a></div><div class="hero-mark"><strong>AV</strong><small>CREATE<br />ORDER</small></div></section>
<div class="wrap"><div class="intro"><div><strong>Create a new order</strong><p class="muted">Your custom order details for AVUNA COLLECTIVE.</p></div><span class="pill">NEW ORDER</span></div>
<div class="layout"><div class="panel"><span class="tag">ORDER DETAILS</span><h2>Customize Your Order</h2><p class="muted">Only available inventory combinations can be selected.</p>
<div class="fields">
<div class="field"><label for="itemName">ITEM NAME </label><select id="itemName"><option value="">Select an item</option></select></div>
<div class="field"><label for="quantity">TOTAL QUANTITY</label><input type="number" id="quantity" min="1" step="1" readonly placeholder="Calculated from colours" /><div class="hint" id="quantityHint">Enter quantities next to the colours you select.</div></div>
<div class="field"><label for="itemSize">SIZE </label><select id="itemSize" disabled><option value="">Select an item first</option></select></div>
<div class="field"><label>COLOURS AND QUANTITIES </label><div id="colourPicker" class="colour-picker"><span class="hint">Select an item and size first.</span></div><p class="hint">Tick each available colour and enter the number of garments for that colour.</p></div>
<div class="field"><label>AUTOMATIC DESIGN PACKAGE</label><div class="auto-package" id="detectedPackage">Select colours to calculate the package</div><p class="hint">1 colour: Bronze · 2: Silver · 3: Gold · 4+: Platinum. Design fee charged once.</p></div>
</div>
<div id="stockMessage" class="stock warn" role="status">Select an item and size, then choose colours and quantities.</div>
<div class="field"><label for="designFile">UPLOAD YOUR DESIGN </label><div class="upload"><div class="upload-icon">&#8682;</div><strong>Upload your custom design</strong><p class="hint">PNG, JPG, JPEG or WEBP, maximum 5 MB</p><input type="file" id="designFile" accept=".png,.jpg,.jpeg,.webp,image/png,image/jpeg,image/webp" /><img id="designPreview" alt="Uploaded design preview" /></div></div>
<button type="button" class="submit" id="submitOrder">Validate Order &amp; Continue to Payment</button><div id="orderMessage" class="feedback" role="alert" aria-live="polite"></div>
</div>
<div class="panel"><span class="tag">ORDER OVERVIEW</span><h2>Order Summary</h2><p class="muted">Live estimate based on the supplied inventory.</p>
<div class="rowline"><span>Item</span><strong id="summaryItem">Not selected</strong></div>
<div class="rowline"><span>Size</span><strong id="summarySize">Not selected</strong></div>
<div class="rowline"><span>Colours</span><strong id="summaryColour">Not selected</strong></div>
<div class="rowline"><span>Quantity</span><strong id="summaryQuantity">-</strong></div>
<div class="rowline"><span>Design package</span><strong id="summaryPackage">Not selected</strong></div>
<div class="rowline"><span>Design file</span><strong id="summaryDesign">Not uploaded</strong></div>
<h3>Your Quotation</h3>
<div class="rowline"><span>Unit cost(s)</span><strong id="quoteUnit">R 0.00</strong></div>
<div class="rowline"><span>Item cost (quantity × unit cost)</span><strong id="quoteItemCost">R 0.00</strong></div>
<div class="rowline"><span>Design fee (once)</span><strong id="quoteFee">R 0.00</strong></div>
<div class="rowline"><span>Amount before VAT</span><strong id="quoteBeforeVat">R 0.00</strong></div>
<div class="rowline"><span>VAT (15%)</span><strong id="quoteVat">R 0.00</strong></div>
<div class="rowline"><span>Subtotal including VAT</span><strong id="quoteSubtotal">R 0.00</strong></div>
<div class="rowline"><span>Markup (10% after VAT)</span><strong id="quoteMarkup">R 0.00</strong></div>
<div class="total"><span>ESTIMATED ORDER TOTAL</span><strong id="quoteTotal">R 0.00</strong></div>
<div class="rowline"><span>Minimum deposit (50%)</span><strong id="quoteDeposit">R 0.00</strong></div>
<div class="note">Demo mode: inventory and prices use the supplied database snapshot. The design package is based on the number of selected garment colours. No order is saved, payment captured or stock reserved.</div>
</div></div></div></div>
<script>
(function () {
"use strict";
// Snapshot of InventoryVariant (Variant_ID, item_ID, size, colour, quantity, unit cost).
// This is NOT a live SQL Server query.
// Canonical product labels: duplicate Inventory item names are grouped.
// E.g. IT4 and IT9 are both Hoodies; IT1 and IT2 are Golf T-Shirts.
var names = {
IT1: "Golf T-Shirts", IT2: "Golf T-Shirts", IT3: "Cap", IT4: "Hoodies", IT5: "Sweaters",
IT6: "Ties", IT7: "V-Neck T-Shirts", IT8: "Varsity Jackets", IT9: "Hoodies",
IT10: "Sunhats", IT11: "Round Neck T-Shirts", IT12: "Plain Jackets", IT13: "V-Neck T-Shirts",
IT14: "Puffer Jackets", IT15: "Raincoats", IT16: "Sweaters", IT17: "Beanies"
};
var records = [
[1, "IT17", "Universal", "Black", 60, 50], [2, "IT3", "One size", "Black", 488, 30],
[3, "IT1", "L", "Brown", 6, 65], [4, "IT14", "M", "Black", 15, 320],
[5, "IT10", "2XL", "White", 36, 40], [6, "IT6", "One size", "Black", 13, 30],
[7, "IT13", "M", "Blue", 700, 60], [8, "IT2", "XS", "White", 46, 90],
[9, "IT2", "M", "White", 46, 90], [10, "IT2", "L", "White", 46, 90],
[11, "IT2", "XL", "White", 46, 90], [12, "IT2", "XXL", "White", 45, 90],
[13, "IT4", "M", "Orange", 99, 170], [14, "IT4", "M", "Black", 99, 170],
[15, "IT4", "XL", "Orange", 99, 170], [16, "IT4", "XL", "Black", 99, 170],
[17, "IT4", "XXL", "Orange", 98, 170], [18, "IT4", "XXL", "Black", 98, 170],
[19, "IT9", "S", "Blue", 168, 170], [20, "IT9", "M", "Blue", 168, 170],
[21, "IT9", "L", "Blue", 168, 170], [22, "IT12", "M", "White", 77, 180],
[23, "IT12", "L", "White", 77, 180], [24, "IT15", "S", "Yellow", 5, 200],
[25, "IT15", "M", "Yellow", 5, 200], [26, "IT15", "L", "Yellow", 4, 200],
[27, "IT15", "XL", "Yellow", 4, 200], [28, "IT11", "M", "White", 270, 65],
[29, "IT11", "L", "White", 270, 65], [30, "IT16", "M", "Purple", 112, 165],
[31, "IT16", "L", "Purple", 111, 165], [32, "IT16", "XL", "Purple", 111, 165],
[33, "IT5", "M", "Orange", 107, 165], [34, "IT5", "XL", "Orange", 107, 165],
[35, "IT5", "XXL", "Orange", 106, 165], [36, "IT7", "S", "White", 230, 60],
[37, "IT7", "M", "White", 230, 60], [38, "IT7", "L", "White", 229, 60],
[39, "IT8", "L", "Blue", 17, 400], [40, "IT8", "XL", "Blue", 17, 400],
[41, "IT8", "XXL", "Blue", 16, 400]
].map(function (r) { return { id: r[0], item: r[1], size: r[2], colour: r[3], stock: r[4], unitCents: Math.round(r[5] * 100) }; });
var fees = { Bronze: 15000, Silver: 25000, Gold: 35000, Platinum: 40000 };
var estimatedPackage = "";
function byId(id) { return document.getElementById(id); }
var item = byId("itemName"), size = byId("itemSize"), qty = byId("quantity"), picker = byId("colourPicker"), file = byId("designFile"), preview = byId("designPreview"), feedback = byId("orderMessage"), previewUrl = null;
var colourQuantities = {};
function money(cents) { return "R " + (cents / 100).toLocaleString("en-ZA", { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }
function fill(select, values, placeholder) { select.replaceChildren(new Option(placeholder, "")); values.forEach(function (v) { select.add(new Option(v.label, v.value)); }); select.disabled = values.length === 0; }
function variants() { return records.filter(function (v) { return names[v.item] === item.value && v.stock > 0; }); }
function availableColours() {
var map = new Map();
variants().filter(function (v) { return v.size === size.value; }).forEach(function (v) {
var current = map.get(v.colour);
if (!current) map.set(v.colour, { colour: v.colour, stock: v.stock, unitCents: v.unitCents, priceConflict: false });
else { current.stock += v.stock; if (current.unitCents !== v.unitCents) current.priceConflict = true; }
});
return Array.from(map.values()).sort(function (a, b) { return a.colour.localeCompare(b.colour); });
}
function selections() {
return availableColours().filter(function (v) { return Object.prototype.hasOwnProperty.call(colourQuantities, v.colour); }).map(function (v) {
var raw = String(colourQuantities[v.colour]);
var n = Number(raw);
return { colour: v.colour, stock: v.stock, unitCents: v.unitCents, priceConflict: v.priceConflict, raw: raw, quantity: n, valid: raw.trim() !== "" && Number.isSafeInteger(n) && n >= 1 && n <= v.stock };
});
}
function packageFor(count) { return count >= 4 ? "Platinum" : count === 3 ? "Gold" : count === 2 ? "Silver" : count === 1 ? "Bronze" : ""; }
function renderColours() {
picker.replaceChildren();
var all = availableColours();
if (!all.length) { var p = document.createElement("span"); p.className = "hint"; p.textContent = size.value ? "No colours in stock for this item and size." : "Select an item and size first."; picker.appendChild(p); return; }
all.forEach(function (v) {
var line = document.createElement("div"); line.className = "colour-option";
var lbl = document.createElement("label"), cb = document.createElement("input"); cb.type = "checkbox"; cb.checked = Object.prototype.hasOwnProperty.call(colourQuantities, v.colour); cb.setAttribute("aria-label", "Select " + v.colour);
lbl.appendChild(cb); lbl.appendChild(document.createTextNode(v.colour)); line.appendChild(lbl);
var number = document.createElement("input"); number.type = "number"; number.min = "1"; number.step = "1"; number.placeholder = "Quantity"; number.disabled = !cb.checked; number.value = cb.checked ? colourQuantities[v.colour] : ""; number.setAttribute("aria-label", v.colour + " quantity");
cb.addEventListener("change", function () { if (cb.checked) colourQuantities[v.colour] = "1"; else delete colourQuantities[v.colour]; renderColours(); update(); clearFeedback(); });
number.addEventListener("input", function () { colourQuantities[v.colour] = number.value; update(); clearFeedback(); });
line.appendChild(number); picker.appendChild(line);
});
}
function setFeedback(errors) { feedback.replaceChildren(); feedback.className = "feedback" + (errors.length ? " error" : " success"); if (errors.length) { var heading = document.createElement("strong"); heading.textContent = "Please correct the following:"; feedback.appendChild(heading); var ul = document.createElement("ul"); errors.forEach(function (e) { var li = document.createElement("li"); li.textContent = e; ul.appendChild(li); }); feedback.appendChild(ul); } else { feedback.textContent = "All product, quantity, image and stock checks passed using the supplied inventory snapshot. Demo only: no order was saved, submitted or reserved."; } }
function clearFeedback() { feedback.className = "feedback"; feedback.replaceChildren(); }
function update() {
var chosen = selections();
var count = chosen.length;
estimatedPackage = packageFor(count);
var valid = chosen.length > 0 && chosen.every(function (v) { return v.valid && !v.priceConflict; });
var sum = chosen.reduce(function (n, v) { return n + (Number.isSafeInteger(v.quantity) && v.quantity > 0 ? v.quantity : 0); }, 0);
qty.value = chosen.length ? String(sum) : "";
byId("summaryItem").textContent = item.value || "Not selected";
byId("summarySize").textContent = size.value || "Not selected";
byId("summaryColour").textContent = chosen.length ? chosen.map(function (v) { return v.colour + " (" + (v.raw || "0") + ")"; }).join(", ") : "Not selected";
byId("summaryQuantity").textContent = chosen.length ? String(sum) : "-";
byId("summaryPackage").textContent = estimatedPackage || "Awaiting colours";
byId("detectedPackage").textContent = estimatedPackage ? estimatedPackage + " — " + money(fees[estimatedPackage]) : "Select colours to calculate the package";
byId("summaryDesign").textContent = file.files.length ? file.files[0].name : "Not uploaded";
var stock = byId("stockMessage"), hint = byId("quantityHint");
if (!size.value) { stock.className = "stock warn"; stock.textContent = "Select an item and size to see available colours."; }
else if (!count) { stock.className = "stock warn"; stock.textContent = "Choose at least one in-stock colour and enter its quantity."; }
else if (!valid) { stock.className = "stock warn"; stock.textContent = "One or more selected colour quantities are invalid or exceed available stock. Correct the quantities shown beside each colour."; }
else { stock.className = "stock"; stock.textContent = "Selected colours and quantities are within the supplied inventory stock limits."; }
hint.textContent = "Total quantity is calculated from the quantities entered for each selected colour.";
var canQuote = valid && estimatedPackage !== "";
var fee = canQuote ? fees[estimatedPackage] : 0;
var itemCost = canQuote ? chosen.reduce(function (n, v) { return n + v.unitCents * v.quantity; }, 0) : 0;
var unitPrices = Array.from(new Set(chosen.map(function (v) { return v.unitCents; })));
byId("quoteUnit").textContent = unitPrices.length ? unitPrices.map(money).join(" / ") : money(0);
var beforeVat = itemCost + fee;
var vat = Math.round(beforeVat * 15 / 100);
var subtotal = beforeVat + vat;
var total = Math.round(subtotal * 110 / 100);
var markup = total - subtotal;
var deposit = Math.round(total / 2);
byId("quoteItemCost").textContent = money(itemCost);
byId("quoteFee").textContent = money(fee);
byId("quoteBeforeVat").textContent = money(beforeVat);
byId("quoteVat").textContent = money(vat);
byId("quoteSubtotal").textContent = money(subtotal);
byId("quoteMarkup").textContent = money(markup);
byId("quoteTotal").textContent = money(total);
byId("quoteDeposit").textContent = money(deposit);
}
function refreshSizes() {
var list = Array.from(new Set(variants().map(function (v) { return v.size; })));
fill(size, list.map(function (s) { return { label: s, value: s }; }), item.value ? "Select a size" : "Select an item first");
colourQuantities = {}; renderColours(); update();
}
var itemNames = Array.from(new Set(records.filter(function (v) { return v.stock > 0; }).map(function (v) { return names[v.item]; }))).sort();
fill(item, itemNames.map(function (name) { return { label: name, value: name }; }), "Select an item");
item.addEventListener("change", function () { refreshSizes(); clearFeedback(); });
size.addEventListener("change", function () { colourQuantities = {}; renderColours(); update(); clearFeedback(); });
file.addEventListener("change", function () {
if (previewUrl) { URL.revokeObjectURL(previewUrl); previewUrl = null; }
preview.style.display = "none"; preview.removeAttribute("src");
var f = file.files[0];
if (f && ["image/png", "image/jpeg", "image/webp"].includes(f.type) && f.size > 0 && f.size <= 5 * 1024 * 1024) {
previewUrl = URL.createObjectURL(f); preview.src = previewUrl; preview.style.display = "block";
}
update(); clearFeedback();
});
byId("submitOrder").addEventListener("click", function () {
var errors = [], chosen = selections(), f = file.files[0];
if (!item.value || !variants().length) errors.push("Select an item that is in stock.");
if (!size.value || !variants().some(function (x) { return x.size === size.value; })) errors.push("Select an available size for this item.");
if (!chosen.length) errors.push("Select at least one available colour.");
chosen.forEach(function (v) {
if (v.priceConflict) errors.push("Different prices were found for " + v.colour + ". This combination needs review.");
if (v.raw.trim() === "" || !Number.isSafeInteger(v.quantity) || v.quantity < 1) errors.push("Enter a positive whole-number quantity for " + v.colour + ".");
else if (v.quantity > v.stock) errors.push("Insufficient stock for " + v.colour + ": requested " + v.quantity + ", but only " + v.stock + " available.");
});
if (!estimatedPackage || !Object.prototype.hasOwnProperty.call(fees, estimatedPackage)) errors.push("The design package could not be calculated. Select at least one colour.");
if (!f) errors.push("Upload your design image.");
else if (!["image/png", "image/jpeg", "image/webp"].includes(f.type) || f.size === 0 || f.size > 5 * 1024 * 1024) errors.push("Upload a non-empty PNG, JPG, JPEG or WEBP image of no more than 5 MB.");
update();
if (errors.length === 0) {
var validSelections = selections();
var priceCents = validSelections.reduce(function (n, v) { return n + v.quantity * v.unitCents; }, 0);
var designFeeCents = fees[estimatedPackage];
var beforeVat = priceCents + designFeeCents;
var vatCents = Math.round(beforeVat * 15 / 100);
var subCents = beforeVat + vatCents;
var totalCents = Math.round(subCents * 110 / 100);
var checkout = {
version: 1, created: Date.now(), item: item.value, size: size.value,
colours: validSelections.map(function (v) { return { colour: v.colour, quantity: v.quantity, unitCents: v.unitCents }; }),
package: estimatedPackage, designFileName: f.name,
itemCostCents: priceCents, designFeeCents: designFeeCents,
beforeVatCents: beforeVat, vatCents: vatCents,
subtotalCents: subCents, markupCents: totalCents - subCents, totalCents: totalCents
};
try {
sessionStorage.setItem("avunaDemoCheckout", JSON.stringify(checkout));
window.location.href = "Payment.aspx";
return;
} catch (e) { errors.push("Could not prepare the payment preview in this browser. Please enable session storage and try again."); }
}
setFeedback(errors); feedback.scrollIntoView({ behavior: "smooth", block: "nearest" });
});
refreshSizes();
})();
</script>
</asp:Content>