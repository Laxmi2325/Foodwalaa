package com.tap.control;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.tap.DAOimp.OrderDaoImpl;
import com.tap.DAOimp.OrderItemDaoImpl;
import com.tap.modell.Cart;
import com.tap.modell.CartItem;
import com.tap.modell.Order;
import com.tap.modell.OrderItem;
import com.tap.modell.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/placeOrder")
public class PlaceOrderController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Check logged-in user
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            session.setAttribute("checkoutRequired", true);
            resp.sendRedirect("login.jsp");
            return;
        }

        // Get cart
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            resp.sendRedirect("cart");
            return;
        }

        // Get payment method
        String paymentMethod = req.getParameter("paymentMethod");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            resp.sendRedirect("payment");
            return;
        }

        // Calculate subtotal
        double subtotal = 0;

        List<CartItem> cartItems = cart.getItems();

        for (CartItem item : cartItems) {
            subtotal += item.getTotalPrice();
        }

        // Delivery fee
        double deliveryFee = 40;

        // Coupon discount
        Double couponDiscountObject =
                (Double) session.getAttribute("couponDiscount");

        double couponDiscount = 0;

        if (couponDiscountObject != null) {
            couponDiscount = couponDiscountObject;
        }

        // Final total
        double totalAmount = subtotal + deliveryFee - couponDiscount;

        if (totalAmount < 0) {
            totalAmount = 0;
        }

        // Get restaurant ID from first cart item
        int restaurantId =
                cartItems.get(0).getMenu().getRestaurantId();

        // Current date and time
        LocalDateTime now = LocalDateTime.now();

        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        String orderDate = now.format(formatter);

        // Create Order object
        Order order = new Order();

        order.setUserId(user.getUserId());
        order.setRestaurantId(restaurantId);
        order.setOrderDate(orderDate);
        order.setTotalAmount(totalAmount);
        order.setStatus("PLACED");
        order.setPaymentMode(paymentMethod);

        // Save order and get generated order ID
        OrderDaoImpl orderDaoImpl = new OrderDaoImpl();

        int orderId = orderDaoImpl.addOrder(order);

        // Check whether order was successfully created
        if (orderId <= 0) {
            resp.sendRedirect("payment");
            return;
        }

        // Create Order Items
        OrderItemDaoImpl orderItemDaoImpl =
                new OrderItemDaoImpl();

        for (CartItem cartItem : cartItems) {

            OrderItem orderItem = new OrderItem();

            orderItem.setOrderId(orderId);

            orderItem.setMenuId(
                    cartItem.getMenu().getMenuId()
            );

            orderItem.setTotalAmount(
                    cartItem.getTotalPrice()
            );

            orderItemDaoImpl.addOrderItem(orderItem);
        }

        // Store order ID in session for confirmation page
        session.setAttribute("orderId", orderId);

        // Store final amount
        session.setAttribute("orderTotal", totalAmount);

        // Clear coupon information
        session.removeAttribute("couponCode");
        session.removeAttribute("couponDiscount");
        session.removeAttribute("couponMessage");

        // Clear cart
        session.removeAttribute("cart");

        // Go to order confirmation page
        resp.sendRedirect("orderConfirmation");
    }
}
