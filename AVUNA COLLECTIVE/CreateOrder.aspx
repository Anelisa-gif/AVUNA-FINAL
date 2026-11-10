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
/* Confirmation popup displayed after successful database commit /
.avuna-confirm-overlay{position:fixed;inset:0;z-index:2147483000;background:rgba(0,0,0,.66);display:flex;align-items:center;justify-content:center;padding:20px}
.avuna-confirm-dialog{box-sizing:border-box;background:#fff;color:#202020;border-radius:18px;box-shadow:0 22px 70px #0006;text-align:center;width:min(100%,440px);padding:36px 28px;font-family:Arial,sans-serif}
.avuna-confirm-icon{width:66px;height:66px;border-radius:50%;background:#e7f8eb;color:#24733d;margin:0 auto 18px;display:flex;align-items:center;justify-content:center;font-size:34px;font-weight:900}
.avuna-confirm-dialog h2{font-size:25px;color:#132c22;margin:0 0 12px}
.avuna-confirm-dialog p{line-height:1.6;font-size:15px;margin:8px 0;overflow-wrap:anywhere}
.avuna-confirm-muted{color:#666}
.avuna-confirm-close{margin-top:20px;border:0;background:#f47b20;color:#fff;border-radius:10px;padding:13px 36px;font-size:15px;font-weight:700;cursor:pointer}
.avuna-confirm-close:hover,.avuna-confirm-close:focus{background:#d9650e}
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
<div class="field"><label for="designFile">UPLOAD YOUR DESIGN </label><div class="upload"><div class="upload-icon">&#8682;</div><strong>Upload your custom design</strong><p class="hint">PNG, JPG, JPEG or WEBP, maximum 5 MB</p><input type="file" id="designFile" name="designFile" accept=".png,.jpg,.jpeg,.webp,image/png,image/jpeg,image/webp" /><img id="designPreview" alt="Uploaded design preview" /></div></div>
<input type="hidden" id="checkoutPayload" name="checkoutPayload" />
<input type="hidden" id="checkoutSubmit" name="checkoutSubmit" value="" />
<button type="submit" class="submit" id="submitOrder">Submit Order</button>
<div id="orderMessage" class="feedback" role="alert" aria-live="polite"></div>
<%= ServerFeedbackHtml %>
</div>
<div class="panel"><span class="tag">ORDER OVERVIEW</span><h2>Order Summary</h2><p class="muted">Quotation based on current database inventory.</p>
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
<div class="note">Inventory and prices are retrieved from GroupWst2 using the normal page load. The design package is based on the number of selected garment colours. Submitting saves your pending order and uploaded design. Stock is checked again before saving, and available inventory quantities are deducted when the order is successfully submitted.</div>
</div></div></div></div>
<script>
    (function () {
        "use strict";
        var records = <%= InventoryJson %>;
        var fees = { Bronze: 15000, Silver: 25000, Gold: 35000, Platinum: 40000 };
        var currentPackage = "";
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
            currentPackage = packageFor(chosen.length);
            var sum = chosen.reduce(function (n, v) { return n + (Number.isSafeInteger(v.quantity) && v.quantity > 0 ? v.quantity : 0); }, 0);
            qty.value = chosen.length ? String(sum) : "";
            el("summaryItem").textContent = item.value || "Not selected";
            el("summarySize").textContent = size.value || "Not selected";
            el("summaryColour").textContent = chosen.length ? chosen.map(function (v) { return v.colour + " (" + (v.raw || "0") + ")"; }).join(", ") : "Not selected";
            el("summaryQuantity").textContent = chosen.length ? String(sum) : "-";
            el("summaryPackage").textContent = currentPackage || "Awaiting colours";
            el("detectedPackage").textContent = currentPackage ? currentPackage + " — " + money(fees[currentPackage]) : "Select colours to calculate the package";
            el("summaryDesign").textContent = file.files.length ? file.files[0].name : "Not uploaded";
            var stock = el("stockMessage"); stock.className = "stock" + (valid ? "" : " warn");
            stock.textContent = !size.value ? "Select an item and size first." : !chosen.length ? "Choose at least one available colour and its quantity." :
                !valid ? "One or more quantities are invalid or exceed current available stock." : "Your selected quantities fit the most recently loaded inventory. Stock is checked again when submitting.";
            var cost = valid ? chosen.reduce(function (n, v) { return n + v.quantity * v.unitCents; }, 0) : 0;
            var fee = valid ? fees[currentPackage] : 0, before = cost + fee, vat = Math.round(before * .15), subtotal = before + vat, total = Math.round(subtotal * 1.1);
            var priceList = Array.from(new Set(chosen.map(function (v) { return v.unitCents; })));
            el("quoteUnit").textContent = priceList.length ? priceList.map(money).join(" / ") : money(0);
            [["quoteItemCost", cost], ["quoteFee", fee], ["quoteBeforeVat", before], ["quoteVat", vat], ["quoteSubtotal", subtotal], ["quoteMarkup", total - subtotal], ["quoteTotal", total]].forEach(function (row) { el(row[0]).textContent = money(row[1]); });
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
            update(); clearFeedback();
        });
        var submissionInProgress = false;
        submit.addEventListener("click", function (event) {
            // Explicitly submit the ASP.NET form after validation. Disabling a clicked
            // submit button before its default action can cancel the postback.
            event.preventDefault();
            if (submissionInProgress) return;
            var errors = [], chosen = selections(), f = file.files[0];
            if (!item.value || !variants().length) errors.push("Select an available item.");
            if (!size.value || !variants().some(function (v) { return v.size === size.value; })) errors.push("Select an available size.");
            if (!chosen.length) errors.push("Select at least one colour.");
            chosen.forEach(function (v) {
                if (v.conflict) errors.push("Multiple prices exist for " + v.colour + ". Please contact staff.");
                if (v.raw.trim() === "" || !Number.isSafeInteger(v.quantity) || v.quantity < 1) errors.push("Enter a positive whole-number quantity for " + v.colour + ".");
                else if (v.quantity > v.stock) errors.push("The requested quantity of " + v.colour + " is not available.");
            });
            if (!f) errors.push("Upload a design image.");
            else if (!["image/png", "image/jpeg", "image/webp"].includes(f.type) || f.size <= 0 || f.size > 5 * 1024 * 1024) errors.push("Upload a non-empty PNG, JPG, JPEG or WEBP image up to 5 MB.");
            if (errors.length) { event.preventDefault(); errorsDisplay(errors); return; }
            el("checkoutPayload").value = JSON.stringify({
                item: item.value, size: size.value,
                colours: chosen.map(function (v) { return { colour: v.colour, quantity: v.quantity }; }), designFileName: f.name
            });
            el("checkoutSubmit").value = "1";
            var form = submit.closest("form");
            if (!form) {
                errorsDisplay(["The order form could not be found. Please reload the page."]);
                return;
            }
            submissionInProgress = true;
            submit.disabled = true;
            submit.textContent = "Validating and saving order...";
            feedback.className = "feedback";
            feedback.textContent = "";
            // Bypass the disabled button's default action; send a normal Web Forms
            // multipart POST containing the uploaded design and hidden order payload.
            HTMLFormElement.prototype.submit.call(form);
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
