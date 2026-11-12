 <%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="AVUNA_COLLECTIVE.Login" %>
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

            <h1>Log In</h1>
            <p class="sub">Welcome back to Avuna Collective</p>

            <asp:Literal ID="litMessage" runat="server" />

            <div class="avuna-field">
                <label for="txtUsername">Username</label>
               <asp:TextBox ID="txtUsername" runat="server" TextMode="SingleLine" placeholder="Enter username" />
            </div>

            <div class="avuna-field">
                <label for="txtPassword">Password</label>
                <div class="password-container">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="••••••••" />
                    <button type="button" class="password-eye" onclick="togglePassword()" aria-label="Show password">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                </div>
            </div>

            <div class="avuna-row-between">
               
                <a href="ForgotPassword.aspx">Forgot password?</a>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Log In" CssClass="avuna-auth-submit" OnClick="btnLogin_Click" />

            <div class="avuna-auth-divider">New here?</div>

            <div class="avuna-auth-register">
               Don't have an account? <a href="~/Register.aspx" runat="server" class="avuna-btn avuna-btn-primary" data-bs-toggle="modal" data-bs-target="#accountTypeModal">Create one</a>
                   
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
    </script>
</asp:Content>
