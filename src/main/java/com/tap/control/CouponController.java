package com.tap.control;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/applyCoupon")
public class CouponController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String couponCode = req.getParameter("couponCode");

        HttpSession session = req.getSession();

        double discount = 0;
        String message;

        if (couponCode != null) {

            couponCode = couponCode.trim().toUpperCase();

            if (couponCode.equals("FOOD10")) {

                discount = 10;
                message = "Coupon applied successfully!";

            } else if (couponCode.equals("WELCOME50")) {

                discount = 50;
                message = "Coupon applied successfully!";

            } else if (couponCode.equals("FIRST100")) {

                discount = 100;
                message = "Coupon applied successfully!";

            } else {

                message = "Invalid coupon code.";

                // Remove previously applied coupon
                session.removeAttribute("couponCode");
            }

        } else {

            message = "Please enter a coupon code.";

            session.removeAttribute("couponCode");
        }

        // Store coupon information in session
        if (discount > 0) {

            session.setAttribute("couponCode", couponCode);
            session.setAttribute("couponDiscount", discount);

        } else {

            session.setAttribute("couponDiscount", 0.0);
        }

        session.setAttribute("couponMessage", message);

        resp.sendRedirect("checkout");
    }
}