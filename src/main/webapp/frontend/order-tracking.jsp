<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.text.SimpleDateFormat, com.foodRush.model.Orders, com.foodRush.model.OrderItem, com.foodRush.model.Restaurant, com.foodRush.model.Menu, com.foodRush.model.User, com.foodRush.model.Driver, com.foodRush.model.Cart"%>
<%
    Orders order = (Orders) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }

    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");
    Driver assignedDriver = (Driver) request.getAttribute("assignedDriver");

    String resName = (restaurant != null && restaurant.getName() != null) ? restaurant.getName() : "Selected Restaurant";
    String resAddress = (restaurant != null && restaurant.getAddress() != null) ? restaurant.getAddress() : "Bangalore";

    User orderCustomer = (User) request.getAttribute("orderCustomer");
    String deliveryAddress = (String) session.getAttribute("lastDeliveryAddress");
    if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
        if (orderCustomer != null && orderCustomer.getAddress() != null && !orderCustomer.getAddress().trim().isEmpty()) {
            deliveryAddress = orderCustomer.getAddress();
        } else {
            User user = (User) session.getAttribute("user");
            deliveryAddress = (user != null && user.getAddress() != null && !user.getAddress().trim().isEmpty())
                              ? user.getAddress()
                              : "Delivery Address on File";
        }
    }

    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String orderTimeStr = (order.getOrderDate() != null) ? timeFormat.format(order.getOrderDate()) : "Just now";
    String orderDateStr = (order.getOrderDate() != null) ? dateFormat.format(order.getOrderDate()) : "Today";

    Cart sessionCart = (Cart) session.getAttribute("cart");
    int sessionCartCount = (sessionCart != null) ? sessionCart.getTotalCount() : 0;

    double grandTotal = order.getTotalAmount();
    double itemTotal = 0.0;
    if (orderItems != null) {
        for (OrderItem oi : orderItems) {
            itemTotal += oi.getItemTotal();
        }
    }
    double deliveryFee = (itemTotal >= 400 || itemTotal == 0) ? 0.0 : 40.0;
    double platformFee = 5.0;
    double gstTax = Math.round(itemTotal * 0.05);
    
    Integer lastTip = (Integer) session.getAttribute("lastTipAmount");
    int tipAmount = (lastTip != null) ? lastTip : 0;

    String rawStatus = (order.getStatus() != null) ? order.getStatus().toUpperCase().replace(" ", "_").replace("-", "_") : "PLACED";
    boolean isPlaced = rawStatus.equals("PLACED") || rawStatus.equals("CONFIRMED") || rawStatus.equals("PENDING");
    boolean isPreparing = rawStatus.equals("PREPARING") || rawStatus.equals("COOKING") || rawStatus.equals("ACCEPTED");
    boolean isOutForDelivery = rawStatus.equals("OUT_FOR_DELIVERY") || rawStatus.equals("OUTFORDELIVERY") || rawStatus.equals("ON_ROUTE") || rawStatus.equals("DISPATCHED");
    boolean isDelivered = rawStatus.equals("DELIVERED") || rawStatus.equals("COMPLETED");

    String paymentMethod = (order.getPaymentMethod() != null) ? order.getPaymentMethod().toUpperCase() : "COD";
    String paymentStatus = (order.getPaymentStatus() != null) ? order.getPaymentStatus().toUpperCase() : "PENDING";

    long elapsedSeconds = 999;
    if (order.getOrderDate() != null) {
        elapsedSeconds = (System.currentTimeMillis() - order.getOrderDate().getTime()) / 1000;
    }
    long remainingGraceSeconds = 60 - elapsedSeconds;
    if (remainingGraceSeconds < 0) remainingGraceSeconds = 0;
    boolean canCancel = isPlaced && !rawStatus.equals("CANCELLED") && remainingGraceSeconds > 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Track your FoodRush live order status, delivery partner progress, and receipt details.">
  <title>Order #ORD-<%= order.getOrderID() %> Tracking — FoodRush</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Core CSS Design System & Font Awesome 6 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css?v=2">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css?v=2">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css?v=2">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/order-tracking.css?v=<%= System.currentTimeMillis() %>">

  <!-- Leaflet Map CSS for Live GPS Delivery Navigation -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.min.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">

  <style>
    .cancel-grace-wrapper {
      margin-top: 4px;
    }
    .grace-timer-badge {
      display: flex;
      align-items: center;
      gap: 8px;
      background: rgba(245, 158, 11, 0.12);
      color: #D97706;
      border: 1px solid rgba(245, 158, 11, 0.3);
      padding: 8px 12px;
      border-radius: var(--radius-md);
      font-size: 12px;
      font-weight: 600;
      margin-bottom: 6px;
    }
    .grace-pulse-indicator {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: #F59E0B;
      box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.7);
      animation: gracePulse 1.5s infinite;
      flex-shrink: 0;
    }
    @keyframes gracePulse {
      0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.7); }
      70% { transform: scale(1); box-shadow: 0 0 0 6px rgba(245, 158, 11, 0); }
      100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0); }
    }
    .cancellation-locked-pill {
      display: flex;
      align-items: center;
      gap: 8px;
      background: var(--color-surface-soft);
      color: var(--color-text-secondary);
      border: 1px solid var(--color-border-subtle);
      padding: 10px 12px;
      border-radius: var(--radius-md);
      font-size: 12px;
      font-weight: 500;
      line-height: 1.4;
      margin-top: 4px;
    }
  </style>

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

  <!-- =========================================================================
       1. Global Header / Navbar
       ========================================================================= -->
  <header class="navbar" id="main-navbar">
    <div class="container nav-container">

      <!-- Left: Brand Logo -->
      <div class="nav-left">
        <a href="<%= request.getContextPath() %>/home" class="brand-logo" title="FoodRush Home">
          <div class="brand-icon"><i class="fa-solid fa-bolt-lightning text-primary"></i></div>
          <span>Food<span class="brand-name-highlight">Rush</span></span>
        </a>
      </div>

      <!-- Right: Links & Profile -->
      <div class="nav-right">
        <nav aria-label="Main Navigation">
          <ul class="nav-menu-links">
            <li><a href="<%= request.getContextPath() %>/home" class="nav-link-item">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/restaurants" class="nav-link-item">Restaurants</a></li>
            <li><a href="<%= request.getContextPath() %>/orders" class="nav-link-item active">Orders</a></li>
          </ul>
        </nav>

        <!-- Theme Toggle Button (Light / Dark Mode) -->
        <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
          <span class="theme-icon sun-icon"><i class="fa-solid fa-sun"></i></span>
          <span class="theme-icon moon-icon"><i class="fa-solid fa-moon"></i></span>
        </button>

        <a href="<%= request.getContextPath() %>/cart" class="nav-cart-btn" title="View Cart">
          <span><i class="fa-solid fa-bag-shopping"></i></span>
          <span>Cart</span>
          <span class="cart-count<%= sessionCartCount <= 0 ? " is-empty" : "" %>" data-count="<%= sessionCartCount %>" style="<%= sessionCartCount <= 0 ? "display: none;" : "" %>"><%= sessionCartCount > 0 ? sessionCartCount : "" %></span>
        </a>

        <!-- Login / User Action Dropdown -->
        <div class="nav-auth-slot" id="nav-auth-slot">
          <%
             User loggedInUser = (User) session.getAttribute("user");
             if (loggedInUser != null) {
               String userName = loggedInUser.getName() != null ? loggedInUser.getName() : "User";
               String firstName = userName.split(" ")[0];
               String initial = !userName.isEmpty() ? userName.substring(0, 1).toUpperCase() : "U";
               boolean isAdmin = loggedInUser.getRole() != null && 
                   (loggedInUser.getRole().equalsIgnoreCase("Admin") || 
                    loggedInUser.getRole().equalsIgnoreCase("Super_Admin") || 
                    loggedInUser.getRole().equalsIgnoreCase("Restaurant_Admin"));
           %>
              <div class="nav-user-dropdown" id="nav-user-dropdown">
               <button type="button" class="nav-user-pill" id="nav-user-pill" aria-expanded="false" aria-haspopup="true" title="Account Menu">
                 <span class="user-avatar-initial"><%= initial %></span>
                 <span class="nav-user-name"><%= firstName %></span>
                 <span class="dropdown-chevron"><i class="fa-solid fa-chevron-down" style="font-size: 10px;"></i></span>
               </button>

               <div class="user-dropdown-menu" id="user-dropdown-menu" role="menu">
                 <div class="user-dropdown-header">
                   <div class="user-dropdown-fullname"><%= userName %></div>
                   <div class="user-dropdown-email"><%= loggedInUser.getEmail() != null ? loggedInUser.getEmail() : "" %></div>
                   <span class="user-dropdown-role"><%= isAdmin ? "<i class='fa-solid fa-bolt text-primary'></i> Admin" : "FoodRush Member" %></span>
                 </div>
                 <hr class="user-dropdown-divider">
                 <a href="<%= request.getContextPath() %>/profile" role="menuitem">
                   <i class="fa-solid fa-user" style="width: 16px;"></i> <span>My Profile</span>
                 </a>
                 <a href="<%= request.getContextPath() %>/orders" role="menuitem">
                   <i class="fa-solid fa-box" style="width: 16px;"></i> <span>My Orders</span>
                 </a>
                 <% if (isAdmin) { %>
                   <a href="<%= request.getContextPath() %>/admin/dashboard" role="menuitem" style="color: var(--color-primary-light); font-weight: 600;">
                     <i class="fa-solid fa-bolt" style="width: 16px;"></i> <span>Admin Portal</span>
                   </a>
                 <% } %>
                 <hr class="user-dropdown-divider">
                 <a href="<%= request.getContextPath() %>/logout" role="menuitem" style="color: var(--color-error); font-weight: 600;">
                   <i class="fa-solid fa-right-from-bracket" style="width: 16px;"></i> <span>Sign Out</span>
                 </a>
               </div>
              </div>
           <% } else { %>
             <a href="<%= request.getContextPath() %>/login" class="btn btn-primary btn-sm">
               Sign In
             </a>
          <% } %>
        </div>

        <!-- Mobile Nav Toggle -->
        <button type="button" class="mobile-nav-toggle" id="mobile-menu-toggle" aria-label="Toggle navigation menu">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="3" y1="12" x2="21" y2="12"></line>
            <line x1="3" y1="6" x2="21" y2="6"></line>
            <line x1="3" y1="18" x2="21" y2="18"></line>
          </svg>
        </button>
      </div>

    </div>
  </header>

  <!-- =========================================================================
       2. Main Content
       ========================================================================= -->
  <main class="main-content section" style="padding-top: var(--space-4);">
    <div class="container">

      <!-- Breadcrumb Navigation -->
      <nav class="breadcrumb-nav" aria-label="Breadcrumb" style="padding: 12px 0;">
        <a href="<%= request.getContextPath() %>/home" class="breadcrumb-link">Home</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%= request.getContextPath() %>/orders" class="breadcrumb-link">Orders</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Tracking <span class="order-id-display">#ORD-<%= order.getOrderID() %></span></span>
      </nav>

      <!-- Confirmation Top Banner -->
      <div class="tracking-hero-banner">
        <div>
          <h1 class="order-success-title" id="hero-status-text">
            <span class="dynamic-confirmation-tick" id="dynamic-confirmation-tick" aria-label="Order Confirmed &amp; Placed" title="Order Confirmed!">
              <span class="tick-ripple-aura"></span>
              <span class="tick-spark spark-1" style="--dx: -16px; --dy: -16px;"></span>
              <span class="tick-spark spark-2" style="--dx: 18px; --dy: -14px;"></span>
              <span class="tick-spark spark-3" style="--dx: -14px; --dy: 16px;"></span>
              <span class="tick-spark spark-4" style="--dx: 16px; --dy: 15px;"></span>
              <svg class="tick-animated-svg" viewBox="0 0 52 52" xmlns="http://www.w3.org/2000/svg">
                <circle class="tick-circle" cx="26" cy="26" r="23" fill="none" />
                <path class="tick-check" fill="none" d="M14.5 27.2 L22.5 35.2 L37.5 18.5" />
              </svg>
            </span>
            <span>Order Confirmed &amp; Placed!</span>
          </h1>
          <p class="order-eta-display" id="hero-eta-text">
            Estimated Delivery: 25-30 mins (approx 30 mins from order)
          </p>
        </div>

        <div style="text-align: right;">
          <div style="font-size: var(--font-size-caption); color: #A8A29E;">Order ID</div>
          <div style="font-size: var(--font-size-h3); font-weight: bold; color: #FFFFFF;" class="order-id-display">
            #ORD-<%= order.getOrderID() %>
          </div>
          <div style="font-size: 11px; color: #D1D5DB; margin-top: 2px;"><%= orderDateStr %></div>
        </div>
      </div>

      <!-- Tracking 2-Column Grid Layout -->
      <div class="tracking-grid-layout">

        <!-- Left: Live Status Stepper, Rider Card & Route Track -->
        <div>

          <!-- Timeline Stepper Card -->
          <section class="timeline-card" aria-labelledby="timeline-heading">
            <h2 class="heading-3" id="timeline-heading">Live Order Status</h2>

            <div class="timeline-stepper">

              <!-- Step 1: Placed -->
              <div class="timeline-step <%= isPlaced ? "active" : "completed" %>" id="step-placed">
                <div class="timeline-step-node"><i class="fa-solid fa-check"></i></div>
                <div class="timeline-step-title">Order Placed & Confirmed</div>
                <div class="timeline-step-desc">Your order has been received and verified by <%= resName %>.</div>
                <div class="timeline-step-time"><%= orderTimeStr %></div>
              </div>

              <!-- Step 2: Preparing -->
              <div class="timeline-step <%= isPreparing ? "active" : ((isOutForDelivery || isDelivered) ? "completed" : "") %>" id="step-prep">
                <div class="timeline-step-node"><i class="fa-solid fa-utensils"></i></div>
                <div class="timeline-step-title">Kitchen is Preparing Your Food</div>
                <div class="timeline-step-desc">The chef is preparing your meal fresh and hot.</div>
                <div class="timeline-step-time">Estimated: 15 mins</div>
              </div>

              <!-- Step 3: Out for Delivery -->
              <div class="timeline-step <%= isOutForDelivery ? "active" : (isDelivered ? "completed" : "") %>" id="step-out">
                <div class="timeline-step-node"><i class="fa-solid fa-motorcycle"></i></div>
                <div class="timeline-step-title">Out for Delivery</div>
                <div class="timeline-step-desc">Our delivery executive is on the way to your address.</div>
                <div class="timeline-step-time">ETA: 25-30 mins</div>
              </div>

              <!-- Step 4: Delivered -->
              <div class="timeline-step <%= isDelivered ? "active completed" : "" %>" id="step-delivered">
                <div class="timeline-step-node"><i class="fa-solid fa-house"></i></div>
                <div class="timeline-step-title">Delivered</div>
                <div class="timeline-step-desc">Handed over at your doorstep. Enjoy your meal!</div>
              </div>

            </div>

          </section>

          <!-- Live Delivery Partner Card -->
          <div class="rider-card" id="rider-info-card">
            <div class="rider-info">
              <div class="rider-avatar-wrap">
                <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120&auto=format&fit=crop&q=80"
                  alt="Delivery Partner" class="rider-avatar">
                <% if (assignedDriver != null) { %>
                <span class="rider-online-dot" title="Active On Road"></span>
                <% } %>
              </div>
              <div>
                <% if (assignedDriver != null) { %>
                <div class="rider-header-row">
                  <span class="rider-name"><%= assignedDriver.getName() %></span>
                  <span class="rider-badge-verified"><i class="fa-solid fa-shield-halved" style="margin-right: 4px;"></i> Verified Hero</span>
                </div>
                <div class="rider-meta">
                  <span class="rider-rating"><i class="fa-solid fa-star text-warning"></i> <%= (assignedDriver.getRating() > 0 ? assignedDriver.getRating() : 4.9) %></span> •
                  <span class="rider-vehicle"><i class="fa-solid fa-motorcycle text-primary"></i> <%= assignedDriver.getVehicleNumber() %> (<%= assignedDriver.getVehicleType() %>)</span>
                </div>
                <div class="rider-safety-tag"><i class="fa-solid fa-shield-halved text-success" style="margin-right: 4px;"></i> Temperature Checked • Insulated Delivery Bag</div>
                <% } else { %>
                <div class="rider-header-row">
                  <span class="rider-name" style="color: var(--color-text-secondary);">Assigning Delivery Partner...</span>
                  <span class="rider-badge-verified" style="background: rgba(245, 158, 11, 0.15); color: #F59E0B;"><i class="fa-solid fa-clock text-warning" style="margin-right: 4px;"></i> In Dispatch</span>
                </div>
                <div class="rider-meta">
                  <span class="rider-vehicle" style="color: var(--color-text-muted);"><i class="fa-solid fa-motorcycle text-primary"></i> Nearest rider being assigned by kitchen</span>
                </div>
                <div class="rider-safety-tag"><i class="fa-solid fa-location-crosshairs text-primary" style="margin-right: 4px;"></i> Live GPS tracking activates on rider pickup</div>
                <% } %>
              </div>
            </div>
            <div class="rider-actions">
              <% if (assignedDriver != null && assignedDriver.getPhone() != null && !assignedDriver.getPhone().isEmpty()) { %>
              <a href="tel:<%= assignedDriver.getPhone() %>" class="btn btn-outline btn-sm rider-btn-call">
                <i class="fa-solid fa-phone" style="margin-right: 6px;"></i> Call Rider
              </a>
              <% } else { %>
              <button type="button" class="btn btn-outline btn-sm rider-btn-call" disabled style="opacity: 0.5;">
                <i class="fa-solid fa-phone" style="margin-right: 6px;"></i> Call Rider
              </button>
              <% } %>
              <button type="button" class="btn btn-secondary btn-sm rider-btn-msg" onclick="if(window.FoodRush) window.FoodRush.showToast('Rider is on the way with your order!', 'info');">
                <i class="fa-solid fa-comments" style="margin-right: 6px;"></i> Chat
              </button>
            </div>
          </div>

          <!-- Interactive Live GPS Map & Route Navigation -->
          <div class="map-track-card" style="background-color: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); padding: var(--space-5); margin-bottom: var(--space-6); box-shadow: var(--shadow-sm); position: relative; overflow: hidden;">
            <div class="map-track-header" style="display: flex; align-items: center; justify-content: space-between; margin-bottom: var(--space-4); flex-wrap: wrap; gap: 8px;">
              <div class="map-track-title" style="font-size: var(--font-size-body); font-weight: var(--font-weight-bold); display: flex; align-items: center; gap: 8px; color: var(--color-text-primary);">
                <span class="live-pulse-dot"></span> Live GPS Delivery Route
              </div>
              <span class="route-eta-pill" id="map-live-eta-pill"><i class="fa-solid fa-bolt text-primary" style="margin-right: 4px;"></i> Express Transit (~18 mins)</span>
            </div>

            <!-- Leaflet Interactive Map Container -->
            <div class="map-container-wrapper" style="position: relative; width: 100%; height: 380px; min-height: 380px; border-radius: var(--radius-lg); overflow: hidden; border: 1px solid var(--color-border); background-color: #1C1917;">
              <div id="live-delivery-map" style="width: 100%; height: 100%; min-height: 380px; position: relative; z-index: 1;"></div>
              
              <div class="map-hud-overlay">
                <div class="hud-item">
                  <span class="hud-label">Rider</span>
                  <span class="hud-value"><%= (assignedDriver != null) ? (assignedDriver.getName() + " (" + assignedDriver.getVehicleNumber() + ")") : "Assigning Rider..." %></span>
                </div>
                <div class="hud-item">
                  <span class="hud-label">Speed</span>
                  <span class="hud-value" id="hud-speed">28 km/h</span>
                </div>
                <div class="hud-item">
                  <span class="hud-label">Distance Left</span>
                  <span class="hud-value" id="hud-distance">1.8 km</span>
                </div>
              </div>
              
              <button type="button" class="map-recenter-btn" id="map-recenter-btn" title="Recenter on delivery rider">
                <i class="fa-solid fa-crosshairs" style="margin-right: 4px;"></i> Recenter
              </button>
            </div>

            <div class="map-footer-meta" style="display: flex; align-items: center; justify-content: space-between; margin-top: var(--space-4); padding-top: var(--space-3); border-top: 1px solid var(--color-border-light); gap: 12px;">
              <div class="map-endpoint" style="display: flex; align-items: center; gap: 8px; flex: 1;">
                <span class="endpoint-icon" style="font-size: 20px; color: var(--color-primary);"><i class="fa-solid fa-store"></i></span>
                <div>
                  <div class="endpoint-name" style="font-size: var(--font-size-body-sm); font-weight: var(--font-weight-bold); color: var(--color-text-primary);"><%= resName %></div>
                  <div class="endpoint-sub" style="font-size: 11px; color: var(--color-text-muted);"><%= resAddress %></div>
                </div>
              </div>
              <div class="endpoint-arrow" style="color: var(--color-primary); font-size: 16px; font-weight: bold;"><i class="fa-solid fa-arrow-right"></i></div>
              <div class="map-endpoint" style="display: flex; align-items: center; gap: 8px; flex: 1;">
                <span class="endpoint-icon" style="font-size: 20px; color: var(--color-success);"><i class="fa-solid fa-house"></i></span>
                <div>
                  <div class="endpoint-name" style="font-size: var(--font-size-body-sm); font-weight: var(--font-weight-bold); color: var(--color-text-primary);">Your Doorstep</div>
                  <div class="endpoint-sub" style="font-size: 11px; color: var(--color-text-muted);"><%= deliveryAddress %></div>
                </div>
              </div>
            </div>
          </div>

        </div>

        <!-- Right: Order Details Receipt -->
        <aside class="receipt-sidebar">
          <div class="receipt-card">

            <div class="receipt-header">
              <h2 class="heading-3" style="margin-bottom: 4px;">Order Summary</h2>
              <div style="font-size: var(--font-size-body-sm); font-weight: bold; color: var(--color-primary);">
                <%= resName %>
              </div>
              <div style="font-size: var(--font-size-caption); color: var(--color-text-muted);">
                <%= resAddress %>
              </div>
            </div>

            <!-- Ordered Items List -->
            <div style="margin-bottom: var(--space-4);">
              <%
                  if (orderItems != null && !orderItems.isEmpty()) {
                      for (OrderItem oi : orderItems) {
                          Menu m = (menuMap != null) ? menuMap.get(oi.getMenuID()) : null;
                          String itemName = (m != null && m.getItemName() != null) ? m.getItemName() : "Dish Item #" + oi.getMenuID();
                          String cat = (m != null && m.getCategory() != null) ? m.getCategory().toLowerCase() : "";
                          String itemLower = itemName.toLowerCase();
                          boolean isVeg = cat.contains("veg") || itemLower.contains("veg") || itemLower.contains("paneer") || itemLower.contains("dal") || itemLower.contains("dosa") || itemLower.contains("idli");
              %>
              <div class="receipt-item-row" style="display: flex; justify-content: space-between; padding: 6px 0; font-size: var(--font-size-body-sm);">
                <span><%= isVeg ? "<i class=\"fa-solid fa-leaf text-success\" style=\"margin-right: 4px;\"></i>" : "<i class=\"fa-solid fa-drumstick-bite text-primary\" style=\"margin-right: 4px;\"></i>" %><%= oi.getQuantity() %> × <%= itemName %></span>
                <span class="font-semibold">₹<%= (int) oi.getItemTotal() %></span>
              </div>
              <%
                      }
                  } else {
              %>
              <div style="font-size: var(--font-size-caption); color: var(--color-text-muted);">
                Items details saved in order #<%= order.getOrderID() %>.
              </div>
              <% } %>
            </div>

            <div class="bill-divider"></div>

            <!-- Price Breakdown -->
            <div class="bill-row">
              <span>Item Total</span>
              <span>₹<%= (int) itemTotal %></span>
            </div>
            <div class="bill-row">
              <span>Delivery Partner Fee</span>
              <span style="<%= deliveryFee == 0 ? "color: var(--color-success); font-weight: bold;" : "" %>">
                <%= deliveryFee == 0 ? "FREE" : "₹" + (int) deliveryFee %>
              </span>
            </div>
            <div class="bill-row">
              <span>Platform Fee</span>
              <span>₹<%= (int) platformFee %></span>
            </div>
            <div class="bill-row">
              <span>GST & Taxes (5%)</span>
              <span>₹<%= (int) gstTax %></span>
            </div>

            <% if (tipAmount > 0) { %>
            <div class="bill-row" style="color: var(--color-primary); font-weight: 600;">
              <span>Rider Tip</span>
              <span>₹<%= tipAmount %></span>
            </div>
            <% } %>

            <div class="bill-divider"></div>

            <div class="bill-row-grand" style="margin-bottom: var(--space-4);">
              <span id="tracking-total-label">Total Amount</span>
              <span class="total-val" id="tracking-grand-total">₹<%= (int) grandTotal %></span>
            </div>

            <!-- Delivery Address Detail -->
            <div style="background-color: var(--color-surface-soft); padding: 12px; border-radius: var(--radius-md); font-size: var(--font-size-caption); margin-bottom: var(--space-4);">
              <div style="font-weight: bold; color: var(--color-text-primary); margin-bottom: 2px;"><i class="fa-solid fa-location-dot text-primary" style="margin-right: 4px;"></i> Delivery Address:</div>
              <p id="tracking-delivery-addr" style="color: var(--color-text-secondary); line-height: 1.4;">
                <%= deliveryAddress %>
              </p>
              <div style="font-weight: bold; color: var(--color-text-primary); margin-top: 6px;"><i class="fa-solid fa-credit-card text-primary" style="margin-right: 4px;"></i> Payment Mode:</div>
              <span id="tracking-payment-mode" style="color: var(--color-success); font-weight: 600;">
                <%= "COD".equalsIgnoreCase(paymentMethod) ? "<i class=\"fa-solid fa-money-bill-wave text-success\" style=\"margin-right: 4px;\"></i> Cash on Delivery (" + paymentStatus + ")" : "<i class=\"fa-solid fa-bolt text-primary\" style=\"margin-right: 4px;\"></i> Paid Online via " + paymentMethod %>
              </span>
              <% String lastPaymentId = (String) session.getAttribute("lastPaymentId");
                 if (lastPaymentId != null && !lastPaymentId.trim().isEmpty()) { %>
                <div style="font-size: 11px; color: var(--color-text-muted); margin-top: 4px;">
                  Razorpay Ref: <code style="background: rgba(0,0,0,0.06); padding: 2px 5px; border-radius: 4px; font-weight: 600;"><%= lastPaymentId %></code>
                </div>
              <% } %>
            </div>

            <!-- Actions -->
            <div style="display: flex; flex-direction: column; gap: 8px;">
              <a href="<%= request.getContextPath() %>/home" class="btn btn-primary" style="width: 100%; text-decoration: none; text-align: center;">
                <i class="fa-solid fa-house" style="margin-right: 6px;"></i> Back to Home
              </a>
              <a href="<%= request.getContextPath() %>/orders" class="btn btn-outline" style="width: 100%; text-decoration: none; text-align: center;">
                <i class="fa-solid fa-box" style="margin-right: 6px;"></i> View All Orders
              </a>
              <% if (!rawStatus.equals("CANCELLED")) { %>
              <div class="cancel-grace-wrapper" id="cancel-grace-wrapper" data-remaining="<%= remainingGraceSeconds %>">
                <% if (canCancel) { %>
                <div class="grace-timer-badge" id="grace-timer-badge">
                  <span class="grace-pulse-indicator"></span>
                  <span>Cancellation window: <strong id="grace-countdown-display">00:<%= String.format("%02d", remainingGraceSeconds) %></strong></span>
                </div>
                <button type="button" id="btn-cancel-order" class="btn btn-outline" style="width: 100%; color: var(--color-error); border-color: rgba(239, 68, 68, 0.4); text-align: center; margin-top: 2px; font-weight: 600;">
                  <i class="fa-solid fa-xmark" style="margin-right: 4px;"></i> Cancel Order (<span id="cancel-timer-btn-text"><%= remainingGraceSeconds %>s</span>)
                </button>
                <% } %>
                <div class="cancellation-locked-pill" id="cancellation-locked-pill" style="<%= canCancel ? "display: none;" : "" %>">
                  <span><i class="fa-solid fa-lock" style="margin-right: 6px;"></i> Kitchen is preparing your food. Cancellation no longer available.</span>
                </div>
              </div>
              <% } %>
            </div>

          </div>
        </aside>

      </div>

    </div>
  </main>

  <!-- Modal: Cancel Order Confirmation -->
  <div class="modal-overlay" id="cancel-confirm-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog">
      <div class="modal-header">
        <h3 class="modal-title">Cancel Order #ORD-<%= order.getOrderID() %>?</h3>
        <button type="button" class="modal-close-btn" aria-label="Close"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="modal-body">
        <div style="background: rgba(239, 68, 68, 0.08); border: 1px solid rgba(239, 68, 68, 0.2); border-radius: var(--radius-md); padding: 12px; margin-bottom: 16px;">
          <p style="font-size: var(--font-size-body-sm); color: var(--color-error); font-weight: 600; margin-bottom: 4px;">
            <i class="fa-solid fa-triangle-exclamation" style="margin-right: 4px;"></i> 60-Second Grace Period
          </p>
          <p style="font-size: var(--font-size-caption); color: var(--color-text-secondary); line-height: 1.4;">
            Free cancellation expires in <strong id="modal-grace-countdown" style="color: var(--color-error);">00:<%= String.format("%02d", remainingGraceSeconds) %></strong>. Once the kitchen starts cooking, this order cannot be cancelled or refunded.
          </p>
        </div>
        <form action="<%= request.getContextPath() %>/order" method="POST" id="cancel-order-form" style="display: flex; gap: 12px; justify-content: flex-end;">
          <input type="hidden" name="action" value="cancel">
          <input type="hidden" name="orderID" value="<%= order.getOrderID() %>">
          <button type="button" class="btn btn-secondary">Keep Order</button>
          <button type="submit" class="btn btn-primary" style="background-color: var(--color-error); border-color: var(--color-error);">Confirm Cancellation</button>
        </form>
      </div>
    </div>
  </div>

  <!-- Mobile Navigation Drawer -->
  <div class="drawer-overlay" id="mobile-nav-drawer">
    <div class="drawer-panel">
      <div class="drawer-header">
        <div class="brand-logo">
          <div class="brand-icon"><i class="fa-solid fa-bolt-lightning text-primary"></i></div>
          <span>Food<span class="brand-name-highlight">Rush</span></span>
        </div>
        <button type="button" class="modal-close-btn" aria-label="Close menu"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="drawer-body">
        <ul style="list-style: none; display: flex; flex-direction: column; gap: 16px; font-size: var(--font-size-body-lg); font-weight: 600;">
          <li><a href="<%= request.getContextPath() %>/home"><i class="fa-solid fa-house"></i> Home</a></li>
          <li><a href="<%= request.getContextPath() %>/restaurants"><i class="fa-solid fa-utensils"></i> Restaurants</a></li>
          <li><a href="<%= request.getContextPath() %>/orders" class="text-brand"><i class="fa-solid fa-box"></i> Orders</a></li>
          <li><a href="<%= request.getContextPath() %>/profile"><i class="fa-solid fa-user"></i> Profile</a></li>
          <li><a href="<%= request.getContextPath() %>/cart"><i class="fa-solid fa-bag-shopping"></i> Cart</a></li>
          <li><a href="<%= request.getContextPath() %>/login"><i class="fa-solid fa-key"></i> Sign In / Account</a></li>
        </ul>

        <div style="margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--color-border);">
          <button type="button" class="theme-toggle-btn mobile-theme-toggle" aria-label="Toggle Dark/Light Mode">
            <span class="theme-icon sun-icon"><i class="fa-solid fa-sun"></i></span>
            <span class="theme-icon moon-icon"><i class="fa-solid fa-moon"></i></span>
            <span class="theme-toggle-label">Dark Mode</span>
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Client-side Cart Cache Invalidation & Scripts -->
  <script>
    // Cleanly wipe client cart cache since order is placed successfully
    try {
      localStorage.removeItem('foodrush_cart');
      localStorage.removeItem('foodrush_cart_restaurant');
      var badge = document.querySelector('.nav-cart-btn .cart-count');
      if (badge) {
        badge.textContent = '';
        badge.setAttribute('data-count', '0');
        badge.classList.add('is-empty');
        badge.style.display = 'none';
      }
    } catch (e) {}
  </script>
  <script>
    window.FOODRUSH_CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js?v=2"></script>
  <!-- Leaflet Interactive Map Engine with CDN Fallback -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.min.js"></script>
  <script>
    if (typeof L === 'undefined') {
      document.write('<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"><\/script>');
    }
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/order-tracking.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
