<%@ Page Title="Client Reviews" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClientReviews.aspx.cs" Inherits="AVUNA_COLLECTIVE.ClientReviews" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* ---------- PAGE HERO BANNER ---------- */
        #avunaReviewsPage .av-hero {
            position: relative;
            width: 100%;
            height: 420px;
            overflow: hidden;
        }

        #avunaReviewsPage .av-hero img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center 35%;
            display: block;
        }

        #avunaReviewsPage .av-hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(10, 30, 25, 0.45);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        #avunaReviewsPage .av-hero-overlay h1 {
            color: #fff;
            font-size: 44px;
            font-weight: 700;
            margin: 0;
            letter-spacing: 1px;
        }

        #avunaReviewsPage .av-hero-overlay p {
            color: #f0f0f0;
            font-size: 16px;
            margin-top: 10px;
        }

        /* ---------- RECENT REVIEWS CAROUSEL ---------- */
        #avunaReviewsPage .av-reviews-section {
            max-width: 1400px;
            margin: 50px auto;
            padding: 0 30px;
            font-family: Arial, sans-serif;
            box-sizing: border-box;
        }

        #avunaReviewsPage .av-reviews-header {
            display: flex !important;
            align-items: center;
            justify-content: flex-end;
            position: relative;
            margin-bottom: 24px;
        }

        #avunaReviewsPage .av-reviews-heading {
            font-size: 26px;
            font-weight: 700;
            color: #14201f;
            margin: 0;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        #avunaReviewsPage .av-reviews-nav {
            display: flex !important;
            gap: 10px;
        }

        #avunaReviewsPage .av-nav-btn {
            width: 36px;
            height: 36px;
            border-radius: 50% !important;
            border: 1px solid #d6d6ec;
            background: #fff;
            color: #5b5b8a;
            font-size: 16px;
            cursor: pointer;
            display: flex !important;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
        }

        #avunaReviewsPage .av-nav-btn:hover {
            background: #f0f0fb;
        }

        #avunaReviewsPage .av-reviews-viewport {
            overflow: hidden;
            width: 100%;
        }

        #avunaReviewsPage .av-reviews-track {
            display: flex !important;
            flex-wrap: nowrap !important;
            gap: 20px;
            overflow-x: auto;
            scroll-behavior: smooth;
            scrollbar-width: none;
            -ms-overflow-style: none;
        }

        #avunaReviewsPage .av-reviews-track::-webkit-scrollbar {
            display: none;
        }

        #avunaReviewsPage .av-review-card {
            flex: 0 0 calc(25% - 15px) !important;
            min-width: 260px;
            border: 1px solid #e6e6e6;
            border-radius: 10px;
            padding: 20px;
            background: #fff;
            display: flex !important;
            flex-direction: column !important;
            box-sizing: border-box;
        }

        @media (max-width: 1100px) {
            #avunaReviewsPage .av-review-card { flex: 0 0 calc(50% - 10px) !important; }
        }

        @media (max-width: 640px) {
            #avunaReviewsPage .av-review-card { flex: 0 0 85% !important; }
        }

        #avunaReviewsPage .av-review-header {
            display: flex !important;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }

        #avunaReviewsPage .av-review-avatar {
            width: 40px !important;
            height: 40px !important;
            min-width: 40px !important;
            border-radius: 50% !important;
            display: flex !important;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 700;
            font-size: 16px;
            flex-shrink: 0 !important;
            box-sizing: border-box;
        }

        #avunaReviewsPage .av-review-name-wrap {
            display: flex;
            flex-direction: column;
        }

        #avunaReviewsPage .av-review-name {
            font-weight: 700;
            font-size: 15px;
            color: #1a1a1a;
        }

        #avunaReviewsPage .av-review-stars {
            display: inline-flex !important;
            gap: 2px;
            background-color: #00b67a;
            padding: 3px 6px;
            border-radius: 3px;
            width: fit-content;
            margin-top: 4px;
        }

        #avunaReviewsPage .av-review-stars.low { background-color: #ff3722; }
        #avunaReviewsPage .av-review-stars.mid { background-color: #ff8622; }

        #avunaReviewsPage .av-review-stars span {
            color: #fff;
            font-size: 13px;
            line-height: 1;
        }

        #avunaReviewsPage .av-review-text {
            font-size: 14px;
            color: #333;
            line-height: 1.5;
            flex-grow: 1;
            display: -webkit-box;
            -webkit-line-clamp: 4;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        #avunaReviewsPage .av-review-date {
            font-size: 12px;
            color: #999;
            margin-top: 14px;
        }

        #avunaReviewsPage .av-no-reviews {
            color: #666;
            font-size: 15px;
            padding: 20px 0;
            width: 100%;
            text-align: center;
        }
    </style>

    <div id="avunaReviewsPage">

        <!-- HERO BANNER -->
        <div class="av-hero">
            <img src="<%= ResolveUrl("~/Images/avuna_collective_background.jpg") %>" alt="Avuna Collective workshop" />
            <div class="av-hero-overlay">
                <h1>Client Reviews</h1>
                <p>See what our clients have to say about Avuna Collective.</p>
            </div>
        </div>

        <div class="av-reviews-section">

            <div class="av-reviews-header">
                <h2 class="av-reviews-heading">Recent Reviews</h2>
                <div class="av-reviews-nav">
                    <button type="button" class="av-nav-btn" id="btnPrev" onclick="scrollReviews(-1)" aria-label="Previous">&#8249;</button>
                    <button type="button" class="av-nav-btn" id="btnNext" onclick="scrollReviews(1)" aria-label="Next">&#8250;</button>
                </div>
            </div>

            <div class="av-reviews-viewport">
                <div class="av-reviews-track" id="reviewsTrack">
                    <asp:Repeater ID="rptReviews" runat="server">
                        <ItemTemplate>
                            <div class="av-review-card">
                                <div class="av-review-header">
                                    <div class="av-review-avatar" style='<%# "background-color:" + Eval("AvatarColor") %>'>
                                        <%# Eval("Initial") %>
                                    </div>
                                    <div class="av-review-name-wrap">
                                        <span class="av-review-name"><%# Eval("Name") %></span>
                                        <div class='<%# "av-review-stars " + Eval("StarClass") %>'>
                                            <%# Eval("StarsHtml") %>
                                        </div>
                                    </div>
                                </div>
                                <div class="av-review-text"><%# Eval("Comment") %></div>
                                <div class="av-review-date"><%# Eval("DateText") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Literal ID="litNoReviews" runat="server" />
                </div>
            </div>
        </div>

    </div>

    <script>
        function scrollReviews(direction) {
            var track = document.getElementById('reviewsTrack');
            var card = track.querySelector('.av-review-card');
            if (!card) return;
            var cardWidth = card.getBoundingClientRect().width + 20;
            track.scrollBy({ left: direction * cardWidth, behavior: 'smooth' });
        }
    </script>

</asp:Content>