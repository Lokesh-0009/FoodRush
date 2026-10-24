<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.foodRush.model.Orders"%>
<%@ page import="com.foodRush.model.OrderItem"%>
<%@ page import="com.foodRush.model.Restaurant"%>
<%@ page import="com.foodRush.model.Menu"%>
<%@ page import="com.foodRush.model.User"%>
<%@ page import="com.foodRush.model.Driver"%>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || loggedUser.getRole() == null ||
        (!loggedUser.getRole().toUpperCase().contains("ADMIN") &&
         !loggedUser.getRole().toUpperCase().contains("MANAGER") &&
         !loggedUser.getRole().toUpperCase().contains("SUPER"))) {
        response.sendRedirect(request.getContextPath() + "/login?redirect=admin/orders");
        return;
    }
    if (request.getAttribute("pendingOrders") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/orders");
        return;
    }
    String adminName = (loggedUser.getName() != null) ? loggedUser.getName() : "System Admin";
    String adminEmail = (loggedUser.getEmail() != null) ? loggedUser.getEmail() : "admin@foodrush.com";

    List<Orders> pendingOrders = (List<Orders>) request.getAttribute("pendingOrders");
    List<Orders> preparingOrders = (List<Orders>) request.getAttribute("preparingOrders");
    List<Orders> outOrders = (List<Orders>) request.getAttribute("outOrders");
    List<Orders> deliveredOrders = (List<Orders>) request.getAttribute("deliveredOrders");
    List<Restaurant> restaurantsList = (List<Restaurant>) request.getAttribute("restaurantsList");
    List<Driver> driverList = (List<Driver>) request.getAttribute("driverList");

    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    Map<Integer, User> userMap = (Map<Integer, User>) request.getAttribute("userMap");
    Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");
    Map<Integer, Driver> driverMap = (Map<Integer, Driver>) request.getAttribute("driverMap");
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");

    int pendingCount = (pendingOrders != null) ? pendingOrders.size() : 1;
    int preparingCount = (preparingOrders != null) ? preparingOrders.size() : 1;
    int outCount = (outOrders != null) ? outOrders.size() : 1;
    int deliveredCount = (deliveredOrders != null) ? deliveredOrders.size() : 1;
    int totalActive = pendingCount + preparingCount + outCount;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="FoodRush Admin Portal - Live Kitchen Orders & Kanban Board. Track order dispatch, update kitchen preparation stages, and manage delivery status.">
  <title>Live Orders & Kitchen Board — FoodRush Admin</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Core CSS Design System -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css?v=2.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css?v=2.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css?v=2.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/admin.css?v=2.0">

  <!-- Font Awesome 6 (Vector Icons) -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- Instant Theme Initializer to prevent white flash in Dark Mode -->
  <script>
    (function () {
      const savedTheme = localStorage.getItem('foodrush_theme');
      if (savedTheme === 'dark' || (!savedTheme && window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.setAttribute('data-theme', 'dark');
      }
    })();
  </script>
</head>
<body>

  <div class="admin-layout">
    
    <!-- =========================================================================
         1. Fixed Admin Sidebar
         ========================================================================= -->
    <aside class="admin-sidebar" id="admin-sidebar" aria-label="Admin Navigation">
      <div>
        <div class="admin-sidebar-header">
          <a href="<%= request.getContextPath() %>/admin/dashboard" class="admin-brand-logo">
            <i class="fa-solid fa-bolt-lightning text-primary"></i>
            <span>FoodRush</span>
            <span class="admin-badge-pill">Admin</span>
          </a>
        </div>

        <ul class="admin-nav-menu">
          <li>
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="admin-nav-link">
              <i class="fa-solid fa-chart-line" style="width: 18px; text-align: center;"></i> Dashboard
            </a>
          </li>
          <li>
            <a href="<%= request.getContextPath() %>/admin/restaurants" class="admin-nav-link">
              <i class="fa-solid fa-utensils" style="width: 18px; text-align: center;"></i> Restaurants
            </a>
          </li>
          <li>
            <a href="<%= request.getContextPath() %>/admin/menu" class="admin-nav-link">
              <i class="fa-solid fa-book-open" style="width: 18px; text-align: center;"></i> Menu Management
            </a>
          </li>
          <li>
            <a href="<%= request.getContextPath() %>/admin/orders" class="admin-nav-link active">
              <i class="fa-solid fa-box" style="width: 18px; text-align: center;"></i> Live Orders / Kitchen
            </a>
          </li>
          <li>
            <a href="<%= request.getContextPath() %>/admin/users" class="admin-nav-link">
              <i class="fa-solid fa-users" style="width: 18px; text-align: center;"></i> User Management
            </a>
          </li>
        </ul>
      </div>

      <!-- Bottom Sidebar: Customer App Link & Profile -->
      <div class="admin-sidebar-footer">
        <a href="<%= request.getContextPath() %>/home" class="admin-customer-link">
          <i class="fa-solid fa-house" style="width: 16px; text-align: center;"></i> Back to Customer Site
        </a>

        <div class="admin-profile-pill">
          <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=80" alt="Admin Avatar" class="admin-avatar">
          <div style="font-size: var(--font-size-caption); min-width: 0;">
            <div style="color: #FFFFFF; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= adminName %></div>
            <div style="color: #D4C5C7; font-size: 11px;"><%= adminEmail %></div>
          </div>
        </div>

        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm" style="width: 100%; justify-content: center; color: var(--color-error); border-color: rgba(229, 9, 20, 0.4); text-decoration: none; font-weight: 600; padding: 6px 12px; font-size: 12px; margin-top: 8px; display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-right-from-bracket"></i> Sign Out
        </a>
      </div>
    </aside>

    <!-- =========================================================================
         2. Main Content Area
         ========================================================================= -->
    <div class="admin-main-wrapper">
      
      <!-- Admin Topbar -->
      <header class="admin-topbar">
        <div style="display: flex; align-items: center; gap: 16px;">
          <button type="button" class="btn btn-secondary btn-sm" id="admin-sidebar-toggle" style="display: none; padding: 6px 10px;">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <div style="font-size: 12px; color: var(--color-text-muted); display: flex; align-items: center; gap: 6px; margin-bottom: 4px;">
              <a href="<%= request.getContextPath() %>/admin/dashboard" style="color: var(--color-text-secondary); text-decoration: none;">Dashboard</a>
              <span>/</span>
              <span style="color: var(--color-primary); font-weight: 600;">Orders</span>
            </div>
            <h1 style="font-size: var(--font-size-h3); font-weight: bold; margin-bottom: 2px;">Kitchen Orders Board</h1>
          </div>
        </div>

        <div style="display: flex; align-items: center; gap: 12px;">
          <!-- Live Auto-refresh Indicator -->
          <div style="display: flex; align-items: center; gap: 6px; font-size: 13px; color: var(--color-success); font-weight: 600; background: var(--color-success-soft); padding: 6px 12px; border-radius: var(--radius-full); border: 1px solid rgba(22,163,74,0.25);">
            <span style="display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: var(--color-success); animation: pulse 1.5s infinite;"></span>
            Live Updates Active
          </div>

          <!-- Theme Toggle Button -->
          <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
            <i class="fa-solid fa-sun sun-icon"></i>
            <i class="fa-solid fa-moon moon-icon"></i>
          </button>

          <!-- Sign Out Button -->
          <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary btn-sm" style="display: flex; align-items: center; gap: 6px; color: var(--color-error); border-color: rgba(229, 9, 20, 0.3); text-decoration: none; font-weight: 600; padding: 7px 14px;" title="Sign Out">
            <i class="fa-solid fa-right-from-bracket"></i> <span>Sign Out</span>
          </a>
        </div>
      </header>

      <!-- Main Dashboard Content -->
      <main class="admin-page-content">
        
        <!-- Filter bar -->
        <div class="admin-filter-bar">
          <div class="admin-filter-group">
            <select id="kitchen-restaurant-filter" class="form-select">
              <option value="ALL">All Outlets</option>
              <%
                  if (restaurantsList != null) {
                      for (Restaurant r : restaurantsList) {
              %>
              <option value="<%= r.getName() %>"><%= r.getName() %></option>
              <%
                      }
                  }
              %>
            </select>

            <select id="kitchen-payment-filter" class="form-select">
              <option value="ALL">All Payments</option>
              <option value="PAID">Online Paid (Card / UPI)</option>
              <option value="COD">Cash on Delivery (COD)</option>
            </select>
          </div>

          <div style="font-size: 13px; color: var(--color-text-secondary); font-weight: 500;">
            Total active pipeline: <strong id="total-active-orders" style="color: var(--color-primary-light); font-weight: 800;"><%= totalActive %> Orders</strong>
          </div>
        </div>

        <!-- =====================================================================
             3. 4-Stage Kanban Board Grid
             ===================================================================== -->
        <div class="kanban-grid">
          
          <!-- STAGE 1: PENDING -->
          <div class="kanban-column kanban-col-pending">
            <div class="kanban-col-header">
              <div class="kanban-col-title">
                <span><i class="fa-solid fa-clock"></i></span>
                <span>1. Pending</span>
              </div>
              <span id="badge-pending-count" class="kanban-badge-count"><%= pendingCount %></span>
            </div>
            <div id="col-pending-orders" style="display: flex; flex-direction: column; gap: var(--space-4); min-height: 400px;">
              <%
                  if (pendingOrders != null && !pendingOrders.isEmpty()) {
                      for (Orders order : pendingOrders) {
                          String custName = (userMap != null && userMap.containsKey(order.getUserID())) ? userMap.get(order.getUserID()).getName() : "Customer #" + order.getUserID();
                          String restName = (restaurantMap != null && restaurantMap.containsKey(order.getRestaurantID())) ? restaurantMap.get(order.getRestaurantID()).getName() : "Outlet #" + order.getRestaurantID();
                          String payMethod = (order.getPaymentMethod() != null) ? order.getPaymentMethod().toUpperCase() : "UPI";
                          String payBadgeClass = payMethod.contains("COD") ? "cod" : (payMethod.contains("CARD") ? "card" : "upi");
              %>
              <div class="kanban-card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                  <div>
                    <strong style="color: var(--color-text-primary);">#ORD-<%= order.getOrderID() %></strong>
                    <div style="font-size: 11px; color: var(--color-text-muted);">Just now</div>
                  </div>
                  <span class="kanban-payment-badge <%= payBadgeClass %>"><%= payMethod %></span>
                </div>
                <div style="font-weight: 700; font-size: 13px; margin-bottom: 4px;"><%= custName %></div>
                <div style="font-size: 12px; color: var(--color-text-secondary); margin-bottom: 8px;"><%= restName %></div>
                <div style="font-size: 12px; color: var(--color-text-primary); margin-bottom: 10px;">
                  <%
                      List<OrderItem> items = (orderItemsMap != null) ? orderItemsMap.get(order.getOrderID()) : null;
                      if (items != null && !items.isEmpty()) {
                          for (OrderItem item : items) {
                              String dName = (menuMap != null && menuMap.containsKey(item.getMenuID())) ? menuMap.get(item.getMenuID()).getItemName() : "Dish #" + item.getMenuID();
                  %>
                  • <%= item.getQuantity() %>× <%= dName %><br>
                  <%
                          }
                      } else {
                  %>
                  • 1× Special Chef Order
                  <%
                      }
                  %>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--color-border-light); padding-top: 8px;">
                  <strong style="color: var(--color-primary-light);">₹<%= (int)order.getTotalAmount() %></strong>
                  <form action="<%= request.getContextPath() %>/admin/order/update-status" method="POST" style="margin: 0;">
                    <input type="hidden" name="orderID" value="<%= order.getOrderID() %>">
                    <input type="hidden" name="status" value="PREPARING">
                    <button type="submit" class="btn btn-primary btn-sm" style="padding: 4px 10px; font-size: 12px; display: inline-flex; align-items: center; gap: 4px;">Accept & Cook <i class="fa-solid fa-arrow-right"></i></button>
                  </form>
                </div>
              </div>
              <%
                      }
                  } else {
              %>
              <div style="text-align: center; padding: 40px 10px; color: var(--color-text-muted); font-size: 12px;">
                No pending orders
              </div>
              <%
                  }
              %>
            </div>
          </div>

          <!-- STAGE 2: PREPARING -->
          <div class="kanban-column kanban-col-preparing">
            <div class="kanban-col-header">
              <div class="kanban-col-title" style="color: var(--color-primary-light);">
                <span><i class="fa-solid fa-kitchen-set"></i></span>
                <span>2. Preparing</span>
              </div>
              <span id="badge-preparing-count" class="kanban-badge-count" style="color: var(--color-primary);"><%= preparingCount %></span>
            </div>
            <div id="col-preparing-orders" style="display: flex; flex-direction: column; gap: var(--space-4); min-height: 400px;">
              <%
                  if (preparingOrders != null && !preparingOrders.isEmpty()) {
                      for (Orders order : preparingOrders) {
                          String custName = (userMap != null && userMap.containsKey(order.getUserID())) ? userMap.get(order.getUserID()).getName() : "Customer #" + order.getUserID();
                          String restName = (restaurantMap != null && restaurantMap.containsKey(order.getRestaurantID())) ? restaurantMap.get(order.getRestaurantID()).getName() : "Outlet #" + order.getRestaurantID();
                          String payMethod = (order.getPaymentMethod() != null) ? order.getPaymentMethod().toUpperCase() : "CARD";
                          String payBadgeClass = payMethod.contains("COD") ? "cod" : (payMethod.contains("CARD") ? "card" : "upi");
              %>
              <div class="kanban-card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                  <div>
                    <strong style="color: var(--color-text-primary);">#ORD-<%= order.getOrderID() %></strong>
                    <div style="font-size: 11px; color: var(--color-text-muted);">Cooking in progress</div>
                  </div>
                  <span class="kanban-payment-badge <%= payBadgeClass %>"><%= payMethod %></span>
                </div>
                <div style="font-weight: 700; font-size: 13px; margin-bottom: 4px;"><%= custName %></div>
                <div style="font-size: 12px; color: var(--color-text-secondary); margin-bottom: 8px;"><%= restName %></div>
                <div style="font-size: 12px; color: var(--color-text-primary); margin-bottom: 10px;">
                  <%
                      List<OrderItem> items = (orderItemsMap != null) ? orderItemsMap.get(order.getOrderID()) : null;
                      if (items != null && !items.isEmpty()) {
                          for (OrderItem item : items) {
                              String dName = (menuMap != null && menuMap.containsKey(item.getMenuID())) ? menuMap.get(item.getMenuID()).getItemName() : "Dish #" + item.getMenuID();
                  %>
                  • <%= item.getQuantity() %>× <%= dName %><br>
                  <%
                          }
                      } else {
                  %>
                  • 1× Butter Chicken Special
                  <%
                      }
                  %>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--color-border-light); padding-top: 8px; gap: 8px;">
                  <strong style="color: var(--color-primary-light);">₹<%= (int)order.getTotalAmount() %></strong>
                  <form action="<%= request.getContextPath() %>/admin/order/update-status" method="POST" style="margin: 0; display: flex; gap: 6px; align-items: center;">
                    <input type="hidden" name="orderID" value="<%= order.getOrderID() %>">
                    <input type="hidden" name="status" value="OUT_FOR_DELIVERY">
                    <select name="driverID" class="form-select" style="padding: 3px 6px; font-size: 11px; max-width: 130px; height: 28px; background: var(--color-surface-hover);" title="Assign Delivery Driver">
                      <option value="">Select Rider...</option>
                      <%
                          if (driverList != null) {
                              for (Driver d : driverList) {
                                  boolean isAssigned = (order.getDriverID() != null && order.getDriverID().equals(d.getDriverID()));
                      %>
                      <option value="<%= d.getDriverID() %>" <%= isAssigned ? "selected" : "" %>>
                        <%= d.getName() %> (<%= d.getVehicleType() %>)
                      </option>
                      <%
                              }
                          }
                      %>
                    </select>
                    <button type="submit" class="btn btn-primary btn-sm" style="padding: 4px 10px; font-size: 11px; white-space: nowrap; display: inline-flex; align-items: center; gap: 4px;">Dispatch <i class="fa-solid fa-arrow-right"></i></button>
                  </form>
                </div>
              </div>
              <%
                      }
                  } else {
              %>
              <div style="text-align: center; padding: 40px 10px; color: var(--color-text-muted); font-size: 12px;">
                No orders currently cooking
              </div>
              <%
                  }
              %>
            </div>
          </div>

          <!-- STAGE 3: OUT FOR DELIVERY -->
          <div class="kanban-column kanban-col-out">
            <div class="kanban-col-header">
              <div class="kanban-col-title" style="color: #60A5FA;">
                <span><i class="fa-solid fa-motorcycle"></i></span>
                <span>3. Out for Delivery</span>
              </div>
              <span id="badge-out-count" class="kanban-badge-count" style="color: #3B82F6;"><%= outCount %></span>
            </div>
            <div id="col-out-orders" style="display: flex; flex-direction: column; gap: var(--space-4); min-height: 400px;">
              <%
                  if (outOrders != null && !outOrders.isEmpty()) {
                      for (Orders order : outOrders) {
                          String custName = (userMap != null && userMap.containsKey(order.getUserID())) ? userMap.get(order.getUserID()).getName() : "Customer #" + order.getUserID();
                          String restName = (restaurantMap != null && restaurantMap.containsKey(order.getRestaurantID())) ? restaurantMap.get(order.getRestaurantID()).getName() : "Outlet #" + order.getRestaurantID();
                          String payMethod = (order.getPaymentMethod() != null) ? order.getPaymentMethod().toUpperCase() : "COD";
                          String payBadgeClass = payMethod.contains("COD") ? "cod" : (payMethod.contains("CARD") ? "card" : "upi");
                          Driver assignedRider = (driverMap != null && order.getDriverID() != null) ? driverMap.get(order.getDriverID()) : null;
              %>
              <div class="kanban-card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                  <div>
                    <strong style="color: var(--color-text-primary);">#ORD-<%= order.getOrderID() %></strong>
                    <% if (assignedRider != null) { %>
                    <div style="font-size: 11px; color: #60A5FA; font-weight: 600;"><i class="fa-solid fa-motorcycle" style="margin-right: 4px;"></i><%= assignedRider.getName() %></div>
                    <% } else { %>
                    <div style="font-size: 11px; color: var(--color-text-muted);">Rider assigned</div>
                    <% } %>
                  </div>
                  <span class="kanban-payment-badge <%= payBadgeClass %>"><%= payMethod %></span>
                </div>
                <div style="font-weight: 700; font-size: 13px; margin-bottom: 4px;"><%= custName %></div>
                <div style="font-size: 12px; color: var(--color-text-secondary); margin-bottom: 8px;"><%= restName %></div>
                <div style="font-size: 12px; color: var(--color-text-primary); margin-bottom: 10px;">
                  <%
                      List<OrderItem> items = (orderItemsMap != null) ? orderItemsMap.get(order.getOrderID()) : null;
                      if (items != null && !items.isEmpty()) {
                          for (OrderItem item : items) {
                              String dName = (menuMap != null && menuMap.containsKey(item.getMenuID())) ? menuMap.get(item.getMenuID()).getItemName() : "Dish #" + item.getMenuID();
                  %>
                  • <%= item.getQuantity() %>× <%= dName %><br>
                  <%
                          }
                      } else {
                  %>
                  • 2× Smash Burgers & Fries
                  <%
                      }
                  %>
                </div>
                <% if (assignedRider != null) { %>
                <div style="margin: 6px 0; padding: 5px 8px; background: rgba(59, 130, 246, 0.08); border-radius: 6px; font-size: 11px; color: var(--color-text-secondary); display: flex; align-items: center; justify-content: space-between;">
                  <span><i class="fa-solid fa-motorcycle" style="margin-right: 4px;"></i><strong><%= assignedRider.getVehicleNumber() %></strong> (<%= assignedRider.getVehicleType() %>)</span>
                  <a href="tel:<%= assignedRider.getPhone() %>" style="color: var(--color-primary-light); text-decoration: none; font-weight: 700;" title="Call Rider"><i class="fa-solid fa-phone" style="margin-right: 3px;"></i><%= assignedRider.getPhone() %></a>
                </div>
                <% } %>
                <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--color-border-light); padding-top: 8px;">
                  <strong style="color: var(--color-primary-light);">₹<%= (int)order.getTotalAmount() %></strong>
                  <form action="<%= request.getContextPath() %>/admin/order/update-status" method="POST" style="margin: 0;">
                    <input type="hidden" name="orderID" value="<%= order.getOrderID() %>">
                    <input type="hidden" name="status" value="DELIVERED">
                    <button type="submit" class="btn btn-secondary btn-sm" style="padding: 4px 10px; font-size: 12px; color: var(--color-success); font-weight: 700; display: inline-flex; align-items: center; gap: 4px;">Mark Delivered <i class="fa-solid fa-check"></i></button>
                  </form>
                </div>
              </div>
              <%
                      }
                  } else {
              %>
              <div style="text-align: center; padding: 40px 10px; color: var(--color-text-muted); font-size: 12px;">
                No orders on route
              </div>
              <%
                  }
              %>
            </div>
          </div>

          <!-- STAGE 4: DELIVERED -->
          <div class="kanban-column kanban-col-delivered">
            <div class="kanban-col-header">
              <div class="kanban-col-title" style="color: var(--color-success);">
                <span><i class="fa-solid fa-circle-check"></i></span>
                <span>4. Delivered</span>
              </div>
              <span id="badge-delivered-count" class="kanban-badge-count" style="color: var(--color-success);"><%= deliveredCount %></span>
            </div>
            <div id="col-delivered-orders" style="display: flex; flex-direction: column; gap: var(--space-4); min-height: 400px;">
              <%
                  if (deliveredOrders != null && !deliveredOrders.isEmpty()) {
                      for (Orders order : deliveredOrders) {
                          String custName = (userMap != null && userMap.containsKey(order.getUserID())) ? userMap.get(order.getUserID()).getName() : "Customer #" + order.getUserID();
                          String restName = (restaurantMap != null && restaurantMap.containsKey(order.getRestaurantID())) ? restaurantMap.get(order.getRestaurantID()).getName() : "Outlet #" + order.getRestaurantID();
              %>
              <div class="kanban-card" style="opacity: 0.95;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                  <div>
                    <strong style="color: var(--color-text-primary);">#ORD-<%= order.getOrderID() %></strong>
                    <div style="font-size: 11px; color: var(--color-text-muted);">Completed</div>
                  </div>
                  <span class="status-pill delivered">Delivered</span>
                </div>
                <div style="font-weight: 700; font-size: 13px; margin-bottom: 4px;"><%= custName %></div>
                <div style="font-size: 12px; color: var(--color-text-secondary); margin-bottom: 8px;"><%= restName %></div>
                <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--color-border-light); padding-top: 8px;">
                  <strong style="color: var(--color-primary-light);">₹<%= (int)order.getTotalAmount() %></strong>
                  <span style="font-size: 11px; color: var(--color-success); font-weight: 700; display: inline-flex; align-items: center; gap: 4px;">Completed <i class="fa-solid fa-check"></i></span>
                </div>
              </div>
              <%
                      }
                  } else {
              %>
              <div style="text-align: center; padding: 40px 10px; color: var(--color-text-muted); font-size: 12px;">
                No delivered orders yet
              </div>
              <%
                  }
              %>
            </div>
          </div>

        </div>

      </main>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Vanilla JavaScript Handlers -->
  <script src="<%= request.getContextPath() %>/frontend/js/global.js"></script>
  <script src="<%= request.getContextPath() %>/frontend/js/admin.js"></script>
</body>
</html>
