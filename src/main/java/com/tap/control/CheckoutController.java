package com.tap.control;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Check whether user is logged in
        Object loggedInUser = session.getAttribute("loggedInUser");

        if (loggedInUser == null) {

            // User is not logged in
            // Remember that checkout was requested
            session.setAttribute("checkoutRequired", true);

            // Send user to login page
            resp.sendRedirect("login.jsp");

        } else {

            // User is already logged in
            // Go directly to checkout page
            req.getRequestDispatcher("checkout.jsp").forward(req, resp);
        }
    }
}
