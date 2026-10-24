package com.foodRush.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {
    "/logout", 
    "/frontend/logout", 
    "/admin/logout", 
    "/signout",
    "/frontend/signout"
})
public class LogoutServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		handleLogout(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		handleLogout(request, response);
	}

	private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		try {
			HttpSession session = request.getSession(false);
			if (session != null) {
				session.removeAttribute("user");
				session.removeAttribute("redirectAfterLogin");
				session.removeAttribute("cart");
				session.invalidate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		String redirect = request.getParameter("redirect");
		String safeRedirect = "/home";
		if (redirect != null && !redirect.trim().isEmpty()) {
			String trimmed = redirect.trim();
			String ctx = request.getContextPath();
			if (ctx != null && !ctx.isEmpty() && trimmed.startsWith(ctx)) {
				trimmed = trimmed.substring(ctx.length());
			}
			if (!trimmed.startsWith("http://") && !trimmed.startsWith("https://") 
					&& !trimmed.startsWith("//") && !trimmed.startsWith("\\")) {
				if (!trimmed.startsWith("/")) {
					trimmed = "/" + trimmed;
				}
				if (!trimmed.startsWith("//") && !trimmed.startsWith("/\\")) {
					safeRedirect = trimmed;
				}
			}
		}
		response.sendRedirect(request.getContextPath() + safeRedirect);
	}
}
