
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="com.tap.modell.Order" %>
<%@ page import="com.tap.modell.User" %>
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
%>

<%
    String contextPath = request.getContextPath();

    Order order =
        (Order) request.getAttribute("order");

    User user =
        (User) session.getAttribute("loggedInUser");

    if (order == null) {
        response.sendRedirect(contextPath + "/restaurant");
        return;
    }

    String paymentMethod = order.getPaymentMode();

    String paymentText =
        paymentMethod == null ? "Not specified" : paymentMethod;

    if ("COD".equals(paymentMethod)) {
        paymentText = "Cash on Delivery";

    } else if ("CARD".equals(paymentMethod)) {
        paymentText = "Credit / Debit Card";

    } else if ("UPI".equals(paymentMethod)) {
        paymentText = "UPI";

    } else if ("NET_BANKING".equals(paymentMethod)) {
        paymentText = "Net Banking";

    } else if ("PAY_LATER".equals(paymentMethod)) {
        paymentText = "Pay Later";
    }

    String customerName =
        user != null && user.getUsername() != null
        ? user.getUsername()
        : "Food Lover";

    String orderDate =
        order.getOrderDate() == null
        ? "Not available"
        : order.getOrderDate().toString();

    String orderStatus =
        order.getStatus() == null
        ? "Confirmed"
        : order.getStatus().toString();

    String totalAmount =
        String.format(
            Locale.US,
            "%.2f",
            order.getTotalAmount()
        );
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Order Confirmed | Foodwala</title>

    <style>

        /* =========================
           GLOBAL
        ========================= */

        :root {
            --black: #111111;
            --orange: #ff6b35;
            --cream: #fff7f2;
            --green: #22a45a;
            --green-dark: #168345;
            --text: #222222;
            --muted: #777777;
            --line: #eee7e2;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;

            font-family: Arial, Helvetica, sans-serif;

            background:
                radial-gradient(
                    circle at 50% 15%,
                    #eaffef 0%,
                    transparent 34%
                ),
                var(--cream);

            color: var(--text);

            overflow-x: hidden;
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

            background: var(--black);

            display: flex;
            align-items: center;
            justify-content: space-between;

            gap: 16px;

            box-shadow:
                0 4px 20px rgba(0, 0, 0, 0.14);
        }

        .logo {
            display: inline-flex;
            align-items: center;

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
            transform: scale(1.06);
            filter: brightness(1.12);
        }

        .header-right {
            display: flex;
            align-items: center;

            gap: 22px;
        }

        .nav-link {
            color: white;

            font-size: 13px;
            font-weight: 700;

            white-space: nowrap;

            transition: color 0.25s ease;
        }

        .nav-link:hover {
            color: var(--orange);
        }

        .cart-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            padding: 10px 17px;

            border-radius: 25px;

            background: var(--orange);
            color: white;

            font-size: 13px;
            font-weight: 700;

            transition:
                background 0.25s ease,
                transform 0.25s ease;
        }

        .cart-link:hover {
            background: #e85a28;
            transform: translateY(-2px);
        }

        /* =========================
           MAIN CONTAINER
        ========================= */

        .container {
            width: 90%;
            max-width: 850px;

            margin: 42px auto 75px;
        }

        /* =========================
           CONFIRMATION CARD
        ========================= */

        .success-card {
            position: relative;

            overflow: hidden;

            background: #fff;

            border: 1px solid #e8f0e9;
            border-radius: 22px;

            padding: 53px 30px 43px;

            text-align: center;

            box-shadow:
                0 12px 42px rgba(0, 0, 0, 0.07);

            animation:
                cardEntrance 0.75s ease both;
        }

        .success-card::before {
            content: "";

            position: absolute;

            top: 0;
            left: 0;
            right: 0;

            height: 5px;

            background:
                linear-gradient(
                    90deg,
                    #22a45a,
                    #74d99b,
                    #22a45a
                );
        }

        /* =========================
           SUCCESS ANIMATION AREA
        ========================= */

        .celebration {
            position: relative;

            width: 230px;
            height: 145px;

            margin: 0 auto 12px;

            display: flex;
            align-items: center;
            justify-content: center;

            isolation: isolate;
        }

        .success-glow {
            position: absolute;

            width: 135px;
            height: 135px;

            border-radius: 50%;

            background:
                radial-gradient(
                    circle,
                    rgba(34, 164, 90, 0.17),
                    rgba(34, 164, 90, 0)
                );

            animation: glowPulse 2.5s ease-in-out infinite;
        }

        .success-icon {
            position: relative;
            z-index: 2;

            width: 91px;
            height: 91px;

            display: flex;
            align-items: center;
            justify-content: center;

            border-radius: 50%;

            background: #e9faef;

            box-shadow:
                0 0 0 8px rgba(34, 164, 90, 0.06);

            animation:
                successPop 0.65s cubic-bezier(
                    0.2, 1.4, 0.4, 1
                ) both;
        }

        .success-svg {
            width: 78px;
            height: 78px;

            overflow: visible;
        }

        .success-circle {
            fill: none;

            stroke: var(--green);
            stroke-width: 2.7;

            stroke-linecap: round;

            stroke-dasharray: 151;
            stroke-dashoffset: 151;

            animation:
                drawCircle 0.75s ease 0.2s forwards;
        }

        .success-check {
            fill: none;

            stroke: var(--green);
            stroke-width: 4;

            stroke-linecap: round;
            stroke-linejoin: round;

            stroke-dasharray: 40;
            stroke-dashoffset: 40;

            animation:
                drawCheck 0.5s ease 0.85s forwards;
        }

        /* =========================
           CONFETTI
        ========================= */

        .confetti-layer {
            position: absolute;

            inset: 0;

            z-index: 3;

            pointer-events: none;
            overflow: visible;
        }

        .confetti-piece {
            position: absolute;

            left: 50%;
            top: 50%;

            width: 8px;
            height: 12px;

            background: var(--piece-color, #22a45a);

            border-radius: 2px;

            opacity: 0;

            transform:
                translate(-50%, -50%) scale(0);

            animation:
                confettiBurst var(--duration, 1.3s)
                cubic-bezier(0.12, 0.7, 0.3, 1)
                var(--delay, 0s) forwards;
        }

        .confetti-piece.round {
            width: 7px;
            height: 7px;

            border-radius: 50%;
        }

        .confetti-piece.strip {
            width: 5px;
            height: 15px;
        }

        /* =========================
           SUCCESS TEXT
        ========================= */

        .greeting {
            color: #555;

            font-size: 16px;
            line-height: 1.5;

            margin-bottom: 11px;

            animation:
                textEntrance 0.6s ease 0.8s both;
        }

        .success-card h1 {
            color: #111;

            font-size: clamp(25px, 4vw, 33px);
            font-weight: 800;

            line-height: 1.25;

            margin-bottom: 13px;

            animation:
                textEntrance 0.6s ease 0.95s both;
        }

        .success-description {
            color: #777;

            max-width: 470px;

            margin: 0 auto;

            font-size: 14px;
            line-height: 1.8;

            animation:
                textEntrance 0.6s ease 1.1s both;
        }

        .order-number {
            display: inline-flex;
            align-items: center;

            gap: 8px;

            margin-top: 23px;
            padding: 11px 19px;

            border-radius: 30px;

            background: #effaf2;
            color: #57715f;

            font-size: 13px;
            font-weight: 700;

            animation:
                textEntrance 0.6s ease 1.2s both;
        }

        .order-number strong {
            color: var(--green-dark);

            font-size: 15px;
        }

        /* =========================
           MAIN ACTION BUTTON
        ========================= */

        .success-action {
            display: flex;
            justify-content: center;

            margin-top: 27px;

            animation:
                textEntrance 0.6s ease 1.3s both;
        }

        .primary-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            gap: 10px;

            min-width: 210px;

            padding: 14px 24px;

            border-radius: 9px;

            background: var(--green);
            color: white;

            font-size: 13px;
            font-weight: 800;

            transition:
                background 0.25s ease,
                transform 0.25s ease,
                box-shadow 0.25s ease;
        }

        .primary-button:hover {
            background: var(--green-dark);

            transform: translateY(-3px);

            box-shadow:
                0 8px 19px rgba(34, 164, 90, 0.22);
        }

        /* =========================
           ORDER DETAILS
        ========================= */

        .details-card {
            margin-top: 25px;

            padding: 29px;

            background: white;

            border: 1px solid rgba(0, 0, 0, 0.04);
            border-radius: 19px;

            box-shadow:
                0 7px 24px rgba(0, 0, 0, 0.045);

            animation:
                cardEntrance 0.7s ease 0.3s both;
        }

        .details-heading {
            display: flex;
            align-items: center;

            gap: 12px;

            margin-bottom: 23px;
            padding-bottom: 18px;

            border-bottom: 1px solid var(--line);
        }

        .heading-icon {
            display: flex;
            align-items: center;
            justify-content: center;

            width: 43px;
            height: 43px;

            flex-shrink: 0;

            border-radius: 12px;

            background: #fff0e7;

            font-size: 20px;
        }

        .details-heading h2 {
            color: #111;

            font-size: 19px;
            font-weight: 800;

            margin-bottom: 5px;
        }

        .details-heading p {
            color: #888;

            font-size: 12px;
        }

        .details-grid {
            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            gap: 14px;
        }

        .detail-box {
            min-width: 0;

            padding: 17px;

            border: 1px solid #f0eae5;
            border-radius: 11px;

            background: #fffaf7;

            transition:
                transform 0.25s ease,
                border-color 0.25s ease;
        }

        .detail-box:hover {
            transform: translateY(-2px);
            border-color: #ffd3bd;
        }

        .detail-label {
            color: #888;

            font-size: 11px;
            font-weight: 800;

            letter-spacing: 0.6px;

            text-transform: uppercase;

            margin-bottom: 9px;
        }

        .detail-value {
            color: #242424;

            font-size: 14px;
            font-weight: 700;

            line-height: 1.5;

            overflow-wrap: anywhere;
        }

        .status {
            color: var(--green-dark);
        }

        .amount {
            color: var(--orange);

            font-size: 19px;
            font-weight: 800;
        }

        /* =========================
           DELIVERY ADDRESS
        ========================= */

        .delivery-box {
            margin-top: 19px;
            padding: 19px;

            border: 1px solid #f5dfd1;
            border-radius: 12px;

            background: #fff8f3;
        }

        .delivery-label {
            color: #a56743;

            font-size: 11px;
            font-weight: 800;

            letter-spacing: 0.5px;

            margin-bottom: 10px;
        }

        .delivery-address {
            color: #444;

            font-size: 14px;
            line-height: 1.7;

            white-space: pre-wrap;
            overflow-wrap: anywhere;
        }

        /* =========================
           INFORMATION MESSAGE
        ========================= */

        .message {
            margin-top: 23px;

            padding: 16px;

            border: 1px solid #d9efdf;
            border-radius: 11px;

            background: #f2fbf4;

            color: #497356;

            font-size: 12px;
            line-height: 1.7;

            text-align: center;
        }

        .message strong {
            color: var(--green-dark);
        }

        /* =========================
           BUTTONS
        ========================= */

        .buttons {
            display: flex;
            justify-content: center;

            flex-wrap: wrap;

            gap: 13px;

            margin-top: 24px;
        }

        .secondary-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            padding: 13px 22px;

            border: 1px solid #e7ddd6;
            border-radius: 9px;

            background: white;
            color: #333;

            font-size: 13px;
            font-weight: 800;

            transition:
                border-color 0.25s ease,
                color 0.25s ease,
                transform 0.25s ease;
        }

        .secondary-button:hover {
            border-color: var(--orange);
            color: var(--orange);

            transform: translateY(-2px);
        }

        /* =========================
           FOOTER
        ========================= */

        .footer {
            padding: 27px 20px;

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
           KEYFRAME ANIMATIONS
        ========================= */

        @keyframes cardEntrance {

            from {
                opacity: 0;
                transform: translateY(24px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes successPop {

            0% {
                opacity: 0;
                transform: scale(0.3);
            }

            65% {
                opacity: 1;
                transform: scale(1.12);
            }

            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes drawCircle {

            to {
                stroke-dashoffset: 0;
            }
        }

        @keyframes drawCheck {

            to {
                stroke-dashoffset: 0;
            }
        }

        @keyframes glowPulse {

            0%, 100% {
                transform: scale(0.9);
                opacity: 0.5;
            }

            50% {
                transform: scale(1.15);
                opacity: 1;
            }
        }

        @keyframes textEntrance {

            from {
                opacity: 0;
                transform: translateY(12px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes confettiBurst {

            0% {
                opacity: 0;

                transform:
                    translate(-50%, -50%)
                    scale(0)
                    rotate(0deg);
            }

            12% {
                opacity: 1;
            }

            65% {
                opacity: 1;
            }

            100% {
                opacity: 0;

                transform:
                    translate(
                        calc(-50% + var(--x)),
                        calc(-50% + var(--y))
                    )
                    scale(0.8)
                    rotate(var(--rotation));
            }
        }

        /* =========================
           RESPONSIVE
        ========================= */

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

            .cart-link {
                padding: 9px 12px;
                font-size: 12px;
            }

            .container {
                width: 92%;
                margin-top: 25px;
            }

            .success-card {
                padding: 35px 19px 32px;
            }

            .celebration {
                height: 130px;
            }

            .greeting {
                font-size: 14px;
            }

            .success-description {
                font-size: 13px;
            }

            .details-card {
                padding: 20px;
            }

            .details-grid {
                grid-template-columns: 1fr;
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

            .cart-link {
                padding: 8px 10px;
                font-size: 11px;
            }
        }

        @media (prefers-reduced-motion: reduce) {

            *,
            *::before,
            *::after {
                animation-duration: 0.01ms !important;
                animation-delay: 0ms !important;
                transition-duration: 0.01ms !important;
            }

            .success-circle,
            .success-check {
                stroke-dashoffset: 0;
            }

            .confetti-layer {
                display: none;
            }
        }

    </style>

</head>

<body>

<!-- =========================
     FOODWALA NAVBAR
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
           class="cart-link">

            &#128722; Cart

        </a>

    </nav>

</header>

<!-- =========================
     MAIN
========================= -->

<main class="container">

    <!-- =========================
         SUCCESS CONFIRMATION
    ========================= -->

    <section class="success-card"
             aria-labelledby="success-title">

        <!-- ANIMATED GREEN CHECK -->

        <div class="celebration">

            <div class="success-glow"></div>

            <div class="confetti-layer"
                 id="confettiLayer"
                 aria-hidden="true"></div>

            <div class="success-icon">

                <svg class="success-svg"
                     viewBox="0 0 60 60"
                     role="img"
                     aria-label="Order successfully confirmed">

                    <circle
                        class="success-circle"
                        cx="30"
                        cy="30"
                        r="24">
                    </circle>

                    <path
                        class="success-check"
                        d="M18 30 L26 38 L43 21">
                    </path>

                </svg>

            </div>

        </div>

        <!-- PERSONAL GREETING -->

        <p class="greeting">

            Hey <%= safe(customerName) %>!

        </p>

        <h1 id="success-title">

            Your Order is Confirmed!

        </h1>

        <p class="success-description">

            Thank you for ordering with Foodwala.
            Your delicious food is being prepared!

        </p>

        <div class="order-number">

            <span>Order ID</span>

            <strong>
                #<%= order.getOrderId() %>
            </strong>

        </div>

        <!-- MAIN STATUS BUTTON -->

        <div class="success-action">

            <a href="<%= contextPath %>/orders"
               class="primary-button">

                View My Orders &#8594;

            </a>

        </div>

    </section>

    <!-- =========================
         ORDER DETAILS
    ========================= -->

    <section class="details-card"
             aria-labelledby="details-title">

        <div class="details-heading">

            <div class="heading-icon"
                 aria-hidden="true">

                &#129534;

            </div>

            <div>

                <h2 id="details-title">
                    Order Details
                </h2>

                <p>
                    Your order information at a glance
                </p>

            </div>

        </div>

        <div class="details-grid">

            <!-- ORDER ID -->

            <div class="detail-box">

                <div class="detail-label">
                    Order ID
                </div>

                <div class="detail-value">
                    #<%= order.getOrderId() %>
                </div>

            </div>

            <!-- ORDER DATE -->

            <div class="detail-box">

                <div class="detail-label">
                    Order Date
                </div>

                <div class="detail-value">
                    <%= safe(orderDate) %>
                </div>

            </div>

            <!-- PAYMENT METHOD -->

            <div class="detail-box">

                <div class="detail-label">
                    Payment Method
                </div>

                <div class="detail-value">
                    <%= safe(paymentText) %>
                </div>

            </div>

            <!-- ORDER STATUS -->

            <div class="detail-box">

                <div class="detail-label">
                    Order Status
                </div>

                <div class="detail-value status">
                    &#9679; <%= safe(orderStatus) %>
                </div>

            </div>

            <!-- TOTAL AMOUNT -->

            <div class="detail-box">

                <div class="detail-label">
                    Total Amount
                </div>

                <div class="detail-value amount">

                    &#8377;<%= totalAmount %>

                </div>

            </div>

        </div>

        <!-- =========================
             DELIVERY ADDRESS
        ========================= -->

        <%
            if (user != null) {
        %>

            <div class="delivery-box">

                <div class="delivery-label">

                    &#128205; DELIVERY ADDRESS

                </div>

                <div class="delivery-address">
                    <%= safe(user.getAddress()) %>
                </div>

            </div>

        <%
            }
        %>

        <!-- =========================
             INFORMATION MESSAGE
        ========================= -->

        <div class="message">

            Your order has been successfully placed.
            Please keep Order ID

            <strong>
                #<%= order.getOrderId() %>
            </strong>

            for future reference.

        </div>

        <!-- =========================
             ACTION BUTTONS
        ========================= -->

        <div class="buttons">

            <a href="<%= contextPath %>/restaurant"
               class="secondary-button">

                &#8592; Continue Shopping

            </a>

            <a href="<%= contextPath %>/orders"
               class="secondary-button">

                View My Orders &#8594;

            </a>

        </div>

    </section>

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
     CONFETTI ANIMATION
========================= -->

<script>

document.addEventListener("DOMContentLoaded", function () {

    const layer =
        document.getElementById("confettiLayer");

    if (!layer) {
        return;
    }

    const reducedMotion =
        window.matchMedia(
            "(prefers-reduced-motion: reduce)"
        ).matches;

    if (reducedMotion) {
        return;
    }

    const colors = [
        "#22a45a",
        "#57c785",
        "#a4e6b8",
        "#ffb347",
        "#ff6b35",
        "#f8d56b",
        "#ffffff"
    ];

    /*
     * Generate colourful paper pieces.
     * Each piece travels away from the green tick.
     */

    const totalPieces = 46;

    for (let i = 0; i < totalPieces; i++) {

        const piece =
            document.createElement("span");

        piece.className = "confetti-piece";

        if (i % 5 === 0) {

            piece.classList.add("round");

        } else if (i % 3 === 0) {

            piece.classList.add("strip");
        }

        const angle =
            (Math.PI * 2 * i / totalPieces) +
            (Math.random() * 0.28);

        const distance =
            55 + Math.random() * 85;

        const x =
            Math.cos(angle) * distance;

        const y =
            Math.sin(angle) * distance;

        const rotation =
            (Math.random() * 900 - 450) + "deg";

        piece.style.setProperty(
            "--x",
            x.toFixed(1) + "px"
        );

        piece.style.setProperty(
            "--y",
            y.toFixed(1) + "px"
        );

        piece.style.setProperty(
            "--rotation",
            rotation
        );

        piece.style.setProperty(
            "--piece-color",
            colors[i % colors.length]
        );

        piece.style.setProperty(
            "--duration",
            (1.1 + Math.random() * 0.7) + "s"
        );

        piece.style.setProperty(
            "--delay",
            (0.8 + Math.random() * 0.25) + "s"
        );

        layer.appendChild(piece);
    }

});

</script>

</body>
</html>
