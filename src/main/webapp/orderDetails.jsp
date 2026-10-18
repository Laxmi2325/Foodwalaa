
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="com.tap.modell.Order" %>
<%@ page import="com.tap.modell.OrderItem" %>
<%@ page import="com.tap.modell.Menu" %>
<%@ page import="com.tap.modell.Restaurant" %>
<%@ page import="java.util.List" %>

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

    List<OrderItem> orderItems =
        (List<OrderItem>) request.getAttribute("orderItems");

    List<Menu> menus =
        (List<Menu>) request.getAttribute("menus");

    Restaurant restaurant =
        (Restaurant) request.getAttribute("restaurant");

    if (order == null) {
        response.sendRedirect(contextPath + "/orders");
        return;
    }

    String paymentMode = order.getPaymentMode();
    String paymentText = paymentMode;

    if ("COD".equals(paymentMode)) {
        paymentText = "Cash on Delivery";
    } else if ("CARD".equals(paymentMode)) {
        paymentText = "Credit / Debit Card";
    } else if ("UPI".equals(paymentMode)) {
        paymentText = "UPI";
    } else if ("NET_BANKING".equals(paymentMode)) {
        paymentText = "Net Banking";
    } else if ("PAY_LATER".equals(paymentMode)) {
        paymentText = "Pay Later";
    }

    String fallbackImage =
        contextPath + "/images/branding/foodwala-logo.png";
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Order Details | Foodwala</title>

<style>

:root {
    --orange: #ff6b35;
    --orange-dark: #eb5723;
    --black: #111111;
    --cream: #fff7f2;
    --text: #222222;
    --muted: #777777;
    --border: #f0e9e4;
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
    font-family: Arial, sans-serif;
    background: var(--cream);
    color: var(--text);
    overflow-x: hidden;
}

/* ================= NAVBAR ================= */

.header {
    position: sticky;
    top: 0;
    z-index: 1000;

    min-height: 76px;
    padding: 10px 6%;

    background: var(--black);

    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 18px;

    box-shadow: 0 5px 22px rgba(0,0,0,0.15);
}

.logo {
    display: inline-flex;
    align-items: center;
    flex-shrink: 0;
    line-height: 0;
    text-decoration: none;
}

.brand-logo {
    display: block;
    width: 155px;
    height: auto;
    max-height: 58px;
    object-fit: contain;

    transition:
        transform 0.35s ease,
        filter 0.35s ease;
}

.logo:hover .brand-logo {
    transform: scale(1.07);
    filter: brightness(1.15);
}

.nav {
    display: flex;
    align-items: center;
    gap: 25px;
}

.nav a {
    position: relative;
    color: white;
    text-decoration: none;
    font-size: 14px;
    font-weight: 700;
    white-space: nowrap;
    transition: color 0.3s ease;
}

.nav a:not(.nav-cta)::after {
    content: "";
    position: absolute;
    left: 0;
    bottom: -7px;
    width: 0;
    height: 2px;
    background: var(--orange);
    transition: width 0.3s ease;
}

.nav a:hover {
    color: var(--orange);
}

.nav a:not(.nav-cta):hover::after {
    width: 100%;
}

.nav .nav-cta {
    padding: 11px 19px;
    border-radius: 25px;
    background: var(--orange);
    color: white;

    transition:
        background 0.3s ease,
        transform 0.3s ease,
        box-shadow 0.3s ease;
}

.nav .nav-cta:hover {
    color: white;
    background: var(--orange-dark);
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(255,107,53,0.3);
}

/* ================= PAGE INTRO ================= */

.page-intro {
    position: relative;
    padding: 48px 7% 43px;

    background:
        radial-gradient(
            circle at 90% 15%,
            rgba(255,107,53,0.12),
            transparent 34%
        ),
        linear-gradient(135deg,#fff7f2,#ffffff);

    border-bottom: 1px solid var(--border);
}

.intro-inner {
    max-width: 1150px;
    margin: auto;
    animation: fadeUp 0.6s ease both;
}

.eyebrow {
    color: var(--orange);
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 2px;
    margin-bottom: 12px;
}

.page-intro h1 {
    color: var(--black);
    font-size: 37px;
    font-weight: 800;
    margin-bottom: 12px;
}

.page-intro h1 span {
    color: var(--orange);
}

.page-intro p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.7;
}

.back-link {
    display: inline-flex;
    align-items: center;
    gap: 7px;

    margin-top: 20px;
    color: #333;
    text-decoration: none;
    font-size: 13px;
    font-weight: bold;

    transition:
        color 0.25s ease,
        transform 0.25s ease;
}

.back-link:hover {
    color: var(--orange);
    transform: translateX(-4px);
}

/* ================= MAIN ================= */

.container {
    width: 90%;
    max-width: 1150px;
    margin: 35px auto 75px;
}

.card {
    background: #fff;
    border: 1px solid rgba(0,0,0,0.045);
    border-radius: 19px;
    padding: 27px;
    margin-bottom: 23px;

    box-shadow: 0 6px 22px rgba(0,0,0,0.055);

    animation: fadeUp 0.65s ease both;

    transition:
        transform 0.3s ease,
        box-shadow 0.3s ease,
        border-color 0.3s ease;
}

.card:hover {
    border-color: rgba(255,107,53,0.16);
    box-shadow: 0 12px 30px rgba(0,0,0,0.075);
}

.section-heading {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 23px;
}

.section-icon {
    width: 43px;
    height: 43px;
    flex-shrink: 0;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 12px;
    background: #fff0e8;
    color: var(--orange);
    font-size: 20px;
}

.section-heading h2 {
    font-size: 20px;
    font-weight: 800;
    color: var(--black);
}

.section-heading p {
    margin-top: 5px;
    font-size: 12px;
    color: var(--muted);
}

/* ================= ORDER INFORMATION ================= */

.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;

    padding-bottom: 22px;
    margin-bottom: 23px;

    border-bottom: 1px solid var(--border);
}

.order-id-label {
    color: var(--muted);
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 1px;
    margin-bottom: 7px;
}

.order-id {
    font-size: 25px;
    font-weight: 800;
    color: var(--black);
}

.order-id span {
    color: var(--orange);
}

.status {
    display: inline-flex;
    align-items: center;
    gap: 7px;

    background: #eaf8ef;
    color: #207c40;

    border: 1px solid #c8ecd3;
    border-radius: 25px;

    padding: 10px 16px;
    font-size: 12px;
    font-weight: 800;
}

.status::before {
    content: "";
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: currentColor;
}

.info-grid {
    display: grid;
    grid-template-columns: repeat(2,minmax(0,1fr));
    gap: 16px;
}

.info-box {
    padding: 19px;
    background: #fffbf8;
    border: 1px solid #f4e9e2;
    border-radius: 12px;

    transition:
        border-color 0.3s ease,
        transform 0.3s ease;
}

.info-box:hover {
    border-color: #ffc9b4;
    transform: translateY(-2px);
}

.info-label {
    color: #888;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 0.7px;
    text-transform: uppercase;
    margin-bottom: 10px;
}

.info-value {
    color: var(--black);
    font-size: 15px;
    font-weight: 700;
    overflow-wrap: anywhere;
}

/* ================= RESTAURANT ================= */

.restaurant-panel {
    display: flex;
    align-items: center;
    gap: 17px;

    background: #fffaf7;
    border: 1px solid #f7e7dc;
    border-radius: 14px;
    padding: 20px;
}

.restaurant-avatar {
    width: 57px;
    height: 57px;
    flex-shrink: 0;

    display: flex;
    justify-content: center;
    align-items: center;

    border-radius: 15px;
    background: var(--black);
    font-size: 26px;
}

.restaurant-name {
    font-size: 20px;
    font-weight: 800;
    margin-bottom: 8px;
}

.restaurant-info {
    color: var(--muted);
    font-size: 13px;
    line-height: 1.7;
    overflow-wrap: anywhere;
}

/* ================= ORDERED ITEMS ================= */

.item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;

    padding: 18px 0;
    border-bottom: 1px solid #f2eeeb;

    transition: background 0.25s ease;
}

.item:hover {
    background: #fffaf7;
}

.item-left {
    display: flex;
    align-items: center;
    gap: 16px;
    min-width: 0;
}

.item-image {
    width: 84px;
    height: 84px;
    flex-shrink: 0;

    object-fit: cover;
    border-radius: 12px;
    background: #191919;

    transition: transform 0.35s ease;
}

.item:hover .item-image {
    transform: scale(1.045);
}

.item-name {
    font-size: 16px;
    font-weight: 800;
    line-height: 1.4;
    overflow-wrap: anywhere;
}

.item-price {
    margin-top: 7px;
    color: var(--muted);
    font-size: 13px;
}

.item-total {
    color: var(--black);
    font-size: 17px;
    font-weight: 800;
    white-space: nowrap;
}

.empty-items {
    padding: 25px;
    text-align: center;
    color: var(--muted);
    background: #fffaf7;
    border-radius: 12px;
    font-size: 14px;
}

/* ================= TOTAL ================= */

.total-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;

    padding: 23px 0 2px;
    margin-top: 12px;

    border-top: 1px solid #eae3de;
}

.total-label {
    color: var(--black);
    font-size: 19px;
    font-weight: 800;
}

.total-price {
    color: var(--orange);
    font-size: 26px;
    font-weight: 800;
    white-space: nowrap;
}

/* ================= BUTTONS ================= */

.buttons {
    display: flex;
    gap: 14px;
    flex-wrap: wrap;
    margin-top: 30px;
}

.btn {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    gap: 8px;

    padding: 14px 23px;
    border-radius: 25px;

    font-size: 13px;
    font-weight: 800;
    text-decoration: none;

    transition:
        transform 0.3s ease,
        background 0.3s ease,
        box-shadow 0.3s ease;
}

.btn:hover {
    transform: translateY(-3px);
}

.primary {
    background: var(--orange);
    color: white;
}

.primary:hover {
    background: var(--orange-dark);
    box-shadow: 0 7px 18px rgba(255,107,53,0.24);
}

.secondary {
    background: var(--black);
    color: white;
}

.secondary:hover {
    background: #303030;
    box-shadow: 0 7px 18px rgba(0,0,0,0.15);
}

/* ================= FOOTER ================= */

.footer {
    background: var(--black);
    color: #aaa;

    text-align: center;
    padding: 26px 20px;

    font-size: 13px;
    line-height: 1.7;
}

.footer span {
    color: var(--orange);
    font-weight: bold;
}

/* ================= ANIMATIONS ================= */

@keyframes fadeUp {
    from {
        opacity: 0;
        transform: translateY(22px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* ================= RESPONSIVE ================= */

@media (max-width: 750px) {

    .header {
        padding: 12px 4%;
    }

    .nav {
        gap: 13px;
    }

    .nav a {
        font-size: 12px;
    }

    .nav .nav-cta {
        padding: 9px 12px;
    }

    .info-grid {
        grid-template-columns: 1fr;
    }

    .page-intro h1 {
        font-size: 30px;
    }

    .container {
        width: 93%;
    }
}

@media (max-width: 500px) {

    .header {
        min-height: 70px;
        padding: 11px 13px;
        gap: 10px;
    }

    .brand-logo {
        width: 105px;
        max-height: 45px;
    }

    .nav {
        gap: 10px;
    }

    .nav a {
        font-size: 11px;
    }

    .nav .nav-cta {
        padding: 9px 10px;
    }

    .page-intro {
        padding: 35px 5%;
    }

    .page-intro h1 {
        font-size: 27px;
    }

    .container {
        margin-top: 24px;
    }

    .card {
        padding: 19px;
    }

    .order-id {
        font-size: 22px;
    }

    .section-heading h2 {
        font-size: 18px;
    }

    .item-image {
        width: 65px;
        height: 65px;
    }

    .item-left {
        gap: 10px;
    }

    .item-name {
        font-size: 14px;
    }

    .item-total {
        font-size: 14px;
    }

    .total-price {
        font-size: 22px;
    }

    .buttons {
        flex-direction: column;
    }

    .btn {
        width: 100%;
    }
}

@media (max-width: 360px) {

    .brand-logo {
        width: 90px;
    }

    .nav {
        gap: 7px;
    }

    .nav a {
        font-size: 10px;
    }

    .nav .nav-cta {
        padding: 8px;
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

<!-- ================= NAVBAR ================= -->

<header class="header">

    <a href="<%= contextPath %>/restaurant"
       class="logo"
       aria-label="Foodwala Home">

        <img
            src="<%= contextPath %>/images/branding/foodwala-logo.png"
            alt="Foodwala"
            class="brand-logo">

    </a>

    <nav class="nav" aria-label="Main navigation">

        <a href="<%= contextPath %>/restaurant">
            Restaurants
        </a>

        <a href="<%= contextPath %>/cart">
            Cart
        </a>

        <a href="<%= contextPath %>/orders"
           class="nav-cta">
            My Orders
        </a>

    </nav>

</header>

<!-- ================= INTRO ================= -->

<section class="page-intro">

    <div class="intro-inner">

        <div class="eyebrow">
            YOUR FOODWALA JOURNEY
        </div>

        <h1>
            Order <span>Details</span>
        </h1>

        <p>
            Everything about your order, all in one place.
        </p>

        <a href="<%= contextPath %>/orders"
           class="back-link">

            &#8592; Back to My Orders

        </a>

    </div>

</section>

<!-- ================= MAIN ================= -->

<main class="container">

    <!-- ORDER INFORMATION -->

    <section class="card">

        <div class="order-header">

            <div>

                <div class="order-id-label">
                    YOUR ORDER NUMBER
                </div>

                <div class="order-id">
                    Order <span>#<%= order.getOrderId() %></span>
                </div>

            </div>

            <div class="status">
                <%= safe(String.valueOf(order.getStatus())) %>
            </div>

        </div>

        <div class="section-heading">

            <div class="section-icon">
                &#128203;
            </div>

            <div>

                <h2>Order Information</h2>

                <p>
                    Your order and payment details
                </p>

            </div>

        </div>

        <div class="info-grid">

            <div class="info-box">

                <div class="info-label">
                    Order Date
                </div>

                <div class="info-value">
                    <%= safe(String.valueOf(order.getOrderDate())) %>
                </div>

            </div>

            <div class="info-box">

                <div class="info-label">
                    Payment Method
                </div>

                <div class="info-value">
                    <%= safe(paymentText) %>
                </div>

            </div>

        </div>

    </section>

    <!-- RESTAURANT -->

    <section class="card">

        <div class="section-heading">

            <div class="section-icon">
                &#127860;
            </div>

            <div>

                <h2>Restaurant</h2>

                <p>
                    Where your food was ordered from
                </p>

            </div>

        </div>

        <% if (restaurant != null) { %>

            <div class="restaurant-panel">

                <div class="restaurant-avatar">
                    &#127869;
                </div>

                <div>

                    <div class="restaurant-name">
                        <%= safe(restaurant.getName()) %>
                    </div>

                    <div class="restaurant-info">

                        <%= safe(restaurant.getCuisineType()) %>

                        <br>

                        <%= safe(restaurant.getAddress()) %>

                    </div>

                </div>

            </div>

        <% } else { %>

            <p class="empty-items">
                Restaurant information is currently unavailable.
            </p>

        <% } %>

    </section>

    <!-- ORDERED ITEMS -->

    <section class="card">

        <div class="section-heading">

            <div class="section-icon">
                &#128722;
            </div>

            <div>

                <h2>Ordered Items</h2>

                <p>
                    A closer look at your delicious choices
                </p>

            </div>

        </div>

        <%
            boolean hasDisplayedItems = false;

            if (orderItems != null && !orderItems.isEmpty()) {

                for (int i = 0; i < orderItems.size(); i++) {

                    OrderItem orderItem = orderItems.get(i);

                    Menu menu = null;

                    if (menus != null && i < menus.size()) {
                        menu = menus.get(i);
                    }

                    if (menu == null) {
                        continue;
                    }

                    hasDisplayedItems = true;

                    String imageUrl = menu.getImagePath();

                    if (imageUrl == null ||
                        imageUrl.trim().isEmpty()) {

                        imageUrl = fallbackImage;

                    } else {

                        imageUrl = imageUrl.trim();

                        if (imageUrl.startsWith("http://") ||
                            imageUrl.startsWith("https://")) {

                            // External image URL.

                        } else if (
                            imageUrl.startsWith(contextPath + "/")) {

                            // Context path already included.

                        } else if (imageUrl.startsWith("/")) {

                            imageUrl = contextPath + imageUrl;

                        } else {

                            imageUrl = contextPath + "/" + imageUrl;
                        }
                    }
        %>

        <div class="item">

            <div class="item-left">

                <img
                    class="item-image"
                    src="<%= safe(imageUrl) %>"
                    alt="<%= safe(menu.getItemName()) %>"
                    loading="lazy"
                    onerror="this.onerror=null;this.src='<%= safe(fallbackImage) %>';">

                <div>

                    <div class="item-name">
                        <%= safe(menu.getItemName()) %>
                    </div>

                    <div class="item-price">
                        Item price:
                        &#8377;<%= String.format("%.2f", menu.getPrice()) %>
                    </div>

                </div>

            </div>

            <div class="item-total">

                &#8377;<%= String.format("%.2f",
                    orderItem.getTotalAmount()) %>

            </div>

        </div>

        <%
                }
            }

            if (!hasDisplayedItems) {
        %>

            <p class="empty-items">
                No item details are available for this order.
            </p>

        <% } %>

        <!-- TOTAL -->

        <div class="total-section">

            <div class="total-label">
                Order Total
            </div>

            <div class="total-price">
                &#8377;<%= String.format("%.2f",
                    order.getTotalAmount()) %>
            </div>

        </div>

    </section>

    <!-- ACTION BUTTONS -->

    <div class="buttons">

        <a href="<%= contextPath %>/orders"
           class="btn secondary">

            &#8592; Back to My Orders

        </a>

        <a href="<%= contextPath %>/restaurant"
           class="btn primary">

            Continue Shopping &#8594;

        </a>

    </div>

</main>

<!-- ================= FOOTER ================= -->

<footer class="footer">

    &#169; 2026 <span>Foodwala</span>

    &bull; Made for Food Lovers.

</footer>

</body>
</html>
