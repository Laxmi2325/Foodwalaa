package com.tap.control;

import java.io.IOException;
import java.util.List;

import com.tap.DAOimp.MenuDaoImpl;
import com.tap.DAOimp.OrderDaoImpl;
import com.tap.DAOimp.OrderItemDaoImpl;
import com.tap.DAOimp.RestaurantDaoImpl;
import com.tap.modell.Menu;
import com.tap.modell.Order;
import com.tap.modell.OrderItem;
import com.tap.modell.Restaurant;
import com.tap.modell.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orderDetails")
public class OrderDetailsController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Check login
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Get order ID from URL
        String orderIdParameter = req.getParameter("orderId");

        if (orderIdParameter == null || orderIdParameter.trim().isEmpty()) {
            resp.sendRedirect("orders");
            return;
        }

        int orderId;

        try {
            orderId = Integer.parseInt(orderIdParameter);
        } catch (NumberFormatException e) {
            resp.sendRedirect("orders");
            return;
        }

        // Get order
        OrderDaoImpl orderDaoImpl = new OrderDaoImpl();
        Order order = orderDaoImpl.getOrder(orderId);

        if (order == null) {
            resp.sendRedirect("orders");
            return;
        }

        // Security check:
        // Make sure this order belongs to the logged-in user
        if (order.getUserId() != user.getUserId()) {
            resp.sendRedirect("orders");
            return;
        }

        // Get order items
        OrderItemDaoImpl orderItemDaoImpl = new OrderItemDaoImpl();

        List<OrderItem> orderItems =
                orderItemDaoImpl.getOrderItemsByOrderId(orderId);

        // Get menu details for each order item
        MenuDaoImpl menuDaoImpl = new MenuDaoImpl();

        List<Menu> menus = new java.util.ArrayList<>();

        for (OrderItem orderItem : orderItems) {

            Menu menu = menuDaoImpl.getMenu(orderItem.getMenuId());

            if (menu != null) {
                menus.add(menu);
            }
        }

        // Get restaurant details
        RestaurantDaoImpl restaurantDaoImpl = new RestaurantDaoImpl();

        Restaurant restaurant =
                restaurantDaoImpl.getRestaurant(order.getRestaurantId());

        // Send data to JSP
        req.setAttribute("order", order);
        req.setAttribute("orderItems", orderItems);
        req.setAttribute("menus", menus);
        req.setAttribute("restaurant", restaurant);

        req.getRequestDispatcher("orderDetails.jsp")
           .forward(req, resp);
    }
}
