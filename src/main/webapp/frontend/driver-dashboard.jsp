<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.foodRush.model.Driver"%>
<%@ page import="com.foodRush.model.Orders"%>
<%@ page import="com.foodRush.model.Restaurant"%>
<%@ page import="com.foodRush.model.Menu"%>
<%@ page import="com.foodRush.model.OrderItem"%>
<%@ page import="com.foodRush.model.User"%>

<%
    User loggedUser = (User) session.getAttribute("user");
    Driver driver = (Driver) request.getAttribute("driver");
    String driverName = (loggedUser != null && loggedUser.getName() != null) ? loggedUser.getName() : "Delivery Partner";
    String driverPhone = (loggedUser != null && loggedUser.getPhone() != null) ? loggedUser.getPhone() : "9876500000";
    String vehicleNumber = (driver != null && driver.getVehicleNumber() != null) ? driver.getVehicleNumber() : "KA-01-DR-1000";
    String vehicleType = (driver != null && driver.getVehicleType() != null) ? driver.getVehicleType() : "Bike";
    String driverStatus = (driver != null && driver.getStatus() != null) ? driver.getStatus().toUpperCase() : "AVAILABLE";
    double rating = (driver != null && driver.getRating() > 0) ? driver.getRating() : 4.9;

    List<Orders> activeDeliveries = (List<Orders>) request.getAttribute("activeDeliveries");
    List<Orders> completedDeliveries = (List<Orders>) request.getAttribute("completedDeliveries");
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    Map<Integer, User> customerMap = (Map<Integer, User>) request.getAttribute("customerMap");
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");
    Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");

    Double totalEarningsObj = (Double) request.getAttribute("totalEarnings");
    double totalEarnings = (totalEarningsObj != null) ? totalEarningsObj : 0.0;

    int activeCount = (activeDeliveries != null) ? activeDeliveries.size() : 0;
    int completedCount = (completedDeliveries != null) ? completedDeliveries.size() : 0;

    DecimalFormat df = new DecimalFormat("#,##0.00");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, hh:mm a");

    String statusUpdatedParam = request.getParameter("statusUpdated");
    String orderUpdatedParam = request.getParameter("orderUpdated");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="FoodRush Delivery Partner Portal - Real-time order dispatch, navigation, and delivery management.">
  <title>Rider Portal — FoodRush</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Core CSS Design System -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css?v=2.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css?v=2.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css?v=2.0">

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

  <style>
    .driver-layout {
      min-height: 100vh;
      background: var(--color-bg-base);
      display: flex;
      flex-direction: column;
    }

    /* Driver Header HUD */
    .driver-navbar {
      background: var(--color-surface);
      border-bottom: 1px solid var(--color-border-subtle);
      padding: 16px 24px;
      position: sticky;
      top: 0;
      z-index: 100;
      backdrop-filter: blur(12px);
    }
    .driver-nav-inner {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 16px;
      flex-wrap: wrap;
    }
    .driver-brand-wrap {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .driver-brand-logo {
      font-size: 20px;
      font-weight: 800;
      color: var(--color-text-primary);
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .driver-badge-pill {
      background: rgba(245, 158, 11, 0.15);
      color: #F59E0B;
      border: 1px solid rgba(245, 158, 11, 0.3);
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 700;
      letter-spacing: 0.5px;
      display: flex;
      align-items: center;
      gap: 4px;
    }

    .driver-header-actions {
      display: flex;
      align-items: center;
      gap: 14px;
    }

    /* Duty Status Switch Form */
    .duty-selector-form {
      display: flex;
      align-items: center;
      gap: 8px;
      background: var(--color-bg-base);
      padding: 4px 10px;
      border-radius: var(--radius-full);
      border: 1px solid var(--color-border-subtle);
    }
    .duty-selector-select {
      background: transparent;
      border: none;
      font-size: 13px;
      font-weight: 600;
      color: var(--color-text-primary);
      cursor: pointer;
      outline: none;
    }

    /* Status dot indicators */
    .status-dot {
      width: 10px;
      height: 10px;
      border-radius: 50%;
      display: inline-block;
    }
    .dot-available { background-color: #10B981; box-shadow: 0 0 8px #10B981; }
    .dot-busy { background-color: #F59E0B; box-shadow: 0 0 8px #F59E0B; }
    .dot-offline { background-color: #6B7280; }

    /* Content Area */
    .driver-main {
      max-width: 1200px;
      margin: 0 auto;
      padding: 24px;
      width: 100%;
      flex: 1;
    }

    /* Top Stats Bar */
    .driver-kpi-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 16px;
      margin-bottom: 28px;
    }
    .driver-kpi-card {
      background: var(--color-surface);
      border: 1px solid var(--color-border-subtle);
      border-radius: var(--radius-lg);
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 16px;
      box-shadow: var(--shadow-sm);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .driver-kpi-card:hover {
      transform: translateY(-2px);
      box-shadow: var(--shadow-md);
    }
    .kpi-icon-wrap {
      width: 48px;
      height: 48px;
      border-radius: var(--radius-md);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
    }
    .kpi-title {
      font-size: 13px;
      font-weight: 500;
      color: var(--color-text-secondary);
      margin-bottom: 4px;
    }
    .kpi-val {
      font-size: 22px;
      font-weight: 800;
      color: var(--color-text-primary);
    }

    /* Tabs Bar */
    .driver-tabs {
      display: flex;
      gap: 12px;
      border-bottom: 1px solid var(--color-border-subtle);
      margin-bottom: 24px;
    }
    .driver-tab-btn {
      padding: 12px 20px;
      font-size: 15px;
      font-weight: 700;
      color: var(--color-text-secondary);
      background: transparent;
      border: none;
      border-bottom: 3px solid transparent;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 8px;
      transition: all 0.2s ease;
    }
    .driver-tab-btn.active {
      color: var(--color-primary);
      border-bottom-color: var(--color-primary);
    }
    .tab-counter {
      background: rgba(239, 68, 68, 0.15);
      color: var(--color-primary);
      font-size: 12px;
      padding: 2px 8px;
      border-radius: 999px;
    }

    /* Delivery Card Design */
    .delivery-cards-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
      gap: 20px;
    }
    .delivery-card {
      background: var(--color-surface);
      border: 1px solid var(--color-border-subtle);
      border-radius: var(--radius-xl);
      padding: 22px;
      box-shadow: var(--shadow-md);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      position: relative;
      overflow: hidden;
      transition: transform 0.2s ease;
    }
    .delivery-card:hover {
      transform: translateY(-2px);
    }
    .delivery-card.active-order {
      border-left: 5px solid #F59E0B;
    }
    .delivery-card.delivered-order {
      border-left: 5px solid #10B981;
      opacity: 0.9;
    }

    .delivery-card-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 16px;
      padding-bottom: 12px;
      border-bottom: 1px dashed var(--color-border-subtle);
    }
    .delivery-order-id {
      font-size: 16px;
      font-weight: 800;
      color: var(--color-text-primary);
    }
    .delivery-order-time {
      font-size: 12px;
      color: var(--color-text-secondary);
      margin-top: 2px;
    }

    .order-status-badge {
      font-size: 11px;
      font-weight: 700;
      padding: 4px 10px;
      border-radius: 999px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .status-out {
      background: rgba(245, 158, 11, 0.15);
      color: #F59E0B;
      border: 1px solid rgba(245, 158, 11, 0.3);
    }
    .status-delivered {
      background: rgba(16, 185, 129, 0.15);
      color: #10B981;
      border: 1px solid rgba(16, 185, 129, 0.3);
    }
    .status-prep {
      background: rgba(59, 130, 246, 0.15);
      color: #3B82F6;
      border: 1px solid rgba(59, 130, 246, 0.3);
    }

    /* Route Steps (Pickup & Dropoff) */
    .route-timeline {
      display: flex;
      flex-direction: column;
      gap: 14px;
      margin-bottom: 18px;
    }
    .route-node {
      display: flex;
      gap: 12px;
      align-items: flex-start;
    }
    .node-icon {
      font-size: 18px;
      background: var(--color-bg-base);
      width: 34px;
      height: 34px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      border: 1px solid var(--color-border-subtle);
    }
    .node-details {
      flex: 1;
    }
    .node-type {
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: var(--color-text-secondary);
    }
    .node-name {
      font-size: 14px;
      font-weight: 700;
      color: var(--color-text-primary);
      margin-top: 1px;
    }
    .node-address {
      font-size: 12px;
      color: var(--color-text-secondary);
      line-height: 1.4;
      margin-top: 2px;
    }

    /* Items Accordion & Bill */
    .delivery-items-summary {
      background: var(--color-bg-base);
      border-radius: var(--radius-md);
      padding: 10px 14px;
      margin-bottom: 18px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 13px;
    }
    .payment-tag {
      font-size: 11px;
      font-weight: 700;
      padding: 3px 8px;
      border-radius: var(--radius-sm);
    }
    .tag-cod {
      background: #FEF3C7;
      color: #92400E;
    }
    .tag-paid {
      background: #D1FAE5;
      color: #065F46;
    }

    /* Action Buttons */
    .delivery-actions-bar {
      display: flex;
      gap: 10px;
    }
    .btn-action {
      flex: 1;
      padding: 12px 16px;
      border-radius: var(--radius-md);
      font-size: 14px;
      font-weight: 700;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      border: none;
      transition: all 0.2s ease;
    }
    .btn-pickup {
      background: #3B82F6;
      color: #FFFFFF;
    }
    .btn-pickup:hover {
      background: #2563EB;
    }
    .btn-deliver {
      background: #10B981;
      color: #FFFFFF;
    }
    .btn-deliver:hover {
      background: #059669;
    }
    .btn-call {
      padding: 12px 16px;
      background: var(--color-bg-base);
      border: 1px solid var(--color-border-subtle);
      color: var(--color-text-primary);
      text-decoration: none;
      border-radius: var(--radius-md);
      font-size: 13px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    /* Empty state */
    .empty-deliveries-card {
      background: var(--color-surface);
      border: 1px dashed var(--color-border-subtle);
      border-radius: var(--radius-xl);
      padding: 48px 24px;
      text-align: center;
      color: var(--color-text-secondary);
      grid-column: 1 / -1;
    }
  </style>
</head>

<body>
  <div class="driver-layout">

    <!-- Top Navigation HUD -->
    <header class="driver-navbar" id="driver-navbar">
      <div class="driver-nav-inner">
        <div class="driver-brand-wrap">
          <a href="<%= request.getContextPath() %>/driver/dashboard" class="driver-brand-logo">
            <i class="fa-solid fa-bolt-lightning text-primary"></i>
            <span>FoodRush</span>
          </a>
          <span class="driver-badge-pill"><i class="fa-solid fa-motorcycle"></i> Delivery Partner</span>
        </div>

        <div class="driver-header-actions">
          <!-- Duty Status Switcher Form -->
          <form class="duty-selector-form" action="<%= request.getContextPath() %>/driver" method="POST" id="status-toggle-form">
            <input type="hidden" name="action" value="updateStatus">
            <span class="status-dot <%= "AVAILABLE".equals(driverStatus) ? "dot-available" : ("BUSY".equals(driverStatus) ? "dot-busy" : "dot-offline") %>"></span>
            <select name="status" class="duty-selector-select" onchange="document.getElementById('status-toggle-form').submit();" title="Change Duty Status">
              <option value="AVAILABLE" <%= "AVAILABLE".equals(driverStatus) ? "selected" : "" %>>Available (On Duty)</option>
              <option value="BUSY" <%= "BUSY".equals(driverStatus) ? "selected" : "" %>>Busy (On Delivery)</option>
              <option value="OFFLINE" <%= "OFFLINE".equals(driverStatus) ? "selected" : "" %>>Offline (Off Duty)</option>
            </select>
          </form>

          <!-- Theme Toggle -->
          <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme" style="background: var(--color-bg-base); border: 1px solid var(--color-border-subtle); border-radius: var(--radius-md); padding: 6px 10px; cursor: pointer; color: var(--color-text-secondary);">
            <i class="fa-solid fa-sun sun-icon"></i>
            <i class="fa-solid fa-moon moon-icon"></i>
          </button>

          <!-- Rider Name & Vehicle Pill -->
          <div style="display: flex; align-items: center; gap: 8px; background: var(--color-bg-base); border: 1px solid var(--color-border-subtle); padding: 6px 12px; border-radius: var(--radius-full);">
            <span style="font-size: 13px; font-weight: 700; color: var(--color-text-primary);"><%= driverName %></span>
            <span style="font-size: 11px; color: var(--color-text-secondary); border-left: 1px solid var(--color-border-subtle); padding-left: 8px; display: inline-flex; align-items: center; gap: 4px;"><i class="fa-solid fa-motorcycle"></i> <%= vehicleNumber %></span>
          </div>

          <!-- Customer View Link -->
          <a href="<%= request.getContextPath() %>/home" class="btn btn-sm btn-outline" style="border-radius: var(--radius-full); font-size: 12px;" title="Browse Customer App">
            Customer View
          </a>

          <!-- Logout -->
          <a href="<%= request.getContextPath() %>/logout" class="btn btn-sm" style="background: rgba(239, 68, 68, 0.15); color: #EF4444; border: 1px solid rgba(239, 68, 68, 0.3); border-radius: var(--radius-full); font-size: 12px; display: inline-flex; align-items: center; gap: 6px;">
            <i class="fa-solid fa-right-from-bracket"></i> Sign Out
          </a>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="driver-main" id="driver-main">

      <!-- Alerts / Notifications -->
      <% if ("1".equals(statusUpdatedParam)) { %>
        <div style="background: rgba(16, 185, 129, 0.15); border: 1px solid #10B981; color: #10B981; padding: 12px 18px; border-radius: var(--radius-md); margin-bottom: 20px; font-weight: 600; display: flex; align-items: center; gap: 8px;">
          <span><i class="fa-solid fa-circle-check"></i></span> Your duty status has been updated to <strong><%= driverStatus %></strong>.
        </div>
      <% } %>
      <% if ("1".equals(orderUpdatedParam)) { %>
        <div style="background: rgba(59, 130, 246, 0.15); border: 1px solid #3B82F6; color: #3B82F6; padding: 12px 18px; border-radius: var(--radius-md); margin-bottom: 20px; font-weight: 600; display: flex; align-items: center; gap: 8px;">
          <span><i class="fa-solid fa-bolt-lightning"></i></span> Delivery status updated successfully!
        </div>
      <% } %>

      <!-- Top Rider Metrics -->
      <section class="driver-kpi-grid">
        <div class="driver-kpi-card">
          <div class="kpi-icon-wrap" style="background: rgba(245, 158, 11, 0.15); color: #F59E0B;">
            <i class="fa-solid fa-motorcycle"></i>
          </div>
          <div>
            <div class="kpi-title">Active Orders</div>
            <div class="kpi-val" id="kpi-active-count"><%= activeCount %></div>
          </div>
        </div>

        <div class="driver-kpi-card">
          <div class="kpi-icon-wrap" style="background: rgba(16, 185, 129, 0.15); color: #10B981;">
            <i class="fa-solid fa-circle-check"></i>
          </div>
          <div>
            <div class="kpi-title">Completed Today</div>
            <div class="kpi-val"><%= completedCount %></div>
          </div>
        </div>

        <div class="driver-kpi-card">
          <div class="kpi-icon-wrap" style="background: rgba(59, 130, 246, 0.15); color: #3B82F6;">
            <i class="fa-solid fa-wallet"></i>
          </div>
          <div>
            <div class="kpi-title">Est. Earnings</div>
            <div class="kpi-val">₹<%= df.format(totalEarnings) %></div>
          </div>
        </div>

        <div class="driver-kpi-card">
          <div class="kpi-icon-wrap" style="background: rgba(168, 85, 247, 0.15); color: #A855F7;">
            <i class="fa-solid fa-star"></i>
          </div>
          <div>
            <div class="kpi-title">Rider Rating</div>
            <div class="kpi-val"><%= rating %> <span style="font-size: 14px; font-weight: 500; color: var(--color-text-secondary);">/ 5.0</span></div>
          </div>
        </div>
      </section>

      <!-- Tabs Navigation -->
      <div class="driver-tabs" role="tablist">
        <button class="driver-tab-btn active" id="tab-active-btn" onclick="switchTab('active')">
          <i class="fa-solid fa-motorcycle"></i> Active Deliveries <span class="tab-counter"><%= activeCount %></span>
        </button>
        <button class="driver-tab-btn" id="tab-history-btn" onclick="switchTab('history')">
          <i class="fa-solid fa-box-archive"></i> Delivery History (<%= completedCount %>)
        </button>
      </div>

      <!-- Section 1: Active Deliveries -->
      <section id="section-active-deliveries" class="delivery-cards-grid">
        <% if (activeDeliveries == null || activeDeliveries.isEmpty()) { %>
          <div class="empty-deliveries-card">
            <div style="font-size: 40px; margin-bottom: 12px; color: var(--color-primary);"><i class="fa-solid fa-champagne-glasses"></i></div>
            <h3 style="font-size: 18px; font-weight: 700; color: var(--color-text-primary); margin-bottom: 6px;">No Active Deliveries Right Now</h3>
            <p style="font-size: 14px; margin-bottom: 16px;">Keep your status set to <strong>Available</strong>. New restaurant assignments will appear here automatically.</p>
            <button type="button" class="btn btn-primary btn-sm" onclick="location.reload();"><i class="fa-solid fa-arrows-rotate" style="margin-right: 6px;"></i>Refresh Feed</button>
          </div>
        <% } else { %>
          <% for (Orders order : activeDeliveries) { 
               Restaurant rest = (restaurantMap != null) ? restaurantMap.get(order.getRestaurantID()) : null;
               User cust = (customerMap != null) ? customerMap.get(order.getUserID()) : null;
               List<OrderItem> items = (orderItemsMap != null) ? orderItemsMap.get(order.getOrderID()) : null;
               String oStatus = (order.getStatus() != null) ? order.getStatus().trim().toUpperCase() : "PENDING";
               boolean isOutForDelivery = "OUT_FOR_DELIVERY".equalsIgnoreCase(oStatus) || "OUTFORDELIVERY".equalsIgnoreCase(oStatus);
          %>
            <article class="delivery-card active-order">
              <div>
                <div class="delivery-card-header">
                  <div>
                    <div class="delivery-order-id">Order #<%= order.getOrderID() %></div>
                    <div class="delivery-order-time"><%= (order.getOrderDate() != null) ? sdf.format(order.getOrderDate()) : "Just now" %></div>
                  </div>
                  <span class="order-status-badge <%= isOutForDelivery ? "status-out" : "status-prep" %>">
                    <%= isOutForDelivery ? "<i class=\"fa-solid fa-motorcycle\" style=\"margin-right: 4px;\"></i> Out For Delivery" : "<i class=\"fa-solid fa-kitchen-set\" style=\"margin-right: 4px;\"></i> " + oStatus %>
                  </span>
                </div>

                <!-- Timeline: Pickup & Dropoff -->
                <div class="route-timeline">
                  <!-- Pickup Restaurant -->
                  <div class="route-node">
                    <div class="node-icon" style="color: #EF4444;"><i class="fa-solid fa-utensils"></i></div>
                    <div class="node-details">
                      <div class="node-type">Pick Up From</div>
                      <div class="node-name"><%= (rest != null) ? rest.getName() : "Restaurant #" + order.getRestaurantID() %></div>
                      <div class="node-address"><i class="fa-solid fa-location-dot" style="margin-right: 4px; color: var(--color-text-secondary);"></i><%= (rest != null && rest.getAddress() != null) ? rest.getAddress() : "Koramangala, Bengaluru" %></div>
                    </div>
                  </div>

                  <!-- Drop-off Customer -->
                  <div class="route-node">
                    <div class="node-icon" style="color: #10B981;"><i class="fa-solid fa-location-dot"></i></div>
                    <div class="node-details">
                      <div class="node-type">Drop Off To</div>
                      <div class="node-name"><%= (cust != null) ? cust.getName() : "Customer #" + order.getUserID() %></div>
                      <div class="node-address"><i class="fa-solid fa-house" style="margin-right: 4px; color: var(--color-text-secondary);"></i><%= (cust != null && cust.getAddress() != null) ? cust.getAddress() : "Bengaluru" %></div>
                    </div>
                  </div>
                </div>

                <!-- Order summary -->
                <div class="delivery-items-summary">
                  <div>
                    <span style="font-weight: 700; color: var(--color-text-primary);">₹<%= df.format(order.getTotalAmount()) %></span>
                    <span style="color: var(--color-text-secondary); font-size: 12px; margin-left: 6px;">
                      (<%= (items != null) ? items.size() : 0 %> items)
                    </span>
                  </div>
                  <span class="payment-tag <%= "COD".equalsIgnoreCase(order.getPaymentMethod()) ? "tag-cod" : "tag-paid" %>">
                    <%= "COD".equalsIgnoreCase(order.getPaymentMethod()) ? "<i class=\"fa-solid fa-money-bill-wave\" style=\"margin-right: 4px;\"></i>Cash On Delivery" : "<i class=\"fa-solid fa-credit-card\" style=\"margin-right: 4px;\"></i>Prepaid (" + order.getPaymentStatus() + ")" %>
                  </span>
                </div>
              </div>

              <!-- Action Buttons -->
              <div class="delivery-actions-bar">
                <% if (cust != null && cust.getPhone() != null && !cust.getPhone().isEmpty()) { %>
                  <a href="tel:<%= cust.getPhone() %>" class="btn-call" title="Call Customer">
                    <i class="fa-solid fa-phone"></i> Call
                  </a>
                <% } %>

                <form action="<%= request.getContextPath() %>/driver" method="POST" style="flex: 1; display: flex;">
                  <input type="hidden" name="action" value="updateOrderStatus">
                  <input type="hidden" name="orderID" value="<%= order.getOrderID() %>">

                  <% if (!isOutForDelivery) { %>
                    <button type="submit" name="newStatus" value="OUT_FOR_DELIVERY" class="btn-action btn-pickup">
                      <i class="fa-solid fa-motorcycle"></i> Pick Up & Start Delivery
                    </button>
                  <% } else { %>
                    <button type="submit" name="newStatus" value="DELIVERED" class="btn-action btn-deliver">
                      <i class="fa-solid fa-circle-check"></i> Mark as Delivered
                    </button>
                  <% } %>
                </form>
              </div>
            </article>
          <% } %>
        <% } %>
      </section>

      <!-- Section 2: Delivery History (Hidden by default) -->
      <section id="section-history-deliveries" class="delivery-cards-grid" style="display: none;">
        <% if (completedDeliveries == null || completedDeliveries.isEmpty()) { %>
          <div class="empty-deliveries-card">
            <div style="font-size: 40px; margin-bottom: 12px; color: var(--color-text-secondary);"><i class="fa-solid fa-box-open"></i></div>
            <h3 style="font-size: 18px; font-weight: 700; color: var(--color-text-primary); margin-bottom: 6px;">No Delivered Orders Yet</h3>
            <p style="font-size: 14px;">Orders you complete will be archived here along with your earnings summary.</p>
          </div>
        <% } else { %>
          <% for (Orders order : completedDeliveries) { 
               Restaurant rest = (restaurantMap != null) ? restaurantMap.get(order.getRestaurantID()) : null;
               User cust = (customerMap != null) ? customerMap.get(order.getUserID()) : null;
          %>
            <article class="delivery-card delivered-order">
              <div>
                <div class="delivery-card-header">
                  <div>
                    <div class="delivery-order-id">Order #<%= order.getOrderID() %></div>
                    <div class="delivery-order-time"><%= (order.getOrderDate() != null) ? sdf.format(order.getOrderDate()) : "" %></div>
                  </div>
                  <span class="order-status-badge status-delivered">
                    <i class="fa-solid fa-circle-check" style="margin-right: 4px;"></i>Delivered
                  </span>
                </div>

                <div class="route-timeline">
                  <div class="route-node">
                    <div class="node-icon" style="color: #EF4444;"><i class="fa-solid fa-utensils"></i></div>
                    <div class="node-details">
                      <div class="node-name"><%= (rest != null) ? rest.getName() : "Restaurant #" + order.getRestaurantID() %></div>
                      <div class="node-address"><i class="fa-solid fa-location-dot" style="margin-right: 4px;"></i><%= (rest != null) ? rest.getAddress() : "" %></div>
                    </div>
                  </div>
                  <div class="route-node">
                    <div class="node-icon" style="color: #10B981;"><i class="fa-solid fa-location-dot"></i></div>
                    <div class="node-details">
                      <div class="node-name"><%= (cust != null) ? cust.getName() : "Customer #" + order.getUserID() %></div>
                      <div class="node-address"><i class="fa-solid fa-house" style="margin-right: 4px;"></i><%= (cust != null) ? cust.getAddress() : "" %></div>
                    </div>
                  </div>
                </div>

                <div class="delivery-items-summary">
                  <div>
                    <span style="font-weight: 700; color: var(--color-text-primary);">₹<%= df.format(order.getTotalAmount()) %></span>
                    <span style="color: #10B981; font-weight: 700; font-size: 12px; margin-left: 8px;">+₹55.00 Earned</span>
                  </div>
                  <span class="payment-tag tag-paid">
                    <%= order.getPaymentStatus() %>
                  </span>
                </div>
              </div>
            </article>
          <% } %>
        <% } %>
      </section>

    </main>
  </div>

  <script>
    // Tab Switching
    function switchTab(tab) {
      const activeSec = document.getElementById('section-active-deliveries');
      const histSec = document.getElementById('section-history-deliveries');
      const activeBtn = document.getElementById('tab-active-btn');
      const histBtn = document.getElementById('tab-history-btn');

      if (tab === 'active') {
        activeSec.style.display = 'grid';
        histSec.style.display = 'none';
        activeBtn.classList.add('active');
        histBtn.classList.remove('active');
      } else {
        activeSec.style.display = 'none';
        histSec.style.display = 'grid';
        activeBtn.classList.remove('active');
        histBtn.classList.add('active');
      }
    }

    // Theme Toggle Handler
    const themeBtn = document.getElementById('theme-toggle-btn');
    if (themeBtn) {
      themeBtn.addEventListener('click', function () {
        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        if (isDark) {
          document.documentElement.removeAttribute('data-theme');
          localStorage.setItem('foodrush_theme', 'light');
        } else {
          document.documentElement.setAttribute('data-theme', 'dark');
          localStorage.setItem('foodrush_theme', 'dark');
        }
      });
    }
  </script>
</body>
</html>
