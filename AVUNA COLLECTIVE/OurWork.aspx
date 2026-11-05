<%@ Page Title="Our Work" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OurWork.aspx.cs" Inherits="AVUNA_COLLECTIVE.Our_Work" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&family=IBM+Plex+Mono:wght@500;600&display=swap" rel="stylesheet">

    <style>
        
        /* 
           OUR WORK — token system
           Ink        #14201f   (existing site dark)
           Thread     #00b67a   (existing site accent)
           Canvas     #F7F5F0   (warm neutral, woven texture)
           Charcoal   #3A3A3A   (secondary text)
           Rust       #C1552C  (sparing accent — hover / active only)  */

        #avunaWorkPage {
            font-family: Arial, sans-serif;
            color: #14201f;
        }

        /* HEADER BAND */
        #avunaWorkPage .av-work-header {
            position: relative;
            padding: 80px 30px 46px;
            text-align: center;
            background-color: #F7F5F0;
            background-image:
                repeating-linear-gradient(45deg, rgba(20,32,31,0.035) 0px, rgba(20,32,31,0.035) 1px, transparent 1px, transparent 13px),
                repeating-linear-gradient(-45deg, rgba(20,32,31,0.035) 0px, rgba(20,32,31,0.035) 1px, transparent 1px, transparent 13px);
            overflow: hidden;
        }

        #avunaWorkPage .av-work-eyebrow {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: #00b67a;
            margin: 0 0 14px;
        }

        #avunaWorkPage .av-work-title {
            font-family: 'Fraunces', serif;
            font-weight: 600;
            font-size: 52px;
            line-height: 1;
            margin: 0;
            color: #14201f;
        }

        #avunaWorkPage .av-work-subtitle {
            font-size: 16px;
            color: #3A3A3A;
            max-width: 480px;
            margin: 16px auto 0;
            line-height: 1.5;
        }

        #avunaWorkPage .av-stitch-divider {
            width: 70px;
            margin: 28px auto 34px;
            border-top: 2px dashed #00b67a;
        }

        /*  FILTER TAGS (garment-tag styling) */
        #avunaWorkPage .av-work-filters {
            display: flex !important;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
        }

        #avunaWorkPage .av-filter-tag {
            position: relative;
            display: inline-flex !important;
            align-items: center;
            gap: 8px;
            padding: 8px 18px 8px 22px;
            background: #fff;
            border: 1px solid #d8d5cc;
            border-radius: 3px 10px 10px 3px;
            font-family: 'IBM Plex Mono', monospace;
            font-size: 12px;
            font-weight: 500;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #3A3A3A;
            cursor: pointer;
            transition: 0.2s;
        }

        #avunaWorkPage .av-filter-tag::before {
            content: '';
            position: absolute;
            left: 9px;
            top: 50%;
            transform: translateY(-50%);
            width: 5px;
            height: 5px;
            border-radius: 50%;
            border: 1px solid #b6b2a6;
            background: #F7F5F0;
        }

        #avunaWorkPage .av-filter-tag:hover {
            border-color: #00b67a;
            color: #14201f;
        }

        #avunaWorkPage .av-filter-tag.active {
            background: #14201f;
            border-color: #14201f;
            color: #fff;
        }

        #avunaWorkPage .av-filter-tag.active::before {
            border-color: #00b67a;
            background: #00b67a;
        }

        /* ---------- MASONRY GALLERY ---------- */
        #avunaWorkPage .av-work-section {
            max-width: 1400px;
            margin: 0 auto;
            padding: 50px 30px 70px;
            box-sizing: border-box;
        }

        #avunaWorkPage .av-work-grid {
            column-count: 3;
            column-gap: 20px;
        }

        @media (max-width: 900px) {
            #avunaWorkPage .av-work-grid { column-count: 2; }
        }

        @media (max-width: 560px) {
            #avunaWorkPage .av-work-grid { column-count: 1; }
        }

        #avunaWorkPage .av-work-item {
            position: relative;
            break-inside: avoid;
            margin-bottom: 20px;
            border-radius: 10px;
            overflow: hidden;
            background: #eee;
            cursor: pointer;
        }

        #avunaWorkPage .av-work-item img {
            width: 100%;
            display: block;
            transition: transform 0.5s ease;
        }

        #avunaWorkPage .av-work-item:hover img {
            transform: scale(1.06);
        }

        /* tailor's-mark corner brackets — signature hover detail */
        #avunaWorkPage .av-work-item::before,
        #avunaWorkPage .av-work-item::after {
            content: '';
            position: absolute;
            width: 22px;
            height: 22px;
            border: 2px dashed #fff;
            opacity: 0;
            transition: opacity 0.3s ease, transform 0.3s ease;
            pointer-events: none;
            z-index: 3;
        }

        #avunaWorkPage .av-work-item::before {
            top: 10px;
            left: 10px;
            border-right: none;
            border-bottom: none;
            transform: translate(-6px, -6px);
        }

        #avunaWorkPage .av-work-item::after {
            bottom: 10px;
            right: 10px;
            border-left: none;
            border-top: none;
            transform: translate(6px, 6px);
        }

        #avunaWorkPage .av-work-item:hover::before,
        #avunaWorkPage .av-work-item:hover::after {
            opacity: 1;
            transform: translate(0, 0);
        }

        #avunaWorkPage .av-work-overlay {
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            padding: 30px 16px 14px;
            background: linear-gradient(to top, rgba(10,20,18,0.88) 0%, rgba(10,20,18,0) 100%);
            transform: translateY(8px);
            opacity: 0;
            transition: 0.3s ease;
            z-index: 2;
        }

        #avunaWorkPage .av-work-item:hover .av-work-overlay {
            opacity: 1;
            transform: translateY(0);
        }

        #avunaWorkPage .av-work-tag {
            display: inline-block;
            font-family: 'IBM Plex Mono', monospace;
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #00b67a;
            margin-bottom: 6px;
        }

        #avunaWorkPage .av-work-name {
            font-family: 'Fraunces', serif;
            font-size: 17px;
            font-weight: 600;
            color: #fff;
            margin: 0;
        }

        #avunaWorkPage .av-work-item.av-hidden {
            display: none;
        }

        /* ---------- CTA ---------- */
        #avunaWorkPage .av-work-cta {
            text-align: center;
            padding: 60px 30px 90px;
            border-top: 1px dashed #d8d5cc;
        }

        #avunaWorkPage .av-work-cta h3 {
            font-family: 'Fraunces', serif;
            font-size: 28px;
            font-weight: 600;
            margin: 0 0 10px;
            color: #14201f;
        }

        #avunaWorkPage .av-work-cta p {
            color: #3A3A3A;
            font-size: 15px;
            margin: 0 0 26px;
        }

        #avunaWorkPage .av-cta-btn {
            display: inline-block;
            background: #14201f;
            color: #fff;
            font-family: 'IBM Plex Mono', monospace;
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            text-decoration: none;
            padding: 14px 30px;
            border-radius: 3px 10px 10px 3px;
            transition: 0.2s;
        }

        #avunaWorkPage .av-cta-btn:hover {
            background: #00b67a;
        }
    </style>

    <div id="avunaWorkPage">

        <div class="av-work-header">
            <h1 class="av-work-title">Our Work</h1>
            <p class="av-work-subtitle">Work we have completed for some of our clients.</p>
            <div class="av-stitch-divider"></div>

           
        </div>

        <div class="av-work-section">
            <!-- Replace image src + labels with real project photos. Repeat this block for each commission. -->
            <div class="av-work-grid" id="workGrid">

                <div class="av-work-item" data-category="tailoring">
                    <img src="<%= ResolveUrl("~/images/Picture1.jpg") %>" />
                    <div class="av-work-overlay">
                    </div>
                </div>

                <div class="av-work-item" data-category="bridal">
                    <img src="<%= ResolveUrl("~/images/Picture2.jpg") %>"/>
                    <div class="av-work-overlay">
                    </div>
                </div>

                <div class="av-work-item" data-category="corporate">
                    <img src="<%= ResolveUrl("~/images/Picture3.jpg") %>" />
                    <div class="av-work-overlay">
                    </div>
                </div>

                <div class="av-work-item" data-category="alterations">
                    <img src="<%= ResolveUrl("~/images/Picture4.jpg") %>" />
                    <div class="av-work-overlay">
                    </div>
                </div>

                <div class="av-work-item" data-category="occasion">
                    <img src="<%= ResolveUrl("~/images/Picture5.jpg") %>" />
                    <div class="av-work-overlay">
                    </div>
                </div>

                <div class="av-work-item" data-category="tailoring">
                    <img src="<%= ResolveUrl("~/images/Picture6.jpg") %>" />
                    <div class="av-work-overlay">
                    </div>
                </div>

                <div class="av-work-item" data-category="bridal">
                    <img src="<%= ResolveUrl("~/images/Picture7.jpg") %>" />
                    <div class="av-work-overlay">
                    </div>
                </div>

                <div class="av-work-item" data-category="corporate">
                    <img src="<%= ResolveUrl("~/images/Picture8.jpg") %>"  />
                    <div class="av-work-overlay">
                    </div>
                </div>

               <div class="av-work-item" data-category="corporate">
                    <img src="<%= ResolveUrl("~/images/Picture9.jpg") %>"  />
                    <div class="av-work-overlay">
                    </div>
               </div>

            </div>
        </div>

        <div class="av-work-cta">
            <h3>Have a project in mind?</h3>
            <p>Tell us what you're picturing and we'll help you bring it to life.</p>
            <a class="av-cta-btn" href="<%= ResolveUrl("~/HowToOrder.aspx") %>">Place an Order</a>
        </div>

    </div>

    <script>
        (function () {
            var filters = document.querySelectorAll('#workFilters .av-filter-tag');
            var items = document.querySelectorAll('#workGrid .av-work-item');

            filters.forEach(function (tag) {
                tag.addEventListener('click', function () {
                    filters.forEach(function (t) { t.classList.remove('active'); });
                    tag.classList.add('active');

                    var value = tag.getAttribute('data-filter');

                    items.forEach(function (item) {
                        if (value === 'all' || item.getAttribute('data-category') === value) {
                            item.classList.remove('av-hidden');
                        } else {
                            item.classList.add('av-hidden');
                        }
                    });
                });
            });
        })();
    </script>

</asp:Content>