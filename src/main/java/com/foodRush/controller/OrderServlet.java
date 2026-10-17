package com.foodRush.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.foodRush.DAO.MenuDAO;
import com.foodRush.DAO.OrderDAO;
import com.foodRush.DAO.OrderItemDAO;
import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAO.UserDAO;
import com.foodRush.DAOImpl.MenuDAOImpl;
import com.foodRush.DAOImpl.OrderDAOImpl;
import com.foodRush.DAOImpl.OrderItemDAOImpl;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.DAOImpl.UserDAOImpl;
import com.foodRush.model.Cart;
import com.foodRush.model.CartItem;
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
    "/order", 
    "/frontend/order", 
    "/orders", 
    "/frontend/orders", 
    "/order-tracking", 
    "/frontend/order-tracking"
})
public class OrderServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private OrderDAO orderDAO;
	private OrderItemDAO orderItemDAO;
	private RestaurantDAO restaurantDAO;
	private MenuDAO menuDAO;
	private UserDAO userDAO;
	private com.foodRush.DAO.DriverDAO driverDAO;

	@Override
	public void init() throws ServletException {
		this.orderDAO = new OrderDAOImpl();
		this.orderItemDAO = new OrderItemDAOImpl();
		this.restaurantDAO = new RestaurantDAOImpl();
		this.menuDAO = new MenuDAOImpl();
		this.userDAO = new UserDAOImpl();
		this.driverDAO = new com.foodRush.DAOImpl.DriverDAOImpl();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String servletPath = request.getServletPath();
		String uri = request.getRequestURI();

		if (uri.contains("/order-tracking") || servletPath.contains("order-tracking")) {
			handleOrderTracking(request, response);
		} else if (uri.contains("/orders") || servletPath.contains("orders")) {
			handleOrderHistory(request, response);
		} else {
			// Default redirect to home or order history
			response.sendRedirect(request.getContextPath() + "/home");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if ("cancel".equalsIgnoreCase(action)) {
			handleCancelOrder(request, response);
			return;
		}
		processOrderPlacement(request, response);
	}

	private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		String orderIdParam = request.getParameter("orderID");
		int oid = 0;
		if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
			try {
				oid = Integer.parseInt(orderIdParam.trim());
				Orders ord = orderDAO.getOrder(oid);
				HttpSession session = request.getSession(false);
				User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
				if (ord != null && currentUser != null && ord.getUserID() == currentUser.getId()) {
					String st = ord.getStatus();
					long elapsedSeconds = 999;
					if (ord.getOrderDate() != null) {
						elapsedSeconds = (System.currentTimeMillis() - ord.getOrderDate().getTime()) / 1000;
					}
					// Enforce 60-second grace window (plus 5s network allowance) and check status
					if (elapsedSeconds <= 65 && (st == null || "PLACED".equalsIgnoreCase(st) || "CONFIRMED".equalsIgnoreCase(st))) {
						ord.setStatus("CANCELLED");
						orderDAO.updateOrder(ord);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		response.sendRedirect(request.getContextPath() + "/order-tracking?orderId=" + oid);
	}

	/**
	 * Handles Order Placement from checkout.jsp
	 */
	private void processOrderPlacement(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		Cart cart = (Cart) session.getAttribute("cart");

		// Validate cart
		if (cart == null || cart.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}

		try {
			// Extract checkout form parameters
			String resIdParam = request.getParameter("restaurantID");
			String totalAmountParam = request.getParameter("totalAmount");
			String paymentMethod = request.getParameter("paymentMethod");
			String razorpayPaymentId = request.getParameter("razorpayPaymentId");
			String address = request.getParameter("address");
			String contactName = request.getParameter("contactName");
			String phone = request.getParameter("phone");
			String tipAmountParam = request.getParameter("tipAmount");

			int restaurantID = (resIdParam != null && !resIdParam.trim().isEmpty())
					? Integer.parseInt(resIdParam.trim())
					: cart.getRestaurantID();

			double totalAmount = (totalAmountParam != null && !totalAmountParam.trim().isEmpty())
					? Double.parseDouble(totalAmountParam.trim())
					: cart.getGrandTotal();

			if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
				paymentMethod = "COD";
			}

			int tipAmount = 0;
			if (tipAmountParam != null && !tipAmountParam.trim().isEmpty()) {
				try {
					tipAmount = Integer.parseInt(tipAmountParam.trim());
				} catch (NumberFormatException e) {
					tipAmount = 0;
				}
			}

			String paymentStatus = "COD".equalsIgnoreCase(paymentMethod) ? "PENDING" : "PAID";
			if (razorpayPaymentId != null && !razorpayPaymentId.trim().isEmpty()) {
				paymentStatus = "PAID";
			}

			// Resolve User - require authenticated customer
			User user = (User) session.getAttribute("user");
			if (user == null || user.getId() <= 0) {
				if (user != null && user.getId() <= 0) {
					session.removeAttribute("user");
				}
				session.setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
				response.sendRedirect(request.getContextPath() + "/login?redirect=checkout");
				return;
			}
			int userID = user.getId();

			// 1. Prepare Order and Items
			Orders order = new Orders(
				userID,
				restaurantID,
				totalAmount,
				"PLACED",
				paymentMethod,
				paymentStatus
			);

			List<OrderItem> itemsList = new java.util.ArrayList<>();
			for (CartItem item : cart.getCartItems()) {
				OrderItem orderItem = new OrderItem(
					0,
					0,
					item.getMenuID(),
					item.getQuantity(),
					item.getItemTotal()
				);
				itemsList.add(orderItem);
			}

			// 2. Persist Order and Items atomically
			int generatedOrderID = orderDAO.createOrderWithItems(order, itemsList);

			if (generatedOrderID > 0) {
				// 3. Save order metadata for session tracking
				session.setAttribute("lastPlacedOrderId", generatedOrderID);
				session.setAttribute("lastDeliveryAddress", address);
				session.setAttribute("lastContactName", contactName);
				session.setAttribute("lastContactPhone", phone);
				session.setAttribute("lastTipAmount", tipAmount);
				if (razorpayPaymentId != null && !razorpayPaymentId.trim().isEmpty()) {
					session.setAttribute("lastPaymentId", razorpayPaymentId.trim());
				} else {
					session.removeAttribute("lastPaymentId");
				}

				// 4. Wipe Cart from Session
				cart.clear();
				session.removeAttribute("cart");

				// 5. Redirect to Order Tracking / Confirmation page
				session.setAttribute("orderSuccessMessage", "🎉 Order #ORD-" + generatedOrderID + " placed successfully!");
				response.sendRedirect(request.getContextPath() + "/order-tracking?orderId=" + generatedOrderID);
				return;
			} else {
				// Failed to generate order ID
				request.setAttribute("errorMessage", "Failed to create your order. Please try again.");
				RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/checkout.jsp");
				dispatcher.forward(request, response);
				return;
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Order placement failed: " + e.getMessage());
		}
	}

	/**
	 * Handles Order Tracking View
	 */
	private void handleOrderTracking(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String orderIdParam = request.getParameter("orderId");
		int orderId = 0;

		if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
			try {
				orderId = Integer.parseInt(orderIdParam.trim());
			} catch (NumberFormatException e) {
				orderId = 0;
			}
		}

		if (orderId <= 0) {
			HttpSession session = request.getSession(false);
			if (session != null && session.getAttribute("lastPlacedOrderId") != null) {
				orderId = (Integer) session.getAttribute("lastPlacedOrderId");
			}
		}

		if (orderId <= 0) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		Orders order = orderDAO.getOrder(orderId);
		if (order == null) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		Restaurant restaurant = restaurantDAO.getRestaurant(order.getRestaurantID());
		List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);

		// Preload menu metadata map (menuId -> Menu object) for rich display in JSP
		Map<Integer, Menu> menuMap = new HashMap<>();
		if (orderItems != null) {
			for (OrderItem oi : orderItems) {
				Menu menu = menuDAO.getMenu(oi.getMenuID());
				if (menu != null) {
					menuMap.put(oi.getMenuID(), menu);
				}
			}
		}

		com.foodRush.model.Driver assignedDriver = null;
		if (order.getDriverID() != null && order.getDriverID() > 0) {
			assignedDriver = driverDAO.getDriver(order.getDriverID());
		}

		request.setAttribute("order", order);
		request.setAttribute("restaurant", restaurant);
		request.setAttribute("orderItems", orderItems);
		request.setAttribute("menuMap", menuMap);
		request.setAttribute("assignedDriver", assignedDriver);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/order-tracking.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 * Handles Order History View
	 */
	private void handleOrderHistory(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		User user = (User) session.getAttribute("user");
		if (user == null) {
			session.setAttribute("redirectAfterLogin", request.getContextPath() + "/orders");
			response.sendRedirect(request.getContextPath() + "/login?redirect=orders");
			return;
		}
		int userId = user.getId();

		List<Orders> userOrders = orderDAO.getOrdersByUserId(userId);
		Map<Integer, Restaurant> restaurantMap = new HashMap<>();
		Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();

		if (userOrders != null) {
			for (Orders ord : userOrders) {
				if (!restaurantMap.containsKey(ord.getRestaurantID())) {
					Restaurant res = restaurantDAO.getRestaurant(ord.getRestaurantID());
					if (res != null) {
						restaurantMap.put(ord.getRestaurantID(), res);
					}
				}
				List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(ord.getOrderID());
				orderItemsMap.put(ord.getOrderID(), items);
			}
		}

		request.setAttribute("userOrders", userOrders);
		request.setAttribute("restaurantMap", restaurantMap);
		request.setAttribute("orderItemsMap", orderItemsMap);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/orders.jsp");
		dispatcher.forward(request, response);
	}
}
