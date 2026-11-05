<%@ Page Title="Register Business" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterBusiness.aspx.cs" Inherits="AVUNA_COLLECTIVE.RegisterBusiness" %>
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

/* The card */
.avuna-card {
    position: relative;
    width: 100%;
    max-width: 560px;
    background: #ffffff;
    border-radius: 18px;
    box-shadow: 0 30px 70px rgba(12,30,28,0.12);
    padding: 48px 44px 40px;
}

.avuna-mark { width: 34px; height: 34px; margin: 0 auto 22px; }
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
.avuna-auth-form input::placeholder { color: #b7b19c; }
.avuna-auth-form input[type="text"]:focus,
.avuna-auth-form input[type="password"]:focus,
.avuna-auth-form input[type="email"]:focus,
.avuna-auth-form input[type="tel"]:focus {
    outline: none;
    border-color: var(--orange);
}
.avuna-auth-form input:focus-visible {
    outline: 2px solid var(--gold);
    outline-offset: 2px;
}

/* cell number split field: (code) ___-____ */
.avuna-cell-group { display: flex; align-items: center; gap: 8px; }
.avuna-cell-group span.paren { font-family: var(--mono); font-size: 1rem; color: #8a8368; }
.avuna-cell-group .code { width: 64px !important; flex: 0 0 64px; text-align: center; }
.avuna-cell-group .mid  { width: 84px !important; flex: 0 0 84px; text-align: center; }
.avuna-cell-group .last { flex: 1 1 auto; text-align: center; }
.avuna-cell-group span.dash { font-family: var(--mono); color: #8a8368; }

/* Password field + eye toggle */
.password-container { position: relative; width: 100%; }
.password-container .password-input { padding-right: 44px !important; }
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
.password-eye:focus-visible { outline: 2px solid var(--gold); outline-offset: 2px; border-radius: 4px; }

.password-requirements { margin: -8px 0 18px; }
.password-requirements p { font-size: 0.85rem; color: #5a615c; margin: 0 0 6px; }
.password-requirements ul { margin: 0; padding-left: 20px; }
.password-requirements li { font-size: 0.82rem; color: #8a8368; margin-bottom: 2px; }

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

.avuna-auth-register { text-align: center; font-size: 0.95rem; color: #5a615c; }
.avuna-auth-register + .avuna-auth-register { margin-top: 10px; }
.avuna-auth-register a { color: var(--orange); font-weight: 700; }
.avuna-auth-register a:hover { color: #b85f19; }

/* Chooser page */
.avuna-choice-list { display: grid; gap: 16px; }
.avuna-choice {
    display: block;
    padding: 22px 24px;
    border: 1px solid var(--line);
    background: var(--field-bg);
    border-radius: 12px;
    color: var(--ink);
    transition: border-color 0.15s ease, transform 0.15s ease;
}
.avuna-choice:hover { border-color: var(--orange); transform: translateY(-1px); }
.avuna-choice:focus-visible { outline: 3px solid var(--gold); outline-offset: 2px; }
.avuna-choice strong {
    display: block;
    font-family: var(--display);
    font-weight: 400;
    text-transform: uppercase;
    letter-spacing: 0.02em;
    font-size: 1.25rem;
    color: var(--dark);
    margin-bottom: 4px;
}
.avuna-choice span { font-size: 0.92rem; color: #5a615c; }

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

            <h1>Business Account</h1>
            <p class="sub">Register your business with Avuna Collective</p>

            <asp:Literal ID="litMessage" runat="server" />

            <div class="avuna-section-title">Business Details</div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtBusinessName" Text="Business Name" />
                <asp:TextBox ID="txtBusinessName" runat="server" MaxLength="100" placeholder="Acme Trading (Pty) Ltd" />
            </div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtEmail" Text="Business Email" />
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="orders@yourbusiness.co.za" />
            </div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtCellCode" Text="Business Number" />
                <div class="avuna-cell-group">
                    <span class="paren">(</span>
                    <asp:TextBox ID="txtCellCode" runat="server" CssClass="code" MaxLength="3" placeholder="031" />
                    <span class="paren">)</span>
                    <asp:TextBox ID="txtCellMid" runat="server" CssClass="mid" MaxLength="3" placeholder="123" />
                    <span class="dash">-</span>
                    <asp:TextBox ID="txtCellLast" runat="server" CssClass="last" MaxLength="4" placeholder="4567" />
                </div>
            </div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtHouseNumber" Text="Building / Unit Number" />
                <asp:TextBox ID="txtHouseNumber" runat="server" placeholder="12" />
            </div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtStreetName" Text="Street Name" />
                <asp:TextBox ID="txtStreetName" runat="server" placeholder="Marine Parade" />
            </div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtSuburb" Text="Suburb" />
                <asp:TextBox ID="txtSuburb" runat="server" placeholder="Umhlanga" />
            </div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtTown" Text="Town/City" />
                <asp:TextBox ID="txtTown" runat="server" placeholder="Durban" />
            </div>

            <div class="avuna-section-title second">Account Access</div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtUsername" Text="Username" />
                <asp:TextBox ID="txtUsername" runat="server" placeholder="Create a username" />
            </div>

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtPassword" Text="Password" />
                <div class="password-container">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="password-input" />
                    <button type="button" class="password-eye" onclick="togglePassword(this, '<%= txtPassword.ClientID %>')" aria-label="Show password">
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

            <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$"
                ErrorMessage="Password must be at least 8 characters and contain at least one uppercase letter, one lowercase letter, one number, and one special character."
                ForeColor="Red" Display="Dynamic" />

            <div class="avuna-field">
                <asp:Label runat="server" AssociatedControlID="txtConfirmPassword" Text="Confirm Password" />
                <div class="password-container">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="password-input" />
                    <button type="button" class="password-eye" onclick="togglePassword(this, '<%= txtConfirmPassword.ClientID %>')" aria-label="Show password">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                </div>
            </div>

            <asp:CompareValidator ID="cvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                ControlToCompare="txtPassword" Operator="Equal"
                ErrorMessage="Passwords do not match." ForeColor="Red" Display="Dynamic" />

            <asp:Button ID="btnRegister" runat="server" Text="Create Business Account" CssClass="avuna-auth-submit" OnClick="btnRegister_Click" />

            <div class="avuna-auth-divider">Already a member?</div>

            <div class="avuna-auth-register">
                Have an account already? <a href="~/Login" runat="server">Log in</a>
            </div>
            <div class="avuna-auth-register">
                Not a business? <a href="~/Register" runat="server">Register as an individual</a>
            </div>
        </div>
    </div>

    <script>
        function togglePassword(btn, inputId) {
            var input = document.getElementById(inputId);
            var icon = btn.querySelector('i');

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
                btn.setAttribute("aria-label", "Hide password");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
                btn.setAttribute("aria-label", "Show password");
            }
        }
    </script>

</asp:Content>


