package com.foodRush.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.model.Restaurant;
import com.foodRush.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/admin/restaurants", "/admin-restaurants", "/admin/restaurant/save", "/admin/restaurant/delete"})
public class AdminRestaurantServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private RestaurantDAO restaurantDAO;

	@Override
	public void init() throws ServletException {
		this.restaurantDAO = new RestaurantDAOImpl();
	}

	private boolean isAuthorizedAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login?redirect=admin/restaurants");
			return false;
		}
		String role = user.getRole();
		if (role == null || (!role.toUpperCase().contains("ADMIN") && !role.toUpperCase().contains("MANAGER") && !role.toUpperCase().contains("SUPER"))) {
			response.sendRedirect(request.getContextPath() + "/home");
			return false;
		}
		return true;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (!isAuthorizedAdmin(request, response)) {
			return;
		}
		try {
			List<Restaurant> allRestaurants = restaurantDAO.getAllRestaurants();
			if (allRestaurants == null) {
				allRestaurants = new ArrayList<>();
			}

			long activeCount = allRestaurants.stream()
					.filter(r -> r.getIsActive() == 1 || r.isActive() == 1)
					.count();

			long inactiveCount = allRestaurants.size() - activeCount;

			double avgRating = allRestaurants.stream()
					.mapToDouble(Restaurant::getRating)
					.average()
					.orElse(4.5);

			request.setAttribute("restaurantsList", allRestaurants);
			request.setAttribute("totalCount", allRestaurants.size());
			request.setAttribute("activeCount", activeCount);
			request.setAttribute("inactiveCount", inactiveCount);
			request.setAttribute("avgRating", String.format("%.1f", avgRating));

			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/admin-restaurants.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading restaurants: " + e.getMessage());
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (!isAuthorizedAdmin(request, response)) {
			return;
		}
		try {
			String action = request.getParameter("action");
			String idParam = request.getParameter("restaurantID");

			if ("delete".equalsIgnoreCase(action) || request.getServletPath().contains("delete")) {
				if (idParam != null && !idParam.trim().isEmpty()) {
					int id = Integer.parseInt(idParam.trim());
					restaurantDAO.deleteRestaurant(id);
				}
			} else {
				// Add or Edit Restaurant
				String name = request.getParameter("name");
				String cuisineType = request.getParameter("cuisineType");
				String deliveryTimeStr = request.getParameter("deliveryTime");
				String address = request.getParameter("address");
				String ratingStr = request.getParameter("rating");
				String adminUserStr = request.getParameter("adminUserID");
				String isActiveStr = request.getParameter("isActive");
				String imageUrl = request.getParameter("imageUrl");

				int deliveryTime = (deliveryTimeStr != null && !deliveryTimeStr.isEmpty()) ? Integer.parseInt(deliveryTimeStr.trim()) : 30;
				double rating = (ratingStr != null && !ratingStr.isEmpty()) ? Double.parseDouble(ratingStr.trim()) : 4.5;
				int adminUserID = (adminUserStr != null && !adminUserStr.isEmpty()) ? Integer.parseInt(adminUserStr.trim()) : 1;
				int isActive = (isActiveStr != null && (isActiveStr.equals("1") || isActiveStr.equalsIgnoreCase("on") || isActiveStr.equalsIgnoreCase("true"))) ? 1 : 0;
				if (imageUrl == null || imageUrl.trim().isEmpty()) {
					imageUrl = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=80";
				}

				if (idParam != null && !idParam.trim().isEmpty()) {
					// Update existing
					int restaurantID = Integer.parseInt(idParam.trim());
					Restaurant r = new Restaurant(restaurantID, name, cuisineType, deliveryTime, address, adminUserID, rating, isActive, imageUrl);
					restaurantDAO.updateRestaurant(r);
				} else {
					// Create new
					Restaurant r = new Restaurant(name, cuisineType, deliveryTime, address, adminUserID, rating, isActive, imageUrl);
					restaurantDAO.addRestaurant(r);
				}
			}

			response.sendRedirect(request.getContextPath() + "/admin/restaurants?success=1");

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/admin/restaurants?error=" + e.getMessage());
		}
	}
}
