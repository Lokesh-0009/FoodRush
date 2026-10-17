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

@WebServlet(urlPatterns = {
    "/driver",
    "/driver/dashboard",
    "/driver-dashboard",
    "/driver/orders",
    "/driver/order/update",
    "/driver/status"
})
public class DriverServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private DriverDAO driverDAO;
	private OrderDAO orderDAO;
	private OrderItemDAO orderItemDAO;
	private RestaurantDAO restaurantDAO;
	private UserDAO userDAO;
	private MenuDAO menuDAO;

	@Override
	public void init() throws ServletException {
		this.driverDAO = new DriverDAOImpl();
		this.orderDAO = new OrderDAOImpl();
		this.orderItemDAO = new OrderItemDAOImpl();
		this.restaurantDAO = new RestaurantDAOImpl();
		this.userDAO = new UserDAOImpl();
		this.menuDAO = new MenuDAOImpl();
	}

	private boolean isAuthorizedDriver(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;

		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login?redirect=driver/dashboard");
			return false;
		}

		String role = user.getRole();
		if (role == null || (!role.toUpperCase().contains("DRIVER") && !role.toUpperCase().contains("ADMIN"))) {
			response.sendRedirect(request.getContextPath() + "/home");
			return false;
		}

		return true;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (!isAuthorizedDriver(request, response)) {
			return;
		}

		HttpSession session = request.getSession(false);
		User currentUser = (User) session.getAttribute("user");

		try {
			// 1. Fetch or initialize Driver profile
			Driver driver = driverDAO.getDriverByUserId(currentUser.getId());
			if (driver == null) {
				driver = new Driver(0, currentUser.getId(), "Bike",
						"KA-05-DR-" + (1000 + currentUser.getId()),
						"DL-KA05-" + (1000 + currentUser.getId()),
						"AVAILABLE", 5.0);
				int newDriverId = driverDAO.addDriver(driver);
				driver.setDriverID(newDriverId);
			}

			// 2. Fetch all orders assigned to this driver
			List<Orders> driverOrders = orderDAO.getOrdersByDriverId(driver.getDriverID());
			if (driverOrders == null) {
				driverOrders = new ArrayList<>();
			}

			List<Orders> activeDeliveries = new ArrayList<>();
			List<Orders> completedDeliveries = new ArrayList<>();

			Map<Integer, Restaurant> restaurantMap = new HashMap<>();
			Map<Integer, User> customerMap = new HashMap<>();
			Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
			Map<Integer, Menu> menuMap = new HashMap<>();

			for (Orders order : driverOrders) {
				String status = (order.getStatus() != null) ? order.getStatus().trim().toUpperCase() : "PENDING";

				if ("DELIVERED".equals(status) || "COMPLETED".equals(status)) {
					completedDeliveries.add(order);
				} else if (!"CANCELLED".equals(status)) {
					activeDeliveries.add(order);
				}

				// Load Restaurant if not already loaded
				if (!restaurantMap.containsKey(order.getRestaurantID())) {
					Restaurant rest = restaurantDAO.getRestaurant(order.getRestaurantID());
					if (rest != null) {
						restaurantMap.put(order.getRestaurantID(), rest);
					}
				}

				// Load Customer if not already loaded
				if (!customerMap.containsKey(order.getUserID())) {
					User cust = userDAO.getUser(order.getUserID());
					if (cust != null) {
						customerMap.put(order.getUserID(), cust);
					}
				}

				// Load items for this order
				List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(order.getOrderID());
				if (items != null) {
					orderItemsMap.put(order.getOrderID(), items);
					for (OrderItem item : items) {
						if (!menuMap.containsKey(item.getMenuID())) {
							Menu m = menuDAO.getMenu(item.getMenuID());
							if (m != null) {
								menuMap.put(item.getMenuID(), m);
							}
						}
					}
				}
			}

			// Calculate earnings: base 50 Rs per delivery
			double totalEarnings = completedDeliveries.size() * 55.0;

			request.setAttribute("driver", driver);
			request.setAttribute("activeDeliveries", activeDeliveries);
			request.setAttribute("completedDeliveries", completedDeliveries);
			request.setAttribute("restaurantMap", restaurantMap);
			request.setAttribute("customerMap", customerMap);
			request.setAttribute("orderItemsMap", orderItemsMap);
			request.setAttribute("menuMap", menuMap);
			request.setAttribute("totalEarnings", totalEarnings);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/driver-dashboard.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading driver dashboard: " + e.getMessage());
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (!isAuthorizedDriver(request, response)) {
			return;
		}

		HttpSession session = request.getSession(false);
		User currentUser = (User) session.getAttribute("user");

		try {
			Driver driver = driverDAO.getDriverByUserId(currentUser.getId());
			if (driver == null) {
				response.sendRedirect(request.getContextPath() + "/driver/dashboard");
				return;
			}

			String action = request.getParameter("action");

			if ("updateStatus".equalsIgnoreCase(action)) {
				// Driver updates duty status (AVAILABLE, BUSY, OFFLINE)
				String status = request.getParameter("status");
				if (status != null && !status.trim().isEmpty()) {
					driverDAO.updateDriverStatus(driver.getDriverID(), status.trim().toUpperCase());
				}
				response.sendRedirect(request.getContextPath() + "/driver/dashboard?statusUpdated=1");
				return;
			}

			if ("updateOrderStatus".equalsIgnoreCase(action)) {
				// Driver updates delivery progress (OUT_FOR_DELIVERY, DELIVERED)
				String orderIdParam = request.getParameter("orderID");
				String newStatus = request.getParameter("newStatus");

				if (orderIdParam != null && newStatus != null) {
					int orderId = Integer.parseInt(orderIdParam.trim());
					Orders order = orderDAO.getOrder(orderId);

					if (order != null && order.getDriverID() != null && order.getDriverID().equals(driver.getDriverID())) {
						order.setStatus(newStatus.trim().toUpperCase());
						
						// If delivered and payment was COD, update payment status to COMPLETED
						if ("DELIVERED".equalsIgnoreCase(newStatus.trim())) {
							order.setPaymentStatus("COMPLETED");
							driverDAO.updateDriverStatus(driver.getDriverID(), "AVAILABLE");
						} else if ("OUT_FOR_DELIVERY".equalsIgnoreCase(newStatus.trim())) {
							driverDAO.updateDriverStatus(driver.getDriverID(), "BUSY");
						}

						orderDAO.updateOrder(order);
					}
				}
				response.sendRedirect(request.getContextPath() + "/driver/dashboard?orderUpdated=1");
				return;
			}

			response.sendRedirect(request.getContextPath() + "/driver/dashboard");

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/driver/dashboard?error=" + e.getMessage());
		}
	}
}
