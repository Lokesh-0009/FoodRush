package com.foodRush.controller;

import java.io.IOException;

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

@WebServlet(urlPatterns = {
    "/login", 
    "/frontend/login", 
    "/register", 
    "/frontend/register"
})
public class LoginServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private UserDAO userDAO;

	@Override
	public void init() throws ServletException {
		this.userDAO = new UserDAOImpl();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String uri = request.getRequestURI();
		String servletPath = request.getServletPath();
		HttpSession session = request.getSession(true);

		// 1. Handle Logout
		if (uri.contains("/logout") || servletPath.contains("logout")) {
			session.removeAttribute("user");
			session.removeAttribute("redirectAfterLogin");
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		// 2. Handle Login / Register Page View
		User loggedInUser = (User) session.getAttribute("user");
		String redirectParam = request.getParameter("redirect");
		if (redirectParam == null || redirectParam.trim().isEmpty()) {
			redirectParam = (String) session.getAttribute("redirectAfterLogin");
		}

		// If user is already authenticated, redirect them directly
		if (loggedInUser != null) {
			if (redirectParam != null && !redirectParam.trim().isEmpty()) {
				String target = redirectParam.startsWith("/") ? redirectParam : "/" + redirectParam;
				session.removeAttribute("redirectAfterLogin");
				response.sendRedirect(request.getContextPath() + target);
			} else if ("DRIVER".equalsIgnoreCase(loggedInUser.getRole())) {
				response.sendRedirect(request.getContextPath() + "/driver/dashboard");
			} else if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
				response.sendRedirect(request.getContextPath() + "/admin/dashboard");
			} else {
				response.sendRedirect(request.getContextPath() + "/home");
			}
			return;
		}

		// Forward to Login JSP
		request.setAttribute("redirect", redirectParam);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/login.jsp");
		dispatcher.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String uri = request.getRequestURI();
		String servletPath = request.getServletPath();
		String action = request.getParameter("action");

		if ("register".equalsIgnoreCase(action) || uri.contains("/register") || servletPath.contains("register")) {
			handleRegister(request, response);
		} else {
			handleLogin(request, response);
		}
	}

	/**
	 * Authenticates existing user with BCrypt password hashing (and automatic legacy hash upgrade)
	 */
	private void handleLogin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String redirect = request.getParameter("redirect");

		if (redirect == null || redirect.trim().isEmpty()) {
			redirect = (String) session.getAttribute("redirectAfterLogin");
		}

		if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
			request.setAttribute("errorMessage", "Please enter both email and password.");
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		email = email.trim().toLowerCase();
		User user = userDAO.getUserByEmail(email);

		if (user == null) {
			request.setAttribute("errorMessage", "No account found with this email. Please register.");
			request.setAttribute("email", email);
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		// Verify password using BCrypt
		boolean passwordMatches = false;
		String dbPassword = user.getPassword();

		if (dbPassword != null) {
			if (dbPassword.startsWith("$2a$") || dbPassword.startsWith("$2b$") || dbPassword.startsWith("$2y$")) {
				passwordMatches = BCrypt.checkpw(password, dbPassword);
			} else if (dbPassword.equals(password)) {
				// Legacy plaintext match - transparently upgrade to BCrypt in DB
				passwordMatches = true;
				String upgradedHash = BCrypt.hashpw(password, BCrypt.gensalt(12));
				user.setPassword(upgradedHash);
				userDAO.updateUser(user);
			}
		}

		if (!passwordMatches) {
			request.setAttribute("errorMessage", "Invalid password. Please try again.");
			request.setAttribute("email", email);
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		// Login Successful: store user in session
		session.setAttribute("user", user);
		session.removeAttribute("redirectAfterLogin");

		// Redirect to role-appropriate interface
		if (redirect != null && !redirect.trim().isEmpty()) {
			String target = redirect.startsWith("/") ? redirect : "/" + redirect;
			response.sendRedirect(request.getContextPath() + target);
		} else if (user != null && "DRIVER".equalsIgnoreCase(user.getRole())) {
			response.sendRedirect(request.getContextPath() + "/driver/dashboard");
		} else if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
			response.sendRedirect(request.getContextPath() + "/admin/dashboard");
		} else {
			response.sendRedirect(request.getContextPath() + "/home");
		}
	}

	/**
	 * Registers a new user with BCrypt hashed password
	 */
	private void handleRegister(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String redirect = request.getParameter("redirect");

		if (redirect == null || redirect.trim().isEmpty()) {
			redirect = (String) session.getAttribute("redirectAfterLogin");
		}

		// Validation
		if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()
				|| password == null || password.trim().isEmpty()) {
			request.setAttribute("errorMessage", "Name, email, and password are required.");
			request.setAttribute("activeTab", "signup");
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		email = email.trim().toLowerCase();

		if (password.length() < 6) {
			request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
			request.setAttribute("activeTab", "signup");
			request.setAttribute("name", name);
			request.setAttribute("email", email);
			request.setAttribute("phone", phone);
			request.setAttribute("address", address);
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		// Check if email already registered
		User existing = userDAO.getUserByEmail(email);
		if (existing != null) {
			request.setAttribute("errorMessage", "An account with this email already exists. Please sign in.");
			request.setAttribute("activeTab", "login");
			request.setAttribute("email", email);
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		phone = (phone != null) ? phone.trim() : "";
		if (phone.isEmpty()) {
			request.setAttribute("errorMessage", "Phone number is required.");
			request.setAttribute("activeTab", "signup");
			request.setAttribute("name", name);
			request.setAttribute("email", email);
			request.setAttribute("address", address);
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		if (!phone.matches("^[0-9]{10}$")) {
			request.setAttribute("errorMessage", "Please enter a valid 10-digit mobile number.");
			request.setAttribute("activeTab", "signup");
			request.setAttribute("name", name);
			request.setAttribute("email", email);
			request.setAttribute("phone", phone);
			request.setAttribute("address", address);
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		// Check if phone already registered
		User existingPhone = userDAO.getUserByPhone(phone);
		if (existingPhone != null) {
			request.setAttribute("errorMessage", "This phone number is already registered to another account. Please sign in or use another number.");
			request.setAttribute("activeTab", "signup");
			request.setAttribute("name", name);
			request.setAttribute("email", email);
			request.setAttribute("address", address);
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		// Hash password with BCrypt (cost factor 12)
		String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

		if (address == null || address.trim().isEmpty()) {
			address = "Bangalore, India";
		}

		User newUser = new User(name.trim(), email, hashedPassword, phone, "CUSTOMER", address.trim());
		userDAO.addUser(newUser);

		// If generated ID not yet set on object, fetch from DB
		if (newUser.getId() <= 0) {
			User saved = userDAO.getUserByEmail(email);
			if (saved != null) {
				newUser = saved;
			}
		}

		// Verify account was genuinely created in the database!
		if (newUser == null || newUser.getId() <= 0) {
			request.setAttribute("errorMessage", "Registration failed. Please check your details and try again.");
			request.setAttribute("activeTab", "signup");
			request.setAttribute("name", name);
			request.setAttribute("email", email);
			request.setAttribute("phone", phone);
			request.setAttribute("address", address);
			request.setAttribute("redirect", redirect);
			request.getRequestDispatcher("/frontend/login.jsp").forward(request, response);
			return;
		}

		// Auto-login newly registered user
		session.setAttribute("user", newUser);
		session.removeAttribute("redirectAfterLogin");

		// Redirect to target (e.g. checkout) or home
		if (redirect != null && !redirect.trim().isEmpty()) {
			String target = redirect.startsWith("/") ? redirect : "/" + redirect;
			response.sendRedirect(request.getContextPath() + target);
		} else {
			response.sendRedirect(request.getContextPath() + "/home");
		}
	}
}
