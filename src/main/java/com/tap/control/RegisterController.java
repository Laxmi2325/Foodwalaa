
package com.tap.control;

import java.io.IOException;
import java.sql.SQLException;

import com.tap.DAOimp.UserDaoImpl;
import com.tap.modell.User;
import com.tap.security.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDaoImpl userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/register.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = clean(req.getParameter("username"));
        String email = clean(req.getParameter("email"));
        String phone = clean(req.getParameter("phone"));
        String address = clean(req.getParameter("address"));

        String password = req.getParameter("password");
        String confirmPassword =
                req.getParameter("confirmPassword");

        // Validate required fields
        if (username.isEmpty() || email.isEmpty()
                || password == null || password.isEmpty()
                || confirmPassword == null
                || confirmPassword.isEmpty()) {

            showError(req, resp,
                    "Please fill all required fields.");
            return;
        }

        // Validate field lengths and email
        if (username.length() > 50
                || email.length() > 100
                || phone.length() > 15
                || address.length() > 255
                || !email.matches(
                        "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {

            showError(req, resp,
                    "Please enter valid account details.");
            return;
        }

        // Validate password length
        if (password.length() < 8
                || password.length() > 128) {

            showError(req, resp,
                    "Password must contain 8 to 128 characters.");
            return;
        }

        // Check password confirmation
        if (!password.equals(confirmPassword)) {

            showError(req, resp,
                    "Password and Confirm Password do not match.");
            return;
        }

        try {

            // Check duplicate username or email
            if (userDao.accountExists(username, email)) {

                showError(req, resp,
                        "Username or email already exists.");
                return;
            }

            // Create User object
            User user = new User();

            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setRole("CUSTOMER");

            // Store a secure password hash
            user.setPassword(
                    PasswordUtil.hashPassword(password));

            // Insert user into database
            boolean success = userDao.registerUser(user);

            if (success) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/login.jsp?registered=1");

            } else {

                showError(req, resp,
                        "Unable to create account.");
            }

        } catch (SQLException e) {

            log("Registration failed", e);

            if ("23000".equals(e.getSQLState())) {

                showError(req, resp,
                        "Username or email already exists.");

            } else {

                showError(req, resp,
                        "Database error. Please try again.");
            }
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private void showError(
            HttpServletRequest req,
            HttpServletResponse resp,
            String message)
            throws ServletException, IOException {

        req.setAttribute("error", message);

        req.getRequestDispatcher("/register.jsp")
                .forward(req, resp);
    }
}
