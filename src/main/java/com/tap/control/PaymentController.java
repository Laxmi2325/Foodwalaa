package com.tap.control;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payment")
public class PaymentController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        if (session.getAttribute("loggedInUser") == null) {
            session.setAttribute("checkoutRequired", true);
            resp.sendRedirect("login.jsp");
            return;
        }

        if (session.getAttribute("cart") == null) {
            resp.sendRedirect("cart");
            return;
        }

        req.getRequestDispatcher("payment.jsp").forward(req, resp);
    }
}