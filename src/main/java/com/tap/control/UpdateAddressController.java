package com.tap.control;

import java.io.IOException;

import com.tap.DAOimp.UserDaoImpl;
import com.tap.modell.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateAddress")
public class UpdateAddressController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String address = req.getParameter("address");

        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("loggedInUser");

        if (user != null && address != null && !address.trim().isEmpty()) {

            // Update address in User object
            user.setAddress(address.trim());

            // Update address in database
            UserDaoImpl userDaoImpl = new UserDaoImpl();
            userDaoImpl.updateUser(user);

            // Update User object in session
            session.setAttribute("loggedInUser", user);
        }

        // Go back to checkout page
        resp.sendRedirect("checkout");
    }
}