<%@ Page Title="Register:Individual" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="AVUNA_COLLECTIVE.Register" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Anton&family=Work+Sans:wght@400;500;600;700&family=Space+Mono:wght@400;700&display=swap');

        .avuna-auth {
            --dark: #0c1e1c;
            --dark-soft: #0a3733;
            --orange: #d9711f;
            --gold: #d9a52c;
            --paper: #f6f1e6;
            --field-bg: #f6f1e6;
            --ink: #14201f;
            --line: #e4dcc4;
            --display: 'Anton', sans-serif;
            --body: 'Work Sans', sans-serif;
            --mono: 'Space Mono', monospace;

            position: relative;
            margin: -15px;
            min-height: 720px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 64px 24px;
            background: var(--paper);
            color: var(--ink);
            overflow: hidden;
            font-family: var(--body);
        }

        .avuna-auth *, .avuna-auth *::before, .avuna-auth *::after { box-sizing: border-box; }
        .avuna-auth a { text-decoration: none; }

        /*  The card  */
        .avuna-card {
            position: relative;
            width: 100%;
            max-width: 560px;
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 30px 70px rgba(12,30,28,0.12);
            padding: 48px 44px 40px;
        }

        .avuna-mark {
            width: 34px;
            height: 34px;
            margin: 0 auto 22px;
        }
        .avuna-mark svg { width: 100%; height: 100%; display: block; }

        .avuna-card h1 {
            font-family: var(--display);
            font-weight: 400;
            text-transform: uppercase;
            font-size: 2.2rem;
            line-height: 1;
            color: var(--dark);
            margin: 0 0 12px;
            letter-spacing: 0.02em;
            text-align: center;
        }

        .avuna-card > p.sub {
            color: #5a615c;
            margin: 0 0 30px;
            font-size: 0.98rem;
            text-align: center;
        }

        .avuna-auth-message {
            font-size: 0.88rem;
            color: var(--orange);
            margin-bottom: 18px;
            display: block;
            text-align: center;
        }

        .avuna-section-title {
            font-family: var(--display);
            font-weight: 400;
            text-transform: uppercase;
            font-size: 1.15rem;
            letter-spacing: 0.02em;
            color: var(--dark);
            margin: 0 0 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--line);
        }
        .avuna-section-title.second { margin-top: 34px; }

        .avuna-field { margin-bottom: 20px; }

        .avuna-field-row {
            display: grid;
            grid-template-columns: 1fr;
            gap: 0 18px;
        }

        .avuna-field label {
            display: block;
            font-family: var(--body);
            font-weight: 600;
            font-size: 0.92rem;
            color: var(--dark);
            margin-bottom: 8px;
        }
        .avuna-field label span.hint { color: #b7b19c; font-weight: 400; }

        .avuna-auth-form input[type="text"],
        .avuna-auth-form input[type="password"],
        .avuna-auth-form input[type="email"],
        .avuna-auth-form input[type="username"],
        .avuna-auth-form input[type="tel"],
        .avuna-auth-form select {
            width: 100% !important;
            max-width: 100% !important;
            border: 1px solid var(--line);
            background: var(--field-bg);
            border-radius: 10px;
            padding: 13px 16px;
            font-family: var(--body);
            font-size: 1rem;
            color: var(--ink);
            transition: border-color 0.15s ease;
            appearance: none;
            -webkit-appearance: none;
        }
        .avuna-auth-form select {
            background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%235a615c' stroke-width='2'><polyline points='6 9 12 15 18 9'/></svg>");
            background-repeat: no-repeat;
            background-position: right 14px center;
            background-size: 16px;
            padding-right: 40px;
            color: var(--ink);
        }
        .avuna-auth-form select:invalid { color: #b7b19c; }
        .avuna-auth-form input::placeholder { color: #b7b19c; }
        .avuna-auth-form input[type="text"]:focus,
        .avuna-auth-form input[type="password"]:focus,
        .avuna-auth-form input[type="email"]:focus,
        .avuna-auth-form input[type="username"]:focus,
        .avuna-auth-form input[type="tel"]:focus,
        .avuna-auth-form select:focus {
            outline: none;
            border-color: var(--orange);
        }
        .avuna-auth-form input:focus-visible,
        .avuna-auth-form select:focus-visible {
            outline: 2px solid var(--gold);
            outline-offset: 2px;
        }

        /* cell number split field: (code) ___-____ */
        .avuna-cell-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .avuna-cell-group span.paren {
            font-family: var(--mono);
            font-size: 1rem;
            color: #8a8368;
        }
        .avuna-cell-group .code {
            width: 64px !important;
            flex: 0 0 64px;
            text-align: center;
        }
        .avuna-cell-group .mid {
            width: 84px !important;
            flex: 0 0 84px;
            text-align: center;
        }
        .avuna-cell-group .last {
            flex: 1 1 auto;
            text-align: center;
        }
        .avuna-cell-group span.dash {
            font-family: var(--mono);
            color: #8a8368;
        }

        /* ---------- Password field + eye toggle (this is what was missing) ---------- */
        .password-container {
            position: relative;
            width: 100%;
        }

        .password-container .password-input {
            padding-right: 44px !important; /* room for the eye icon so text never overlaps it */
        }

        .password-eye {
            position: absolute;
            top: 50%;
            right: 14px;
            transform: translateY(-50%);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: #8a8368;
            font-size: 1.05rem;
            background: none;
            border: none;
            padding: 4px;
            line-height: 1;
        }
        .password-eye:hover { color: var(--orange); }
        .password-eye:focus-visible {
            outline: 2px solid var(--gold);
            outline-offset: 2px;
            border-radius: 4px;
        }

        .password-requirements {
            margin: -8px 0 18px;
        }
        .password-requirements p {
            font-size: 0.85rem;
            color: #5a615c;
            margin: 0 0 6px;
        }
        .password-requirements ul {
            margin: 0;
            padding-left: 20px;
        }
        .password-requirements li {
            font-size: 0.82rem;
            color: #8a8368;
            margin-bottom: 2px;
        }

        .avuna-auth-submit {
            width: 100%;
            background: var(--dark);
            color: var(--paper);
            border: none;
            font-family: var(--body);
            font-weight: 700;
            font-size: 0.95rem;
            letter-spacing: 0.02em;
            padding: 15px 0;
            border-radius: 10px;
            cursor: pointer;
            margin-top: 8px;
            transition: background 0.15s ease, transform 0.15s ease;
        }
        .avuna-auth-submit:hover { background: var(--dark-soft); transform: translateY(-1px); }
        .avuna-auth-submit:focus-visible { outline: 3px solid var(--gold); outline-offset: 2px; }

        .avuna-auth-divider {
            position: relative;
            text-align: center;
            margin: 28px 0 20px;
            font-family: var(--body);
            font-size: 0.88rem;
            color: #b0aa93;
        }
        .avuna-auth-divider::before,
        .avuna-auth-divider::after {
            content: "";
            position: absolute;
            top: 50%;
            width: 38%;
            border-top: 1px solid var(--line);
        }
        .avuna-auth-divider::before { left: 0; }
        .avuna-auth-divider::after { right: 0; }

        .avuna-auth-register {
            text-align: center;
            font-size: 0.95rem;
            color: #5a615c;
        }
        .avuna-auth-register a { color: var(--orange); font-weight: 700; }
        .avuna-auth-register a:hover { color: #b85f19; }

        @media (max-width: 640px) {
            .avuna-auth { padding: 40px 16px; min-height: 0; }
            .avuna-card { padding: 36px 26px 32px; }
            .avuna-card h1 { font-size: 1.9rem; }
        }
    </style>

    <div class="avuna-auth">
        <div class="avuna-card avuna-auth-form">
            <div class="avuna-mark" aria-hidden="true">
                <svg viewBox="0 0 100 100">
                    <polygon points="50,10 20,90 40,90 62,30" fill="#0c1e1c"/>
                    <polygon points="53,18 58,32 45,68 62,30" fill="#d9711f"/>
                    <polygon points="60,52 78,90 58,90 50,68" fill="#0c1e1c"/>
                    <polygon points="60,52 66,68 74,68" fill="#d9a52c"/>
                    <line x1="12" y1="58" x2="80" y2="34" stroke="#0c1e1c" stroke-width="4"/>
                </svg>
            </div>

            <h1>Individual Customer Account</h1>
            <p class="sub">Join Avuna Collective to track your orders</p>

            <asp:Literal ID="litMessage" runat="server" />

            <div class="avuna-section-title">Individual Customer Details</div>

            <div class="avuna-field">
                <label for="txtFirstName">First Name</label>
                <asp:TextBox ID="txtFirstName" runat="server" TextMode="SingleLine" placeholder="Jane" />
            </div>

            <div class="avuna-field">
                <label for="txtLastName">Last Name</label>
                <asp:TextBox ID="txtLastName" runat="server" TextMode="SingleLine" placeholder="Doe" />
            </div>

            <div class="avuna-field">
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="you@example.com" />
            </div>

            
          <div class="avuna-field">
            <label for="txtUsername">Username</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Create a username">  </asp:TextBox>
               <asp:RequiredFieldValidator
                   ID="rfvUsername"
                   runat="server"
                   ControlToValidate="txtUsername"
                   ErrorMessage="Please enter a username."
                   ForeColor="Red"
                   Display="Dynamic">
              </asp:RequiredFieldValidator>

          </div>

            <div class="avuna-field">
                <label for="txtCellCode">Cell Number</label>
                <div class="avuna-cell-group">
                    <span class="paren">(</span>
                    <asp:TextBox ID="txtCellCode" runat="server" CssClass="code" TextMode="SingleLine" MaxLength="3" placeholder="071" />
                    <span class="paren">)</span>
                    <asp:TextBox ID="txtCellMid" runat="server" CssClass="mid" TextMode="SingleLine" MaxLength="3" placeholder="123" />
                    <span class="dash">-</span>
                    <asp:TextBox ID="txtCellLast" runat="server" CssClass="last" TextMode="SingleLine" MaxLength="4" placeholder="4567" />
                </div>
            </div>


            <div class="avuna-field">
                <label for="txtHouseNumber">House Number</label>
                <asp:TextBox ID="txtHouseNumber" runat="server" TextMode="SingleLine" placeholder="12" />
            </div>

            <div class="avuna-field">
                <label for="txtStreetName">Street Name</label>
                <asp:TextBox ID="txtStreetName" runat="server" TextMode="SingleLine" placeholder="Marine Parade" />
            </div>

            <div class="avuna-field">
                <label for="txtSuburb">Suburb</label>
                <asp:TextBox ID="txtSuburb" runat="server" TextMode="SingleLine" placeholder="Umhlanga" />
            </div>

            <div class="avuna-field">
                <label for="txtTown">Town/City</label>
                <asp:TextBox ID="txtTown" runat="server" TextMode="SingleLine" placeholder="Durban" />
            </div>

            <div class="avuna-section-title second">Account Access</div>

            <div class="avuna-field">
                <label for="txtPassword">Password</label>
                <div class="password-container">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="password-input" />
                    <button type="button" class="password-eye" onclick="togglePassword()" aria-label="Show password">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                </div>
            </div>

            <div class="password-requirements">
                <p>Password must contain:</p>
                <ul>
                    <li>At least 8 characters</li>
                    <li>One uppercase letter (A-Z)</li>
                    <li>One lowercase letter (a-z)</li>
                    <li>One number (0-9)</li>
                    <li>One special character (!, @, #, $, etc.)</li>
                </ul>
            </div>

            <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword" ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$"
                ErrorMessage="Password must be at least 8 characters and contain at least one uppercase letter, one lowercase letter, one number, and one special character."
                ForeColor="Red"
                Display="Dynamic">
            </asp:RegularExpressionValidator>

            <div class="avuna-field">
                <label for="txtConfirmPassword">Confirm Password</label>
                <div class="password-container">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="password-input" />
                    <button type="button" class="password-eye" onclick="toggleConfirmPassword()" aria-label="Show password">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                </div>
            </div>

            <asp:CompareValidator ID="cvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" Operator="Equal"
                ErrorMessage="Passwords do not match." ForeColor="Red" Display="Dynamic">
            </asp:CompareValidator>

            <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="avuna-auth-submit" OnClick="btnRegister_Click" />

            <div class="avuna-auth-divider">Already a member?</div>

            <div class="avuna-auth-register">
                Have an account already? <a href="~/Login" runat="server">Log in</a>
            </div>

             <div class="avuna-auth-register">
                 Not an individual? <a href="~/RegisterBusiness" runat="server">Register as a business</a>
             </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            var password = document.getElementById('<%= txtPassword.ClientID %>');
            var icon = event.currentTarget.querySelector('i');

            if (password.type === "password") {
                password.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
                event.currentTarget.setAttribute("aria-label", "Hide password");
            } else {
                password.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
                event.currentTarget.setAttribute("aria-label", "Show password");
            }
        }

        function toggleConfirmPassword() {
            var password = document.getElementById('<%= txtConfirmPassword.ClientID %>');
            var icon = event.currentTarget.querySelector('i');

            if (password.type === "password") {
                password.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
                event.currentTarget.setAttribute("aria-label", "Hide password");
            } else {
                password.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
                event.currentTarget.setAttribute("aria-label", "Show password");
            }
        }
    </script>

</asp:Content>
