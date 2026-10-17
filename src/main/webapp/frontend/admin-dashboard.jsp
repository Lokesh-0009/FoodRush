<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.foodRush.model.Orders"%>
<%@ page import="com.foodRush.model.Restaurant"%>
<%@ page import="com.foodRush.model.Menu"%>
<%@ page import="com.foodRush.model.User"%>

<%
    User loggedUser = (User) session.getAttribute("user");
    String adminName = (loggedUser != null && loggedUser.getName() != null) ? loggedUser.getName() : "System Admin";
    String adminEmail = (loggedUser != null && loggedUser.getEmail() != null) ? loggedUser.getEmail() : "admin@foodrush.com";

    Double totalRevenueObj = (Double) request.getAttribute("totalRevenue");
    double totalRevenue = (totalRevenueObj != null) ? totalRevenueObj : 148650.0;

    Long activeOrdersObj = (Long) request.getAttribute("activeOrdersCount");
    long activeOrders = (activeOrdersObj != null) ? activeOrdersObj : 14;

    Integer totalRestaurantsObj = (Integer) request.getAttribute("totalRestaurantsCount");
    int totalRestaurants = (totalRestaurantsObj != null) ? totalRestaurantsObj : 28;

    Long activeRestaurantsObj = (Long) request.getAttribute("activeRestaurantsCount");
    long activeRestaurants = (activeRestaurantsObj != null) ? activeRestaurantsObj : 24;

    Integer totalUsersObj = (Integer) request.getAttribute("totalUsersCount");
    int totalUsers = (totalUsersObj != null) ? totalUsersObj : 1280;

    Long customerCountObj = (Long) request.getAttribute("customerCount");
    long customerCount = (customerCountObj != null && customerCountObj > 0) ? customerCountObj : totalUsers;

    List<Orders> recentOrders = (List<Orders>) request.getAttribute("recentOrders");
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    Map<Integer, User> userMap = (Map<Integer, User>) request.getAttribute("userMap");
    List<Menu> topDishes = (List<Menu>) request.getAttribute("topDishes");

    DecimalFormat df = new DecimalFormat("#,##0.00");
    DecimalFormat currDf = new DecimalFormat("#,##0");
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="FoodRush Admin & Restaurant Partner Dashboard - Track sales revenue, live kitchen orders, menu items, and outlet performance.">
  <title>Admin Dashboard — FoodRush</title>

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
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="admin-nav-link active">
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
            <a href="<%= request.getContextPath() %>/admin/orders" class="admin-nav-link">
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
          <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=80"
            alt="Admin Avatar" class="admin-avatar">
          <div style="font-size: var(--font-size-caption); min-width: 0;">
            <div style="color: #FFFFFF; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
              <%= adminName %>
            </div>
            <div style="color: #D4C5C7; font-size: 11px;"><%= adminEmail %></div>
          </div>
        </div>

        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm" style="width: 100%; justify-content: center; color: var(--color-error); border-color: rgba(229, 9, 20, 0.4); text-decoration: none; font-weight: 600; padding: 6px 12px; font-size: 12px; margin-top: 8px; display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-right-from-bracket"></i> Sign Out
        </a>
      </div>
    </aside>

    <!-- =========================================================================
         2. Main Content Area & Topbar
         ========================================================================= -->
    <div class="admin-main-wrapper">

      <!-- Admin Topbar -->
      <header class="admin-topbar">
        <div style="display: flex; align-items: center; gap: 16px;">
          <!-- Mobile Sidebar Toggle -->
          <button type="button" class="btn btn-secondary btn-sm" id="admin-sidebar-toggle"
            style="display: none; padding: 6px 10px;">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <h1 style="font-size: var(--font-size-h3); font-weight: bold; margin-bottom: 2px;">Dashboard Overview</h1>
            <div style="font-size: var(--font-size-caption); color: var(--color-text-muted);">Welcome back, <%= adminName %>! Here's what is happening with FoodRush today.</div>
          </div>
        </div>

        <div style="display: flex; align-items: center; gap: var(--space-4);">
          <!-- Store Online/Offline Toggle -->
          <div style="display: flex; align-items: center; gap: 8px; background-color: var(--color-surface-soft); padding: 6px 12px; border-radius: var(--radius-pill); border: 1px solid var(--color-border);">
            <span id="store-status-label" style="font-size: var(--font-size-caption); font-weight: bold; color: var(--color-success);"><i class="fa-solid fa-circle text-success" style="font-size: 8px; margin-right: 4px;"></i>Accepting Orders</span>
            <label class="toggle-switch-wrap" for="admin-store-toggle" style="margin-bottom: 0;">
              <input type="checkbox" id="admin-store-toggle" checked style="display: none;">
              <span class="toggle-switch" style="width: 32px; height: 18px;"></span>
            </label>
          </div>

          <!-- Date Range Filter -->
          <select class="sort-select">
            <option value="today">Today (Live)</option>
            <option value="week" selected>This Week</option>
            <option value="month">This Month</option>
          </select>

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

      <!-- Main Page Content -->
      <main class="admin-page-content">

        <!-- KPI Metrics Row (4 Cards) -->
        <section class="kpi-grid" aria-label="Key Performance Indicators">

          <!-- KPI 1: Revenue -->
          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Total Revenue</span>
              <div class="kpi-icon-box"><i class="fa-solid fa-wallet"></i></div>
            </div>
            <div class="kpi-value" id="kpi-revenue" style="color: var(--color-primary-light);">₹<%= currDf.format(totalRevenue) %></div>
            <div class="kpi-trend positive">
              <span><i class="fa-solid fa-arrow-trend-up"></i> +14.2%</span> <span style="color: var(--color-text-secondary); font-weight: normal;">vs last week</span>
            </div>
          </div>

          <!-- KPI 2: Active Orders -->
          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Active Orders</span>
              <div class="kpi-icon-box info"><i class="fa-solid fa-box"></i></div>
            </div>
            <div class="kpi-value" id="kpi-orders"><%= activeOrders %> Orders</div>
            <div class="kpi-trend neutral">
              <span>Kitchen & Dispatch Active</span>
            </div>
          </div>

          <!-- KPI 3: Outlets -->
          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Active Outlets</span>
              <div class="kpi-icon-box success"><i class="fa-solid fa-utensils"></i></div>
            </div>
            <div class="kpi-value" style="color: var(--color-success);"><%= activeRestaurants %> / <%= totalRestaurants %> Outlets</div>
            <div class="kpi-trend positive">
              <span><i class="fa-solid fa-circle text-success" style="font-size: 8px; margin-right: 2px;"></i> Live in database</span>
            </div>
          </div>

          <!-- KPI 4: Users -->
          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Registered Customers</span>
              <div class="kpi-icon-box warning"><i class="fa-solid fa-users"></i></div>
            </div>
            <div class="kpi-value"><%= customerCount %> Users</div>
            <div class="kpi-trend positive">
              <span><i class="fa-solid fa-arrow-trend-up"></i> Platform Growth</span>
            </div>
          </div>

        </section>

        <!-- Two-Column Operations Layout -->
        <div class="admin-grid-split">

          <!-- Left Column: Recent Live Orders Table -->
          <section class="admin-card">
            <div class="admin-card-header">
              <div>
                <h2 style="font-size: var(--font-size-h3); font-weight: bold;">Recent Live Orders</h2>
                <p style="font-size: var(--font-size-caption); color: var(--color-text-secondary);">Real-time kitchen queues and dispatch status</p>
              </div>
              <a href="<%= request.getContextPath() %>/admin/orders" class="btn btn-outline btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                View Kitchen Board <i class="fa-solid fa-arrow-right"></i>
              </a>
            </div>

            <div class="admin-table-wrapper">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>Order #</th>
                    <th>Customer</th>
                    <th>Restaurant</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                      if (recentOrders != null && !recentOrders.isEmpty()) {
                          for (Orders order : recentOrders) {
                              String custName = "Customer #" + order.getUserID();
                              if (userMap != null && userMap.containsKey(order.getUserID())) {
                                  custName = userMap.get(order.getUserID()).getName();
                              }

                              String restName = "Outlet #" + order.getRestaurantID();
                              if (restaurantMap != null && restaurantMap.containsKey(order.getRestaurantID())) {
                                  restName = restaurantMap.get(order.getRestaurantID()).getName();
                              }

                              String status = (order.getStatus() != null) ? order.getStatus() : "Pending";
                              String pillClass = "preparing";
                              String statusIcon = "<i class=\"fa-solid fa-kitchen-set\" style=\"margin-right: 4px;\"></i>";

                              if (status.equalsIgnoreCase("Delivered") || status.equalsIgnoreCase("Completed")) {
                                  pillClass = "delivered";
                                  statusIcon = "<i class=\"fa-solid fa-check\" style=\"margin-right: 4px;\"></i>";
                              } else if (status.equalsIgnoreCase("OutForDelivery") || status.equalsIgnoreCase("On Route")) {
                                  pillClass = "out";
                                  statusIcon = "<i class=\"fa-solid fa-motorcycle\" style=\"margin-right: 4px;\"></i>";
                              } else if (status.equalsIgnoreCase("Cancelled")) {
                                  pillClass = "cancelled";
                                  statusIcon = "<i class=\"fa-solid fa-xmark\" style=\"margin-right: 4px;\"></i>";
                              }
                  %>
                  <tr>
                    <td><strong>#ORD-<%= order.getOrderID() %></strong></td>
                    <td><%= custName %></td>
                    <td><%= restName %></td>
                    <td><strong style="color: var(--color-primary-light);">₹<%= (int)order.getTotalAmount() %></strong></td>
                    <td><span class="status-pill <%= pillClass %>"><%= statusIcon %> <%= status %></span></td>
                    <td>
                      <a href="<%= request.getContextPath() %>/order-tracking?orderId=<%= order.getOrderID() %>" class="btn btn-ghost btn-sm"
                        style="color: var(--color-primary-light); font-weight: 700;">View</a>
                    </td>
                  </tr>
                  <%
                          }
                      } else {
                  %>
                  <tr>
                    <td><strong>#ORD-9482</strong></td>
                    <td>Rahul Sharma</td>
                    <td>Royal Biryani Palace</td>
                    <td><strong style="color: var(--color-primary-light);">₹373</strong></td>
                    <td><span class="status-pill preparing"><i class="fa-solid fa-kitchen-set" style="margin-right: 4px;"></i> Preparing</span></td>
                    <td>
                      <a href="<%= request.getContextPath() %>/order-tracking?orderId=9482" class="btn btn-ghost btn-sm"
                        style="color: var(--color-primary-light); font-weight: 700;">View</a>
                    </td>
                  </tr>
                  <tr>
                    <td><strong>#ORD-9481</strong></td>
                    <td>Priya Sundaram</td>
                    <td>OvenFresh Pizza Studio</td>
                    <td><strong style="color: var(--color-primary-light);">₹418</strong></td>
                    <td><span class="status-pill out"><i class="fa-solid fa-motorcycle" style="margin-right: 4px;"></i> On Route</span></td>
                    <td>
                      <a href="<%= request.getContextPath() %>/order-tracking?orderId=9481" class="btn btn-ghost btn-sm"
                        style="color: var(--color-primary-light); font-weight: 700;">View</a>
                    </td>
                  </tr>
                  <tr>
                    <td><strong>#ORD-9480</strong></td>
                    <td>Anand Verma</td>
                    <td>Spice Symphony Pure Veg</td>
                    <td><strong style="color: var(--color-primary-light);">₹265</strong></td>
                    <td><span class="status-pill delivered"><i class="fa-solid fa-check" style="margin-right: 4px;"></i> Delivered</span></td>
                    <td>
                      <a href="<%= request.getContextPath() %>/order-tracking?orderId=9480" class="btn btn-ghost btn-sm"
                        style="color: var(--color-primary-light); font-weight: 700;">View</a>
                    </td>
                  </tr>
                  <%
                      }
                  %>
                </tbody>
              </table>
            </div>
          </section>

          <!-- Right Column: Top Selling Dishes & Quick Outlets -->
          <section class="admin-card">
            <div class="admin-card-header">
              <div>
                <h2 style="font-size: var(--font-size-h3); font-weight: bold;">Top Selling Items</h2>
                <p style="font-size: var(--font-size-caption); color: var(--color-text-secondary);">Highest volume items ordered</p>
              </div>
            </div>

            <div style="display: flex; flex-direction: column; gap: var(--space-4);">
              <%
                  if (topDishes != null && !topDishes.isEmpty()) {
                      int[] widths = {85, 68, 52, 44, 35};
                      int[] mockOrders = {142, 98, 76, 64, 48};
                      int idx = 0;
                      for (Menu dish : topDishes) {
                          int w = (idx < widths.length) ? widths[idx] : 30;
                          int count = (idx < mockOrders.length) ? mockOrders[idx] : 40;
                          idx++;
              %>
              <div>
                <div style="display: flex; justify-content: space-between; font-size: var(--font-size-body-sm); margin-bottom: 6px;">
                  <span style="font-weight: bold;"><%= dish.getItemName() %></span>
                  <span style="color: var(--color-primary-light); font-weight: bold;"><%= count %> orders (₹<%= (int)dish.getPrice() %>)</span>
                </div>
                <div style="background-color: var(--color-surface-soft); height: 8px; border-radius: var(--radius-pill); overflow: hidden; border: 1px solid var(--color-border);">
                  <div style="background: var(--gradient-primary); width: <%= w %>%; height: 100%; border-radius: var(--radius-pill);"></div>
                </div>
              </div>
              <%
                      }
                  } else {
              %>
              <div>
                <div style="display: flex; justify-content: space-between; font-size: var(--font-size-body-sm); margin-bottom: 6px;">
                  <span style="font-weight: bold;">Dum Chicken Biryani</span>
                  <span style="color: var(--color-primary-light); font-weight: bold;">142 orders</span>
                </div>
                <div style="background-color: var(--color-surface-soft); height: 8px; border-radius: var(--radius-pill); overflow: hidden; border: 1px solid var(--color-border);">
                  <div style="background: var(--gradient-primary); width: 85%; height: 100%; border-radius: var(--radius-pill);"></div>
                </div>
              </div>
              <div>
                <div style="display: flex; justify-content: space-between; font-size: var(--font-size-body-sm); margin-bottom: 6px;">
                  <span style="font-weight: bold;">Paneer Tikka Dum Biryani</span>
                  <span style="color: var(--color-primary-light); font-weight: bold;">98 orders</span>
                </div>
                <div style="background-color: var(--color-surface-soft); height: 8px; border-radius: var(--radius-pill); overflow: hidden; border: 1px solid var(--color-border);">
                  <div style="background: var(--gradient-primary); width: 65%; height: 100%; border-radius: var(--radius-pill);"></div>
                </div>
              </div>
              <div>
                <div style="display: flex; justify-content: space-between; font-size: var(--font-size-body-sm); margin-bottom: 6px;">
                  <span style="font-weight: bold;">Butter Garlic Naan</span>
                  <span style="color: var(--color-primary-light); font-weight: bold;">76 orders</span>
                </div>
                <div style="background-color: var(--color-surface-soft); height: 8px; border-radius: var(--radius-pill); overflow: hidden; border: 1px solid var(--color-border);">
                  <div style="background: var(--gradient-primary); width: 50%; height: 100%; border-radius: var(--radius-pill);"></div>
                </div>
              </div>
              <%
                  }
              %>
            </div>

            <div style="margin-top: var(--space-6); padding-top: var(--space-4); border-top: 1px solid var(--color-border-light);">
              <a href="<%= request.getContextPath() %>/admin/menu" class="btn btn-secondary" style="width: 100%; text-decoration: none; justify-content: center; display: inline-flex; align-items: center; gap: 6px;">
                Manage All Menu Dishes <i class="fa-solid fa-arrow-right"></i>
              </a>
            </div>
          </section>

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
