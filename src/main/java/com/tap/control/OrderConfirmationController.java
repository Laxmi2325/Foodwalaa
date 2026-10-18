package com.tap.control;

import java.io.IOException;

import com.tap.DAOimp.OrderDaoImpl;
import com.tap.modell.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orderConfirmation")
public class OrderConfirmationController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Get order ID from session
        Object orderIdObject = session.getAttribute("orderId");

        if (orderIdObject == null) {
            resp.sendRedirect("restaurant");
            return;
        }

        int orderId = (Integer) orderIdObject;

        // Get order from database
        OrderDaoImpl orderDaoImpl = new OrderDaoImpl();

        Order order = orderDaoImpl.getOrder(orderId);

        if (order == null) {
            resp.sendRedirect("restaurant");
            return;
        }

        // Send order to JSP
        req.setAttribute("order", order);

        // Forward to confirmation page
        req.getRequestDispatcher("orderConfirmation.jsp")
           .forward(req, resp);
    }
}
