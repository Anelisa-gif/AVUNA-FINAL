<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="AVUNA_COLLECTIVE.ForgotPassword" %>
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

        /* ---------- The card ---------- */
        .avuna-card {
            position: relative;
            width: 100%;
            max-width: 460px;
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
            font-size: 2.4rem;
            line-height: 1;
            color: var(--dark);
            margin: 0 0 12px;
            letter-spacing: 0.02em;
            text-align: center;
        }

        .avuna-card > p.sub {
            color: #5a615c;
            margin: 0 0 32px;
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

        .avuna-field { margin-bottom: 22px; }

        .avuna-field label {
            display: block;
            font-family: var(--body);
            font-weight: 600;
            font-size: 0.92rem;
            color: var(--dark);
            margin-bottom: 8px;
        }

        .avuna-auth-form input[type="text"],
        .avuna-auth-form input[type="password"],
        .avuna-auth-form input[type="username"] {
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
        }
        .avuna-auth-form input::placeholder { color: #b7b19c; }
        .avuna-auth-form input[type="text"]:focus,
        .avuna-auth-form input[type="password"]:focus,
        .avuna-auth-form input[type="username"]:focus {
            outline: none;
            border-color: var(--orange);
        }
        .avuna-auth-form input:focus-visible {
            outline: 2px solid var(--gold);
            outline-offset: 2px;
        }

        /* ---------- Password field + eye toggle (this was missing) ---------- */
        .password-container {
            position: relative;
            width: 100%;
        }

        .password-container input[type="password"],
        .password-container input[type="text"] {
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

        .avuna-row-between {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 4px 0 26px;
            font-size: 0.92rem;
        }
        .avuna-remember { display: flex; align-items: center; gap: 8px; color: #5a615c; }
        .avuna-remember input[type="checkbox"] { accent-color: var(--orange); }
        .avuna-row-between a { color: var(--orange); font-weight: 600; }
        .avuna-row-between a:hover { color: #b85f19; }

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
            transition: background 0.15s ease, transform 0.15s ease;
        }
        .avuna-auth-submit:hover { background: var(--dark-soft); transform: translateY(-1px); }
        .avuna-auth-submit:focus-visible { outline: 3px solid var(--gold); outline-offset: 2px; }

        .avuna-auth-divider {
            position: relative;
            text-align: center;
            margin: 30px 0 22px;
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
            .avuna-card h1 { font-size: 2.05rem; }
        }
    </style>
    <style>
        .avuna-auth-success { display: block; background: #e8f4ec; border: 1px solid #bfe0c9; color: #267347; border-radius: 10px; padding: 12px 14px; font-size: 0.92rem; line-height: 1.5; margin-bottom: 16px; }
        .avuna-auth-info { display: block; background: #fff5eb; border: 1px solid #f5d9bd; color: #8a4b16; border-radius: 10px; padding: 12px 14px; font-size: 0.92rem; line-height: 1.5; margin-bottom: 16px; }
        .avuna-code-input { text-align: center; font-size: 1.6rem !important; letter-spacing: 10px; font-weight: 700; font-family: "Space Mono", monospace; }
        .avuna-timer { text-align: center; font-size: 0.9rem; color: #5a615c; margin: 4px 0 16px; }
        .avuna-timer.expired { color: #b03a3a; font-weight: 700; }
        .avuna-secondary { display: block; width: 100%; margin-top: 12px; padding: 12px; border-radius: 10px; border: 1.5px solid var(--orange); background: #fff; color: var(--orange); font-weight: 700; font-size: 0.95rem; cursor: pointer; }
        .avuna-secondary:hover { background: #fff0e4; }
        .avuna-linkbtn { display: block; text-align: center; margin: 14px auto 0; background: none; border: 0; color: #5a615c; font-size: 0.9rem; text-decoration: underline; cursor: pointer; }
        .avuna-rules { font-size: 0.82rem; color: #5a615c; margin: -4px 0 16px; line-height: 1.5; }
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

            <h1>Forgot Password</h1>
            <p class="sub"><asp:Literal ID="litSub" runat="server" /></p>

            <asp:Literal ID="litMessage" runat="server" />

            <%-- STEP 1: email --%>
            <asp:Panel ID="pnlEmail" runat="server" DefaultButton="btnSendCode">
                <div class="avuna-field">
                    <label for="<%= txtEmail.ClientID %>">Email address</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="The email you registered with" MaxLength="100" />
                </div>
                <asp:Button ID="btnSendCode" runat="server" Text="Send verification code" CssClass="avuna-auth-submit" OnClick="btnSendCode_Click" />
                <div class="avuna-auth-register" style="margin-top:18px">
                    <a href="Login.aspx">Back to Log In</a>
                </div>
            </asp:Panel>

            <%-- STEP 2: verification code --%>
            <asp:Panel ID="pnlCode" runat="server" Visible="false" DefaultButton="btnVerify">
                <div class="avuna-field">
                    <label for="<%= txtCode.ClientID %>">Verification code</label>
                    <asp:TextBox ID="txtCode" runat="server" CssClass="avuna-code-input" MaxLength="6" placeholder="------" autocomplete="one-time-code" inputmode="numeric" />
                </div>
                <div id="codeTimer" class="avuna-timer"></div>
                <asp:HiddenField ID="hfSecondsLeft" runat="server" Value="0" />
                <asp:Button ID="btnVerify" runat="server" Text="Verify code" CssClass="avuna-auth-submit" OnClick="btnVerify_Click" />
                <asp:Button ID="btnResend" runat="server" Text="Resend code" CssClass="avuna-secondary" OnClick="btnResend_Click" CausesValidation="false" />
                <asp:LinkButton ID="lnkChangeEmail" runat="server" CssClass="avuna-linkbtn" OnClick="lnkChangeEmail_Click" CausesValidation="false">Use a different email</asp:LinkButton>
            </asp:Panel>

            <%-- STEP 3: new password --%>
            <asp:Panel ID="pnlReset" runat="server" Visible="false" DefaultButton="btnReset">
                <div class="avuna-field">
                    <label for="<%= txtNewPassword.ClientID %>">New password</label>
                    <div class="password-container">
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="New password" />
                        <button type="button" class="password-eye" onclick="togglePw(this, '<%= txtNewPassword.ClientID %>')" aria-label="Show password"><i class="fa-solid fa-eye"></i></button>
                    </div>
                </div>
                <div class="avuna-field">
                    <label for="<%= txtConfirmPassword.ClientID %>">Confirm new password</label>
                    <div class="password-container">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Repeat new password" />
                        <button type="button" class="password-eye" onclick="togglePw(this, '<%= txtConfirmPassword.ClientID %>')" aria-label="Show password"><i class="fa-solid fa-eye"></i></button>
                    </div>
                </div>
                <p class="avuna-rules">At least 8 characters with an uppercase letter, a lowercase letter, a number and a special character.</p>
                <asp:Button ID="btnReset" runat="server" Text="Change password" CssClass="avuna-auth-submit" OnClick="btnReset_Click" />
            </asp:Panel>

            <%-- STEP 4: done --%>
            <asp:Panel ID="pnlDone" runat="server" Visible="false">
                <a href="Login.aspx" class="avuna-auth-submit" style="display:block;text-align:center;text-decoration:none">Go to Log In</a>
            </asp:Panel>
        </div>
    </div>

    <script>
        function togglePw(btn, id) {
            var box = document.getElementById(id);
            var icon = btn.querySelector('i');
            if (box.type === "password") {
                box.type = "text"; icon.classList.remove("fa-eye"); icon.classList.add("fa-eye-slash");
                btn.setAttribute("aria-label", "Hide password");
            } else {
                box.type = "password"; icon.classList.remove("fa-eye-slash"); icon.classList.add("fa-eye");
                btn.setAttribute("aria-label", "Show password");
            }
        }

        // 5-minute countdown for the verification code
        (function () {
            var hf = document.getElementById('<%= hfSecondsLeft.ClientID %>');
            var label = document.getElementById('codeTimer');
            if (!hf || !label) return;
            var left = parseInt(hf.value, 10) || 0;
            var verify = document.getElementById('<%= btnVerify.ClientID %>');
            function show() {
                if (left > 0) {
                    var m = Math.floor(left / 60), s = left % 60;
                    label.className = "avuna-timer";
                    label.textContent = "This code expires in " + m + ":" + (s < 10 ? "0" : "") + s;
                } else {
                    label.className = "avuna-timer expired";
                    label.textContent = "This code has expired. Click Resend code to get a new one.";
                    if (verify) verify.disabled = true;
                }
            }
            show();
            if (left > 0) {
                var t = setInterval(function () { left--; show(); if (left <= 0) clearInterval(t); }, 1000);
            }
        })();
    </script>
</asp:Content>
