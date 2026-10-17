package com.foodRush.controller;

import java.io.IOException;
import java.util.List;

import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/restaurants", "/frontend/restaurants", "/getAllRestaurants"})
public class RestaurantServlet extends HttpServlet {
	
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
			List<Restaurant> restaurantList = restaurantDAO.getAllRestaurants();
			if (restaurantList == null) {
				restaurantList = new java.util.ArrayList<Restaurant>();
			}
			
			request.setAttribute("restaurantList", restaurantList);
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/restaurants.jsp");
			dispatcher.forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving restaurant data: " + e.getMessage());
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doGet(request, response);
	}
}
