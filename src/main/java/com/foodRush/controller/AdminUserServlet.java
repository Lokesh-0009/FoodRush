package com.foodRush.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.foodRush.DAO.UserDAO;
import com.foodRush.DAOImpl.UserDAOImpl;
import com.foodRush.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/admin/users", "/admin-users", "/admin/user/save", "/admin/user/delete"})
public class AdminUserServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private UserDAO userDAO;
	private com.foodRush.DAO.DriverDAO driverDAO;

	@Override
	public void init() throws ServletException {
		this.userDAO = new UserDAOImpl();
		this.driverDAO = new com.foodRush.DAOImpl.DriverDAOImpl();
	}

	private boolean isAuthorizedAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login?redirect=admin/users");
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
			List<User> allUsers = userDAO.getAllUsers();
			if (allUsers == null) allUsers = new ArrayList<>();

			long customerCount = allUsers.stream()
					.filter(u -> u.getRole() == null || u.getRole().equalsIgnoreCase("Customer") || u.getRole().equalsIgnoreCase("User"))
					.count();

			long managerCount = allUsers.stream()
					.filter(u -> u.getRole() != null && (u.getRole().equalsIgnoreCase("Restaurant_Admin") || u.getRole().equalsIgnoreCase("Manager")))
					.count();

			long adminCount = allUsers.stream()
					.filter(u -> u.getRole() != null && (u.getRole().equalsIgnoreCase("Super_Admin") || u.getRole().equalsIgnoreCase("Admin")))
					.count();

			long driverCount = allUsers.stream()
					.filter(u -> u.getRole() != null && (u.getRole().equalsIgnoreCase("Driver") || u.getRole().equalsIgnoreCase("Delivery_Partner") || u.getRole().equalsIgnoreCase("DRIVER")))
					.count();

			request.setAttribute("userList", allUsers);
			request.setAttribute("totalUsers", allUsers.size());
			request.setAttribute("customerCount", customerCount);
			request.setAttribute("managerCount", managerCount);
			request.setAttribute("adminCount", adminCount);
			request.setAttribute("driverCount", driverCount);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/admin-users.jsp");
			dispatcher.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading user management: " + e.getMessage());
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
			String idParam = request.getParameter("id");

			if ("delete".equalsIgnoreCase(action) || request.getServletPath().contains("delete")) {
				if (idParam != null && !idParam.trim().isEmpty()) {
					int id = Integer.parseInt(idParam.trim());
					userDAO.deleteUser(id);
				}
			} else {
				// Add or Edit User
				String name = request.getParameter("name");
				String email = request.getParameter("email");
				String phone = request.getParameter("phone");
				String role = request.getParameter("role");
				String address = request.getParameter("address");
				String password = request.getParameter("password");

				if (role == null || role.trim().isEmpty()) {
					role = "Customer";
				}

				if (idParam != null && !idParam.trim().isEmpty()) {
					// Update existing
					int id = Integer.parseInt(idParam.trim());
					User existing = userDAO.getUser(id);
					String pass;
					if (password != null && !password.trim().isEmpty()) {
						if (password.startsWith("$2a$") || password.startsWith("$2b$") || password.startsWith("$2y$")) {
							pass = password;
						} else {
							pass = BCrypt.hashpw(password.trim(), BCrypt.gensalt(12));
						}
					} else {
						pass = (existing != null && existing.getPassword() != null) ? existing.getPassword() : BCrypt.hashpw("defaultPass123", BCrypt.gensalt(12));
					}
					User u = new User(name, email, pass, phone, role, address, id);
					userDAO.updateUser(u);
					if (role != null && role.toUpperCase().contains("DRIVER")) {
						com.foodRush.model.Driver existingDriver = driverDAO.getDriverByUserId(id);
						if (existingDriver == null) {
							driverDAO.addDriver(new com.foodRush.model.Driver(0, id, "Bike", "KA-05-DR-" + (1000 + id), null, "AVAILABLE", 5.0));
						}
					}
				} else {
					// Add new with BCrypt hash
					if (password == null || password.trim().isEmpty()) {
						password = "defaultPass123";
					}
					String hashedPassword = BCrypt.hashpw(password.trim(), BCrypt.gensalt(12));
					User u = new User(name, email, hashedPassword, phone, role, address);
					userDAO.addUser(u);
					int newId = u.getId();
					if (newId <= 0) {
						User created = userDAO.getUserByEmail(email);
						if (created != null) newId = created.getId();
					}
					if (role != null && role.toUpperCase().contains("DRIVER") && newId > 0) {
						com.foodRush.model.Driver existingDriver = driverDAO.getDriverByUserId(newId);
						if (existingDriver == null) {
							driverDAO.addDriver(new com.foodRush.model.Driver(0, newId, "Bike", "KA-05-DR-" + (1000 + newId), null, "AVAILABLE", 5.0));
						}
					}
				}
			}

			response.sendRedirect(request.getContextPath() + "/admin/users?success=1");

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/admin/users?error=" + e.getMessage());
		}
	}
}
