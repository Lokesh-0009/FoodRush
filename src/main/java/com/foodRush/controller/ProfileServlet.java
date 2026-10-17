package com.foodRush.controller;

import java.io.IOException;
import java.util.List;

import com.foodRush.DAO.OrderDAO;
import com.foodRush.DAO.UserDAO;
import com.foodRush.DAOImpl.OrderDAOImpl;
import com.foodRush.DAOImpl.UserDAOImpl;
import com.foodRush.model.Orders;
import com.foodRush.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/profile", "/frontend/profile", "/updateProfile", "/changePassword"})
public class ProfileServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private UserDAO userDAO;
	private OrderDAO orderDAO;

	@Override
	public void init() throws ServletException {
		userDAO = new UserDAOImpl();
		orderDAO = new OrderDAOImpl();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		User currentUser = (User) session.getAttribute("user");

		if (currentUser == null) {
			session.setAttribute("redirectAfterLogin", "/profile");
			response.sendRedirect(request.getContextPath() + "/login?redirect=profile");
			return;
		}

		// Fetch freshest user data from database
		User freshUser = null;
		if (currentUser.getId() > 0) {
			freshUser = userDAO.getUser(currentUser.getId());
		}
		if (freshUser == null && currentUser.getEmail() != null) {
			freshUser = userDAO.getUserByEmail(currentUser.getEmail());
		}
		if (freshUser != null) {
			currentUser = freshUser;
			session.setAttribute("user", freshUser);
		}

		// Get total orders for profile statistics
		int totalOrders = 0;
		if (currentUser.getId() > 0) {
			List<Orders> userOrders = orderDAO.getOrdersByUserId(currentUser.getId());
			if (userOrders != null) {
				totalOrders = userOrders.size();
			}
		}

		request.setAttribute("profileUser", currentUser);
		request.setAttribute("ordersCount", totalOrders);

		request.getRequestDispatcher("/frontend/profile.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		User currentUser = (User) session.getAttribute("user");

		if (currentUser == null) {
			response.sendRedirect(request.getContextPath() + "/login?redirect=profile");
			return;
		}

		String servletPath = request.getServletPath();
		String action = request.getParameter("action");

		if ("/changePassword".equals(servletPath) || "changePassword".equalsIgnoreCase(action)) {
			handleChangePassword(request, response, session, currentUser);
		} else {
			handleUpdateProfile(request, response, session, currentUser);
		}
	}

	private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response,
			HttpSession session, User currentUser) throws ServletException, IOException {

		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");

		if (name != null && !name.trim().isEmpty()) {
			currentUser.setName(name.trim());
		}
		if (phone != null && !phone.trim().isEmpty()) {
			currentUser.setPhone(phone.trim());
		}
		if (address != null && !address.trim().isEmpty()) {
			currentUser.setAddress(address.trim());
		}

		userDAO.updateUser(currentUser);
		session.setAttribute("user", currentUser);
		session.setAttribute("profileSuccessMessage", "Profile details updated successfully!");

		response.sendRedirect(request.getContextPath() + "/profile");
	}

	private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
			HttpSession session, User currentUser) throws ServletException, IOException {

		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		if (currentPassword == null || newPassword == null || confirmPassword == null) {
			session.setAttribute("profileErrorMessage", "All password fields are required.");
			response.sendRedirect(request.getContextPath() + "/profile#security");
			return;
		}

		if (!newPassword.equals(confirmPassword)) {
			session.setAttribute("profileErrorMessage", "New password and confirmation do not match.");
			response.sendRedirect(request.getContextPath() + "/profile#security");
			return;
		}

		if (newPassword.length() < 6) {
			session.setAttribute("profileErrorMessage", "New password must be at least 6 characters long.");
			response.sendRedirect(request.getContextPath() + "/profile#security");
			return;
		}

		// Verify current password
		String storedPassword = currentUser.getPassword();
		boolean isCurrentValid = false;
		if (storedPassword != null) {
			if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$")) {
				isCurrentValid = BCrypt.checkpw(currentPassword, storedPassword);
			} else {
				isCurrentValid = storedPassword.equals(currentPassword);
			}
		}

		if (!isCurrentValid) {
			session.setAttribute("profileErrorMessage", "Incorrect current password. Please try again.");
			response.sendRedirect(request.getContextPath() + "/profile#security");
			return;
		}

		// Hash new password with BCrypt (12 rounds)
		String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
		currentUser.setPassword(hashedNewPassword);
		userDAO.updateUser(currentUser);

		session.setAttribute("user", currentUser);
		session.setAttribute("profileSuccessMessage", "Password updated successfully with BCrypt security!");

		response.sendRedirect(request.getContextPath() + "/profile");
	}
}
