package com.tap.control;

import java.io.IOException;
import java.util.List;

import com.tap.DAOimp.OrderDaoImpl;
import com.tap.modell.Order;
import com.tap.modell.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        OrderDaoImpl orderDaoImpl = new OrderDaoImpl();

        List<Order> orders = orderDaoImpl.getOrdersByUserId(user.getUserId());

        req.setAttribute("orders", orders);

        req.getRequestDispatcher("orders.jsp").forward(req, resp);
    }
}
