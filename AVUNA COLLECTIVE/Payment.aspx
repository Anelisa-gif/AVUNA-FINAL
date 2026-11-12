<%@ Page Title="Pay for Order" Language="C#" MasterPageFile="~/Customer_master.Master" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="AVUNA_COLLECTIVE.Payment" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
.avuna-payment{min-height:82vh;background:#f6f3ed;padding-bottom:70px;font-family: var(--av-sans);color:#242424}.avuna-payment *{box-sizing:border-box}.avuna-payment .hero{background:#171717;color:white;padding:58px max(5%,24px) 85px}.avuna-payment .hero h1{font-size:42px;color:white;margin:8px 0}.avuna-payment .tag{letter-spacing:2px;color:#8a6a35;font-weight:800;font-size:12px}.avuna-payment .container{max-width:960px;margin:-36px auto 0;padding:0 18px;position:relative}.avuna-payment .panel{background:#fbf8f2;border:1px solid #e8e1d8;border-radius:15px;padding:28px;box-shadow:0 12px 26px #0001;margin-bottom:18px}.avuna-payment h2{font-size:22px;color:#173c2c;margin-top:0}.avuna-payment h3{font-size:17px;color:#173c2c;margin:8px 0 15px}.avuna-payment .two{display:grid;grid-template-columns:1fr 1fr;gap:14px}.avuna-payment .choice{border:1px solid #dcd5cc;border-radius:11px;padding:20px;cursor:pointer;display:block;background:#fbf8f2}.avuna-payment .choice.selected{border:2px solid #c49a45;background:#f2e2c9}.avuna-payment .choice input{accent-color:#0f2a1f}.avuna-payment .choice strong{display:block;margin:8px 0}.avuna-payment .choice p{margin:0;font-size:13px;color:#777;line-height:1.6}.avuna-payment .btn{background:#0f2a1f;color:white;border:0;border-radius:10px;padding:15px 24px;font-weight:800;cursor:pointer;width:100%;margin-top:18px;font-size:15px}.avuna-payment .amount{font-size:30px;color:#8a6a35;font-weight:900}.avuna-payment .muted{color:#666;line-height:1.7}.avuna-payment .message{border-radius:9px;background:#f1f7f2;border:1px solid #badcc0;color:#27633a;padding:18px;line-height:1.7}.avuna-payment .error{border-radius:9px;background:#fff2f0;border:1px solid #e6aca6;color:#a02e26;padding:16px;line-height:1.7}.avuna-payment .back{display:inline-block;margin-top:15px;color:#8a6a35;font-weight:700}.avuna-payment .alert{background:#f2e2c9;border-radius:9px;padding:15px;font-size:13px;color:#765122;line-height:1.7;margin-top:15px}.avuna-payment .field{margin:14px 0}.avuna-payment .field label{font-size:13px;font-weight:700;display:block;margin:0 0 8px;color:#29382f}.avuna-payment .field input,.avuna-payment .field select{width:100%;padding:13px 12px;border-radius:9px;border:1px solid #d8d4cc;background:#fbf8f2;color:#252525;font-size:15px}.avuna-payment .bank-detail{background:#f9f6f0;border:1px solid #e5d9c6;border-radius:11px;padding:18px;line-height:1.85}.avuna-payment .detail-title{color:#a45114;font-size:12px;font-weight:800;letter-spacing:1px}.avuna-payment .demo-notice{font-size:13px;color:#8b4718;background:#fff1e4;padding:12px;border-radius:8px;margin:14px 0}.avuna-payment .method-fields{border-top:1px solid #eee;margin-top:20px;padding-top:18px}.avuna-payment .hidden{display:none!important}.avuna-payment .inline-fields{display:grid;grid-template-columns:1fr 1fr;gap:12px}.avuna-payment .client-error{margin-top:12px;color:#a02e26;font-size:13px;font-weight:700}.avuna-payment .small{font-size:12px;color:#777}
.avuna-modal-overlay{position:fixed;inset:0;z-index:99999;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,.65);padding:20px}.avuna-modal{background:#fbf8f2;text-align:center;border-radius:18px;padding:32px;max-width:450px;width:100%;box-shadow:0 24px 90px rgba(0,0,0,.35);color:#26342e}.avuna-modal-tick{width:72px;height:72px;background:#e7f8eb;color:#238248;border-radius:50%;font-size:45px;display:flex;justify-content:center;align-items:center;margin:0 auto 20px}.avuna-modal h2{font-size:25px;color:#123728}.avuna-modal p{line-height:1.65}.avuna-sim-caption{font-size:12px;color:#656565}.avuna-modal-ok{background:#0f2a1f;color:white;display:block;padding:14px;border-radius:9px;text-decoration:none;font-weight:800;margin-top:18px}.avuna-modal-ok:hover{background:#d65b0e;color:white}
@media(max-width:650px){.avuna-payment .two,.avuna-payment .inline-fields{grid-template-columns:1fr}.avuna-payment .hero h1{font-size:32px}}
</style>
<div class="avuna-payment">
  <section class="hero"><span class="tag">AVUNA COLLECTIVE · CUSTOMER PORTAL</span><h1>Order Payment</h1><p>Choose EFT or card payment for your order.</p></section>
  <div class="container">
    <%= PaymentFeedbackHtml %>
    <% if (ShowPaymentDetails) { %>
      <div class="panel">
        <span class="tag">ORDER DETAILS</span>
        <h2>Order <%= Server.HtmlEncode(CurrentOrderId) %></h2>
        <p class="muted">Current order status: <strong><%= Server.HtmlEncode(CurrentOrderStatus) %></strong></p>
        <div class="amount">R <%= AmountDue.ToString("N2", System.Globalization.CultureInfo.GetCultureInfo("en-ZA")) %></div>
        <p class="muted">Outstanding balance recorded in this demonstration database</p>
      </div>
      <% if (AmountDue > 0) { %>
      <div class="panel" id="avunaPaymentPanel">
        <h2>Select payment method</h2>
        <div class="two">
          <label class="choice selected" id="avunaEftChoice">
            <input type="radio" name="avunaMethodChoice" id="avunaEftRadio" checked="checked" />
            <strong>EFT / Bank transfer</strong><p>View AVUNA's banking details and enter your own bank information.</p>
          </label>
          <label class="choice" id="avunaCardChoice">
            <input type="radio" name="avunaMethodChoice" id="avunaCardRadio" />
            <strong>Card payment</strong><p>Enter card information to submit a payment request.</p>
          </label>
        </div>
        <div id="avunaEftFields" class="method-fields">
          <h3>AVUNA banking details</h3>
          <div class="bank-detail">
            <div class="detail-title">PAYEE DETAILS</div>
            <strong>Bank:</strong> Capital Bank Limited<br />
            <strong>Account name:</strong> AVUNA COLLECTIVE<br />
            <strong>Account number:</strong> 34675567746<br />
            <strong>Branch code:</strong> 34566<br />
            <strong>Payment reference:</strong> <%= Server.HtmlEncode(CurrentOrderId) %>
          </div>
          <h3 style="margin-top:24px">Your banking details</h3>
          <div class="field"><label for="avunaCustomerBank">Choose your bank</label>
            <select id="avunaCustomerBank">
              <option value="">Select bank</option>
              <option value="Horizon Bank">Horizon Bank</option>
              <option value="Ubuntu Trust Bank">Ubuntu Trust Bank</option>
              <option value="Nova Financial Bank">Nova Financial Bank</option>
              <option value="Unity Savings Bank">Unity Savings Bank</option>
              <option value="Summit National Bank">Summit National Bank</option>
              <option value="Capital Bank Limited">Capital Bank Limited</option>
            </select>
          </div>
          <div class="field"><label for="avunaAccountHolder">Account holder</label>
            <input id="avunaAccountHolder" type="text" maxlength="80" placeholder="Enter account holder name" autocomplete="off" />
          </div>
          <div class="field"><label for="avunaAccountNumber">Account number</label>
            <input id="avunaAccountNumber" type="text" maxlength="18" inputmode="numeric" placeholder="Enter account number" autocomplete="off" />
          </div>
          
        </div>
        <div id="avunaCardFields" class="method-fields hidden">
          <h3>Card details</h3>
          <div class="field"><label for="avunaCardName">Cardholder name</label>
            <input type="text" id="avunaCardName" value="<%= Server.HtmlEncode(CardholderName) %>" readonly="readonly" />
          </div>
          <div class="field"><label for="avunaCardNumber">Card number</label>
            <input type="text" id="avunaCardNumber" inputmode="numeric" maxlength="23" placeholder="Enter card number" autocomplete="off" />
          </div>
          <div class="inline-fields">
            <div class="field"><label for="avunaExpiry">Expiry date (MM/YY)</label><input type="text" id="avunaExpiry" inputmode="numeric" maxlength="5" placeholder="MM/YY" autocomplete="off" /></div>
            <div class="field"><label for="avunaCvv">CVV</label><input type="password" id="avunaCvv" inputmode="numeric" maxlength="4" placeholder="CVV" autocomplete="off" /></div>
          </div>
          <p class="small">Simulation only — no card is charged. Use fictional card details.</p>
        </div>
        <div class="client-error" id="avunaPaymentError" role="alert" aria-live="polite"></div>
        <input type="hidden" name="avunaPaymentSubmit" id="avunaPaymentSubmit" value="" />
        <input type="hidden" name="avunaPaymentMethod" id="avunaPaymentMethod" value="EFT" />
        <button type="button" class="btn" id="avunaPaymentButton">Submit EFT</button>
      </div>
      <% } else { %><div class="panel"><div class="message">This order is marked Paid in the demonstration database.</div></div><% } %>
    <% } %>
    <% if (ShowSuccessModal) { %>
    <div class="avuna-modal-overlay" role="presentation">
      <div class="avuna-modal" role="dialog" aria-modal="true" aria-labelledby="avunaSuccessTitle" aria-describedby="avunaSuccessDescription">
        <div class="avuna-modal-tick" aria-hidden="true">&#10003;</div>
        <h2 id="avunaSuccessTitle">Payment Simulation Successful!</h2>
        <p id="avunaSuccessDescription">Your <%= Server.HtmlEncode(SubmittedMethod) %> payment simulation was completed successfully. The demonstration order status is now Paid.</p>
        <p><strong>Order:</strong> <%= Server.HtmlEncode(CurrentOrderId) %><br />
        <strong>Reference:</strong> <%= Server.HtmlEncode(SubmittedPaymentId) %></p>
        <p class="avuna-sim-caption">Demonstration only: no funds were transferred or received. "Paid" is recorded only in the demo database.</p>
        <a class="avuna-modal-ok" id="avunaModalOkay" href="<%= ResolveUrl("~/CreateOrder.aspx") %>">OK</a>
      </div>
    </div>
    <% } %>
    <a class="back" href="CreateOrder.aspx">Back to Create Order</a>
  </div>
</div>
<script>
    (function () {
        var ok = document.getElementById('avunaModalOkay');
        if (ok) { ok.focus(); }
        var eft = document.getElementById('avunaEftRadio');
        var card = document.getElementById('avunaCardRadio');
        var method = document.getElementById('avunaPaymentMethod');
        var button = document.getElementById('avunaPaymentButton');
        if (!button) return;
        var error = document.getElementById('avunaPaymentError');
        function refresh() {
            var isCard = card.checked;
            method.value = isCard ? 'Card' : 'EFT';
            document.getElementById('avunaEftFields').classList.toggle('hidden', isCard);
            document.getElementById('avunaCardFields').classList.toggle('hidden', !isCard);
            document.getElementById('avunaEftChoice').classList.toggle('selected', !isCard);
            document.getElementById('avunaCardChoice').classList.toggle('selected', isCard);
            button.textContent = isCard ? 'Submit Card Payment' : 'Submit EFT';
            error.textContent = '';
        }
        eft.addEventListener('change', refresh);
        card.addEventListener('change', refresh);
        refresh();
        button.addEventListener('click', function () {
            error.textContent = '';
            if (card.checked) {
                var digits = document.getElementById('avunaCardNumber').value.replace(/[\s-]/g, '');
                var expiry = document.getElementById('avunaExpiry').value.trim();
                var cvv = document.getElementById('avunaCvv').value.trim();
                var m = /^(0[1-9]|1[0-2])\/(\d{2})$/.exec(expiry);
                if (!document.getElementById('avunaCardName').value.trim() ||
                    !/^\d{12,19}$/.test(digits) || !m || !/^\d{3,4}$/.test(cvv)) {
                    error.textContent = 'Enter fictional card details, MM/YY expiry and a 3- or 4-digit CVV.';
                    return;
                }
            } else {
                var account = document.getElementById('avunaAccountNumber').value.replace(/\s/g, '');
                if (!document.getElementById('avunaCustomerBank').value ||
                    !document.getElementById('avunaAccountHolder').value.trim() || !/^\d{6,18}$/.test(account)) {
                    error.textContent = 'Select your bank and enter an account holder and account number (6–18 digits).';
                    return;
                }
            }
            // All editable financial inputs are deliberately unnamed and are removed
            // from the DOM before posting so they can never be transmitted to ASP.NET.
            ['avunaCardNumber', 'avunaExpiry', 'avunaCvv', 'avunaAccountNumber', 'avunaAccountHolder']
                .forEach(function (id) { var el = document.getElementById(id); if (el) el.value = ''; });
            document.getElementById('avunaPaymentSubmit').value = '1';
            var form = button.closest('form');
            if (form) HTMLFormElement.prototype.submit.call(form);
            else error.textContent = 'The form could not be found.';
        });
    })();
</script>
</asp:Content>
