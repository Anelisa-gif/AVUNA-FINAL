<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="AVUNA_COLLECTIVE.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent"   runat="server">
<meta charset="UTF-8">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root{
    --ink:      #16261F;   /* deep forest — matches your nav */
    --ink-soft: #1E332A;
    --parchment:#EFE6D8;   /* warm page background */
    --card:     #FFFFFF;
    --gold:     #B8912F;   /* Avuna wordmark gold */
    --gold-soft:#E7D9B6;
    --orange:   #E2793C;   /* matches "Start Your Order" CTA */
    --charcoal: #1B1B1B;
    --muted:    #6b6558;
    --thread:   #C9B896;
    --line:     #E3D9C8;
  }

  .avuna-contact-page *{ box-sizing: border-box; }
  .avuna-contact-page{
    font-family:'Inter', sans-serif;
    background: #FFFFFF;
    color: var(--charcoal);
  }

  /* ---------- NAV ---------- */
  .avuna-nav{
    background: var(--ink);
    padding: 14px 6vw;
    display:flex; align-items:center; gap: 26px;
  }
  .avuna-nav__logo{
    width: 34px; height: 34px;
    border-radius: 3px;
    background: #fff;
    display:flex; align-items:center; justify-content:center;
    flex: none;
  }
  .avuna-nav__logo img{ width: 26px; height: 26px; object-fit: contain; }
  .avuna-nav__brand{
    font-family: 'Inter', sans-serif;
    font-size: 16px;
    font-weight: 500;
    color: var(--orange);
    text-decoration: underline;
    text-underline-offset: 3px;
    white-space: nowrap;
  }
  .avuna-nav__links{ display:flex; gap: 26px; list-style:none; margin:0; padding:0; }
  .avuna-nav__links a{
    color: #F5F1E8; text-decoration:none; font-size: 15px; font-weight:500;
    transition: color 0.2s ease;
  }
  .avuna-nav__links a:hover{ color: var(--orange); }

  /* ---------- HERO ---------- */
  .avuna-hero{
    background: linear-gradient(160deg, var(--ink) 0%, var(--ink-soft) 100%);
    padding: 84px 6vw 96px;
    text-align:center;
    position:relative;
    overflow:hidden;
  }
  .avuna-hero::before{
    content:"";
    position:absolute; inset:0;
    background-image: radial-gradient(circle at 20% 20%, rgba(184,145,47,0.10), transparent 40%),
                       radial-gradient(circle at 85% 75%, rgba(226,121,60,0.08), transparent 45%);
  }
  .avuna-hero__eyebrow{
    position:relative;
    font-size: 13px; font-weight:700; letter-spacing: 0.3em; text-transform:uppercase;
    color: var(--orange); margin: 0 0 16px;
  }
  .avuna-hero__title{
    position:relative;
    font-family:'Bebas Neue', sans-serif;
    font-size: clamp(46px, 7vw, 78px);
    letter-spacing: 0.03em;
    color: var(--gold);
    margin: 0;
    line-height: 1;
  }
  .avuna-hero__sub{
    position:relative;
    max-width: 560px; margin: 20px auto 0;
    color: #C9C3B4; font-size: 15.5px; line-height: 1.65;
  }

  /* ---------- CONTACT SECTION ---------- */
  .avuna-contact{
    padding: 76px 6vw 110px;
    max-width: 680px;
    margin: 0 auto;
  }

  .avuna-info{ display:flex; flex-direction:column; gap: 18px; }

  .avuna-info-card{
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 6px;
    padding: 24px 24px;
    display:flex; gap: 18px; align-items:flex-start;
    transition: border-color 0.2s ease, transform 0.2s ease;
  }
  .avuna-info-card:hover{ border-color: var(--gold); transform: translateY(-2px); }

  .avuna-info-card__icon{
    flex: none;
    width: 44px; height: 44px;
    border-radius: 6px;
    background: var(--ink);
    display:flex; align-items:center; justify-content:center;
  }
  .avuna-info-card__icon svg{ width: 20px; height: 20px; stroke: var(--gold); fill:none; }

  .avuna-info-card h3{
    font-family:'Bebas Neue', sans-serif;
    font-size: 18px; letter-spacing: 0.05em; text-transform:uppercase;
    margin: 2px 0 6px; color: var(--ink);
  }
  .avuna-info-card p{
    margin:0; font-size: 14.5px; line-height: 1.6; color: var(--muted);
  }
  .avuna-info-card a{ color: var(--charcoal); text-decoration:none; }
  .avuna-info-card a:hover{ color: var(--orange); }

  @media (prefers-reduced-motion: reduce){
    .avuna-info-card{ transition:none; }
  }
</style>

<div class="avuna-contact-page">

  <header class="avuna-hero">
    <p class="avuna-hero__eyebrow">Get In Touch</p>
    <h1 class="avuna-hero__title">Contact Us</h1>
    <p class="avuna-hero__sub">
      Got an idea, a question, or just want to chat before you commit?
      We'd love to hear from you.
    </p>
  </header>

  <section class="avuna-contact">

    <div class="avuna-info">

      <div class="avuna-info-card">
        <div class="avuna-info-card__icon">
          <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0Z"/>
            <circle cx="12" cy="10" r="3"/>
          </svg>
        </div>
        <div>
          <h3>Our Address</h3>
          <p>127 Victoria Embankment,<br>Astron Garage,<br>Durban, KwaZulu-Natal,<br>South Africa</p>
        </div>
      </div>

      <div class="avuna-info-card">
        <div class="avuna-info-card__icon">
          <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.35 1.9.66 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.31 1.85.53 2.81.66A2 2 0 0 1 22 16.92Z"/>
          </svg>
        </div>
        <div>
          <h3>Phone Number</h3>
          <p><a href="tel:0671736313">067 173 6313</a></p>
        </div>
      </div>

      <div class="avuna-info-card">
        <div class="avuna-info-card__icon">
          <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="4" width="20" height="16" rx="2"/>
            <path d="m22 6-10 7L2 6"/>
          </svg>
        </div>
        <div>
          <h3>Email Address</h3>
          <p><a href="mailto:avunacollected@gmail.com">avunacollected@gmail.com</a></p>
        </div>
      </div>

      <div class="avuna-info-card">
        <div class="avuna-info-card__icon">
          <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="5"/>
            <circle cx="12" cy="12" r="4"/>
            <circle cx="17.5" cy="6.5" r="1"/>
          </svg>
        </div>
        <div>
          <h3>Instagram</h3>
          <p><a href="https://www.instagram.com/avunacollected" target="_blank" rel="noopener noreferrer">@avunacollected</a></p>
        </div>
      </div>

    </div>

  </section>

   <section class="contact-map-section">
    <h3>Find Us:</h3>
    <div class="map-container">
        <iframe
            src="https://www.google.com/maps?q=127+Victoria+Embankment,+Astron+Garage,+Durban&output=embed"
            width="100%"
            height="450"
            style="border:0;"
            allowfullscreen=""
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade">
        </iframe>
    </div>
    <p>
        <a href="https://www.google.com/maps/search/?api=1&query=127%20Victoria%20Embankment%2C%20Astron%20Garage%2C%20Durban" target="_blank" rel="noopener">
            Get directions on Google Maps
        </a>
    </p>
</section>

</div>

</asp:Content>

