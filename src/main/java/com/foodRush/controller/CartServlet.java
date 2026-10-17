package com.foodRush.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.foodRush.DAO.MenuDAO;
import com.foodRush.DAO.RestaurantDAO;
import com.foodRush.DAOImpl.MenuDAOImpl;
import com.foodRush.DAOImpl.RestaurantDAOImpl;
import com.foodRush.model.Cart;
import com.foodRush.model.CartItem;
import com.foodRush.model.Menu;
import com.foodRush.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/cart", "/frontend/cart", "/cart/add", "/cart/update", "/cart/remove", "/cart/clear", "/cart/coupon"})
public class CartServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private MenuDAO menuDAO;
	private RestaurantDAO restaurantDAO;

	@Override
	public void init() throws ServletException {
		this.menuDAO = new MenuDAOImpl();
		this.restaurantDAO = new RestaurantDAOImpl();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processCartRequest(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processCartRequest(request, response);
	}

	private void processCartRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		Cart cart = (Cart) session.getAttribute("cart");
		if (cart == null) {
			cart = new Cart();
			session.setAttribute("cart", cart);
		}

		String action = request.getParameter("action");
		if (action == null || action.trim().isEmpty()) {
			String uri = request.getRequestURI();
			if (uri.endsWith("/add")) action = "add";
			else if (uri.endsWith("/update")) action = "update";
			else if (uri.endsWith("/remove")) action = "remove";
			else if (uri.endsWith("/clear")) action = "clear";
			else if (uri.endsWith("/coupon")) action = "coupon";
			else action = "view";
		}

		String format = request.getParameter("format");
		boolean isAjax = "json".equalsIgnoreCase(format) 
				|| "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));

		String conflictJson = null;
		try {
			if ("add".equalsIgnoreCase(action)) {
				conflictJson = handleAdd(request, cart);
			} else if ("update".equalsIgnoreCase(action)) {
				handleUpdate(request, cart);
			} else if ("remove".equalsIgnoreCase(action)) {
				handleRemove(request, cart);
			} else if ("clear".equalsIgnoreCase(action)) {
				cart.clear();
			} else if ("coupon".equalsIgnoreCase(action)) {
				handleCoupon(request, cart);
			}
		} catch (Exception e) {
			e.printStackTrace();
			if (isAjax) {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				try (PrintWriter out = response.getWriter()) {
					String msg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Internal Server Error";
					out.print(String.format("{\"success\":false,\"error\":\"%s\"}", msg));
					out.flush();
				}
				return;
			}
		}

		session.setAttribute("cart", cart);

		if (isAjax) {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			try (PrintWriter out = response.getWriter()) {
				if (conflictJson != null) {
					response.setStatus(HttpServletResponse.SC_OK);
					out.print(conflictJson);
				} else {
					response.setStatus(HttpServletResponse.SC_OK);
					out.print(String.format(
						"{\"success\":true,\"conflict\":false,\"totalCount\":%d,\"itemTotal\":%.2f,\"deliveryFee\":%.2f,\"platformFee\":%.2f,\"gstTax\":%.2f,\"discount\":%.2f,\"grandTotal\":%.2f,\"restaurantId\":%d,\"restaurantName\":\"%s\"}",
						cart.getTotalCount(),
						cart.getItemTotal(),
						cart.getDeliveryFee(),
						cart.getPlatformFee(),
						cart.getGstTax(),
						cart.getDiscountAmount(),
						cart.getGrandTotal(),
						cart.getRestaurantID(),
						cart.getRestaurantName() != null ? cart.getRestaurantName().replace("\"", "\\\"") : ""
					));
				}
				out.flush();
			}
			return;
		}

		// Forward to cart.jsp for normal page load
		request.setAttribute("cart", cart);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/cart.jsp");
		dispatcher.forward(request, response);
	}

	private String handleAdd(HttpServletRequest request, Cart cart) {
		String menuIdParam = request.getParameter("menuId");
		String qtyParam = request.getParameter("quantity");
		String resIdParam = request.getParameter("restaurantId");
		boolean forceReset = "true".equalsIgnoreCase(request.getParameter("forceReset"));

		int menuId = (menuIdParam != null && !menuIdParam.trim().isEmpty()) ? Integer.parseInt(menuIdParam.trim().replace("item-", "")) : 0;
		int qty = (qtyParam != null && !qtyParam.trim().isEmpty()) ? Integer.parseInt(qtyParam.trim()) : 1;
		int resId = (resIdParam != null && !resIdParam.trim().isEmpty()) ? Integer.parseInt(resIdParam.trim()) : 0;

		if (menuId > 0) {
			Menu menu = menuDAO.getMenu(menuId);
			if (menu != null) {
				int incomingResId = menu.getRestaurantID() > 0 ? menu.getRestaurantID() : resId;

				// Check for restaurant conflict
				if (cart.hasRestaurantConflict(incomingResId) && !forceReset) {
					Restaurant newRes = restaurantDAO.getRestaurant(incomingResId);
					String newResName = (newRes != null && newRes.getName() != null) ? newRes.getName() : "another restaurant";
					return String.format("{\"success\":false,\"conflict\":true,\"currentRestaurant\":\"%s\",\"newRestaurant\":\"%s\",\"currentRestaurantId\":%d,\"newRestaurantId\":%d}",
						cart.getRestaurantName() != null ? cart.getRestaurantName().replace("\"", "\\\"") : "",
						newResName.replace("\"", "\\\""),
						cart.getRestaurantID(),
						incomingResId
					);
				}

				String cat = (menu.getCategory() != null) ? menu.getCategory().toLowerCase() : "";
				String name = (menu.getItemName() != null) ? menu.getItemName().toLowerCase() : "";
				boolean isVeg = cat.contains("veg") || name.contains("veg") || name.contains("paneer") || name.contains("dal");

				CartItem item = new CartItem(
					menu.getMenuID(),
					incomingResId,
					menu.getItemName(),
					menu.getPrice(),
					qty,
					menu.getImagePath(),
					menu.getCategory(),
					isVeg
				);

				if (forceReset || cart.getRestaurantName() == null || cart.getRestaurantName().isEmpty() || cart.getRestaurantID() != incomingResId) {
					Restaurant res = restaurantDAO.getRestaurant(incomingResId);
					if (res != null && res.getName() != null) {
						cart.setRestaurantName(res.getName());
					}
				}

				cart.addItem(item, forceReset);
			} else {
				// Fallback if menu item not found in DB directly
				String name = request.getParameter("name");
				String priceParam = request.getParameter("price");
				double price = (priceParam != null && !priceParam.trim().isEmpty()) ? Double.parseDouble(priceParam.trim()) : 200.0;
				if (name != null && !name.trim().isEmpty()) {
					if (cart.hasRestaurantConflict(resId) && !forceReset) {
						Restaurant newRes = restaurantDAO.getRestaurant(resId);
						String newResName = (newRes != null && newRes.getName() != null) ? newRes.getName() : "another restaurant";
						return String.format("{\"success\":false,\"conflict\":true,\"currentRestaurant\":\"%s\",\"newRestaurant\":\"%s\",\"currentRestaurantId\":%d,\"newRestaurantId\":%d}",
							cart.getRestaurantName() != null ? cart.getRestaurantName().replace("\"", "\\\"") : "",
							newResName.replace("\"", "\\\""),
							cart.getRestaurantID(),
							resId
						);
					}
					Restaurant res = restaurantDAO.getRestaurant(resId);
					if (res != null && res.getName() != null) {
						cart.setRestaurantName(res.getName());
					}
					CartItem item = new CartItem(menuId, resId, name, price, qty, null, "Main Course", true);
					cart.addItem(item, forceReset);
				}
			}
		}
		return null;
	}

	private void handleUpdate(HttpServletRequest request, Cart cart) {
		String menuIdParam = request.getParameter("menuId");
		String qtyParam = request.getParameter("quantity");

		if (menuIdParam != null && qtyParam != null) {
			int menuId = Integer.parseInt(menuIdParam.trim().replace("item-", ""));
			int qty = Integer.parseInt(qtyParam.trim());
			cart.updateQuantity(menuId, qty);
		}
	}

	private void handleRemove(HttpServletRequest request, Cart cart) {
		String menuIdParam = request.getParameter("menuId");
		if (menuIdParam != null) {
			int menuId = Integer.parseInt(menuIdParam.trim().replace("item-", ""));
			cart.removeItem(menuId);
		}
	}

	private void handleCoupon(HttpServletRequest request, Cart cart) {
		String code = request.getParameter("couponCode");
		if (code != null) {
			code = code.trim().toUpperCase();
			if ("RUSH50".equals(code)) {
				cart.setCouponCode("RUSH50");
				cart.setDiscountAmount(50.0);
			} else if ("FEAST100".equals(code)) {
				cart.setCouponCode("FEAST100");
				cart.setDiscountAmount(100.0);
			} else if ("WELCOME20".equals(code)) {
				cart.setCouponCode("WELCOME20");
				double discount = Math.min(60.0, cart.getItemTotal() * 0.20);
				cart.setDiscountAmount(discount);
			} else {
				cart.setCouponCode("");
				cart.setDiscountAmount(0.0);
			}
		}
	}
}
