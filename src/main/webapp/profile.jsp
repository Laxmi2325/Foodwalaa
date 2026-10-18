
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="com.tap.modell.User" %>

<%!
    private String safe(String value) {

        if (value == null || value.trim().isEmpty()) {
            return "Not provided";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User user = (User) request.getAttribute("profileUser");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/profile");
        return;
    }

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Profile | Foodwala</title>

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
            min-height: 100vh;
            overflow-x: hidden;

            display: flex;
            flex-direction: column;
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

            background: #111;

            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;

            box-shadow:
                0 3px 20px rgba(0, 0, 0, 0.15);
        }

        /* =========================
           FOODWALA LOGO
        ========================= */

        .logo {
            display: inline-flex;
            align-items: center;
            flex-shrink: 0;

            text-decoration: none;
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
           NAVIGATION
        ========================= */

        .nav {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .nav a {
            color: white;
            text-decoration: none;

            font-size: 14px;
            font-weight: bold;

            transition: color 0.3s ease;
            white-space: nowrap;
        }

        .nav a:hover {
            color: #ff6b35;
        }

        .cart-link {
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
            background: #ff6b35;
            color: white;

            border: none;
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
            background: #e85a2a;
            transform: translateY(-2px);
        }

        /* =========================
           MAIN CONTAINER
        ========================= */

        .container {
            width: 100%;
            max-width: 900px;

            margin: 55px auto 70px;
            padding: 0 20px;

            flex: 1;
        }

        /* =========================
           PAGE HEADING
        ========================= */

        .heading {
            text-align: center;
            margin-bottom: 32px;

            animation: fadeUp 0.6s ease;
        }

        .section-label {
            color: #ff6b35;

            font-size: 12px;
            font-weight: bold;
            letter-spacing: 2px;

            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .heading h1 {
            color: #111;

            font-size: 36px;
            font-weight: 800;

            margin-bottom: 10px;
        }

        .heading p {
            color: #777;
            font-size: 15px;
            line-height: 1.6;
        }

        /* =========================
           PROFILE CARD
        ========================= */

        .profile-card {
            background: white;

            border-radius: 22px;
            overflow: hidden;

            border:
                1px solid rgba(0, 0, 0, 0.04);

            box-shadow:
                0 10px 35px rgba(0, 0, 0, 0.08);

            animation: fadeUp 0.7s ease;
        }

        /* =========================
           PROFILE BANNER
        ========================= */

        .profile-banner {
            position: relative;

            background:
                radial-gradient(
                    circle at 85% 20%,
                    rgba(255, 107, 53, 0.23),
                    transparent 35%
                ),
                linear-gradient(
                    135deg,
                    #111111,
                    #352019
                );

            color: white;
            text-align: center;

            padding: 42px 20px 38px;

            overflow: hidden;
        }

        .profile-banner::before {
            content: "";

            position: absolute;

            width: 180px;
            height: 180px;

            border-radius: 50%;

            border:
                1px solid rgba(255, 107, 53, 0.20);

            top: -100px;
            right: -65px;

            pointer-events: none;
        }

        .avatar {
            position: relative;

            width: 85px;
            height: 85px;

            border-radius: 50%;

            background:
                linear-gradient(
                    135deg,
                    #ff6b35,
                    #f04423
                );

            display: flex;
            align-items: center;
            justify-content: center;

            margin: 0 auto 17px;

            font-size: 38px;

            border:
                3px solid rgba(255, 255, 255, 0.25);

            box-shadow:
                0 8px 25px rgba(255, 107, 53, 0.25);
        }

        .profile-banner h2 {
            position: relative;

            font-size: 25px;
            font-weight: 800;

            margin-bottom: 9px;

            overflow-wrap: anywhere;
        }

        .profile-banner p {
            position: relative;

            color: #cccccc;
            font-size: 14px;
        }

        /* =========================
           PROFILE DETAILS
        ========================= */

        .profile-details {
            padding: 38px;
        }

        .section-title {
            color: #171717;

            font-size: 19px;
            font-weight: 800;

            margin-bottom: 25px;
            padding-bottom: 14px;

            border-bottom:
                2px solid #fff0e9;
        }

        .details-grid {
            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            gap: 22px;
        }

        /* =========================
           INDIVIDUAL DETAIL
        ========================= */

        .detail {
            background: #fff9f5;

            padding: 20px;

            border-radius: 13px;

            border:
                1px solid #ffede4;

            min-width: 0;

            transition:
                transform 0.3s ease,
                border-color 0.3s ease,
                box-shadow 0.3s ease;
        }

        .detail:hover {
            transform: translateY(-3px);

            border-color:
                rgba(255, 107, 53, 0.45);

            box-shadow:
                0 7px 20px rgba(255, 107, 53, 0.07);
        }

        .detail-label {
            color: #888;

            font-size: 12px;
            font-weight: bold;

            text-transform: uppercase;
            letter-spacing: 1px;

            margin-bottom: 10px;
        }

        .detail-value {
            color: #222;

            font-size: 15px;
            font-weight: 600;

            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .address-detail {
            grid-column: 1 / -1;
        }

        /* =========================
           PROFILE FOOTER
        ========================= */

        .profile-footer {
            margin-top: 32px;
            text-align: center;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;

            background: #ff6b35;
            color: white;

            text-decoration: none;

            padding: 13px 25px;
            border-radius: 25px;

            font-size: 14px;
            font-weight: bold;

            transition: all 0.3s ease;
        }

        .back-button:hover {
            background: #111;
            transform: translateY(-2px);

            box-shadow:
                0 8px 20px rgba(0, 0, 0, 0.12);
        }

        /* =========================
           WEBSITE FOOTER
        ========================= */

        .site-footer {
            background: #111;
            color: #aaa;

            text-align: center;
            padding: 25px 20px;

            font-size: 13px;
            line-height: 1.6;
        }

        .site-footer strong {
            color: #ff6b35;
        }

        /* =========================
           ANIMATIONS
        ========================= */

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

        @media (max-width: 650px) {

            .header {
                min-height: 70px;
                padding: 12px 15px;
            }

            .brand-logo {
                width: 115px;
                max-height: 48px;
            }

            .nav {
                gap: 10px;
            }

            .nav a {
                font-size: 12px;
            }

            .logout-button {
                padding: 9px 12px;
                font-size: 12px;
            }

            .container {
                margin: 35px auto 50px;
            }

            .heading h1 {
                font-size: 29px;
            }

            .profile-details {
                padding: 23px;
            }

            .details-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .address-detail {
                grid-column: auto;
            }

            .profile-banner {
                padding: 35px 18px;
            }

            .profile-banner h2 {
                font-size: 22px;
            }
        }

        @media (max-width: 390px) {

            .header {
                padding-left: 10px;
                padding-right: 10px;
            }

            .brand-logo {
                width: 95px;
                max-height: 42px;
            }

            .nav {
                gap: 7px;
            }

            .nav a {
                font-size: 11px;
            }

            .logout-button {
                padding: 8px 9px;
                font-size: 11px;
            }

            .profile-details {
                padding: 18px;
            }
        }

        @media (prefers-reduced-motion: reduce) {

            *,
            *::before,
            *::after {
                animation-duration: 0.01ms !important;
                transition-duration: 0.01ms !important;
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

        <!-- NAVIGATION -->

        <nav class="nav" aria-label="Main navigation">

            <a href="<%= contextPath %>/restaurant">
                Restaurants
            </a>

            <a href="<%= contextPath %>/cart"
               class="cart-link">
                &#128722; Cart
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

        </nav>

    </header>

    <!-- =========================
         PROFILE SECTION
    ========================= -->

    <main class="container">

        <!-- PAGE HEADING -->

        <div class="heading">

            <div class="section-label">
                MY FOODWALA ACCOUNT
            </div>

            <h1>My Profile</h1>

            <p>
                Your personal account information,
                all in one place.
            </p>

        </div>

        <!-- PROFILE CARD -->

        <div class="profile-card">

            <!-- PROFILE BANNER -->

            <div class="profile-banner">

                <div class="avatar" aria-hidden="true">
                    &#128100;
                </div>

                <h2>
                    <%= safe(user.getUsername()) %>
                </h2>

                <p>Foodwala Customer</p>

            </div>

            <!-- PROFILE INFORMATION -->

            <div class="profile-details">

                <h3 class="section-title">
                    Personal Information
                </h3>

                <div class="details-grid">

                    <!-- USERNAME -->

                    <div class="detail">

                        <div class="detail-label">
                            Username
                        </div>

                        <div class="detail-value">
                            <%= safe(user.getUsername()) %>
                        </div>

                    </div>

                    <!-- EMAIL -->

                    <div class="detail">

                        <div class="detail-label">
                            Email Address
                        </div>

                        <div class="detail-value">
                            <%= safe(user.getEmail()) %>
                        </div>

                    </div>

                    <!-- PHONE -->

                    <div class="detail">

                        <div class="detail-label">
                            Phone Number
                        </div>

                        <div class="detail-value">
                            <%= safe(user.getPhone()) %>
                        </div>

                    </div>

                    <!-- ACCOUNT ROLE -->

                    <div class="detail">

                        <div class="detail-label">
                            Account Role
                        </div>

                        <div class="detail-value">
                            <%= safe(user.getRole()) %>
                        </div>

                    </div>

                    <!-- ADDRESS -->

                    <div class="detail address-detail">

                        <div class="detail-label">
                            Delivery Address
                        </div>

                        <div class="detail-value">
                            <%= safe(user.getAddress()) %>
                        </div>

                    </div>

                </div>

                <!-- BACK BUTTON -->

                <div class="profile-footer">

                    <a href="<%= contextPath %>/restaurant"
                       class="back-button">

                        &#8592; Back to Restaurants

                    </a>

                </div>

            </div>

        </div>

    </main>

    <!-- =========================
         FOOTER
    ========================= -->

    <footer class="site-footer">

        <p>
            &#169; 2026
            <strong>Foodwala</strong>
            • Made for Food Lovers
        </p>

    </footer>

</body>
</html>
