package com.foodRush.controller;

import java.io.IOException;
import java.util.List;

import com.foodRush.DAO.MenuDAO;
import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAOImpl.MenuDAOImpl;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.model.Menu;
import com.foodRush.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/menu", "/frontend/menu", "/restaurant-detail", "/getMenu"})
public class MenuServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private RestaurantDAO restaurantDAO;
	private MenuDAO menuDAO;

	@Override
	public void init() throws ServletException {
		this.restaurantDAO = new RestaurantDAOImpl();
		this.menuDAO = new MenuDAOImpl();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		
		try {
			String resIdParam = request.getParameter("restaurantId");
			int restaurantId = 1; // Default to first restaurant if not provided
			
			if (resIdParam != null && !resIdParam.trim().isEmpty()) {
				try {
					restaurantId = Integer.parseInt(resIdParam.trim());
				} catch (NumberFormatException e) {
					restaurantId = 1;
				}
			}
			
			// 1. Fetch Restaurant metadata
			Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);
			if (restaurant == null) {
				// Fallback to first available restaurant if ID not found
				List<Restaurant> all = restaurantDAO.getAllRestaurants();
				if (all != null && !all.isEmpty()) { 
					restaurant = all.get(0);
					restaurantId = restaurant.getRestaurantID();
				}
			}
			
			// 2. Fetch Menu items belonging to this Restaurant
			List<Menu> menuList = menuDAO.getAllMenusByRestaurantID(restaurantId);
			if (menuList == null || menuList.isEmpty()) {
				// Fallback: If no menus for this restaurant ID, fetch all menus as showcase
				menuList = menuDAO.getAllMenus();
			}
			
			// 3. Attach data to request
			request.setAttribute("restaurant", restaurant);
			request.setAttribute("menuList", menuList);
			
			// 4. Forward to menu.jsp
			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/menu.jsp");
			dispatcher.forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving menu data: " + e.getMessage());
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doGet(request, response);
	}
}
