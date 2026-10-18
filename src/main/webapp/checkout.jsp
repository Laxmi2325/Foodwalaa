
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.tap.modell.User" %>
<%@ page import="com.tap.modell.Cart" %>
<%@ page import="com.tap.modell.CartItem" %>
<%@ page import="java.util.Locale" %>

<%!
    private String safe(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String money(double value) {
        return String.format(Locale.US, "%.2f", value);
    }
%>

<%
    String contextPath = request.getContextPath();

    User user = (User) session.getAttribute("loggedInUser");
    Cart cart = (Cart) session.getAttribute("cart");

    if (user == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    boolean hasItems = cart != null
            && cart.getItems() != null
            && !cart.getItems().isEmpty();

    double subtotal = 0;

    if (hasItems) {
        for (CartItem item : cart.getItems()) {
            subtotal += item.getTotalPrice();
        }
    }

    double deliveryFee = 40;
    double couponDiscount = 0;

    Object discountObject = session.getAttribute("couponDiscount");

    if (discountObject instanceof Number) {
        couponDiscount = ((Number) discountObject).doubleValue();
    }

    double total = Math.max(
        0,
        subtotal + deliveryFee - couponDiscount
    );

    String couponMessage =
        (String) session.getAttribute("couponMessage");

    String appliedCoupon =
        (String) session.getAttribute("couponCode");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Secure Checkout | Foodwala</title>

    <style>

        /* =========================
           GLOBAL
        ========================= */

        :root {
            --black: #141414;
            --orange: #ff6b35;
            --orange-dark: #e95520;
            --cream: #fff7f2;
            --muted: #777;
            --line: #f0e7e0;
            --green: #23834b;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: var(--cream);
            color: var(--black);
            min-height: 100vh;
        }

        button,
        input,
        textarea {
            font: inherit;
        }

        a {
            text-decoration: none;
        }

        /* =========================
           NAVBAR
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

            gap: 20px;

            box-shadow: 0 4px 22px rgba(0, 0, 0, 0.15);
        }

        .logo {
            display: inline-flex;
            align-items: center;
            line-height: 0;
            flex-shrink: 0;
        }

        .brand-logo {
            display: block;

            width: 155px;
            max-height: 58px;
            height: auto;

            object-fit: contain;

            transition:
                transform 0.3s ease,
                filter 0.3s ease;
        }

        .logo:hover .brand-logo {
            transform: scale(1.06);
            filter: brightness(1.15);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .location {
            color: #ddd;
            font-size: 13px;
            white-space: nowrap;
        }

        .nav-link {
            color: white;
            font-size: 13px;
            font-weight: bold;
            white-space: nowrap;

            transition: color 0.2s ease;
        }

        .nav-link:hover {
            color: var(--orange);
        }

        .cart-link {
            background: var(--orange);
            color: white;

            padding: 11px 17px;
            border-radius: 25px;

            font-size: 13px;
            font-weight: bold;
            white-space: nowrap;

            transition:
                background 0.2s ease,
                transform 0.2s ease;
        }

        .cart-link:hover {
            background: var(--orange-dark);
            transform: translateY(-2px);
        }

        /* =========================
           PAGE INTRO
        ========================= */

        .intro {
            padding: 43px 7% 30px;

            background:
                radial-gradient(
                    circle at 92% 10%,
                    rgba(255, 107, 53, 0.11),
                    transparent 38%
                ),
                linear-gradient(
                    135deg,
                    #fff7f2,
                    #fffdfb
                );
        }

        .intro-inner {
            max-width: 1200px;
            margin: auto;

            animation: fadeUp 0.5s ease both;
        }

        .eyebrow {
            color: var(--orange);
            letter-spacing: 2px;
            font-size: 11px;
            font-weight: 800;
            margin-bottom: 11px;
        }

        .intro h1 {
            margin-bottom: 11px;

            font-size: clamp(29px, 4vw, 39px);
            line-height: 1.2;
        }

        .intro h1 span {
            color: var(--orange);
        }

        .intro p {
            color: #706b68;
            font-size: 14px;
            line-height: 1.7;
        }

        .steps {
            display: flex;
            align-items: center;
            flex-wrap: wrap;

            gap: 9px;
            margin-top: 23px;

            font-size: 12px;
            font-weight: bold;
            color: #999;
        }

        .steps .done {
            color: var(--green);
        }

        .steps .current {
            color: var(--orange);
        }

        .steps .line {
            width: 24px;
            height: 1px;
            background: #d7c9c0;
        }

        /* =========================
           MAIN LAYOUT
        ========================= */

        .container {
            width: 86%;
            max-width: 1200px;

            margin: 30px auto 75px;
        }

        .checkout-layout {
            display: grid;

            grid-template-columns:
                minmax(0, 1fr) minmax(310px, 380px);

            gap: 25px;
            align-items: start;
        }

        /* =========================
           GENERAL CARD
        ========================= */

        .checkout-card {
            background: white;

            border: 1px solid rgba(0, 0, 0, 0.04);
            border-radius: 19px;

            padding: 26px;
            margin-bottom: 22px;

            box-shadow:
                0 6px 23px rgba(0, 0, 0, 0.045);

            animation: fadeUp 0.55s ease both;
        }

        .summary-card {
            position: sticky;
            top: 96px;
        }

        .card-heading {
            display: flex;
            align-items: center;
            gap: 12px;

            margin-bottom: 24px;
            padding-bottom: 18px;

            border-bottom: 1px solid var(--line);
        }

        .heading-icon {
            display: grid;
            place-items: center;

            width: 40px;
            height: 40px;

            flex-shrink: 0;

            border-radius: 12px;

            background: #fff0e7;
            color: var(--orange);

            font-size: 19px;
        }

        .card-heading h2 {
            font-size: 19px;
            margin-bottom: 4px;
        }

        .card-heading p {
            color: var(--muted);
            font-size: 12px;
            line-height: 1.4;
        }

        /* =========================================
           NEW PREMIUM DELIVERY DETAILS
        ========================================= */

        .delivery-card {
            padding: 28px;
            background: white;
            border-radius: 18px;
        }

        .delivery-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;

            gap: 15px;

            padding-bottom: 22px;
            margin-bottom: 25px;

            border-bottom: 1px solid #f0ece8;
        }

        .delivery-heading-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .delivery-icon {
            display: flex;
            align-items: center;
            justify-content: center;

            width: 44px;
            height: 44px;

            flex-shrink: 0;

            background: #fff0e8;
            color: var(--orange);

            border-radius: 12px;
            font-size: 21px;
        }

        .delivery-heading h2 {
            margin-bottom: 6px;

            color: #171717;
            font-size: 20px;
            font-weight: 800;
        }

        .delivery-heading p {
            color: #888;
            font-size: 12px;
            line-height: 1.5;
        }

        .delivery-tag {
            color: var(--orange);
            background: #fff3ec;

            padding: 8px 12px;
            border-radius: 20px;

            font-size: 10px;
            font-weight: 800;

            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        /* CUSTOMER DETAILS GRID */

        .delivery-information {
            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            column-gap: 20px;
            row-gap: 16px;

            margin-bottom: 24px;
        }

        .delivery-field {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: flex-start;

            text-align: left;

            min-width: 0;

            background: #faf9f7;

            padding: 16px 18px;

            border: 1px solid #f0ece8;
            border-radius: 11px;

            transition:
                border-color 0.25s ease,
                background 0.25s ease,
                transform 0.25s ease;
        }

        .delivery-field:hover {
            background: #fffaf6;
            border-color: #ffd3bd;
            transform: translateY(-2px);
        }

        .delivery-label {
            display: block;
            width: 100%;

            color: #999;

            font-size: 10px;
            font-weight: 800;

            letter-spacing: 0.8px;
            text-align: left;

            margin-bottom: 9px;
        }

        .delivery-value {
            display: block;
            width: 100%;

            color: #222;

            font-size: 14px;
            font-weight: 700;
            line-height: 1.6;

            text-align: left;

            overflow-wrap: anywhere;
        }

        .delivery-email {
            grid-column: 1 / -1;
        }

        /* DELIVERY ADDRESS */

        .delivery-address-box {
            background:
                linear-gradient(
                    135deg,
                    #fff9f4,
                    #fff4eb
                );

            border: 1px solid #f6dccb;
            border-radius: 13px;

            padding: 20px;
            text-align: left;
        }

        .address-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;

            gap: 15px;
        }

        .address-heading {
            color: #222;

            font-size: 14px;
            font-weight: 800;

            margin-bottom: 11px;
        }

        .address-value {
            color: #555;

            font-size: 13px;
            line-height: 1.7;
            font-weight: 500;

            white-space: pre-wrap;
            overflow-wrap: anywhere;
            text-align: left;
        }

        .address-status {
            background: #e8f8ed;
            color: #25824b;

            padding: 6px 10px;
            border-radius: 20px;

            font-size: 10px;
            font-weight: 800;
            letter-spacing: 0.5px;

            white-space: nowrap;
        }

        /* ADDRESS BUTTON */

        .change-address-button {
            display: inline-flex;

            margin-top: 18px;

            background: #111;
            color: white;

            padding: 11px 18px;

            border: none;
            border-radius: 25px;

            font-size: 12px;
            font-weight: 700;

            cursor: pointer;

            transition:
                background 0.25s ease,
                transform 0.25s ease;
        }

        .change-address-button:hover {
            background: var(--orange);
            transform: translateY(-2px);
        }

        .address-form {
            margin-top: 18px;
        }

        .address-form[hidden] {
            display: none;
        }

        .address-input {
            width: 100%;
            padding: 13px;

            background: white;

            border: 1px solid #e5d5ca;
            border-radius: 9px;

            font-size: 13px;
            line-height: 1.6;

            resize: vertical;
            outline: none;

            transition:
                border-color 0.2s,
                box-shadow 0.2s;
        }

        .address-input:focus,
        .coupon-input:focus {
            border-color: var(--orange);

            box-shadow:
                0 0 0 3px rgba(255, 107, 53, 0.10);
        }

        .save-address-button {
            background: var(--orange);
            color: white;

            border: none;
            border-radius: 25px;

            padding: 11px 18px;
            margin-top: 11px;

            font-size: 12px;
            font-weight: 800;

            cursor: pointer;

            transition: background 0.2s ease;
        }

        .save-address-button:hover {
            background: #111;
        }

        /* =========================
           YOUR ORDER
        ========================= */

        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;

            gap: 15px;

            padding: 15px 0;

            border-bottom: 1px solid var(--line);
        }

        .order-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .item-name {
            font-size: 14px;
            font-weight: 700;
            line-height: 1.5;
        }

        .item-quantity {
            color: var(--muted);
            font-size: 12px;
            margin-top: 5px;
        }

        .item-price {
            font-size: 14px;
            font-weight: 800;

            white-space: nowrap;
            color: #242424;
        }

        .empty-order {
            padding: 10px 0;

            color: var(--muted);
            font-size: 14px;
            line-height: 1.6;
        }

        .empty-order a {
            color: var(--orange);
            font-weight: bold;
        }

        /* =========================
           ORDER SUMMARY
        ========================= */

        .summary-row {
            display: flex;
            justify-content: space-between;

            gap: 12px;
            padding: 9px 0;

            color: #5d5956;
            font-size: 13px;
        }

        .summary-row span:last-child {
            white-space: nowrap;
            font-weight: 700;
            color: #252525;
        }

        /* =========================
           COUPON SECTION
        ========================= */

        .coupon-section {
            border-top: 1px dashed #e8ded6;
            border-bottom: 1px dashed #e8ded6;

            margin: 17px 0;
            padding: 20px 0;
        }

        .coupon-title {
            font-size: 14px;
            font-weight: 800;

            margin-bottom: 13px;
        }

        .coupon-list {
            display: grid;
            gap: 10px;
        }

        .coupon-card {
            display: flex;
            justify-content: space-between;
            align-items: center;

            gap: 10px;
            padding: 13px;

            border: 1px solid #f0e4dc;
            border-radius: 12px;

            background:
                linear-gradient(
                    135deg,
                    #fff,
                    #fff9f4
                );

            transition:
                transform 0.2s,
                border-color 0.2s,
                box-shadow 0.2s;
        }

        .coupon-card:hover {
            transform: translateY(-2px);
            border-color: var(--orange);

            box-shadow:
                0 5px 14px rgba(255, 107, 53, 0.09);
        }

        .coupon-card.applied {
            border-color: #75c593;
            background: #f1fff5;
        }

        .coupon-info {
            min-width: 0;

            display: flex;
            flex-direction: column;

            gap: 5px;
        }

        .coupon-code {
            color: var(--orange-dark);

            font-size: 13px;
            font-weight: 800;
            letter-spacing: 0.4px;
        }

        .coupon-card.applied .coupon-code {
            color: var(--green);
        }

        .coupon-description {
            color: #777;

            font-size: 11px;
            line-height: 1.4;
        }

        .coupon-card form {
            flex-shrink: 0;
        }

        .coupon-button {
            border: none;

            background: #111;
            color: white;

            border-radius: 8px;
            padding: 9px 12px;

            font-size: 12px;
            font-weight: 700;

            cursor: pointer;

            transition:
                background 0.2s,
                transform 0.2s;
        }

        .coupon-button:hover {
            background: var(--orange);
            transform: translateY(-1px);
        }

        .coupon-card.applied .coupon-button {
            background: var(--green);
            cursor: default;
        }

        .coupon-card.applied .coupon-button:hover {
            transform: none;
        }

        .coupon-or {
            display: flex;
            align-items: center;

            gap: 10px;
            margin: 17px 0;

            color: #999;
            font-size: 10px;
            font-weight: 800;
        }

        .coupon-or::before,
        .coupon-or::after {
            content: "";

            flex: 1;
            height: 1px;

            background: #ece4de;
        }

        .coupon-form {
            display: flex;
            gap: 8px;
        }

        .coupon-input {
            min-width: 0;
            flex: 1;

            border: 1px solid #e3d7cf;
            border-radius: 9px;

            padding: 11px;

            outline: none;
            font-size: 12px;

            transition:
                border 0.2s,
                box-shadow 0.2s;
        }

        .coupon-message {
            margin-top: 12px;

            border-radius: 9px;
            padding: 11px 12px;

            background: #f2f9f3;
            border: 1px solid #cce7d2;

            color: #286b3d;

            font-size: 12px;
            font-weight: 700;
            line-height: 1.5;

            overflow-wrap: anywhere;
        }

        .summary-row .coupon-discount {
            color: var(--green);
        }

        /* =========================
           TOTAL & PAYMENT
        ========================= */

        .total-row {
            margin-top: 10px;
            padding-top: 18px;

            border-top: 1px solid #e7ddd6;

            font-size: 18px;
            font-weight: 800;

            color: #111;
            align-items: center;
        }

        .total-row span:last-child {
            font-size: 23px;
            color: var(--orange-dark);
        }

        .continue-payment-button {
            display: flex;
            justify-content: center;
            align-items: center;

            gap: 10px;

            width: 100%;
            margin-top: 19px;
            padding: 15px 18px;

            background: var(--orange);
            color: white;

            border-radius: 11px;

            font-size: 14px;
            font-weight: 800;
            text-align: center;

            transition:
                background 0.2s,
                transform 0.2s,
                box-shadow 0.2s;
        }

        .continue-payment-button:hover {
            background: #111;

            transform: translateY(-2px);

            box-shadow:
                0 8px 20px rgba(0, 0, 0, 0.12);
        }

        .payment-note {
            text-align: center;

            font-size: 11px;
            color: #888;
            line-height: 1.5;

            margin-top: 13px;
        }

        /* =========================
           FOOTER
        ========================= */

        .footer {
            padding: 25px 15px;

            background: #111;

            text-align: center;

            color: #aaa;
            font-size: 12px;
        }

        .footer span {
            color: var(--orange);
            font-weight: 800;
        }

        /* =========================
           ANIMATION
        ========================= */

        @keyframes fadeUp {

            from {
                opacity: 0;
                transform: translateY(15px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* =========================
           RESPONSIVE
        ========================= */

        @media (max-width: 900px) {

            .checkout-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }

            .container {
                width: 90%;
            }
        }

        @media (max-width: 650px) {

            .header {
                padding: 11px 4%;
                min-height: 70px;
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

            .intro {
                padding: 34px 5% 24px;
            }

            .container {
                width: 92%;
                margin-top: 22px;
            }

            .checkout-card {
                padding: 20px;
                border-radius: 16px;
            }

            .delivery-card {
                padding: 19px;
            }

            .delivery-heading {
                align-items: flex-start;
            }

            .delivery-heading h2 {
                font-size: 17px;
            }

            .delivery-tag {
                display: none;
            }

            .delivery-information {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .delivery-email {
                grid-column: auto;
            }

            .delivery-field {
                padding: 14px;
            }

            .delivery-address-box {
                padding: 16px;
            }

            .address-top {
                flex-wrap: wrap;
            }

            .cart-link {
                padding: 9px 12px;
            }
        }

        @media (max-width: 390px) {

            .brand-logo {
                width: 95px;
            }

            .header-right {
                gap: 9px;
            }

            .nav-link,
            .cart-link {
                font-size: 11px;
            }

            .coupon-form {
                flex-direction: column;
            }

            .coupon-form .coupon-button {
                width: 100%;
            }
        }

        @media (prefers-reduced-motion: reduce) {

            *,
            *::before,
            *::after {
                animation-duration: 0.01ms !important;
                transition-duration: 0.01ms !important;
                scroll-behavior: auto !important;
            }
        }

    </style>

</head>

<body>

<!-- =========================
     NAVBAR
========================= -->

<header class="header">

    <a class="logo"
       href="<%= contextPath %>/restaurant"
       aria-label="Foodwala Home">

        <img
            class="brand-logo"
            src="<%= contextPath %>/images/branding/foodwala-logo.png"
            alt="Foodwala">

    </a>

    <nav class="header-right"
         aria-label="Main navigation">

        <span class="location">
            &#128205; Bengaluru
        </span>

        <a class="nav-link"
           href="<%= contextPath %>/restaurant">

            Restaurants

        </a>

        <a class="cart-link"
           href="<%= contextPath %>/cart">

            &#128722; Cart

        </a>

    </nav>

</header>

<!-- =========================
     INTRODUCTION
========================= -->

<section class="intro">

    <div class="intro-inner">

        <div class="eyebrow">
            MADE FOR FOOD LOVERS
        </div>

        <h1>
            Almost there. <span>Checkout</span>
        </h1>

        <p>
            Confirm your delivery details, review your food
            and continue to payment.
        </p>

        <div class="steps"
             aria-label="Checkout progress">

            <span class="done">
                &#10003; Cart
            </span>

            <span class="line"></span>

            <span class="current">
                2. Checkout
            </span>

            <span class="line"></span>

            <span>
                3. Payment
            </span>

        </div>

    </div>

</section>

<!-- =========================
     MAIN CHECKOUT
========================= -->

<main class="container">

    <div class="checkout-layout">

        <!-- LEFT SIDE -->

        <div>

            <!-- =========================
                 PREMIUM DELIVERY DETAILS
            ========================= -->

            <section class="checkout-card delivery-card"
                     aria-labelledby="delivery-title">

                <div class="delivery-heading">

                    <div class="delivery-heading-left">

                        <div class="delivery-icon">
                            &#128205;
                        </div>

                        <div>

                            <h2 id="delivery-title">
                                Delivery Details
                            </h2>

                            <p>
                                Your contact and delivery information
                            </p>

                        </div>

                    </div>

                    <span class="delivery-tag">
                        YOUR DETAILS
                    </span>

                </div>

                <!-- CUSTOMER INFORMATION -->

                <div class="delivery-information">

                    <!-- NAME -->

                    <div class="delivery-field">

                        <span class="delivery-label">
                            FULL NAME
                        </span>

                        <span class="delivery-value">
                            <%= safe(user.getUsername()) %>
                        </span>

                    </div>

                    <!-- PHONE -->

                    <div class="delivery-field">

                        <span class="delivery-label">
                            PHONE NUMBER
                        </span>

                        <span class="delivery-value">
                            <%= safe(user.getPhone()) %>
                        </span>

                    </div>

                    <!-- EMAIL -->

                    <div class="delivery-field delivery-email">

                        <span class="delivery-label">
                            EMAIL ADDRESS
                        </span>

                        <span class="delivery-value">
                            <%= safe(user.getEmail()) %>
                        </span>

                    </div>

                </div>

                <!-- DELIVERY ADDRESS -->

                <div class="delivery-address-box">

                    <div class="address-top">

                        <div>

                            <div class="address-heading">
                                &#128205; Delivery Address
                            </div>

                            <div class="address-value">
                                <%= safe(user.getAddress()) %>
                            </div>

                        </div>

                        <span class="address-status">
                            SAVED
                        </span>

                    </div>

                    <button
                        type="button"
                        class="change-address-button"
                        id="toggleAddress"
                        aria-expanded="false"
                        aria-controls="addressForm">

                        Change Address &#8594;

                    </button>

                    <!-- CHANGE ADDRESS FORM -->

                    <div id="addressForm"
                         class="address-form"
                         hidden>

                        <form
                            action="<%= contextPath %>/updateAddress"
                            method="post">

                            <textarea
                                name="address"
                                class="address-input"
                                rows="3"
                                maxlength="255"
                                placeholder="Enter your new delivery address"
                                required><%= safe(user.getAddress()) %></textarea>

                            <button
                                type="submit"
                                class="save-address-button">

                                Save Address

                            </button>

                        </form>

                    </div>

                </div>

            </section>

            <!-- =========================
                 YOUR ORDER
            ========================= -->

            <section class="checkout-card"
                     aria-labelledby="order-title">

                <div class="card-heading">

                    <div class="heading-icon"
                         aria-hidden="true">
                        &#127869;
                    </div>

                    <div>

                        <h2 id="order-title">
                            Your Order
                        </h2>

                        <p>
                            A final look at your selected dishes
                        </p>

                    </div>

                </div>

                <%
                    if (hasItems) {

                        for (CartItem item : cart.getItems()) {
                %>

                    <div class="order-item">

                        <div>

                            <div class="item-name">
                                <%= safe(item.getMenu().getItemName()) %>
                            </div>

                            <div class="item-quantity">
                                Quantity: <%= item.getQuantity() %>
                            </div>

                        </div>

                        <div class="item-price">
                            &#8377;<%= money(item.getTotalPrice()) %>
                        </div>

                    </div>

                <%
                        }

                    } else {
                %>

                    <div class="empty-order">

                        Your cart is empty.

                        <a href="<%= contextPath %>/restaurant">
                            Explore restaurants &#8594;
                        </a>

                    </div>

                <%
                    }
                %>

            </section>

        </div>

        <!-- =========================
             ORDER SUMMARY
        ========================= -->

        <aside class="checkout-card summary-card"
               aria-labelledby="summary-title">

            <div class="card-heading">

                <div class="heading-icon"
                     aria-hidden="true">
                    &#129534;
                </div>

                <div>

                    <h2 id="summary-title">
                        Order Summary
                    </h2>

                    <p>
                        Your bill, clearly broken down
                    </p>

                </div>

            </div>

            <!-- SUBTOTAL -->

            <div class="summary-row">

                <span>
                    Subtotal
                </span>

                <span>
                    &#8377;<%= money(subtotal) %>
                </span>

            </div>

            <!-- DELIVERY FEE -->

            <div class="summary-row">

                <span>
                    Delivery Fee
                </span>

                <span>
                    &#8377;<%= money(deliveryFee) %>
                </span>

            </div>

            <!-- =========================
                 COUPONS
            ========================= -->

            <div class="coupon-section">

                <div class="coupon-title">
                    Available Coupons
                </div>

                <div class="coupon-list">

                    <%
                        String[] codes = {
                            "FOOD10",
                            "WELCOME50",
                            "FIRST100"
                        };

                        String[] descriptions = {
                            "Get ₹10 OFF on your order",
                            "Get ₹50 OFF on your order",
                            "Get ₹100 OFF on your order"
                        };

                        for (int i = 0; i < codes.length; i++) {

                            boolean applied =
                                codes[i].equals(appliedCoupon);
                    %>

                        <div class="coupon-card <%= applied ? "applied" : "" %>">

                            <div class="coupon-info">

                                <span class="coupon-code">

                                    <%= applied ? "✓ " : "" %>
                                    <%= codes[i] %>

                                </span>

                                <span class="coupon-description">
                                    <%= descriptions[i] %>
                                </span>

                            </div>

                            <form
                                action="<%= contextPath %>/applyCoupon"
                                method="post">

                                <input
                                    type="hidden"
                                    name="couponCode"
                                    value="<%= codes[i] %>">

                                <button
                                    class="coupon-button"
                                    type="submit"
                                    <%= applied ? "disabled" : "" %>>

                                    <%= applied ? "Applied" : "Apply" %>

                                </button>

                            </form>

                        </div>

                    <%
                        }
                    %>

                </div>

                <!-- OR SEPARATOR -->

                <div class="coupon-or">
                    OR
                </div>

                <!-- MANUAL COUPON -->

                <div class="coupon-title">
                    Have another coupon?
                </div>

                <form
                    action="<%= contextPath %>/applyCoupon"
                    method="post"
                    class="coupon-form">

                    <input
                        class="coupon-input"
                        type="text"
                        name="couponCode"
                        placeholder="Enter coupon code"
                        maxlength="40"
                        required
                        aria-label="Coupon code">

                    <button
                        class="coupon-button"
                        type="submit">

                        Apply

                    </button>

                </form>

                <!-- COUPON MESSAGE -->

                <%
                    if (couponMessage != null
                            && !couponMessage.trim().isEmpty()) {
                %>

                    <div class="coupon-message"
                         role="status">

                        <%= safe(couponMessage) %>

                    </div>

                <%
                    }
                %>

            </div>

            <!-- COUPON DISCOUNT -->

            <%
                if (couponDiscount > 0) {
            %>

                <div class="summary-row">

                    <span>
                        Coupon Discount
                    </span>

                    <span class="coupon-discount">

                        -&#8377;<%= money(couponDiscount) %>

                    </span>

                </div>

            <%
                }
            %>

            <!-- TOTAL -->

            <div class="summary-row total-row">

                <span>
                    Total
                </span>

                <span>
                    &#8377;<%= money(total) %>
                </span>

            </div>

            <!-- PAYMENT -->

            <%
                if (hasItems) {
            %>

                <a href="<%= contextPath %>/payment"
                   class="continue-payment-button">

                    Continue to Payment

                    <span aria-hidden="true">
                        &#8594;
                    </span>

                </a>

            <%
                } else {
            %>

                <a href="<%= contextPath %>/restaurant"
                   class="continue-payment-button">

                    Explore Restaurants

                    <span aria-hidden="true">
                        &#8594;
                    </span>

                </a>

            <%
                }
            %>

            <p class="payment-note">
                Review your details before proceeding.
            </p>

        </aside>

    </div>

</main>

<!-- =========================
     FOOTER
========================= -->

<footer class="footer">

    &#169; 2026

    <span>Foodwala</span>

    &bull; Delicious food, delivered with care.

</footer>

<!-- =========================
     ADDRESS FORM JAVASCRIPT
========================= -->

<script>

    document.addEventListener("DOMContentLoaded", function () {

        const button =
            document.getElementById("toggleAddress");

        const panel =
            document.getElementById("addressForm");

        if (!button || !panel) {
            return;
        }

        button.addEventListener("click", function () {

            panel.hidden = !panel.hidden;

            button.setAttribute(
                "aria-expanded",
                String(!panel.hidden)
            );

            button.textContent = panel.hidden
                ? "Change Address →"
                : "Hide Address Form ↑";

            if (!panel.hidden) {

                panel.querySelector("textarea").focus();

            }

        });

    });

</script>

</body>
</html>
