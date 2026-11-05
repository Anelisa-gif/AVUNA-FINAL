<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="AVUNA_COLLECTIVE.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
       
 <style>


      /* ---------- About / location ---------- */
 .avuna-about{ 
                 padding: 80px 20px; 
                
             }

 .avuna-about .wrap {
     display: flex;
     gap: 56px;
     flex-wrap: wrap;
     align-items: flex-start;
 }

 .avuna-about-copy { flex: 1 1 420px; }
 .avuna-about-copy .eyebrow { color: darkorange; margin-bottom: 10px; }
 .avuna-about-copy h2 {
     font-family: var(--display);
font-weight: 700;
text-transform: uppercase;
font-size: 48px;
color:white;
margin: 15px 0;
 }
 .avuna-about-copy p {
     color: white;
     line-height: 1.65;
     margin: 0 0 16px;
 }

 .avuna-about-card {
     flex: 1 1 280px;
     background: var(--dark);
     color: #f2efe8;
     padding: 30px;
     border-radius: 4px;
 }
 .avuna-about-card .eyebrow { color: var(--gold); margin-bottom: 14px; }
 .avuna-about-card dl { margin: 0; }
 .avuna-about-card dt {
     font-family: var(--mono);
     font-size: 0.7rem;
     letter-spacing: 0.08em;
     text-transform: uppercase;
     color: #a9a496;
     margin-top: 16px;
 }
 .avuna-about-card dt:first-child { margin-top: 0; }
 .avuna-about-card dd {
     margin: 4px 0 0;
     font-size: 0.98rem;
 }

 /* ---------- Services ---------- */
.avuna-services { padding: 84px 0; }

.avuna-section-head { max-width: 60ch; margin-bottom: 48px; }
.avuna-section-head .eyebrow { color: var(--orange); margin-bottom: 10px; }
.avuna-section-head h2 {
    font-family: var(--display);
    font-weight: 400;
    text-transform: uppercase;
    font-size: clamp(1.8rem, 3.4vw, 2.5rem);
    color:darkorange;
    margin: 0 0 12px;
    letter-spacing: 0.01em;
}
.avuna-section-head p { color: black;
line-height: 1.6;
margin: 0;
text-shadow: 0 1px 6px rgba(0,0,0,0.6); }

.avuna-service-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 1px;
    background: var(--line);
    border: 1px solid var(--line);
}

.avuna-service-card {
    background:#F6F1E6;
    padding: 32px 26px;
}

.avuna-service-card .num {
    font-family: var(--mono);
    font-size: 0.78rem;
    color: var(--orange);
    display: block;
    margin-bottom: 20px;
}

.avuna-service-card h3 {
    font-family: var(--body);
    font-weight: 700;
    font-size: 1.08rem;
    color: #d9711f;
    margin: 0 0 10px;
}

.avuna-service-card p {
    font-size: 0.92rem;
    line-height: 1.55;
    color: #565c58;
    margin: 0;
}
 </style>

 <div class="avuna-about-services-wrap">    
     <!-- About / location -->
<section class="avuna-about" aria-labelledby="avunaAboutTitle">
    <div class="wrap">
        <div class="avuna-about-copy">
            <h2 id="avunaAboutTitle">A brand built on getting it right the first time</h2>
            <p class="eyebrow">BASED IN DURBAN</p>

            <p>Avuna Collective is a clothing brand and customisation business serving individuals who want branded apparel. We are your solution to embroidering designs for any occasion.
                Avuna Collective operates as an apparel brand and customization service offering end-to-end solutions including garment design, and personalization.
                We transform your designs onto perfected wearable clothing pieces. Every order, from a single hoodie to corporate wear, is handled through one
                organised system, and not scattered across many platforms.</p>

        </div>
    </div>
</section>

<!-- Services -->
<section class="avuna-services" id="services" aria-labelledby="avunaServicesTitle">
    <div class="wrap">
        <div class="avuna-section-head">
            <h2 id="avunaServicesTitle">From concept to closet</h2>
            <p>End-to-end apparel and branding, whether you're one customer with an idea or a company
                outfitting a whole team.</p>
        </div>
        <div class="avuna-service-grid">
            <div class="avuna-service-card">
                <span class="num">01</span>
                <h3>Custom Design</h3>
                <p>Bring your own artwork or work with us to develop it — fit, fabric, and finish
                    chosen to match your vision.</p>
            </div>
            <div class="avuna-service-card">
                <span class="num">02</span>
                <h3>Branded Apparel</h3>
                <p>Uniforms, team kits, and corporate wear produced to a consistent standard across
                    every size and every order.</p>
            </div>
            <div class="avuna-service-card">
                <span class="num">03</span>
                <h3>Personalisation &amp; Print</h3>
                <p>Embroidery, screen print, and heat transfer applied to individual pieces or full
                    production runs.</p>
            </div>
            <div class="avuna-service-card">
                <span class="num">04</span>
                <h3>Production &amp; Fulfilment</h3>
                <p>Every order queued, produced, and quality-checked, with status updated as it moves
                    through the floor.</p>
            </div>

        </div>
    </div>
</section>
     </div>
</main>
    
</asp:Content>


