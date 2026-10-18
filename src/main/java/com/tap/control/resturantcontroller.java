package com.tap.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.tap.DAOimp.RestaurantDaoImpl;
import com.tap.modell.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/restaurant")
public class resturantcontroller extends HttpServlet{

	

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	        throws ServletException, IOException {

	    RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

	    List<Restaurant> allRestaurants = restaurantDao.getAllRestaurants();

	    req.setAttribute("Restaurants", allRestaurants);

	    req.getRequestDispatcher("restaurant.jsp").forward(req, resp);
	}
}
