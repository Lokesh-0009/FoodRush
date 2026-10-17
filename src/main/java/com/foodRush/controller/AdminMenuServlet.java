package com.foodRush.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.foodRush.DAO.MenuDAO;
import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAOImpl.MenuDAOImpl;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.model.Menu;
import com.foodRush.model.Restaurant;
import com.foodRush.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/admin/menu", "/admin-menu", "/admin/menu/save", "/admin/menu/delete"})
public class AdminMenuServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private MenuDAO menuDAO;
	private RestaurantDAO restaurantDAO;

	@Override
	public void init() throws ServletException {
		this.menuDAO = new MenuDAOImpl();
		this.restaurantDAO = new RestaurantDAOImpl();
	}

	private boolean isAuthorizedAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login?redirect=admin/menu");
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
			List<Menu> allMenus = menuDAO.getAllMenus();
			if (allMenus == null) allMenus = new ArrayList<>();

			List<Restaurant> allRestaurants = restaurantDAO.getAllRestaurants();
			if (allRestaurants == null) allRestaurants = new ArrayList<>();

			Map<Integer, Restaurant> restaurantMap = new HashMap<>();
			for (Restaurant r : allRestaurants) {
				restaurantMap.put(r.getRestaurantID(), r);
			}

			long availableCount = allMenus.stream()
					.filter(m -> m.getIsAvailable() == 1)
					.count();

			long soldOutCount = allMenus.size() - availableCount;

			double avgPrice = allMenus.stream()
					.mapToDouble(Menu::getPrice)
					.average()
					.orElse(250.0);

			request.setAttribute("menuList", allMenus);
			request.setAttribute("restaurantsList", allRestaurants);
			request.setAttribute("restaurantMap", restaurantMap);
			request.setAttribute("totalDishes", allMenus.size());
			request.setAttribute("availableDishes", availableCount);
			request.setAttribute("soldOutDishes", soldOutCount);
			request.setAttribute("avgPrice", (int) Math.round(avgPrice));

			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/admin-menu.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading menu catalog: " + e.getMessage());
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
			String idParam = request.getParameter("menuID");

			if ("delete".equalsIgnoreCase(action) || request.getServletPath().contains("delete")) {
				if (idParam != null && !idParam.trim().isEmpty()) {
					int menuID = Integer.parseInt(idParam.trim());
					menuDAO.deleteMenu(menuID);
				}
			} else {
				// Add or Edit Dish
				String itemName = request.getParameter("itemName");
				String restaurantIdStr = request.getParameter("restaurantID");
				String category = request.getParameter("category");
				String description = request.getParameter("description");
				String priceStr = request.getParameter("price");
				String isAvailableStr = request.getParameter("isAvailable");
				String imageUrl = request.getParameter("imageUrl");

				int restaurantID = 1;
				if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
					try {
						restaurantID = Integer.parseInt(restaurantIdStr.trim());
					} catch (NumberFormatException e) {
						restaurantID = 1;
					}
				}

				double price = 200.0;
				if (priceStr != null && !priceStr.trim().isEmpty()) {
					try {
						price = Double.parseDouble(priceStr.trim());
					} catch (NumberFormatException e) {
						price = 200.0;
					}
				}

				int isAvailable = (isAvailableStr != null && (isAvailableStr.equals("1") || isAvailableStr.equalsIgnoreCase("on") || isAvailableStr.equalsIgnoreCase("true"))) ? 1 : 0;
				
				if (imageUrl == null || imageUrl.trim().isEmpty()) {
					imageUrl = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop&q=80";
				} else {
					imageUrl = imageUrl.trim();
					if (imageUrl.length() > 255) {
						imageUrl = imageUrl.substring(0, 255);
					}
				}

				if (category == null || category.trim().isEmpty()) {
					category = "Main Course";
				} else {
					category = category.trim();
					if (category.length() > 100) {
						category = category.substring(0, 100);
					}
				}

				if (itemName == null || itemName.trim().isEmpty()) {
					itemName = "Special Dish";
				} else {
					itemName = itemName.trim();
					if (itemName.length() > 150) {
						itemName = itemName.substring(0, 150);
					}
				}

				if (description != null) {
					description = description.trim();
					if (description.length() > 500) {
						description = description.substring(0, 500);
					}
				} else {
					description = "";
				}

				if (idParam != null && !idParam.trim().isEmpty()) {
					// Update existing
					int menuID = Integer.parseInt(idParam.trim());
					Menu m = new Menu(menuID, restaurantID, itemName, description, price, isAvailable, category, null, null, null, imageUrl);
					menuDAO.updateMenu(m);
					response.sendRedirect(request.getContextPath() + "/admin/menu?updated=1");
					return;
				} else {
					// Add new
					Menu m = new Menu(restaurantID, itemName, description, price, isAvailable, category, imageUrl);
					menuDAO.addMenu(m);
					response.sendRedirect(request.getContextPath() + "/admin/menu?added=1");
					return;
				}
			}

			response.sendRedirect(request.getContextPath() + "/admin/menu?success=1");

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/admin/menu?error=" + e.getMessage());
		}
	}
}
