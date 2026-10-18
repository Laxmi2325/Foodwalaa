
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List, com.tap.modell.Restaurant"%>

<%
    String contextPath = request.getContextPath();
    boolean isLoggedIn = session.getAttribute("loggedInUser") != null;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodwala - Restaurants</title>

    <style>

        /* =========================
           GLOBAL STYLES
        ========================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: Arial, sans-serif;
            background: #fff7f2;
            color: #222;
            overflow-x: hidden;
        }

        /* =========================
           HEADER
        ========================= */

        .header {
            position: sticky;
            top: 0;
            z-index: 1000;

            min-height: 76px;
            padding: 10px 6%;

            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;

            background: #111111;

            box-shadow:
                0 3px 20px rgba(0, 0, 0, 0.15);
        }

        /* =========================
           FOODWALA IMAGE LOGO
        ========================= */

        .logo {
            display: inline-flex;
            align-items: center;
            justify-content: flex-start;

            text-decoration: none;
            flex-shrink: 0;

            line-height: 0;
        }

        .brand-logo {
            display: block;

            width: 155px;
            height: auto;
            max-height: 58px;

            object-fit: contain;

            transition:
                transform 0.3s ease,
                filter 0.3s ease;
        }

        .logo:hover .brand-logo {
            transform: scale(1.05);
            filter: brightness(1.12);
        }

        /* =========================
           HEADER RIGHT
        ========================= */

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .location {
            color: #eeeeee;
            font-size: 14px;
            white-space: nowrap;
        }

        /* =========================
           CART BUTTON
        ========================= */

        .cart-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;

            text-decoration: none;
            color: white;
            background: #ff6b35;

            padding: 10px 18px;
            border-radius: 25px;

            font-size: 14px;
            font-weight: bold;

            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .cart-button:hover {
            background: white;
            color: #111;
            transform: translateY(-2px);
        }

        /* =========================
           ACCOUNT NAVIGATION
        ========================= */

        .account-nav {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .login-link,
        .profile-link {
            color: white;
            text-decoration: none;

            font-size: 14px;
            font-weight: bold;

            transition: color 0.3s ease;
            white-space: nowrap;
        }

        .login-link:hover,
        .profile-link:hover {
            color: #ff6b35;
        }

        .profile-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        /* =========================
           LOGOUT BUTTON
        ========================= */

        .logout-form {
            margin: 0;
            padding: 0;
        }

        .logout-button {
            background: transparent;
            color: white;

            border:
                1px solid rgba(255, 255, 255, 0.45);

            border-radius: 25px;

            padding: 10px 18px;

            font-family: inherit;
            font-size: 14px;
            font-weight: bold;

            cursor: pointer;

            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .logout-button:hover {
            background: #ff6b35;
            border-color: #ff6b35;
            transform: translateY(-2px);
        }

        /* =========================
           HERO SECTION
        ========================= */

        .hero {
            position: relative;

            width: 100%;
            min-height: 500px;

            display: flex;
            align-items: center;

            padding: 55px 7%;

            background:
                radial-gradient(
                    circle at 70% 50%,
                    rgba(255, 107, 53, 0.20),
                    transparent 38%
                ),
                linear-gradient(
                    135deg,
                    #111111 0%,
                    #181818 55%,
                    #241714 100%
                );

            overflow: hidden;
        }

        .hero::before {
            content: "";

            position: absolute;

            width: 500px;
            height: 500px;

            right: -180px;
            top: -180px;

            border-radius: 50%;

            background:
                rgba(255, 107, 53, 0.08);

            filter: blur(2px);
        }

        .hero::after {
            content: "";

            position: absolute;

            width: 250px;
            height: 250px;

            left: -120px;
            bottom: -150px;

            border-radius: 50%;

            border:
                1px solid rgba(255, 107, 53, 0.18);
        }

        /* =========================
           HERO LEFT CONTENT
        ========================= */

        .hero-content {
            position: relative;
            z-index: 3;

            width: 50%;
            padding-right: 35px;

            animation: heroText 0.9s ease;
        }

        .hero-small {
            display: inline-block;

            color: #ff6b35;

            font-size: 13px;
            font-weight: bold;
            letter-spacing: 2.5px;

            margin-bottom: 18px;
        }

        .hero-title {
            color: white;

            font-size: clamp(42px, 5vw, 66px);
            line-height: 1.05;
            letter-spacing: -2px;

            margin-bottom: 20px;
        }

        .hero-title .orange {
            color: #ff6b35;
            display: block;
        }

        .hero-title .white {
            color: white;
            display: block;
        }

        .hero-description {
            max-width: 520px;

            color: #cccccc;

            font-size: 16px;
            line-height: 1.75;

            margin-bottom: 28px;
        }

        .hero-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;

            text-decoration: none;

            background: #ff6b35;
            color: white;

            padding: 13px 24px;
            border-radius: 25px;

            font-size: 14px;
            font-weight: bold;

            transition: all 0.3s ease;
        }

        .hero-button:hover {
            background: white;
            color: #111;

            transform: translateY(-3px);

            box-shadow:
                0 12px 30px rgba(255, 107, 53, 0.25);
        }

        /* =========================
           HERO ANIMATION AREA
        ========================= */

        .hero-animation-wrapper {
            position: relative;
            z-index: 2;

            width: 50%;
            height: 430px;

            display: flex;
            justify-content: center;
            align-items: center;

            animation: animationEnter 1s ease;
        }

        .hero-animation {
            position: relative;

            width: 330px;
            height: 430px;

            overflow: hidden;
            border-radius: 28px;

            background:
                linear-gradient(
                    145deg,
                    #d9443b,
                    #ef5a43
                );

            box-shadow:
                0 25px 70px rgba(0, 0, 0, 0.40);

            transform: rotate(1deg);

            transition:
                transform 0.5s ease,
                box-shadow 0.5s ease;
        }

        .hero-animation:hover {
            transform:
                rotate(0deg)
                translateY(-8px)
                scale(1.015);

            box-shadow:
                0 35px 80px rgba(0, 0, 0, 0.48);
        }

        .hero-animation video {
            width: 100%;
            height: 100%;

            display: block;
            object-fit: cover;
        }

        .hero-animation::after {
            content: "";

            position: absolute;
            inset: 0;

            border-radius: 28px;

            border:
                1px solid rgba(255, 255, 255, 0.16);

            pointer-events: none;
        }

        .animation-glow {
            position: absolute;

            width: 370px;
            height: 370px;

            border-radius: 50%;

            background:
                radial-gradient(
                    circle,
                    rgba(255, 107, 53, 0.30),
                    transparent 70%
                );

            filter: blur(15px);
            z-index: -1;
        }

        /* =========================
           MAIN CONTENT
        ========================= */

        .container {
            width: 88%;
            max-width: 1350px;

            margin: 0 auto;
            padding: 65px 0 80px;
        }

        /* =========================
           PAGE TITLE
        ========================= */

        .page-title {
            text-align: center;
            margin-bottom: 42px;

            animation: fadeUp 0.8s ease;
        }

        .section-label {
            color: #ff6b35;

            font-size: 13px;
            font-weight: bold;
            letter-spacing: 2px;

            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .page-title h1 {
            font-size: 36px;
            color: #111;
            margin-bottom: 10px;
        }

        .page-title p {
            color: #777;
            font-size: 16px;
        }

        /* =========================
           RESTAURANT GRID
        ========================= */

        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
        }

        /* =========================
           RESTAURANT CARD
        ========================= */

        .restaurant-card {
            position: relative;

            background: white;
            border-radius: 20px;
            overflow: hidden;

            box-shadow:
                0 5px 20px rgba(0, 0, 0, 0.07);

            border:
                1px solid rgba(0, 0, 0, 0.04);

            transition:
                transform 0.35s ease,
                box-shadow 0.35s ease;

            animation: fadeUp 0.7s ease both;
        }

        .restaurant-card:hover {
            transform: translateY(-10px);

            box-shadow:
                0 18px 40px rgba(0, 0, 0, 0.14);
        }

        .restaurant-card:nth-child(2) {
            animation-delay: 0.05s;
        }

        .restaurant-card:nth-child(3) {
            animation-delay: 0.10s;
        }

        .restaurant-card:nth-child(4) {
            animation-delay: 0.15s;
        }

        .restaurant-card:nth-child(5) {
            animation-delay: 0.20s;
        }

        .restaurant-card:nth-child(6) {
            animation-delay: 0.25s;
        }

        /* =========================
           RESTAURANT IMAGE
        ========================= */

        .image-wrapper {
            position: relative;

            width: 100%;
            height: 235px;

            overflow: hidden;
            background: #eeeeee;
        }

        .restaurant-image {
            width: 100%;
            height: 100%;

            object-fit: cover;
            display: block;

            transition:
                transform 0.6s ease,
                filter 0.4s ease;
        }

        .restaurant-card:hover .restaurant-image {
            transform: scale(1.08);
            filter: brightness(0.88);
        }

        .image-wrapper::after {
            content: "";

            position: absolute;

            left: 0;
            right: 0;
            bottom: 0;

            height: 80px;

            background:
                linear-gradient(
                    transparent,
                    rgba(0, 0, 0, 0.35)
                );

            pointer-events: none;
        }

        .rating-badge {
            position: absolute;

            left: 15px;
            bottom: 15px;
            z-index: 2;

            background: #267a3e;
            color: white;

            padding: 6px 10px;
            border-radius: 7px;

            font-size: 13px;
            font-weight: bold;

            box-shadow:
                0 4px 12px rgba(0, 0, 0, 0.18);
        }

        /* =========================
           CARD CONTENT
        ========================= */

        .restaurant-content {
            padding: 22px;
        }

        .restaurant-name {
            color: #151515;
            font-size: 21px;
            font-weight: 800;

            margin-bottom: 7px;
            line-height: 1.25;
        }

        .cuisine {
            display: inline-block;

            background: #fff1eb;
            color: #e85a2a;

            padding: 5px 10px;
            border-radius: 20px;

            font-size: 12px;
            font-weight: bold;

            margin-bottom: 16px;
        }

        .restaurant-info {
            display: flex;
            justify-content: space-between;
            align-items: center;

            gap: 10px;
            margin-bottom: 14px;
        }

        .rating {
            background: #267a3e;
            color: white;

            padding: 5px 9px;
            border-radius: 6px;

            font-size: 12px;
            font-weight: bold;
        }

        .delivery {
            color: #555;
            font-size: 13px;
            font-weight: 600;
        }

        .address {
            min-height: 38px;

            color: #777;
            font-size: 13px;
            line-height: 1.5;

            margin-bottom: 18px;
        }

        /* =========================
           MENU BUTTON
        ========================= */

        .menu-button {
            display: block;
            width: 100%;

            text-align: center;
            text-decoration: none;

            background: #111;
            color: white;

            padding: 12px;
            border-radius: 10px;

            font-size: 14px;
            font-weight: bold;

            transition:
                background 0.3s ease,
                transform 0.3s ease;
        }

        .menu-button:hover {
            background: #ff6b35;
            transform: translateY(-2px);
        }

        /* =========================
           EMPTY MESSAGE
        ========================= */

        .empty-message {
            text-align: center;

            background: white;
            padding: 50px;
            border-radius: 20px;

            box-shadow:
                0 5px 20px rgba(0, 0, 0, 0.07);
        }

        .empty-message h2 {
            margin-bottom: 10px;
        }

        .empty-message p {
            color: #777;
        }

        /* =========================
           FOOTER
        ========================= */

        .footer {
            background: #111;
            color: #aaa;

            text-align: center;
            padding: 28px 20px;

            font-size: 13px;
        }

        .footer strong {
            color: #ff6b35;
        }

        /* =========================
           ANIMATIONS
        ========================= */

        @keyframes heroText {

            from {
                opacity: 0;
                transform: translateX(-45px);
            }

            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes animationEnter {

            from {
                opacity: 0;

                transform:
                    translateX(45px)
                    scale(0.94);
            }

            to {
                opacity: 1;

                transform:
                    translateX(0)
                    scale(1);
            }
        }

        @keyframes fadeUp {

            from {
                opacity: 0;
                transform: translateY(25px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* =========================
           RESPONSIVE DESIGN
        ========================= */

        @media (max-width: 1100px) {

            .restaurant-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .hero-animation {
                width: 290px;
                height: 390px;
            }
        }

        @media (max-width: 800px) {

            .hero {
                min-height: 750px;
                flex-direction: column;
                justify-content: center;

                text-align: center;
                padding: 55px 7%;
            }

            .hero-content {
                width: 100%;
                padding-right: 0;
                margin-bottom: 35px;
            }

            .hero-description {
                margin-left: auto;
                margin-right: auto;
            }

            .hero-animation-wrapper {
                width: 100%;
                height: 350px;
            }

            .hero-animation {
                width: 250px;
                height: 330px;
            }
        }

        @media (max-width: 650px) {

            .header {
                padding: 12px 15px;
                min-height: 70px;
            }

            .brand-logo {
                width: 115px;
                max-height: 48px;
            }

            .header-right {
                gap: 9px;
            }

            .location {
                display: none;
            }

            .cart-button {
                padding: 9px 11px;
                font-size: 12px;
            }

            .account-nav {
                gap: 9px;
            }

            .profile-link,
            .login-link {
                font-size: 12px;
            }

            .logout-button {
                padding: 9px 11px;
                font-size: 12px;
            }

            .hero {
                min-height: 700px;
            }

            .hero-title {
                font-size: 42px;
                letter-spacing: -1px;
            }

            .hero-animation {
                width: 220px;
                height: 300px;
                border-radius: 22px;
            }

            .restaurant-grid {
                grid-template-columns: 1fr;
                gap: 22px;
            }

            .page-title h1 {
                font-size: 29px;
            }

            .container {
                padding-top: 45px;
            }

            .image-wrapper {
                height: 220px;
            }
        }

        @media (max-width: 390px) {

            .header {
                padding-left: 10px;
                padding-right: 10px;
            }

            .brand-logo {
                width: 100px;
                max-height: 42px;
            }

            .header-right,
            .account-nav {
                gap: 7px;
            }

            .profile-link {
                gap: 3px;
            }

            .cart-button,
            .logout-button {
                padding: 8px;
                font-size: 11px;
            }
        }

    </style>

</head>

<body>

    <!-- =========================
         HEADER
    ========================= -->

    <header class="header">

        <!-- FOODWALA IMAGE LOGO -->

        <a href="<%= contextPath %>/restaurant"
           class="logo"
           aria-label="Foodwala Home">

            <img
                src="<%= contextPath %>/images/branding/foodwala-logo.png"
                alt="Foodwala"
                class="brand-logo">

        </a>

        <div class="header-right">

            <!-- LOCATION -->

            <span class="location">
                &#128205; Bengaluru
            </span>

            <!-- CART -->

            <a href="<%= contextPath %>/cart"
               class="cart-button">
                &#128722; Cart
            </a>

            <!-- ACCOUNT NAVIGATION -->

            <div class="account-nav">

                <% if (isLoggedIn) { %>

                    <!-- PROFILE -->

                    <a href="<%= contextPath %>/profile"
                       class="profile-link">
                        &#128100; Profile
                    </a>

                    <!-- LOGOUT -->

                    <form action="<%= contextPath %>/logout"
                          method="post"
                          class="logout-form">

                        <button type="submit"
                                class="logout-button">
                            Logout
                        </button>

                    </form>

                <% } else { %>

                    <!-- LOGIN -->

                    <a href="<%= contextPath %>/login.jsp"
                       class="login-link">
                        Login
                    </a>

                <% } %>

            </div>

        </div>

    </header>

    <!-- =========================
         HERO SECTION
    ========================= -->

    <section class="hero">

        <!-- LEFT SIDE -->

        <div class="hero-content">

            <div class="hero-small">
                FOODWALA • BENGALURU
            </div>

            <h1 class="hero-title">

                <span class="white">
                    Treat yourself.
                </span>

                <span class="orange">
                    You deserve
                    better food.
                </span>

            </h1>

            <p class="hero-description">

                Take a break, explore something delicious
                and enjoy your favourite flavours from
                Bengaluru's restaurants.

            </p>

            <a href="#restaurants"
               class="hero-button">

                Explore Restaurants &#8595;

            </a>

        </div>

        <!-- RIGHT SIDE ANIMATION -->

        <div class="hero-animation-wrapper">

            <div class="animation-glow"></div>

            <div class="hero-animation">

                <video
                    autoplay
                    muted
                    loop
                    playsinline
                    preload="auto">

                    <source
                        src="<%= contextPath %>/videos/foodwala-animation.mp4"
                        type="video/mp4">

                    Your browser does not support video.

                </video>

            </div>

        </div>

    </section>

    <!-- =========================
         MAIN CONTENT
    ========================= -->

    <main class="container" id="restaurants">

        <div class="page-title">

            <div class="section-label">
                Explore • Choose • Enjoy
            </div>

            <h1>
                Restaurants in Bengaluru
            </h1>

            <p>
                Discover delicious food from restaurants near you
            </p>

        </div>

        <%

            List<Restaurant> restaurants =
                (List<Restaurant>) request.getAttribute("Restaurants");

            if (restaurants != null && !restaurants.isEmpty()) {

        %>

            <div class="restaurant-grid">

                <%

                    for (Restaurant restaurant : restaurants) {

                %>

                    <div class="restaurant-card">

                        <div class="image-wrapper">

                            <img
                                class="restaurant-image"
                                src="<%= restaurant.getImagePath() %>"
                                alt="<%= restaurant.getName() %>">

                            <span class="rating-badge">
                                &#9733; <%= restaurant.getRating() %>
                            </span>

                        </div>

                        <div class="restaurant-content">

                            <div class="restaurant-name">
                                <%= restaurant.getName() %>
                            </div>

                            <div class="cuisine">
                                <%= restaurant.getCuisineType() %>
                            </div>

                            <div class="restaurant-info">

                                <span class="rating">
                                    &#9733; <%= restaurant.getRating() %>
                                </span>

                                <span class="delivery">

                                    &#128338;
                                    <%= restaurant.getDeliveryTime() %>
                                    mins

                                </span>

                            </div>

                            <div class="address">

                                &#128205;
                                <%= restaurant.getAddress() %>

                            </div>

                            <a class="menu-button"
                               href="<%= contextPath %>/menu?restaurantId=<%= restaurant.getRestaurantId() %>">

                                View Menu &#8594;

                            </a>

                        </div>

                    </div>

                <%

                    }

                %>

            </div>

        <%

            } else {

        %>

            <div class="empty-message">

                <h2>
                    No restaurants available
                </h2>

                <p>
                    Please check again later.
                </p>

            </div>

        <%

            }

        %>

    </main>

    <!-- =========================
         FOOTER
    ========================= -->

    <footer class="footer">

        <p>

            &#169; 2026

            <strong>Foodwala</strong>

            • Delicious food, delivered with care.

        </p>

    </footer>

</body>
</html>
