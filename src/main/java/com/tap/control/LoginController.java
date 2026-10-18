
package com.tap.control;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.SQLException;

import com.tap.DAOimp.UserDaoImpl;
import com.tap.modell.User;
import com.tap.security.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Get username and password from login.jsp
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Validate input
        if (username == null || password == null
                || username.trim().isEmpty()
                || password.isEmpty()) {

            showError(req, resp);
            return;
        }

        username = username.trim();

        UserDaoImpl userDao = new UserDaoImpl();

        try {

            // Find user using username
            User user = userDao.getUserByUsername(username);

            if (user == null) {
                showError(req, resp);
                return;
            }

            String storedPassword = user.getPassword();

            // Verify securely hashed password
            boolean valid = PasswordUtil.verifyPassword(
                    password, storedPassword);

            // Support old Foodwala accounts with plain-text passwords
            if (!valid && storedPassword != null
                    && !storedPassword.startsWith("pbkdf2$")) {

                valid = MessageDigest.isEqual(
                        password.getBytes(StandardCharsets.UTF_8),
                        storedPassword.getBytes(StandardCharsets.UTF_8));

                if (valid) {

                    // Convert old password into a secure hash
                    String hashedPassword =
                            PasswordUtil.hashPassword(password);

                    boolean updated = userDao.updatePassword(
                            user.getUserId(), hashedPassword);

                    if (!updated) {
                        log("Password upgrade failed for user ID "
                                + user.getUserId());

                        resp.sendError(
                                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                                "Unable to complete login.");
                        return;
                    }
                }
            }

            // Invalid username or password
            if (!valid) {
                showError(req, resp);
                return;
            }

            // Do not store passwords in session
            user.setPassword(null);

            // Create or reuse session to preserve existing cart
            HttpSession session = req.getSession();

            // Change session ID for security without deleting cart
            req.changeSessionId();

            // Store logged-in user in session
            session.setAttribute("loggedInUser", user);

            // Redirect to existing checkout controller
            resp.sendRedirect(
                    req.getContextPath() + "/checkout");

        } catch (SQLException e) {

            log("Login database error", e);

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to process login.");
        }
    }

    // Display login error
    private void showError(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute(
                "error", "Invalid username or password");

        req.getRequestDispatcher("/login.jsp")
                .forward(req, resp);
    }
}
