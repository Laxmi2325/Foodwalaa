package com.tap.control;

import java.io.IOException;
import java.util.List;

import com.tap.DAOimp.MenuDaoImpl;
import com.tap.modell.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class menucontroller extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String restaurantIdParam = req.getParameter("restaurantId");

        if (restaurantIdParam == null || restaurantIdParam.isEmpty()) {
            resp.sendRedirect("restaurant");
            return;
        }

        int restaurantId = Integer.parseInt(restaurantIdParam);

        MenuDaoImpl menuDaoImpl = new MenuDaoImpl();

        List<Menu> menuList =
                menuDaoImpl.getMenusByRestaurantId(restaurantId);

        req.setAttribute("allmenu", menuList);

        RequestDispatcher rd =
                req.getRequestDispatcher("menu.jsp");

        rd.forward(req, resp);
    }
}