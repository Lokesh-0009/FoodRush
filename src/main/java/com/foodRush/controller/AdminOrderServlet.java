package com.foodRush.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.foodRush.DAO.DriverDAO;
import com.foodRush.DAO.MenuDAO;
import com.foodRush.DAO.OrderDAO;
import com.foodRush.DAO.OrderItemDAO;
import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAO.UserDAO;
import com.foodRush.DAOImpl.DriverDAOImpl;
import com.foodRush.DAOImpl.MenuDAOImpl;
import com.foodRush.DAOImpl.OrderDAOImpl;
import com.foodRush.DAOImpl.OrderItemDAOImpl;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.DAOImpl.UserDAOImpl;
import com.foodRush.model.Driver;
import com.foodRush.model.Menu;
import com.foodRush.model.OrderItem;
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

@WebServlet(urlPatterns = {"/admin/orders", "/admin-orders", "/admin/order/update-status", "/admin/order/update", "/admin/order/assign-driver"})
public class AdminOrderServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private OrderDAO orderDAO;
	private OrderItemDAO orderItemDAO;
	private RestaurantDAO restaurantDAO;
	private UserDAO userDAO;
	private MenuDAO menuDAO;
	private DriverDAO driverDAO;

	@Override
	public void init() throws ServletException {
		this.orderDAO = new OrderDAOImpl();
		this.orderItemDAO = new OrderItemDAOImpl();
		this.restaurantDAO = new RestaurantDAOImpl();
		this.userDAO = new UserDAOImpl();
		this.menuDAO = new MenuDAOImpl();
		this.driverDAO = new DriverDAOImpl();
	}

	private boolean isAuthorizedAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login?redirect=admin/orders");
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
			List<Orders> allOrders = orderDAO.getAllOrders();
			if (allOrders == null) allOrders = new ArrayList<>();

			List<Restaurant> allRestaurants = restaurantDAO.getAllRestaurants();
			if (allRestaurants == null) allRestaurants = new ArrayList<>();

			List<User> allUsers = userDAO.getAllUsers();
			if (allUsers == null) allUsers = new ArrayList<>();

			List<Menu> allMenus = menuDAO.getAllMenus();
			if (allMenus == null) allMenus = new ArrayList<>();

			Map<Integer, Restaurant> restaurantMap = new HashMap<>();
			for (Restaurant r : allRestaurants) {
				restaurantMap.put(r.getRestaurantID(), r);
			}

			Map<Integer, User> userMap = new HashMap<>();
			for (User u : allUsers) {
				userMap.put(u.getId(), u);
			}

			Map<Integer, Menu> menuMap = new HashMap<>();
			for (Menu m : allMenus) {
				menuMap.put(m.getMenuID(), m);
			}

			// Group into 4 Kanban stages
			List<Orders> pendingOrders = new ArrayList<>();
			List<Orders> preparingOrders = new ArrayList<>();
			List<Orders> outOrders = new ArrayList<>();
			List<Orders> deliveredOrders = new ArrayList<>();

			Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();

			for (Orders order : allOrders) {
				String status = (order.getStatus() != null) ? order.getStatus().trim() : "Pending";
				
				// Fetch items for order
				List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(order.getOrderID());
				if (items != null && !items.isEmpty()) {
					orderItemsMap.put(order.getOrderID(), items);
				}

				String s = status.toUpperCase().replace(" ", "_").replace("-", "_");
				if (s.equals("PENDING") || s.equals("PLACED") || s.equals("CONFIRMED") || s.equals("CREATED")) {
					pendingOrders.add(order);
				} else if (s.equals("PREPARING") || s.equals("COOKING") || s.equals("ACCEPTED") || s.equals("IN_PREPARATION")) {
					preparingOrders.add(order);
				} else if (s.equals("OUT_FOR_DELIVERY") || s.equals("OUTFORDELIVERY") || s.equals("ON_ROUTE") || s.equals("DISPATCHED")) {
					outOrders.add(order);
				} else if (s.equals("DELIVERED") || s.equals("COMPLETED")) {
					deliveredOrders.add(order);
				} else {
					pendingOrders.add(order);
				}
			}

			List<Driver> allDrivers = driverDAO.getAllDrivers();
			if (allDrivers == null) allDrivers = new ArrayList<>();
			Map<Integer, Driver> driverMap = new HashMap<>();
			for (Driver d : allDrivers) {
				driverMap.put(d.getDriverID(), d);
			}

			request.setAttribute("driverList", allDrivers);
			request.setAttribute("driverMap", driverMap);
			request.setAttribute("pendingOrders", pendingOrders);
			request.setAttribute("preparingOrders", preparingOrders);
			request.setAttribute("outOrders", outOrders);
			request.setAttribute("deliveredOrders", deliveredOrders);
			request.setAttribute("allOrders", allOrders);
			request.setAttribute("restaurantsList", allRestaurants);
			request.setAttribute("restaurantMap", restaurantMap);
			request.setAttribute("userMap", userMap);
			request.setAttribute("menuMap", menuMap);
			request.setAttribute("orderItemsMap", orderItemsMap);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/admin-orders.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading kitchen board: " + e.getMessage());
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
			String orderIdStr = request.getParameter("orderID");
			String newStatus = request.getParameter("status");
			String driverIdStr = request.getParameter("driverID");

			if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
				int orderID = Integer.parseInt(orderIdStr.trim());
				Integer driverID = null;
				if (driverIdStr != null && !driverIdStr.trim().isEmpty()) {
					try {
						int parsed = Integer.parseInt(driverIdStr.trim());
						if (parsed > 0) driverID = parsed;
					} catch (NumberFormatException ignore) {}
				}

				if ("assign_driver".equalsIgnoreCase(action) && driverID != null) {
					orderDAO.assignDriver(orderID, driverID);
				} else if (newStatus != null && !newStatus.trim().isEmpty()) {
					Orders order = orderDAO.getOrder(orderID);
					if (order != null) {
						order.setStatus(newStatus.trim());
						if ("Delivered".equalsIgnoreCase(newStatus.trim()) || "DELIVERED".equalsIgnoreCase(newStatus.trim())) {
							order.setPaymentStatus("PAID");
						}
						if (driverID != null) {
							order.setDriverID(driverID);
							driverDAO.updateDriverStatus(driverID, "BUSY");
						}
						orderDAO.updateOrder(order);
					}
				}
			}

			response.sendRedirect(request.getContextPath() + "/admin/orders?updated=1");

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + e.getMessage());
		}
	}
}
