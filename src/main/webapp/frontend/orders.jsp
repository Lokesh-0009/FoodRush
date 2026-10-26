<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.text.SimpleDateFormat, com.foodRush.model.Orders, com.foodRush.model.OrderItem, com.foodRush.model.Restaurant, com.foodRush.model.User, com.foodRush.model.Cart"%>
<%
    if (session.getAttribute("user") == null) {
        session.setAttribute("redirectAfterLogin", "/orders");
        response.sendRedirect(request.getContextPath() + "/login?redirect=orders");
        return;
    }
    if (request.getAttribute("userOrders") == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }

    List<Orders> userOrders = (List<Orders>) request.getAttribute("userOrders");
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    int orderCount = (userOrders != null) ? userOrders.size() : 0;

    Cart sessionCart = (Cart) session.getAttribute("cart");
    int sessionCartCount = (sessionCart != null) ? sessionCart.getTotalCount() : 0;

    String orderSuccessMsg = (String) session.getAttribute("orderSuccessMessage");
    if (orderSuccessMsg != null) {
        session.removeAttribute("orderSuccessMessage");
    }
    String lastPaymentId = (String) session.getAttribute("lastPaymentId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="View and manage your previous FoodRush orders, track active deliveries, and reorder your favorite meals.">
  <title>My Orders (<%= orderCount %>) — FoodRush</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Font Awesome 6 Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- Core CSS Design System -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/orders.css">

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
      
      <!-- Left: Brand Logo & Location -->
      <div class="nav-left">
        <a href="<%= request.getContextPath() %>/home" class="brand-logo" title="FoodRush Home">
          <div class="brand-icon"><i class="fa-solid fa-bolt-lightning text-primary"></i></div>
          <span>Food<span class="brand-name-highlight">Rush</span></span>
        </a>

        <!-- Location Trigger -->
        <button type="button" class="location-trigger" title="Change Delivery Location">
          <span class="loc-icon"><i class="fa-solid fa-location-dot text-primary"></i></span>
          <span class="loc-text selected-location-text">Koramangala, Bangalore</span>
          <span class="loc-arrow"><i class="fa-solid fa-chevron-down" style="font-size: 10px;"></i></span>
        </button>
      </div>

      <!-- Right: Links, Cart & Profile -->
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

        <!-- Cart Button -->
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
                   <span><i class="fa-solid fa-user"></i></span> <span>My Profile</span>
                 </a>
                 <a href="<%= request.getContextPath() %>/orders" role="menuitem">
                   <span><i class="fa-solid fa-box"></i></span> <span>My Orders</span>
                 </a>
                 <% if (isAdmin) { %>
                   <a href="<%= request.getContextPath() %>/admin/dashboard" role="menuitem" style="color: var(--color-primary-light); font-weight: 600;">
                     <span><i class="fa-solid fa-bolt"></i></span> <span>Admin Portal</span>
                   </a>
                 <% } %>
                 <hr class="user-dropdown-divider">
                 <a href="<%= request.getContextPath() %>/logout" role="menuitem" style="color: var(--color-error); font-weight: 600;">
                   <span><i class="fa-solid fa-right-from-bracket"></i></span> <span>Sign Out</span>
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
        <span class="breadcrumb-current">My Orders</span>
      </nav>

      <!-- Page Header -->
      <div class="orders-page-header">
        <div>
          <h1 class="heading-1">Order History & Tracking</h1>
          <p class="section-subtitle">Manage previous meals, track active deliveries, or reorder in one click</p>
        </div>
      </div>

      <% if (orderSuccessMsg != null && !orderSuccessMsg.trim().isEmpty()) { %>
      <div style="background-color: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; padding: 16px 20px; border-radius: var(--radius-lg); margin-bottom: var(--space-5); display: flex; align-items: center; justify-content: space-between; gap: 14px; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.12); flex-wrap: wrap;">
        <div style="display: flex; align-items: center; gap: 12px;">
          <div style="font-size: 20px; background: #D1FAE5; width: 44px; height: 44px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #059669;"><i class="fa-solid fa-circle-check"></i></div>
          <div>
            <div style="font-size: var(--font-size-body); font-weight: bold; color: #065F46;"><%= orderSuccessMsg %></div>
            <div style="font-size: 13px; color: #047857; margin-top: 2px;">
              Your order has been received by the kitchen! 
              <% if (lastPaymentId != null && !lastPaymentId.isEmpty()) { %>
                <span style="margin-left: 6px;">• Razorpay Ref: <code style="background: rgba(0,0,0,0.06); padding: 2px 6px; border-radius: 4px;"><%= lastPaymentId %></code></span>
              <% } %>
            </div>
          </div>
        </div>
        <span style="font-size: 12px; color: #065F46; background: #A7F3D0; padding: 6px 12px; border-radius: var(--radius-pill); font-weight: 700;">
          <i class="fa-solid fa-bolt-lightning"></i> Active Order
        </span>
      </div>
      <% } %>

      <!-- Status Filter Tabs -->
      <div class="orders-filter-tabs" role="tablist">
        <button type="button" class="order-tab-btn active" data-filter="all">All Orders (<%= orderCount %>)</button>
        <button type="button" class="order-tab-btn" data-filter="active">Active Orders</button>
        <button type="button" class="order-tab-btn" data-filter="delivered">Delivered</button>
        <button type="button" class="order-tab-btn" data-filter="cancelled">Cancelled</button>
      </div>

      <!-- Orders List Container -->
      <div class="orders-list-container" id="orders-list">
        
        <%
            if (userOrders != null && !userOrders.isEmpty()) {
                for (Orders ord : userOrders) {
                    Restaurant res = (restaurantMap != null) ? restaurantMap.get(ord.getRestaurantID()) : null;
                    String resName = (res != null && res.getName() != null) ? res.getName() : "Restaurant #" + ord.getRestaurantID();
                    String resImg = (res != null && res.getImagePath() != null && !res.getImagePath().trim().isEmpty())
                                    ? res.getImagePath()
                                    : request.getContextPath() + "/frontend/public/auth-food-showcase.jpg";
                    String resLoc = (res != null && res.getAddress() != null) ? res.getAddress() : "Bangalore";
                    String orderDateFormatted = (ord.getOrderDate() != null) ? dateFormat.format(ord.getOrderDate()) : "Recent";
                    String rawStatus = (ord.getStatus() != null) ? ord.getStatus() : "PLACED";
                    String normStatus = rawStatus.toUpperCase().replace(" ", "_");
                    boolean isActive = normStatus.equals("PLACED") || normStatus.equals("CONFIRMED") || normStatus.equals("PREPARING") || normStatus.equals("OUT_FOR_DELIVERY");
                    boolean isDelivered = normStatus.equals("DELIVERED") || normStatus.equals("COMPLETED");
                    boolean isCancelled = normStatus.equals("CANCELLED") || normStatus.equals("CANCELED");
                    String filterCategory = isActive ? "active" : (isCancelled ? "cancelled" : "delivered");
                    
                    String displayStatus = normStatus.equals("OUT_FOR_DELIVERY") ? "Out for Delivery" :
                                          (normStatus.equals("PREPARING") ? "Preparing" :
                                          (normStatus.equals("DELIVERED") ? "Delivered" :
                                          (normStatus.equals("CANCELLED") ? "Cancelled" :
                                          (normStatus.equals("CONFIRMED") ? "Confirmed" : "Placed"))));
        %>
        <!-- Dynamic Order Card -->
        <article class="order-history-card" data-status="<%= filterCategory %>">
          <div class="order-card-top">
            <div class="order-restaurant-info">
              <img src="<%= resImg %>" alt="<%= resName %>" class="order-restaurant-avatar" onerror="this.src='<%= request.getContextPath() %>/frontend/public/auth-food-showcase.jpg'">
              <div>
                <h2 class="order-restaurant-name"><%= resName %></h2>
                <div class="order-meta-info"><i class="fa-solid fa-location-dot text-primary"></i> <%= resLoc %> • Order #ORD-<%= ord.getOrderID() %></div>
                <div class="order-meta-info" style="margin-top: 2px;"><%= orderDateFormatted %></div>
              </div>
            </div>

            <!-- Status Badge -->
            <span class="badge" style="<%= isActive ? "background-color: var(--color-primary-soft); color: var(--color-primary); border: 1px solid var(--color-primary);" : (isDelivered ? "background-color: var(--color-success-soft); color: var(--color-success); border: 1px solid rgba(22,163,74,0.3);" : "background-color: var(--color-surface-soft); color: var(--color-text-secondary);") %> font-size: 13px; padding: 6px 12px;">
              <% if (isActive) { %>
                <i class="fa-solid fa-bolt-lightning"></i> <%= displayStatus %>
              <% } else if (isDelivered) { %>
                <i class="fa-solid fa-check"></i> Delivered
              <% } else { %>
                <i class="fa-solid fa-xmark"></i> <%= displayStatus %>
              <% } %>
            </span>
          </div>

          <div class="order-card-bottom">
            <div>
              <span style="font-size: var(--font-size-caption); color: var(--color-text-muted);">Total Amount: </span>
              <span class="order-total-price">₹<%= (int) ord.getTotalAmount() %></span>
              <span style="font-size: var(--font-size-caption); color: var(--color-success); margin-left: 6px;">(<%= ord.getPaymentMethod() != null ? ord.getPaymentMethod() : "COD" %>)</span>
            </div>

            <div class="order-actions-group">
              <a href="<%= request.getContextPath() %>/order-tracking?orderId=<%= ord.getOrderID() %>" class="btn btn-primary btn-sm" style="text-decoration: none;">
                <i class="fa-solid fa-motorcycle"></i> Track / View Receipt <i class="fa-solid fa-arrow-right"></i>
              </a>
            </div>
          </div>
        </article>
        <%
                }
            } else {
        %>
        <div id="orders-empty-state" style="text-align: center; padding: 48px 16px; background-color: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg);">
          <div style="font-size: 48px; margin-bottom: 12px; color: var(--color-text-muted);"><i class="fa-solid fa-box-open"></i></div>
          <h2 class="heading-2">No Orders Found</h2>
          <p class="section-subtitle" style="margin-bottom: 20px;">You haven't placed any orders yet. Discover delicious dishes nearby!</p>
          <a href="<%= request.getContextPath() %>/restaurants" class="btn btn-primary btn-lg" style="text-decoration: none;">Browse Restaurants</a>
        </div>
        <% } %>

        <div id="orders-filter-empty-state" style="display: none; text-align: center; padding: 48px 16px; background-color: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg);">
          <div style="font-size: 48px; margin-bottom: 12px; color: var(--color-text-muted);"><i class="fa-solid fa-magnifying-glass"></i></div>
          <h2 class="heading-2">No Matching Orders</h2>
          <p class="section-subtitle" style="margin-bottom: 16px;">No orders found in this filter category.</p>
        </div>

      </div>

    </div>
  </main>

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

  <% if (orderSuccessMsg != null && !orderSuccessMsg.trim().isEmpty()) { %>
  <script>
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
  <% } %>

  <!-- Vanilla JavaScript Handlers -->
  <script>
    window.FOODRUSH_CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js"></script>
  <script src="<%= request.getContextPath() %>/frontend/js/orders.js"></script>
</body>
</html>
