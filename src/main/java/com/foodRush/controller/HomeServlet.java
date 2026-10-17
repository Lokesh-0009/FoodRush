package com.foodRush.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/home", "/frontend/home", "/index", "/frontend/index"})
public class HomeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private RestaurantDAO restaurantDAO;

	@Override
	public void init() throws ServletException {
		this.restaurantDAO = new RestaurantDAOImpl();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		
		try {
			List<Restaurant> allRestaurants = restaurantDAO.getAllRestaurants();
			if (allRestaurants == null) {
				allRestaurants = new ArrayList<Restaurant>();
			}

			// 1. Top Rated Restaurants (Sorted by Rating Descending)
			List<Restaurant> topRatedList = allRestaurants.stream()
					.sorted((a, b) -> Double.compare(b.getRating(), a.getRating()))
					.limit(4)
					.collect(Collectors.toList());

			// 2. Fastest Delivery (Sorted by DeliveryTime Ascending)
			List<Restaurant> fastestList = allRestaurants.stream()
					.sorted((a, b) -> Integer.compare(a.getDeliveryTime(), b.getDeliveryTime()))
					.limit(4)
					.collect(Collectors.toList());

			request.setAttribute("topRatedList", topRatedList);
			request.setAttribute("fastestList", fastestList);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/index.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading home page: " + e.getMessage());
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doGet(request, response);
	}
}
