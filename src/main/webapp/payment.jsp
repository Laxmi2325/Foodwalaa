
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

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

    private String money(double amount) {
        return String.format(Locale.US, "%.2f", amount);
    }
%>

<%
    String contextPath = request.getContextPath();

    User user =
        (User) session.getAttribute("loggedInUser");

    Cart cart =
        (Cart) session.getAttribute("cart");

    if (user == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    boolean hasItems =
        cart != null &&
        cart.getItems() != null &&
        !cart.getItems().isEmpty();

    double subtotal = 0;

    if (hasItems) {

        for (CartItem item : cart.getItems()) {
            subtotal += item.getTotalPrice();
        }
    }

    double deliveryFee = 40;

    double couponDiscount = 0;

    Object discountObject =
        session.getAttribute("couponDiscount");

    if (discountObject instanceof Number) {

        couponDiscount =
            ((Number) discountObject).doubleValue();
    }

    double total =
        Math.max(0, subtotal + deliveryFee - couponDiscount);
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Payment | Foodwala</title>

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
            min-height: 100vh;

            font-family: Arial, Helvetica, sans-serif;

            background: var(--cream);
            color: var(--black);

            overflow-x: hidden;
        }

        button,
        input {
            font: inherit;
        }

        a {
            text-decoration: none;
        }

        /* =========================
           PREMIUM NAVBAR
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

            box-shadow:
                0 4px 22px rgba(0, 0, 0, 0.15);
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
            height: auto;
            max-height: 58px;

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

        .nav-link {
            color: #fff;

            font-size: 13px;
            font-weight: 700;

            white-space: nowrap;

            transition: color 0.25s ease;
        }

        .nav-link:hover {
            color: var(--orange);
        }

        .back-cart {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            gap: 7px;

            padding: 11px 17px;

            background: var(--orange);
            color: white;

            border-radius: 25px;

            font-size: 13px;
            font-weight: 700;

            white-space: nowrap;

            transition:
                background 0.25s ease,
                transform 0.25s ease;
        }

        .back-cart:hover {
            background: var(--orange-dark);
            transform: translateY(-2px);
        }

        /* =========================
           PAGE INTRODUCTION
        ========================= */

        .intro {
            padding: 43px 7% 30px;

            background:
                radial-gradient(
                    circle at 90% 15%,
                    rgba(255, 107, 53, 0.12),
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

            font-size: 11px;
            font-weight: 800;

            letter-spacing: 2px;

            margin-bottom: 11px;
        }

        .intro h1 {
            font-size: clamp(29px, 4vw, 39px);
            line-height: 1.2;

            margin-bottom: 11px;
        }

        .intro h1 span {
            color: var(--orange);
        }

        .intro p {
            color: #706b68;

            font-size: 14px;
            line-height: 1.7;
        }

        /* =========================
           CHECKOUT PROGRESS
        ========================= */

        .steps {
            display: flex;
            align-items: center;
            flex-wrap: wrap;

            gap: 10px;

            margin-top: 23px;

            font-size: 12px;
            font-weight: 700;

            color: #999;
        }

        .steps .done {
            color: var(--green);
        }

        .steps .current {
            color: var(--orange);
        }

        .steps .line {
            width: 25px;
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

        .payment-layout {
            display: grid;

            grid-template-columns:
                minmax(0, 1fr) minmax(310px, 380px);

            gap: 25px;

            align-items: start;
        }

        /* =========================
           PREMIUM CARDS
        ========================= */

        .card {
            background: #fff;

            border: 1px solid rgba(0, 0, 0, 0.045);
            border-radius: 19px;

            padding: 26px;
            margin-bottom: 22px;

            box-shadow:
                0 6px 23px rgba(0, 0, 0, 0.045);

            animation: fadeUp 0.55s ease both;
        }

        .card-heading {
            display: flex;
            align-items: center;

            gap: 12px;

            padding-bottom: 19px;
            margin-bottom: 22px;

            border-bottom: 1px solid var(--line);
        }

        .heading-icon {
            display: flex;
            align-items: center;
            justify-content: center;

            width: 42px;
            height: 42px;

            flex-shrink: 0;

            background: #fff0e7;
            color: var(--orange);

            border-radius: 12px;

            font-size: 20px;
        }

        .card-heading h2 {
            color: #171717;

            font-size: 19px;
            font-weight: 800;

            margin-bottom: 5px;
        }

        .card-heading p {
            color: #888;

            font-size: 12px;
            line-height: 1.5;
        }

        /* =========================
           DELIVERY ADDRESS
        ========================= */

        .address-box {
            background:
                linear-gradient(
                    135deg,
                    #fffaf6,
                    #fff5ee
                );

            border: 1px solid #f4e1d3;
            border-radius: 13px;

            padding: 20px;
        }

        .address-label {
            display: inline-block;

            color: var(--orange-dark);

            font-size: 10px;
            font-weight: 800;

            letter-spacing: 0.8px;

            margin-bottom: 12px;
        }

        .customer-name {
            color: #171717;

            font-size: 15px;
            font-weight: 800;

            margin-bottom: 9px;
        }

        .customer-phone {
            color: #555;

            font-size: 13px;
            font-weight: 600;

            margin-bottom: 10px;
        }

        .customer-address {
            color: #555;

            font-size: 13px;
            line-height: 1.7;

            white-space: pre-wrap;
            overflow-wrap: anywhere;
        }

        .address-footer {
            margin-top: 16px;
            padding-top: 14px;

            border-top: 1px solid #eeded2;
        }

        .edit-address {
            display: inline-flex;
            align-items: center;
            gap: 6px;

            color: var(--orange-dark);

            font-size: 12px;
            font-weight: 800;

            transition: color 0.2s ease;
        }

        .edit-address:hover {
            color: #111;
        }

        /* =========================
           PAYMENT OPTIONS
        ========================= */

        .payment-option {
            display: flex;
            align-items: center;

            gap: 15px;

            width: 100%;

            padding: 17px;
            margin-bottom: 12px;

            border: 1px solid #eae4df;
            border-radius: 13px;

            background: #fff;

            cursor: pointer;

            transition:
                border-color 0.25s ease,
                background 0.25s ease,
                transform 0.25s ease,
                box-shadow 0.25s ease;
        }

        .payment-option:hover {
            border-color: var(--orange);

            background: #fffaf6;

            transform: translateY(-2px);

            box-shadow:
                0 5px 16px rgba(255, 107, 53, 0.08);
        }

        .payment-option input[type="radio"] {
            width: 19px;
            height: 19px;

            flex-shrink: 0;

            accent-color: var(--orange);
            cursor: pointer;
        }

        .payment-icon {
            display: flex;
            align-items: center;
            justify-content: center;

            width: 43px;
            height: 43px;

            flex-shrink: 0;

            border-radius: 11px;

            background: #fff0e7;

            font-size: 21px;
        }

        .payment-details {
            flex: 1;
            min-width: 0;
        }

        .payment-name {
            color: #202020;

            font-size: 14px;
            font-weight: 800;

            margin-bottom: 5px;
        }

        .payment-description {
            color: #888;

            font-size: 12px;
            line-height: 1.5;
        }

        /* SELECTED PAYMENT */

        .payment-option:has(input:checked) {
            border-color: var(--orange);
            border-width: 2px;

            background: #fff7f1;

            padding: 16px;

            box-shadow:
                0 4px 15px rgba(255, 107, 53, 0.11);
        }

        .payment-option:has(input:checked) .payment-icon {
            background: #ffe4d4;
        }

        /* =========================
           PLACE ORDER BUTTON
        ========================= */

        .place-order-button {
            display: flex;
            align-items: center;
            justify-content: center;

            gap: 10px;

            width: 100%;

            margin-top: 23px;
            padding: 16px 20px;

            border: none;
            border-radius: 11px;

            background: var(--orange);
            color: #fff;

            font-size: 15px;
            font-weight: 800;

            cursor: pointer;

            transition:
                background 0.25s ease,
                transform 0.25s ease,
                box-shadow 0.25s ease;
        }

        .place-order-button:hover:not(:disabled) {
            background: #111;

            transform: translateY(-2px);

            box-shadow:
                0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .place-order-button:active:not(:disabled) {
            transform: scale(0.99);
        }

        .place-order-button:disabled {
            background: #d7d2ce;
            color: #777;

            cursor: not-allowed;
        }

        /* =========================
           ORDER SUMMARY
        ========================= */

        .summary-card {
            position: sticky;
            top: 96px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;

            gap: 12px;

            padding: 11px 0;

            color: #666;

            font-size: 13px;
        }

        .summary-row span:last-child {
            color: #242424;
            font-weight: 700;
            white-space: nowrap;
        }

        .summary-row.discount,
        .summary-row.discount span:last-child {
            color: var(--green);
            font-weight: 800;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            align-items: center;

            gap: 12px;

            margin-top: 14px;
            padding-top: 19px;

            border-top: 1px solid #e7ddd6;

            color: #111;

            font-size: 18px;
            font-weight: 800;
        }

        .total-amount {
            color: var(--orange-dark);
            font-size: 23px;
            white-space: nowrap;
        }

        .summary-note {
            margin-top: 17px;
            padding: 13px;

            border-radius: 10px;

            background: #fff8f3;

            color: #76675f;

            font-size: 12px;
            line-height: 1.6;
        }

        /* =========================
           PAYMENT NOTE
        ========================= */

        .security-message {
            display: flex;
            align-items: flex-start;

            gap: 10px;

            padding: 16px 18px;

            border: 1px solid #e5e9e3;
            border-radius: 12px;

            background: #f8fbf7;

            color: #667366;

            font-size: 12px;
            line-height: 1.6;
        }

        .security-icon {
            font-size: 19px;
            flex-shrink: 0;
        }

        /* =========================
           FOOTER
        ========================= */

        .footer {
            padding: 26px 15px;

            background: #111;
            color: #aaa;

            text-align: center;

            font-size: 12px;
            line-height: 1.6;
        }

        .footer span {
            color: var(--orange);
            font-weight: 800;
        }

        /* =========================
           ANIMATIONS
        ========================= */

        @keyframes fadeUp {

            from {
                opacity: 0;
                transform: translateY(16px);
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

            .payment-layout {
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
                min-height: 70px;
                padding: 11px 4%;
            }

            .brand-logo {
                width: 115px;
                max-height: 48px;
            }

            .header-right {
                gap: 12px;
            }

            .nav-link {
                font-size: 12px;
            }

            .back-cart {
                padding: 9px 12px;
                font-size: 12px;
            }

            .intro {
                padding: 34px 5% 24px;
            }

            .container {
                width: 92%;
                margin-top: 22px;
            }

            .card {
                padding: 20px;
                border-radius: 16px;
            }

            .payment-option {
                gap: 11px;
                padding: 14px;
            }

            .payment-option:has(input:checked) {
                padding: 13px;
            }

            .payment-icon {
                width: 39px;
                height: 39px;
                font-size: 19px;
            }

            .payment-name {
                font-size: 13px;
            }

            .payment-description {
                font-size: 11px;
            }
        }

        @media (max-width: 390px) {

            .brand-logo {
                width: 95px;
                max-height: 42px;
            }

            .header-right {
                gap: 8px;
            }

            .nav-link {
                font-size: 11px;
            }

            .back-cart {
                padding: 8px 10px;
                font-size: 11px;
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
     PREMIUM FOODWALA NAVBAR
========================= -->

<header class="header">

    <a href="<%= contextPath %>/restaurant"
       class="logo"
       aria-label="Foodwala Home">

        <img
            src="<%= contextPath %>/images/branding/foodwala-logo.png"
            alt="Foodwala"
            class="brand-logo">

    </a>

    <nav class="header-right"
         aria-label="Main navigation">

        <a href="<%= contextPath %>/restaurant"
           class="nav-link">

            Restaurants

        </a>

        <a href="<%= contextPath %>/cart"
           class="back-cart">

            &#8592; Back to Cart

        </a>

    </nav>

</header>

<!-- =========================
     PAGE INTRODUCTION
========================= -->

<section class="intro">

    <div class="intro-inner">

        <div class="eyebrow">
            MADE FOR FOOD LOVERS
        </div>

        <h1>
            Complete Your <span>Payment</span>
        </h1>

        <p>
            Choose your preferred payment method and
            review your order before placing it.
        </p>

        <div class="steps"
             aria-label="Checkout progress">

            <span class="done">
                &#10003; Cart
            </span>

            <span class="line"></span>

            <span class="done">
                &#10003; Checkout
            </span>

            <span class="line"></span>

            <span class="current">
                3. Payment
            </span>

        </div>

    </div>

</section>

<!-- =========================
     MAIN PAYMENT PAGE
========================= -->

<main class="container">

    <div class="payment-layout">

        <!-- =========================
             LEFT SIDE
        ========================= -->

        <div>

            <!-- DELIVERY ADDRESS -->

            <section class="card"
                     aria-labelledby="address-title">

                <div class="card-heading">

                    <div class="heading-icon"
                         aria-hidden="true">

                        &#128205;

                    </div>

                    <div>

                        <h2 id="address-title">
                            Delivery Address
                        </h2>

                        <p>
                            Your selected delivery destination
                        </p>

                    </div>

                </div>

                <div class="address-box">

                    <span class="address-label">
                        DELIVERING TO
                    </span>

                    <div class="customer-name">
                        <%= safe(user.getUsername()) %>
                    </div>

                    <div class="customer-phone">
                        &#128222; <%= safe(user.getPhone()) %>
                    </div>

                    <div class="customer-address">
                        <%= safe(user.getAddress()) %>
                    </div>

                    <div class="address-footer">

                        <a href="<%= contextPath %>/checkout"
                           class="edit-address">

                            Edit Delivery Details &#8594;

                        </a>

                    </div>

                </div>

            </section>

            <!-- =========================
                 PAYMENT METHODS
            ========================= -->

            <section class="card"
                     aria-labelledby="payment-title">

                <div class="card-heading">

                    <div class="heading-icon"
                         aria-hidden="true">

                        &#128179;

                    </div>

                    <div>

                        <h2 id="payment-title">
                            Select Payment Method
                        </h2>

                        <p>
                            Choose how you would like to pay
                        </p>

                    </div>

                </div>

                <form
                    action="<%= contextPath %>/placeOrder"
                    method="post"
                    id="paymentForm">

                    <!-- CASH ON DELIVERY -->

                    <label class="payment-option">

                        <input
                            type="radio"
                            name="paymentMethod"
                            value="COD"
                            checked
                            required>

                        <span class="payment-icon"
                              aria-hidden="true">

                            &#128181;

                        </span>

                        <span class="payment-details">

                            <span class="payment-name"
                                  style="display:block;">

                                Cash on Delivery

                            </span>

                            <span class="payment-description"
                                  style="display:block;">

                                Pay with cash when your order is delivered.

                            </span>

                        </span>

                    </label>

                    <!-- CREDIT / DEBIT CARD -->

                    <label class="payment-option">

                        <input
                            type="radio"
                            name="paymentMethod"
                            value="CARD"
                            required>

                        <span class="payment-icon"
                              aria-hidden="true">

                            &#128179;

                        </span>

                        <span class="payment-details">

                            <span class="payment-name"
                                  style="display:block;">

                                Credit / Debit Card

                            </span>

                            <span class="payment-description"
                                  style="display:block;">

                                Choose card as your payment method.

                            </span>

                        </span>

                    </label>

                    <!-- UPI -->

                    <label class="payment-option">

                        <input
                            type="radio"
                            name="paymentMethod"
                            value="UPI"
                            required>

                        <span class="payment-icon"
                              aria-hidden="true">

                            &#128241;

                        </span>

                        <span class="payment-details">

                            <span class="payment-name"
                                  style="display:block;">

                                UPI

                            </span>

                            <span class="payment-description"
                                  style="display:block;">

                                Choose UPI as your payment method.

                            </span>

                        </span>

                    </label>

                    <!-- NET BANKING -->

                    <label class="payment-option">

                        <input
                            type="radio"
                            name="paymentMethod"
                            value="NET_BANKING"
                            required>

                        <span class="payment-icon"
                              aria-hidden="true">

                            &#127974;

                        </span>

                        <span class="payment-details">

                            <span class="payment-name"
                                  style="display:block;">

                                Net Banking

                            </span>

                            <span class="payment-description"
                                  style="display:block;">

                                Choose your bank account payment method.

                            </span>

                        </span>

                    </label>

                    <!-- PAY LATER -->

                    <label class="payment-option">

                        <input
                            type="radio"
                            name="paymentMethod"
                            value="PAY_LATER"
                            required>

                        <span class="payment-icon"
                              aria-hidden="true">

                            &#128337;

                        </span>

                        <span class="payment-details">

                            <span class="payment-name"
                                  style="display:block;">

                                Pay Later

                            </span>

                            <span class="payment-description"
                                  style="display:block;">

                                Select the pay-later option.

                            </span>

                        </span>

                    </label>

                    <!-- EXISTING TOTAL AMOUNT FIELD -->

                    <input
                        type="hidden"
                        name="totalAmount"
                        value="<%= total %>">

                    <!-- PLACE ORDER -->

                    <button
                        type="submit"
                        class="place-order-button"
                        id="placeOrderButton"
                        <%= hasItems ? "" : "disabled" %>>

                        <span>
                            Place Order
                        </span>

                        <span aria-hidden="true">
                            &#8594;
                        </span>

                    </button>

                </form>

            </section>

            <!-- PAYMENT NOTE -->

            <div class="security-message">

                <span class="security-icon"
                      aria-hidden="true">

                    &#128274;

                </span>

                <span>
                    Please review your payment selection before
                    placing your order. Payment processing depends
                    on the available Foodwala payment integration.
                </span>

            </div>

        </div>

        <!-- =========================
             RIGHT SIDE
        ========================= -->

        <aside class="card summary-card"
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
                        Your final payment breakdown
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

            <!-- COUPON DISCOUNT -->

            <%
                if (couponDiscount > 0) {
            %>

                <div class="summary-row discount">

                    <span>
                        Coupon Discount
                    </span>

                    <span>
                        -&#8377;<%= money(couponDiscount) %>
                    </span>

                </div>

            <%
                }
            %>

            <!-- FINAL TOTAL -->

            <div class="summary-total">

                <span>
                    Total
                </span>

                <span class="total-amount">
                    &#8377;<%= money(total) %>
                </span>

            </div>

            <div class="summary-note">

                Your final amount includes the delivery fee
                and any applied coupon discount.

            </div>

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
     PREVENT ACCIDENTAL DOUBLE SUBMIT
========================= -->

<script>

    document.addEventListener("DOMContentLoaded", function () {

        const form =
            document.getElementById("paymentForm");

        const button =
            document.getElementById("placeOrderButton");

        if (!form || !button) {
            return;
        }

        form.addEventListener("submit", function () {

            if (button.disabled) {
                return;
            }

            button.disabled = true;

            button.innerHTML =
                "<span>Placing Order...</span>";

        });

    });

</script>

</body>
</html>
