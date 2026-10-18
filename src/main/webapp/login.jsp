
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String contextPath = request.getContextPath();

    String error = (String) request.getAttribute("error");

    boolean registered =
        "1".equals(request.getParameter("registered"));
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Login | Foodwala</title>

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
            min-height: 100vh;

            font-family: Arial, sans-serif;

            background: #fff7f2;
            color: #222;

            display: flex;
            flex-direction: column;

            overflow-x: hidden;
        }

        /* =========================
           HEADER
        ========================= */

        .header {
            position: relative;
            z-index: 10;

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

        .header-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .location {
            color: #ddd;
            font-size: 14px;
            white-space: nowrap;
        }

        .home-link {
            color: white;

            text-decoration: none;
            font-size: 14px;
            font-weight: bold;

            transition: color 0.3s ease;
            white-space: nowrap;
        }

        .home-link:hover {
            color: #ff6b35;
        }

        /* =========================
           LOGIN SECTION
        ========================= */

        .login-section {
            position: relative;
            isolation: isolate;

            flex: 1;

            display: flex;
            justify-content: center;
            align-items: center;

            padding: 65px 20px;

            background:
                radial-gradient(
                    circle at 10% 20%,
                    rgba(255, 107, 53, 0.12),
                    transparent 35%
                ),
                radial-gradient(
                    circle at 90% 85%,
                    rgba(255, 107, 53, 0.10),
                    transparent 35%
                ),
                #fff7f2;

            overflow: hidden;
        }

        .login-section::before {
            content: "";

            position: absolute;

            width: 350px;
            height: 350px;

            border-radius: 50%;

            border:
                1px solid rgba(255, 107, 53, 0.16);

            top: -190px;
            left: -120px;

            pointer-events: none;
            z-index: -1;
        }

        .login-section::after {
            content: "";

            position: absolute;

            width: 300px;
            height: 300px;

            border-radius: 50%;

            background:
                rgba(255, 107, 53, 0.055);

            right: -140px;
            bottom: -160px;

            pointer-events: none;
            z-index: -1;
        }

        /* =========================
           LOGIN CARD
        ========================= */

        .login-card {
            position: relative;

            width: 100%;
            max-width: 450px;

            background: white;

            padding: 40px;

            border-radius: 22px;

            border:
                1px solid rgba(0, 0, 0, 0.04);

            box-shadow:
                0 15px 45px rgba(0, 0, 0, 0.09);

            animation: fadeUp 0.7s ease both;
        }

        .login-card::before {
            content: "";

            position: absolute;

            top: 0;
            left: 45px;
            right: 45px;

            height: 4px;

            background:
                linear-gradient(
                    90deg,
                    #ff6b35,
                    #ffad78
                );

            border-radius: 0 0 8px 8px;
        }

        /* =========================
           LOGIN HEADING
        ========================= */

        .login-label {
            color: #ff6b35;

            text-align: center;

            font-size: 12px;
            font-weight: bold;
            letter-spacing: 2px;

            margin-bottom: 12px;
        }

        .login-title {
            color: #111;

            text-align: center;

            font-size: 31px;
            font-weight: 800;

            margin-bottom: 10px;
        }

        .login-subtitle {
            color: #777;

            text-align: center;

            font-size: 14px;
            line-height: 1.7;

            margin-bottom: 30px;
        }

        /* =========================
           ERROR MESSAGE
        ========================= */

        .error-message {
            background: #fff0ee;
            color: #b42318;

            padding: 13px 15px;

            border-radius: 9px;

            border:
                1px solid #ffd0ca;

            font-size: 13px;
            line-height: 1.5;

            margin-bottom: 20px;
            text-align: center;

            overflow-wrap: anywhere;
        }

        /* =========================
           SUCCESS MESSAGE
        ========================= */

        .success-message {
            background: #e9f8ed;
            color: #18713b;

            padding: 13px 15px;

            border-radius: 9px;

            border:
                1px solid #c9ebd2;

            font-size: 13px;
            line-height: 1.6;

            text-align: center;

            margin-bottom: 20px;
        }

        /* =========================
           FORM
        ========================= */

        .form-group {
            margin-bottom: 21px;
        }

        .form-group label {
            display: block;

            margin-bottom: 9px;

            color: #333;

            font-size: 13px;
            font-weight: bold;
        }

        .form-group input {
            display: block;

            width: 100%;

            padding: 14px 15px;

            background: #fffdfb;
            color: #222;

            border:
                1px solid #e5e1dd;

            border-radius: 10px;

            font-family: inherit;
            font-size: 14px;

            outline: none;

            transition:
                border-color 0.3s ease,
                box-shadow 0.3s ease,
                background 0.3s ease;
        }

        .form-group input::placeholder {
            color: #aaa;
        }

        .form-group input:hover {
            border-color: #ffc2a9;
        }

        .form-group input:focus {
            background: white;

            border-color: #ff6b35;

            box-shadow:
                0 0 0 3px rgba(255, 107, 53, 0.11);
        }

        /* =========================
           LOGIN BUTTON
        ========================= */

        .login-button {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;

            width: 100%;

            margin-top: 8px;
            padding: 14px 18px;

            background: #111;
            color: white;

            border: none;
            border-radius: 10px;

            font-family: inherit;
            font-size: 15px;
            font-weight: bold;

            cursor: pointer;

            transition:
                background 0.3s ease,
                transform 0.3s ease,
                box-shadow 0.3s ease;
        }

        .login-button:hover {
            background: #ff6b35;

            transform: translateY(-2px);

            box-shadow:
                0 9px 22px rgba(255, 107, 53, 0.22);
        }

        .login-button:active {
            transform: translateY(0);
        }

        /* =========================
           REGISTER LINK
        ========================= */

        .register-text {
            color: #666;

            text-align: center;

            margin-top: 26px;

            font-size: 14px;
            line-height: 1.6;
        }

        .register-text a {
            color: #ff6b35;

            text-decoration: none;
            font-weight: bold;

            transition: color 0.3s ease;
        }

        .register-text a:hover {
            color: #d84c1d;
            text-decoration: underline;
        }

        /* =========================
           CARD BOTTOM
        ========================= */

        .card-bottom {
            margin-top: 25px;
            padding-top: 20px;

            border-top:
                1px solid #f0ece8;

            text-align: center;

            color: #999;

            font-size: 11px;
            letter-spacing: 1.3px;
            font-weight: bold;
        }

        /* =========================
           FOOTER
        ========================= */

        .footer {
            background: #111;
            color: #aaa;

            text-align: center;

            padding: 24px 20px;

            font-size: 13px;
            line-height: 1.6;
        }

        .footer strong {
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

            .header-right {
                gap: 12px;
            }

            .location {
                display: none;
            }

            .home-link {
                font-size: 12px;
            }

            .login-section {
                padding: 40px 16px;
            }

            .login-card {
                padding: 32px 23px;
                border-radius: 18px;
            }

            .login-title {
                font-size: 28px;
            }

            .login-subtitle {
                font-size: 13px;
            }
        }

        @media (max-width: 390px) {

            .brand-logo {
                width: 100px;
                max-height: 42px;
            }

            .login-card {
                padding: 30px 19px;
            }

            .login-title {
                font-size: 26px;
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

        <div class="header-right">

            <span class="location">
                &#128205; Bengaluru
            </span>

            <a href="<%= contextPath %>/restaurant"
               class="home-link">

                Explore Restaurants &#8594;

            </a>

        </div>

    </header>

    <!-- =========================
         LOGIN SECTION
    ========================= -->

    <main class="login-section">

        <div class="login-card">

            <!-- HEADING -->

            <div class="login-label">
                MADE FOR FOOD LOVERS
            </div>

            <h1 class="login-title">
                Welcome Back!
            </h1>

            <p class="login-subtitle">
                Login to continue your delicious
                Foodwala journey.
            </p>

            <!-- =========================
                 ERROR MESSAGE
            ========================= -->

            <% if (error != null && !error.trim().isEmpty()) { %>

                <div class="error-message"
                     role="alert">

                    <%= escapeHtml(error) %>

                </div>

            <% } %>

            <!-- =========================
                 REGISTRATION SUCCESS
            ========================= -->

            <% if (registered) { %>

                <div class="success-message"
                     role="status">

                    Account created successfully!<br>
                    Please login to continue.

                </div>

            <% } %>

            <!-- =========================
                 LOGIN FORM
            ========================= -->

            <form action="<%= contextPath %>/login"
                  method="post">

                <!-- USERNAME -->

                <div class="form-group">

                    <label for="username">
                        Username
                    </label>

                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your username"
                        autocomplete="username"
                        maxlength="100"
                        required>

                </div>

                <!-- PASSWORD -->

                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>

                </div>

                <!-- LOGIN BUTTON -->

                <button type="submit"
                        class="login-button">

                    Login &#8594;

                </button>

            </form>

            <!-- =========================
                 REGISTRATION LINK
            ========================= -->

            <div class="register-text">

                Don't have an account?

                <a href="<%= contextPath %>/register">
                    Create Account
                </a>

            </div>

            <div class="card-bottom">
                FOODWALA • MADE FOR FOOD LOVERS
            </div>

        </div>

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
