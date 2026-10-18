<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.modell.Order" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Orders - Foodwala</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f5f5f5;
    color: #222;
}

/* Header */
.header {
    background: #111;
    color: white;
    padding: 18px 50px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.logo {
    color: #ff6b35;
    font-size: 28px;
    font-weight: bold;
}

.header a {
    color: white;
    text-decoration: none;
    margin-left: 25px;
    font-weight: bold;
}

.header a:hover {
    color: #ff6b35;
}

/* Main */
.container {
    width: 90%;
    max-width: 1100px;
    margin: 40px auto;
}

h1 {
    text-align: center;
    margin-bottom: 30px;
}

/* Order Card */
.order-card {
    background: white;
    padding: 25px;
    margin-bottom: 20px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
}

.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #eee;
    padding-bottom: 15px;
}

.order-id {
    font-size: 20px;
    font-weight: bold;
}

.status {
    background: #e8f8ee;
    color: #198754;
    padding: 7px 14px;
    border-radius: 20px;
    font-weight: bold;
}

.order-info {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
    margin-top: 20px;
}

.info-box {
    background: #fafafa;
    padding: 12px;
    border-radius: 8px;
}

.info-box span {
    display: block;
    color: #777;
    font-size: 13px;
    margin-bottom: 5px;
}

.info-box strong {
    font-size: 15px;
}

/* Button */
.view-button {
    display: inline-block;
    margin-top: 20px;
    background: #ff6b35;
    color: white;
    text-decoration: none;
    padding: 11px 20px;
    border-radius: 8px;
    font-weight: bold;
}

.view-button:hover {
    background: #e85a2a;
}

/* No orders */
.no-orders {
    background: white;
    padding: 40px;
    text-align: center;
    border-radius: 12px;
}

.shop-button {
    display: inline-block;
    margin-top: 15px;
    background: #ff6b35;
    color: white;
    text-decoration: none;
    padding: 12px 22px;
    border-radius: 8px;
    font-weight: bold;
}

/* Responsive */
@media(max-width: 600px) {

    .header {
        padding: 15px 20px;
    }

    .order-info {
        grid-template-columns: 1fr;
    }

    .order-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 10px;
    }
}

</style>

</head>

<body>

<div class="header">

    <div class="logo">
        Foodwala
    </div>

    <div>
        <a href="restaurant">Home</a>
        <a href="cart">Cart</a>
        <a href="orders">My Orders</a>
    </div>

</div>


<div class="container">

    <h1>My Orders</h1>

    <%
        List<Order> orders =
            (List<Order>) request.getAttribute("orders");
    %>

    <%
        if (orders == null || orders.isEmpty()) {
    %>

        <div class="no-orders">

            <h2>No Orders Found</h2>

            <p>You have not placed any orders yet.</p>

            <a href="restaurant" class="shop-button">
                Start Shopping
            </a>

        </div>

    <%
        } else {

            for (Order order : orders) {
    %>

        <div class="order-card">

            <div class="order-header">

                <div class="order-id">
                    Order #<%= order.getOrderId() %>
                </div>

                <div class="status">
                    <%= order.getStatus() %>
                </div>

            </div>


            <div class="order-info">

                <div class="info-box">
                    <span>Order Date</span>
                    <strong>
                        <%= order.getOrderDate() %>
                    </strong>
                </div>


                <div class="info-box">
                    <span>Total Amount</span>
                    <strong>
                        ₹<%= String.format("%.2f",
                                order.getTotalAmount()) %>
                    </strong>
                </div>


                <div class="info-box">
                    <span>Payment Method</span>
                    <strong>

                        <%
                            String paymentMode =
                                order.getPaymentMode();

                            if ("COD".equals(paymentMode)) {
                        %>
                            Cash on Delivery
                        <%
                            } else if ("CARD".equals(paymentMode)) {
                        %>
                            Credit / Debit Card
                        <%
                            } else if ("UPI".equals(paymentMode)) {
                        %>
                            UPI
                        <%
                            } else if ("NET_BANKING".equals(paymentMode)) {
                        %>
                            Net Banking
                        <%
                            } else if ("PAY_LATER".equals(paymentMode)) {
                        %>
                            Pay Later
                        <%
                            } else {
                        %>
                            <%= paymentMode %>
                        <%
                            }
                        %>

                    </strong>
                </div>


                <div class="info-box">
                    <span>Restaurant ID</span>
                    <strong>
                        <%= order.getRestaurantId() %>
                    </strong>
                </div>

            </div>


            <!-- View Details Button -->

            <a
                href="orderDetails?orderId=<%= order.getOrderId() %>"
                class="view-button">
                View Details
            </a>

        </div>

    <%
            }
        }
    %>

</div>

</body>
</html>