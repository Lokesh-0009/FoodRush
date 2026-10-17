package com.foodRush.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.foodRush.DAO.MenuDAO;
import com.foodRush.DAO.OrderDAO;
import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAO.UserDAO;
import com.foodRush.DAOImpl.MenuDAOImpl;
import com.foodRush.DAOImpl.OrderDAOImpl;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.DAOImpl.UserDAOImpl;
import com.foodRush.model.Menu;
import com.foodRush.model.Orders;
import com.foodRush.model.Restaurant;
import com.foodRush.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/admin", "/admin/dashboard", "/admin-dashboard"})
public class AdminDashboardServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private OrderDAO orderDAO;
	private RestaurantDAO restaurantDAO;
	private MenuDAO menuDAO;
	private UserDAO userDAO;

	@Override
	public void init() throws ServletException {
		this.orderDAO = new OrderDAOImpl();
		this.restaurantDAO = new RestaurantDAOImpl();
		this.menuDAO = new MenuDAOImpl();
		this.userDAO = new UserDAOImpl();
	}

	private boolean isAuthorizedAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login?redirect=admin/dashboard");
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
			// 1. Fetch data from DAOs
			List<Orders> allOrders = orderDAO.getAllOrders();
			if (allOrders == null) allOrders = new ArrayList<>();

			List<Restaurant> allRestaurants = restaurantDAO.getAllRestaurants();
			if (allRestaurants == null) allRestaurants = new ArrayList<>();

			List<Menu> allMenus = menuDAO.getAllMenus();
			if (allMenus == null) allMenus = new ArrayList<>();

			List<User> allUsers = userDAO.getAllUsers();
			if (allUsers == null) allUsers = new ArrayList<>();

			// 2. Maps for quick display lookup
			Map<Integer, Restaurant> restaurantMap = new HashMap<>();
			for (Restaurant r : allRestaurants) {
				restaurantMap.put(r.getRestaurantID(), r);
			}

			Map<Integer, User> userMap = new HashMap<>();
			for (User u : allUsers) {
				userMap.put(u.getId(), u);
			}

			// 3. Compute KPI metrics
			double totalRevenue = allOrders.stream()
					.filter(o -> o.getStatus() == null || (!o.getStatus().equalsIgnoreCase("Cancelled") && !o.getStatus().equalsIgnoreCase("CANCELLED")))
					.mapToDouble(Orders::getTotalAmount)
					.sum();

			long activeOrdersCount = allOrders.stream()
					.filter(o -> {
						if (o.getStatus() == null) return false;
						String s = o.getStatus().toUpperCase().replace(" ", "_").replace("-", "_");
						return s.equals("PLACED") || s.equals("CONFIRMED") || s.equals("PREPARING") || s.equals("OUT_FOR_DELIVERY") || s.equals("PENDING");
					})
					.count();

			long activeRestaurantsCount = allRestaurants.stream()
					.filter(r -> r.getIsActive() == 1 || r.isActive() == 1)
					.count();

			long customerCount = allUsers.stream()
					.filter(u -> u.getRole() == null || u.getRole().equalsIgnoreCase("Customer") || u.getRole().equalsIgnoreCase("CUSTOMER") || u.getRole().equalsIgnoreCase("User"))
					.count();

			// 4. Sorted Recent Orders (Newest first)
			List<Orders> recentOrders = allOrders.stream()
					.sorted((a, b) -> {
						if (a.getOrderDate() != null && b.getOrderDate() != null) {
							return b.getOrderDate().compareTo(a.getOrderDate());
						}
						return Integer.compare(b.getOrderID(), a.getOrderID());
					})
					.limit(8)
					.collect(Collectors.toList());

			// 5. Top Selling Dishes (Top items from menu list)
			List<Menu> topDishes = allMenus.stream()
					.limit(5)
					.collect(Collectors.toList());

			// 6. Set Request Attributes
			request.setAttribute("totalRevenue", totalRevenue);
			request.setAttribute("activeOrdersCount", activeOrdersCount);
			request.setAttribute("totalOrdersCount", allOrders.size());
			request.setAttribute("totalRestaurantsCount", allRestaurants.size());
			request.setAttribute("activeRestaurantsCount", activeRestaurantsCount);
			request.setAttribute("totalUsersCount", allUsers.size());
			request.setAttribute("customerCount", customerCount);
			request.setAttribute("recentOrders", recentOrders);
			request.setAttribute("restaurantMap", restaurantMap);
			request.setAttribute("userMap", userMap);
			request.setAttribute("topDishes", topDishes);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/admin-dashboard.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading admin dashboard: " + e.getMessage());
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
