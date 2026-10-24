package com.foodRush.controller;

import java.io.IOException;

import com.foodRush.model.Cart;
import com.foodRush.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/checkout", "/frontend/checkout"})
public class CheckoutServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processCheckout(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processCheckout(request, response);
	}

	private void processCheckout(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(true);
		Cart cart = (Cart) session.getAttribute("cart");

		// Validate cart exists and has items
		if (cart == null || cart.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/cart");
			return;
		}

		User user = (User) session.getAttribute("user");
		if (user == null || user.getId() <= 0) {
			if (user != null && user.getId() <= 0) {
				session.removeAttribute("user");
			}
			session.setAttribute("redirectAfterLogin", "/checkout");
			response.sendRedirect(request.getContextPath() + "/login?redirect=checkout");
			return;
		}

		request.setAttribute("cart", cart);
		request.setAttribute("user", user);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/frontend/checkout.jsp");
		dispatcher.forward(request, response);
	}
}
