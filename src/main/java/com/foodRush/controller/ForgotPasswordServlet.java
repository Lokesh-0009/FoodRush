package com.foodRush.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

import org.mindrot.jbcrypt.BCrypt;

import com.foodRush.DAO.UserDAO;
import com.foodRush.DAOImpl.UserDAOImpl;
import com.foodRush.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {
    "/forgot-password", 
    "/reset-password", 
    "/frontend/forgot-password"
})
public class ForgotPasswordServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private UserDAO userDAO;

	@Override
	public void init() throws ServletException {
		this.userDAO = new UserDAOImpl();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/forgot-password.jsp");
		dispatcher.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String format = request.getParameter("format");
		boolean isJson = "json".equalsIgnoreCase(format) || 
		                 "application/json".equalsIgnoreCase(request.getHeader("Accept"));

		if ("verifyAndReset".equalsIgnoreCase(action) || "resetPassword".equalsIgnoreCase(action)) {
			handleResetPassword(request, response, isJson);
		} else {
			handleSendOtp(request, response, isJson);
		}
	}

	/**
	 * Step 1: Validates registered email and generates a secure 6-digit OTP
	 */
	private void handleSendOtp(HttpServletRequest request, HttpServletResponse response, boolean isJson)
			throws ServletException, IOException {
		String email = request.getParameter("email");
		if (email == null || email.trim().isEmpty()) {
			sendError(request, response, isJson, "Please enter your registered email address.", "1");
			return;
		}

		email = email.trim().toLowerCase();
		User user = userDAO.getUserByEmail(email);

		if (user == null) {
			sendError(request, response, isJson, "No account found with this email address. Please register.", "1");
			return;
		}

		// Generate a 6-digit OTP verification code
		String otp = String.format("%06d", new Random().nextInt(900000) + 100000);
		HttpSession session = request.getSession(true);
		session.setAttribute("fp_email", email);
		session.setAttribute("fp_otp", otp);
		session.setAttribute("fp_expiry", System.currentTimeMillis() + (10 * 60 * 1000)); // 10 minutes

		// Attempt to dispatch real email to recipient
		boolean emailSent = com.foodRush.util.EmailService.sendOtpEmail(email, otp);

		if (!emailSent) {
			System.out.println("[DEV / TEST] SMTP not configured. OTP for " + email + ": " + otp);
		}

		if (isJson) {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			if (emailSent) {
				out.print(String.format("{\"success\":true,\"emailSent\":true,\"message\":\"Verification code sent to your email (%s)! Please check your inbox.\",\"email\":\"%s\"}",
					escapeJson(email), escapeJson(email)));
			} else {
				out.print(String.format("{\"success\":true,\"emailSent\":false,\"message\":\"Verification code generated (SMTP server offline, code logged to server console).\",\"email\":\"%s\"}",
					escapeJson(email)));
			}
			out.flush();
		} else {
			request.setAttribute("step", "2");
			request.setAttribute("email", email);
			if (emailSent) {
				request.setAttribute("successMessage", "Verification code sent to your email (" + email + ")! Please check your inbox and spam folder.");
			} else {
				request.setAttribute("successMessage", "Verification code generated (SMTP server offline, code logged to server console).");
			}
			request.getRequestDispatcher("/frontend/forgot-password.jsp").forward(request, response);
		}
	}

	/**
	 * Step 2: Validates OTP and updates password with BCrypt hashing
	 */
	private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, boolean isJson)
			throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String email = request.getParameter("email");
		if (email == null || email.trim().isEmpty()) {
			email = (String) session.getAttribute("fp_email");
		}
		String otp = request.getParameter("otp");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		String storedOtp = (String) session.getAttribute("fp_otp");
		Long expiry = (Long) session.getAttribute("fp_expiry");

		if (email == null || email.trim().isEmpty()) {
			sendError(request, response, isJson, "Session expired. Please request a new OTP code.", "1");
			return;
		}
		email = email.trim().toLowerCase();

		if (storedOtp == null || expiry == null || System.currentTimeMillis() > expiry) {
			sendError(request, response, isJson, "The verification code has expired. Please request a new code.", "2");
			return;
		}

		if (otp == null || !storedOtp.equals(otp.trim())) {
			sendError(request, response, isJson, "Invalid verification code. Please check and try again.", "2");
			return;
		}

		if (newPassword == null || newPassword.trim().length() < 6) {
			sendError(request, response, isJson, "New password must be at least 6 characters long.", "2");
			return;
		}

		if (!newPassword.equals(confirmPassword)) {
			sendError(request, response, isJson, "Passwords do not match. Please re-enter.", "2");
			return;
		}

		User user = userDAO.getUserByEmail(email);
		if (user == null) {
			sendError(request, response, isJson, "User account not found.", "1");
			return;
		}

		// Hash new password using BCrypt (12 rounds)
		String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
		boolean updated = userDAO.updateUserPassword(user.getId(), hashed);
		if (!updated) {
			sendError(request, response, isJson, "Failed to update password. Please try again.", "2");
			return;
		}

		// Clear reset session attributes
		session.removeAttribute("fp_email");
		session.removeAttribute("fp_otp");
		session.removeAttribute("fp_expiry");

		if (isJson) {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.print("{\"success\":true,\"message\":\"Password updated successfully! Redirecting to sign in...\"}");
			out.flush();
		} else {
			session.setAttribute("loginSuccessMessage", "Password has been reset successfully! Please sign in with your new password.");
			response.sendRedirect(request.getContextPath() + "/login?resetSuccess=true&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
		}
	}

	private void sendError(HttpServletRequest request, HttpServletResponse response, boolean isJson, 
	                       String message, String step) throws ServletException, IOException {
		if (isJson) {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.print(String.format("{\"success\":false,\"message\":\"%s\"}", escapeJson(message)));
			out.flush();
		} else {
			request.setAttribute("errorMessage", message);
			request.setAttribute("step", step);
			request.getRequestDispatcher("/frontend/forgot-password.jsp").forward(request, response);
		}
	}

	private String escapeJson(String s) {
		if (s == null) return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
	}
}
