
package com.tap.control;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        // Get the existing session without creating a new one
        HttpSession session = req.getSession(false);

        // Remove all session information, including logged-in user
        if (session != null) {
            session.invalidate();
        }

        // Prevent browser caching of the logout response
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        // Redirect customer to login page
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
