
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.modell.Cart"%>
<%@ page import="com.tap.modell.CartItem"%>

<%
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Foodwala - Cart</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    background-color: #f5f5f5;
    color: #222;
}

/* ================= HEADER ================= */

.header {
    background-color: #111;
    color: white;
    padding: 20px 60px;

    display: flex;
    justify-content: space-between;
    align-items: center;
}

.logo {
    font-size: 28px;
    font-weight: bold;
}

.logo span {
    color: #ff6b35;
}

.header-right {
    display: flex;
    align-items: center;
    gap: 25px;
}

.restaurant-link {
    color: #ddd;
    text-decoration: none;
    font-size: 14px;
}

.restaurant-link:hover {
    color: #ff6b35;
}

.cart-title {
    color: white;
    font-size: 14px;
}

/* ================= MAIN CONTAINER ================= */

.container {
    width: 90%;
    max-width: 1150px;
    margin: 40px auto;
}

.page-title {
    margin-bottom: 25px;
}

.page-title h1 {
    font-size: 30px;
    margin-bottom: 7px;
}

.page-title p {
    color: #666;
    font-size: 15px;
}

/* ================= CART LAYOUT ================= */

.cart-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 320px;
    gap: 30px;
    align-items: start;
}

/* ================= CART ITEMS CONTAINER ================= */

.cart-items {
    background-color: white;
    border-radius: 14px;
    padding: 25px;

    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);

    display: flex;
    flex-direction: column;
}

/* ================= SINGLE CART ITEM ================= */

.cart-item {
    width: 100%;

    display: flex;
    align-items: center;
    gap: 20px;

    padding: 20px 0;
    border-bottom: 1px solid #eee;
}

.cart-item:first-child {
    padding-top: 0;
}

.cart-item:last-child {
    border-bottom: none;
    padding-bottom: 0;
}

/* ================= FOOD IMAGE ================= */

.item-image {
    width: 110px;
    height: 90px;

    object-fit: cover;
    border-radius: 10px;

    flex-shrink: 0;
}

/* ================= ITEM DETAILS ================= */

.item-details {
    flex: 1;
    min-width: 0;
}

.item-name {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 7px;
    line-height: 1.25;
}

.item-price {
    color: #666;
    font-size: 14px;
}

.item-total {
    font-weight: bold;
    font-size: 16px;
    margin-top: 7px;
}

/* ================= QUANTITY ================= */

.quantity-controls {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-shrink: 0;
}

.quantity-controls form {
    margin: 0;
    padding: 0;
}

.quantity-controls button {
    width: 32px;
    height: 32px;

    display: flex;
    align-items: center;
    justify-content: center;

    background-color: #111;
    color: white;

    border: none;
    border-radius: 6px;

    font-size: 18px;
    font-weight: bold;

    cursor: pointer;
    transition: background-color 0.2s ease;
}

.quantity-controls button:hover {
    background-color: #ff6b35;
}

.quantity {
    min-width: 28px;
    text-align: center;

    font-size: 15px;
    font-weight: bold;
}

/* ================= ORDER SUMMARY ================= */

.cart-summary {
    background-color: white;

    border-radius: 14px;
    padding: 25px;

    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);

    position: sticky;
    top: 20px;
}

.cart-summary h2 {
    font-size: 21px;
    margin-bottom: 20px;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;

    padding: 10px 0;

    color: #555;
    font-size: 15px;
}

.total-row {
    border-top: 1px solid #ddd;

    margin-top: 10px;
    padding-top: 15px;

    color: #111;
    font-size: 18px;
    font-weight: bold;
}

/* ================= CHECKOUT BUTTON ================= */

.checkout-button {
    display: block;

    width: 100%;
    margin-top: 20px;
    padding: 13px;

    text-align: center;
    text-decoration: none;

    background-color: #111;
    color: white;

    border-radius: 8px;
    font-size: 15px;
    font-weight: bold;

    transition: background-color 0.2s ease;
}

.checkout-button:hover {
    background-color: #ff6b35;
}

/* ================= CLEAR CART ================= */

.clear-cart-form {
    width: 100%;
    margin-top: 15px;
}

.clear-cart {
    display: block;
    width: 100%;

    text-align: center;
    padding: 10px;

    background: transparent;
    border: none;

    color: #d32f2f;
    font-size: 14px;
    font-family: inherit;

    cursor: pointer;
}

.clear-cart:hover {
    color: #b71c1c;
    text-decoration: underline;
}

/* ================= EMPTY CART ================= */

.empty-cart {
    background-color: white;

    border-radius: 14px;
    padding: 60px 30px;

    text-align: center;

    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

.empty-cart h2 {
    margin-bottom: 10px;
}

.empty-cart p {
    color: #666;
    margin-bottom: 20px;
}

.browse-button {
    display: inline-block;

    background-color: #111;
    color: white;

    text-decoration: none;
    padding: 12px 25px;

    border-radius: 8px;
    font-weight: bold;
}

.browse-button:hover {
    background-color: #ff6b35;
}

/* ================= TABLET ================= */

@media (max-width: 900px) {

    .cart-layout {
        grid-template-columns: 1fr;
    }

    .cart-summary {
        position: static;
    }
}

/* ================= MOBILE ================= */

@media (max-width: 600px) {

    .container {
        width: 94%;
        margin: 25px auto;
    }

    .header {
        padding: 16px 20px;
    }

    .logo {
        font-size: 24px;
    }

    .header-right {
        gap: 12px;
    }

    .cart-item {
        flex-wrap: wrap;
        gap: 15px;
    }

    .item-image {
        width: 85px;
        height: 70px;
    }

    .item-details {
        min-width: calc(100% - 105px);
    }

    .quantity-controls {
        margin-left: 105px;
    }
}

</style>
</head>

<body>

<!-- ================= HEADER ================= -->

<header class="header">

    <div class="logo">
        Food<span>wala</span>
    </div>

    <div class="header-right">

        <a href="<%= contextPath %>/restaurant"
           class="restaurant-link">
            Restaurants
        </a>

        <span class="cart-title">
            &#128722; My Cart
        </span>

    </div>

</header>

<!-- ================= MAIN ================= -->

<main class="container">

    <div class="page-title">

        <h1>Your Cart</h1>

        <p>
            Review your items before proceeding to checkout
        </p>

    </div>

    <%

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null && !cart.getItems().isEmpty()) {

            double subtotal = 0;

    %>

    <!-- ================= CART LAYOUT ================= -->

    <div class="cart-layout">

        <!-- ================= LEFT: CART ITEMS ================= -->

        <div class="cart-items">

            <%

                for (CartItem item : cart.getItems()) {

                    subtotal += item.getTotalPrice();

            %>

            <!-- SINGLE CART ITEM -->

            <div class="cart-item">

                <!-- FOOD IMAGE -->

                <img
                    class="item-image"
                    src="<%= item.getMenu().getImagePath() %>"
                    alt="<%= item.getMenu().getItemName() %>"
                >

                <!-- ITEM DETAILS -->

                <div class="item-details">

                    <div class="item-name">
                        <%= item.getMenu().getItemName() %>
                    </div>

                    <div class="item-price">

                        &#8377;<%= item.getMenu().getPrice() %>
                        &times;
                        <%= item.getQuantity() %>

                    </div>

                    <div class="item-total">
                        &#8377;<%= item.getTotalPrice() %>
                    </div>

                </div>

                <!-- ================= QUANTITY ================= -->

                <div class="quantity-controls">

                    <!-- DECREASE -->

                    <form action="<%= contextPath %>/cart"
                          method="post">

                        <input type="hidden"
                               name="action"
                               value="update">

                        <input type="hidden"
                               name="menuId"
                               value="<%= item.getMenu().getMenuId() %>">

                        <input type="hidden"
                               name="quantity"
                               value="<%= item.getQuantity() - 1 %>">

                        <button type="submit"
                                aria-label="Decrease quantity">
                            -
                        </button>

                    </form>

                    <!-- CURRENT QUANTITY -->

                    <span class="quantity">
                        <%= item.getQuantity() %>
                    </span>

                    <!-- INCREASE -->

                    <form action="<%= contextPath %>/cart"
                          method="post">

                        <input type="hidden"
                               name="action"
                               value="update">

                        <input type="hidden"
                               name="menuId"
                               value="<%= item.getMenu().getMenuId() %>">

                        <input type="hidden"
                               name="quantity"
                               value="<%= item.getQuantity() + 1 %>">

                        <button type="submit"
                                aria-label="Increase quantity">
                            +
                        </button>

                    </form>

                </div>

            </div>

            <%

                }

            %>

        </div>

        <!-- ================= RIGHT: SUMMARY ================= -->

        <div class="cart-summary">

            <h2>Order Summary</h2>

            <div class="summary-row">

                <span>Subtotal</span>

                <span>
                    &#8377;<%= subtotal %>
                </span>

            </div>

            <div class="summary-row">

                <span>Delivery Fee</span>

                <span>&#8377;40</span>

            </div>

            <div class="summary-row total-row">

                <span>Total</span>

                <span>
                    &#8377;<%= subtotal + 40 %>
                </span>

            </div>

            <!-- CHECKOUT -->

            <a href="<%= contextPath %>/checkout"
               class="checkout-button">

                Proceed to Checkout

            </a>

            <!-- CLEAR CART: NO CONFIRMATION POPUP -->

            <form action="<%= contextPath %>/cart"
                  method="post"
                  class="clear-cart-form">

                <input type="hidden"
                       name="action"
                       value="clear">

                <button type="submit"
                        class="clear-cart">
                    Clear Cart
                </button>

            </form>

        </div>

    </div>

    <%

        } else {

    %>

    <!-- ================= EMPTY CART ================= -->

    <div class="empty-cart">

        <h2>Your cart is empty</h2>

        <p>
            Add some delicious food from our restaurants.
        </p>

        <a href="<%= contextPath %>/restaurant"
           class="browse-button">
            Browse Restaurants
        </a>

    </div>

    <%

        }

    %>

</main>

</body>
</html>
