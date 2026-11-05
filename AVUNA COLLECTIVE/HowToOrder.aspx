<%@ Page Title="How To Order" Language="C#" MasterPageFile="~/Site.Master"  AutoEventWireup="true" CodeBehind="HowToOrder.aspx.cs" Inherits="AVUNA_COLLECTIVE.HowItWorks" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    
    <style>
     .avuna-process {
     padding: 80px 20px;

 background-image: url('../images/GG-0653_PinksInks_29_lg.jpg');
 background-size: cover;
 background-position: center;
 background-repeat: no-repeat;


}
.avuna-process .avuna-section-head h2 { color: #f2efe8; }
.avuna-process .avuna-section-head p { color:#f2efe8; }
.avuna-process .eyebrow { color: #f2efe8; }

.avuna-steps {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
     padding: 80px 20px;
   
}

.avuna-step {
    position: relative;
    padding: 0 22px 0 0;
    border-right: 1px dashed rgba(242,239,232,0.28);
}
.avuna-step:last-child { border-right: none; padding-right: 0; }

.avuna-step .stepnum {
    font-family: var(--display);
    font-size: 2.6rem;
    color: white;
    line-height: 1;
    margin-bottom: 14px;
}

.avuna-step h4 {
    color: darkorange;
    font-family: var(--body);
    font-size: 1rem;
    font-weight: 700;
    margin: 0 0 8px;
}

.avuna-step p {
    font-size: 0.88rem;
    line-height: 1.55;
    color:white;
    margin: 0;
}

    </style>

 <!-- How to order -->
 <section class="avuna-process" aria-labelledby="avunaProcessTitle">
    <div class="wrap">
        <div class="avuna-section-head">
            <p class="eyebrow">How To Order</p>
            <h2 id="avunaProcessTitle">One order, No guesswork</h2>
            <p>No more chasing replies over WhatsApp or email, your order lives in one place, start
                to finish.</p>
        </div>
    </div>
    <div class="avuna-steps">
    <div class="avuna-step">
        <span class="stepnum">01</span>
        <h4>SUBMIT YOUR DESIGN</h4>
        <p>Upload artwork or describe what you need directly through your Avuna profile.</p>
        <div class="step-thumb">
            <i class="ti ti-upload"></i>
        </div>
    </div>

    <div class="avuna-step">
        <span class="stepnum">02</span>
        <h4>GET A CLEAR QUOTE</h4>
        <p>Pricing calculated accurately against your spec, no manual back and forth.</p>
        <div class="step-thumb">
            <i class="ti ti-receipt"></i>
        </div>
    </div>

    <div class="avuna-step">
        <span class="stepnum">03</span>
        <h4>MAKE A PAYMENT</h4>
        <p>Upon receiving a quote, make a payment to start the production of your order.</p>
        <div class="step-thumb">
            <i class="ti ti-credit-card"></i>
        </div>
    </div>

    <div class="avuna-step">
        <span class="stepnum">04</span>
        <h4>WE PRODUCE IT</h4>
        <p>Your order moves through our production floor, tracked at every stage.</p>
        <div class="step-thumb">
            <i class="ti ti-shirt"></i>
        </div>
    </div>

    <div class="avuna-step">
        <span class="stepnum">05</span>
        <h4>TRACK &amp; RECEIVE</h4>
        <p>Check your status any time and get notified the moment it's ready.</p>
        <div class="step-thumb">
            <i class="ti ti-truck-delivery"></i>
        </div>
    </div>
</div>
</section>

 

</asp:Content>