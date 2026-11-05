<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AVUNA_COLLECTIVE._Default" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Anton&family=Work+Sans:wght@400;500;600;700&family=Space+Mono:wght@400;700&display=swap');

        /* ---------- Scoped design tokens ---------- */
        .avuna-home {
            --dark: #0f2b2c;
            --dark-soft: #17403f;
            --orange: #d9711f;
            --gold: #d9a52c;
            --paper: #faf8f4;
            --ink: #14201f;
            --line: #e2dfd4;
            --display: 'Anton', sans-serif;
            --body: 'Work Sans', sans-serif;
            --mono: 'Space Mono', monospace;

            font-family: var(--body);
            color: var(--ink);
            background: var(--paper);
            margin: -15px;
        }

        .avuna-home * { box-sizing: border-box; }
        .avuna-home a { text-decoration: none; }
        .avuna-home img { max-width: 100%; }

        .avuna-home .wrap {
            max-width: 1120px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .avuna-home .eyebrow {
            font-family: var(--mono);
            font-size: 0.78rem;
            letter-spacing: 0.14em;
            text-transform: uppercase;
        }

        /* ---------- Hero ---------- */
        .avuna-hero {
         width: 100%;
         height: 100vh;
    min-height: 100vh;

    background-image: url("../images/avuna_collective_background.jpg");
    background-size: cover;
    background-position: center top;
    background-repeat: no-repeat;

    display: flex;
    align-items: center;

    padding: 80px, 20px;
   
        }

 

        .avuna-hero .wrap {
            display: flex;
            align-items: center;
            gap: 56px;
            flex-wrap: wrap;
        }

        .avuna-hero-copy { flex: 1 1 440px; }

        .avuna-hero .eyebrow { color: var(--gold); margin-bottom: 18px; }

        .avuna-hero h1 {
           
            font-family: var(--display);
            font-weight: 400;
            font-size: clamp(2.6rem, 5.4vw, 4.2rem);
            line-height: 1.02;
            letter-spacing: 0.01em;
            margin: 0 0 22px;
            text-transform: uppercase;
        }

        .avuna-hero h1 span { color: var(--orange); }

        .avuna-hero p.lead {
            font-size: 1.1rem;
            line-height: 1.65;
            max-width: 46ch;
            color: #ffffff;
            text-shadow:  0 1px 4px rgba(0, 0, 0, 0.9), 0 3px 10px rgba(0, 0, 0, 0.6);
            font-weight: 500;
            margin-bottom: 34px;
        }

        .avuna-cta-row { display: flex; gap: 16px; flex-wrap: wrap; 
          
        }

        .avuna-btn {
            display: inline-block;
            font-family: var(--body);
            font-weight: 600;
            font-size: 0.95rem;
            padding: 14px 26px;
            border-radius: 2px;
            transition: transform 0.15s ease, background 0.15s ease;
        }
        .avuna-btn:focus-visible { outline: 3px solid var(--gold); outline-offset: 2px; }

        .avuna-btn-primary {
            background: var(--orange);
            color: #fff;
        }
        .avuna-btn-primary:hover { background: #c05f14; transform: translateY(-1px); color: #fff; }

        .avuna-btn-ghost {
            border: 1px solid rgba(242, 239, 232, 0.4);
            color: #f2efe8;
        }
        .avuna-btn-ghost:hover { border-color: var(--gold); color: var(--gold); }

/*WHAT WE OFFER SECTION*/


  :root{
    --ink:      #14201f;   /* deep forest — matches header/nav */
    --parchment:#EFE6D8;   /* warm section background */
    --gold:     #d9a52c;   /* Avuna wordmark gold */
    --orange:   #d9711f;   /* matches your "Start Your Order" CTA */
    --charcoal: #1B1B1B;
    --thread:   #C9B896;
  }

  

  .avuna-offer{
    background: var(--parchment);
    padding: 96px 6vw 110px;
    font-family: 'Inter', sans-serif;
    color: var(--charcoal);
  }

  .avuna-offer__head{
    text-align: center;
    max-width: 640px;
    margin: 0 auto 20px;
  }

 

  .avuna-offer__title{
    font-family: var(--display);
    font-size: clamp(2.6rem, 5.4vw, 4.2rem);
    letter-spacing:  0.01em;
    color: var(--ink);
    margin:  0 0 22px;
    line-height:  1.02;
  }

  
  .avuna-offer__sub{
    font-size: 15.5px;
    line-height: 1.6;
    color: #4b463c;
    margin: 18px auto 0;
    max-width: 520px;
  }

 

  .avuna-offer__grid{
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 28px;
    max-width: 1180px;
    margin: 0 auto;
  }

  @media (max-width: 900px){
    .avuna-offer__grid{ grid-template-columns: repeat(2, 1fr); }
  }
  @media (max-width: 560px){
    .avuna-offer__grid{ grid-template-columns: 1fr; }
  }

  .avuna-card{
    position: relative;
    aspect-ratio: 4 / 5;
    border-radius: 2px;
    overflow: hidden;
    cursor: pointer;
    background: var(--ink);
    isolation: isolate;
  }

  .avuna-card__img{
    position:absolute; inset:0;
    background-size: cover;
    background-position: center;
    transform: scale(1.04);
    transition: transform 0.6s cubic-bezier(.2,.7,.2,1);
  }
  .avuna-card:hover .avuna-card__img{ transform: scale(1.12); }

  .avuna-card__shade{
    position:absolute; inset:0;
    background: linear-gradient(to top, rgba(22,38,31,0.92) 0%, rgba(22,38,31,0.15) 55%, rgba(22,38,31,0) 75%);
  }

  .avuna-card__tag{
    position:absolute; top:16px; left:16px;
    font-size: 11px;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--ink);
    background: var(--thread);
    padding: 5px 10px;
    border-radius: 2px;
  }

  .avuna-card__info{
    position:absolute; left:0; right:0; bottom:0;
    padding: 20px 20px 22px;
    color: #F5F1E8;
  }

  .avuna-card__name{
    font-family: 'Bebas Neue', sans-serif;
    font-size: 24px;
    letter-spacing: 0.03em;
    margin: 0 0 4px;
  }

  .avuna-card__meta{
    font-size: 12.5px;
    color: var(--thread);
    margin: 0;
    max-height: 0;
    opacity: 0;
    overflow: hidden;
    transition: max-height 0.35s ease, opacity 0.35s ease;
  }
  .avuna-card:hover .avuna-card__meta{
    max-height: 40px;
    opacity: 1;
  }

  .avuna-card__seam{
    position:absolute; inset: 10px;
    border: 1.5px dashed rgba(245,241,232,0);
    border-radius: 1px;
    transition: border-color 0.4s ease;
    pointer-events: none;
  }
  .avuna-card:hover .avuna-card__seam{
    border-color: rgba(245,241,232,0.55);
  }

  .avuna-offer__cta{
    display:flex;
    justify-content:center;
    margin-top: 56px;
  }
  .avuna-offer__cta a{
    display:inline-block;
    background: var(--orange);
    color: #fff;
    font-weight: 600;
    font-size: 14.5px;
    letter-spacing: 0.03em;
    text-decoration:none;
    padding: 15px 34px;
    border-radius: 2px;
    transition: filter 0.2s ease, transform 0.2s ease;
  }
  .avuna-offer__cta a:hover{ filter: brightness(1.08); transform: translateY(-1px); }

  @media (prefers-reduced-motion: reduce){
    .avuna-card__img, .avuna-card__meta, .avuna-card__seam, .avuna-offer__cta a{ transition: none; }
  }


        /* ---------- Hang-tag signature element ---------- */
        .avuna-tag-wrap { flex: 1 1 300px; display: flex; justify-content: center; }

        .avuna-tag {
            position: relative;
            width: 270px;
            background: var(--paper);
            color: var(--ink);
            padding: 30px 24px 26px;
            border-radius: 4px;
            transform: rotate(4deg);
            box-shadow: 0 30px 60px rgba(0,0,0,0.35);
        }

        .avuna-tag::before {
            content: "";
            position: absolute;
            top: 20px;
            left: 24px;
            width: 16px;
            height: 16px;
            border: 3px solid var(--dark);
            border-radius: 50%;
            background: var(--paper);
        }

        .avuna-tag-string {
            position: absolute;
            top: -34px;
            left: 30px;
            width: 42px;
            height: 44px;
            border: 3px solid var(--gold);
            border-bottom: none;
            border-radius: 50% 50% 0 0 / 100% 100% 0 0;
            transform: rotate(-6deg);
        }

        .avuna-tag-label {
            font-family: var(--mono);
            font-size: 0.68rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: #7a7568;
            margin: 22px 0 4px;
        }

        .avuna-tag-value {
            font-family: var(--mono);
            font-size: 0.95rem;
            font-weight: 700;
            margin-bottom: 14px;
        }

        .avuna-tag-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: var(--mono);
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--dark);
            border: 1px dashed var(--dark);
            padding: 6px 10px;
            margin-top: 6px;
        }
        .avuna-tag-status::before {
            content: "";
            width: 8px; height: 8px;
            border-radius: 50%;
            background: var(--orange);
        }


        /* ---------- CTA band ---------- */
        .avuna-cta-band {
            background: var(--gold);
            color: var(--dark);
            width: 100%;
            max-width: none;
            padding: 56px 0;
            margin: 0;
           box-sizing: border-box;
        }
        .avuna-cta-band .wrap {
            width: 100%;
            max-width: none;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            flex-wrap: wrap;
            box-sizing: border-box;
        }
        .avuna-cta-band h2 {
            font-family: var(--display);
            font-weight: 400;
            text-transform: uppercase;
            font-size: clamp(1.5rem, 3vw, 2.1rem);
            margin: 0;
        }
        .avuna-cta-band .avuna-btn-primary { background: var(--dark); }
        .avuna-cta-band .avuna-btn-primary:hover { background: #08191a; }

        /* ---------- Responsive ---------- */
        @media (max-width: 900px) {
            .avuna-service-grid { grid-template-columns: repeat(2, 1fr); }
            .avuna-steps { grid-template-columns: repeat(2, 1fr); row-gap: 32px; }
            .avuna-step { border-right: none; }
            .avuna-step:nth-child(odd) { border-right: 1px dashed rgba(242,239,232,0.28); padding-right: 22px; }
        }
        @media (max-width: 620px) {
            .avuna-service-grid { grid-template-columns: 1fr; }
            .avuna-steps { grid-template-columns: 1fr; }
            .avuna-step:nth-child(odd) { border-right: none; padding-right: 0; }
            .avuna-tag { transform: rotate(2deg); }
            .avuna-hero { padding: 56px 0 64px; }
        }

        @media (prefers-reduced-motion: reduce) {
            .avuna-btn { transition: none; }
        }
    </style>

    <div class="avuna-home">

        <!-- Hero -->
        <section class="avuna-hero" aria-labelledby="avunaHeroTitle">
            <div class="wrap">
                <div class="avuna-hero-copy">
                    <h1> WELCOME TO AVUNA COLLECTIVE</h1>
                    <p class="lead">Avuna Collective turns a sketch, a logo, or a vision into finished garments —
                        for individuals who want something no one else is wearing, and for businesses that need
                        branded workwear done right. Submit your design online and follow it from cutting table
                        to delivery.</p>
                    <div class="avuna-cta-row">
                        <a href="#avuna-cta-brand" class="avuna-btn avuna-btn-primary">Place Your Order</a>
                    </div>
                </div>
               
            </div>
        </section>

<section class="avuna-offer">
  <div class="avuna-offer__head">
   
    <h2 class="avuna-offer__title">What We Offer</h2>
    <p class="avuna-offer__sub">
      A selection of garments we've taken from sketch to stitch. From custom pieces
      for individuals and branded workwear for teams. We are your go to for any occasions that need custom apparel.
       We bring your vision to life.  From a simple deisign, to complex designs you need on your clothing,
        you can trust us at Avuna Collective to get the job done.
        We are your one stop shop for all your custom apparel needs.
    </p>
  </div>


  <div class="avuna-offer__grid" id="avunaGrid">

    <!-- Each .avuna-card is one finished project. -->

    <div class="avuna-card">
      <div class="avuna-card__img" style="background-image:url('../images/sweater.jpg')"></div>
      <div class="avuna-card__shade"></div>
      <div class="avuna-card__seam"></div>
      <span class="avuna-card__tag">Custom Apparel</span>
      <div class="avuna-card__info">
        <h3 class="avuna-card__name">Signature Sweater</h3>
       
      </div>
    </div>

    <div class="avuna-card">
      <div class="avuna-card__img" style="background-image:url('../images/jacket.jpg')"></div>
      <div class="avuna-card__shade"></div>
      <div class="avuna-card__seam"></div>
      <span class="avuna-card__tag">Custom Apparel</span>
      <div class="avuna-card__info">
        <h3 class="avuna-card__name">Jackets</h3>
       
      </div>
    </div>

    <div class="avuna-card">
      <div class="avuna-card__img" style="background-image:url('../images/cap.jpg')"></div>
      <div class="avuna-card__shade"></div>
      <div class="avuna-card__seam"></div>
      <span class="avuna-card__tag">Headwear</span>
      <div class="avuna-card__info">
        <h3 class="avuna-card__name">Embroidered Cap</h3>
       
      </div>
    </div>

    <div class="avuna-card">
      <div class="avuna-card__img" style="background-image:url('../images/tshirt.jpg')"></div>
      <div class="avuna-card__shade"></div>
      <div class="avuna-card__seam"></div>
      <span class="avuna-card__tag">Custom Apparel</span>
      <div class="avuna-card__info">
        <h3 class="avuna-card__name">Everyday T-Shirt</h3>
       
      </div>
    </div>

    <div class="avuna-card">
      <div class="avuna-card__img" style="background-image:url('../images/Golf tshirt.jpg')"></div>
      <div class="avuna-card__shade"></div>
      <div class="avuna-card__seam"></div>
      <span class="avuna-card__tag">Custom Apparel</span>
      <div class="avuna-card__info">
        <h3 class="avuna-card__name">Branded Golf T-shirt</h3>
       
      </div>
    </div>

    <div class="avuna-card">
      <div class="avuna-card__img" style="background-image:url('../images/jersey.jpg')"></div>
      <div class="avuna-card__shade"></div>
      <div class="avuna-card__seam"></div>
      <span class="avuna-card__tag">Custom Apparel</span>
      <div class="avuna-card__info">
        <h3 class="avuna-card__name">A Personalised Jersey</h3>
       
      </div>
    </div>

  </div>
</section> 
       
       
        <!-- CTA band -->
        <section class="avuna-cta-band" id="avuna-cta-brand" aria-labelledby="avunaCtaTitle">
            <div class="wrap">
                <h2 id="avunaCtaTitle">Ready to get your order moving?</h2>
                <a href="~/Register.aspx" runat="server" class="avuna-btn avuna-btn-primary" data-bs-toggle="modal" data-bs-target="#accountTypeModal">Create Your Account</a>
                 <a href="~/Login.aspx" runat="server" class="avuna-btn avuna-btn-primary">Log Into Your Account</a>
            </div>
        </section>

    </div>

</asp:Content>
