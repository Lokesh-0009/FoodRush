<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.util.LinkedHashMap, java.util.ArrayList, com.foodRush.model.Restaurant, com.foodRush.model.Menu, com.foodRush.model.Cart"%>
<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");

    Cart sessionCart = (Cart) session.getAttribute("cart");
    int sessionCartCount = (sessionCart != null) ? sessionCart.getTotalCount() : 0;

    String resName = (restaurant != null && restaurant.getName() != null) ? restaurant.getName() : "Royal Biryani Palace";
    String cuisines = (restaurant != null && restaurant.getCuisineType() != null) ? restaurant.getCuisineType() : "Biryani, North Indian, Mughlai";
    String address = (restaurant != null && restaurant.getAddress() != null) ? restaurant.getAddress() : "5th Block, Koramangala, Bangalore";
    double rating = (restaurant != null) ? restaurant.getRating() : 4.8;
    int deliveryTime = (restaurant != null && restaurant.getDeliveryTime() > 0) ? restaurant.getDeliveryTime() : 30;
    String resImage = (restaurant != null && restaurant.getImagePath() != null && !restaurant.getImagePath().trim().isEmpty())
                      ? restaurant.getImagePath().trim()
                      : "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&auto=format&fit=crop&q=80";
    
    // Group menu items by Category preserving insertion order
    Map<String, List<Menu>> categoryMap = new LinkedHashMap<>();
    if (menuList != null && !menuList.isEmpty()) {
        for (Menu m : menuList) {
            String cat = (m.getCategory() != null && !m.getCategory().trim().isEmpty()) ? m.getCategory().trim() : "Chef's Specials";
            categoryMap.computeIfAbsent(cat, k -> new ArrayList<>()).add(m);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Order delicious meals from <%= resName %> on FoodRush. Fast delivery and fresh hot food.">
  <title><%= resName %> — Menu & Order Online | FoodRush</title>

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
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/restaurant-detail.css">
  <style>
    /* Suppress duplicate Microsoft Edge native password reveal icon */
    input::-ms-reveal, input::-ms-clear { display: none !important; width: 0 !important; height: 0 !important; pointer-events: none !important; }
  </style>

  <!-- Instant Theme Initializer to prevent white flash in Dark Mode -->
  <script>
    (function () {
      const savedTheme = localStorage.getItem('foodrush_theme');
      if (savedTheme === 'dark' || (!savedTheme && window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.setAttribute('data-theme', 'dark');
      }
    })();

    // Bulletproof password visibility toggler available immediately
    function togglePasswordVisibility(inputRef, btnRef, e) {
      if (e) {
        if (typeof e.preventDefault === 'function') e.preventDefault();
        if (typeof e.stopPropagation === 'function') e.stopPropagation();
      }
      var input = null;
      if (typeof inputRef === 'string') {
        input = document.getElementById(inputRef);
      } else if (inputRef && inputRef.nodeType) {
        input = inputRef;
      }
      if (!input && btnRef && btnRef.closest) {
        var wrapper = btnRef.closest('.password-input-wrapper, .form-input-wrapper, .input-icon-wrapper');
        if (wrapper) {
          input = wrapper.querySelector('input');
        }
      }
      if (!input) return;

      var currentType = input.getAttribute('type') || input.type;
      var isPass = (currentType === 'password');
      var newType = isPass ? 'text' : 'password';

      try {
        input.type = newType;
      } catch (err) {}
      try {
        input.setAttribute('type', newType);
      } catch (err) {}

      var btn = btnRef;
      if (!btn && input.parentElement) {
        btn = input.parentElement.querySelector('.password-toggle-btn');
      }

      if (btn) {
        btn.innerHTML = isPass 
          ? '<i class="fa-solid fa-eye-slash" style="pointer-events: none;"></i>' 
          : '<i class="fa-solid fa-eye" style="pointer-events: none;"></i>';
        btn.setAttribute('aria-label', isPass ? 'Hide password' : 'Show password');
        btn.setAttribute('title', isPass ? 'Hide password' : 'Show password');
      }

      try {
        input.focus();
        var val = input.value;
        input.value = '';
        input.value = val;
      } catch (err) {}
    }
    window.togglePasswordVisibility = togglePasswordVisibility;
    window.togglePassVisibility = togglePasswordVisibility;
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

      <!-- Right: Links, Cart & Auth -->
      <div class="nav-right">
        <nav aria-label="Main Navigation">
          <ul class="nav-menu-links">
            <li><a href="<%= request.getContextPath() %>/home" class="nav-link-item">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/restaurants" class="nav-link-item active">Restaurants</a></li>
            <li><a href="<%= request.getContextPath() %>/orders" class="nav-link-item">Orders</a></li>
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
             com.foodRush.model.User currentUser = (com.foodRush.model.User) session.getAttribute("user");
             if (currentUser != null) {
               String userName = currentUser.getName() != null ? currentUser.getName() : "User";
               String firstName = userName.split(" ")[0];
               String initial = !userName.isEmpty() ? userName.substring(0, 1).toUpperCase() : "U";
               boolean isAdmin = currentUser.getRole() != null && 
                   (currentUser.getRole().equalsIgnoreCase("Admin") || 
                    currentUser.getRole().equalsIgnoreCase("Super_Admin") || 
                    currentUser.getRole().equalsIgnoreCase("Restaurant_Admin"));
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
                   <div class="user-dropdown-email"><%= currentUser.getEmail() != null ? currentUser.getEmail() : "" %></div>
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
  <main class="main-content section" style="padding-top: var(--space-4); padding-bottom: var(--space-20);">
    <div class="container">
      
      <!-- Breadcrumb Navigation -->
      <nav class="breadcrumb-nav" aria-label="Breadcrumb" style="padding: 12px 0;">
        <a href="<%= request.getContextPath() %>/home" class="breadcrumb-link">Home</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%= request.getContextPath() %>/restaurants" class="breadcrumb-link">Restaurants</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current"><%= resName %></span>
      </nav>

      <!-- Restaurant Hero Card with Faded Background Image -->
      <div class="restaurant-hero-card" style="background-image: url('<%= resImage %>');">
        
        <div class="restaurant-hero-top">
          <div class="restaurant-main-info">
            <h1 class="restaurant-hero-title"><%= resName %></h1>
            <p class="restaurant-hero-cuisines"><%= cuisines %></p>
            <p class="restaurant-hero-address">
              <span><i class="fa-solid fa-location-dot text-primary"></i></span> <%= address %> • 1.8 km away
            </p>
          </div>

          <div class="restaurant-hero-rating-box">
            <div class="restaurant-hero-rating-val"><i class="fa-solid fa-star text-warning"></i> <%= String.format("%.1f", rating) %></div>
            <div class="restaurant-hero-rating-count">2,500+ Ratings</div>
          </div>
        </div>

        <!-- Metrics Bar -->
        <div class="restaurant-metrics-bar">
          <div class="metric-item">
            <span class="metric-icon"><i class="fa-solid fa-clock"></i></span>
            <div>
              <div>Delivery Time</div>
              <strong><%= deliveryTime %>-<%= deliveryTime + 5 %> mins</strong>
            </div>
          </div>

          <div class="metric-item">
            <span class="metric-icon"><i class="fa-solid fa-wallet"></i></span>
            <div>
              <div>Average Cost</div>
              <strong>₹350 for two</strong>
            </div>
          </div>

          <div class="metric-item">
            <span class="metric-icon"><i class="fa-solid fa-shield-halved"></i></span>
            <div>
              <div>Food Safety</div>
              <strong>Hygiene Certified</strong>
            </div>
          </div>
        </div>

        <!-- Special Offers Banner -->
        <div class="restaurant-offer-card">
          <div style="display: flex; align-items: center; gap: 10px;">
            <span class="offer-tag-badge">Offer</span>
            <span style="font-size: var(--font-size-body-sm); font-weight: 600;">
              Get 50% OFF up to ₹100 on orders above ₹199
            </span>
          </div>
          <button type="button" class="btn btn-outline btn-sm">
            Use Code: RUSH50
          </button>
        </div>

      </div>

      <!-- Menu Category Navigation & Search Toolbar (Sticky) -->
      <div class="menu-toolbar">
        <div class="menu-toolbar-inner">
          
          <!-- Category Tabs (Smooth Scroll Jump Anchors) -->
          <div class="category-tabs-nav">
            <%
                int catIdx = 0;
                for (String categoryName : categoryMap.keySet()) {
                    String slug = categoryName.toLowerCase().replaceAll("[^a-z0-9]+", "-");
                    String activeClass = (catIdx == 0) ? "active" : "";
                    catIdx++;
            %>
              <a href="#sec-<%= slug %>" class="category-tab-btn <%= activeClass %>" style="text-decoration: none;"><%= categoryName %></a>
            <%  } %>
            <%  if (categoryMap.isEmpty()) { %>
              <a href="#sec-all" class="category-tab-btn active" style="text-decoration: none;">All Dishes</a>
            <%  } %>
          </div>

          <!-- Filters Right -->
          <div class="menu-filters-right">
            <!-- Dietary Filter Pills -->
            <button type="button" class="btn btn-secondary btn-sm" id="filter-veg-btn">
              <span class="dietary-badge veg" style="margin-bottom: 0;"></span> Veg
            </button>
            <button type="button" class="btn btn-secondary btn-sm" id="filter-nonveg-btn">
              <span class="dietary-badge nonveg" style="margin-bottom: 0;"></span> Non-Veg
            </button>

            <!-- Search Inside Menu -->
            <div class="menu-search-box">
              <span class="menu-search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
              <input type="text" id="menu-search-input" class="menu-search-input" placeholder="Search menu...">
            </div>
          </div>

        </div>
      </div>

      <!-- =====================================================================
           3. Menu Sections
           ===================================================================== -->
      <%
          if (!categoryMap.isEmpty()) {
              int totalItemCounter = 0;
              for (Map.Entry<String, List<Menu>> entry : categoryMap.entrySet()) {
                  String categoryName = entry.getKey();
                  List<Menu> items = entry.getValue();
                  String slug = categoryName.toLowerCase().replaceAll("[^a-z0-9]+", "-");
      %>
      <section class="menu-section" id="sec-<%= slug %>">
        <h2 class="menu-section-title">
          <%= categoryName %> <span class="menu-section-count">(<%= items.size() %> items)</span>
        </h2>

        <div class="menu-items-grid">
          <%
              for (Menu item : items) {
                  totalItemCounter++;
                  String itemName = item.getItemName();
                  String itemDesc = (item.getDescription() != null) ? item.getDescription() : "";
                  double itemPrice = item.getPrice();
                  boolean isAvailable = (item.getIsAvailable() == 1);
                  
                  // Vegetarian check helper
                  String combinedText = (itemName + " " + itemDesc + " " + categoryName).toLowerCase();
                  boolean isVeg = !(combinedText.contains("chicken") || combinedText.contains("mutton") 
                                  || combinedText.contains("egg") || combinedText.contains("prawn") 
                                  || combinedText.contains("fish") || combinedText.contains("meat")
                                  || combinedText.contains("non-veg") || combinedText.contains("murgh"));

                  String imgPath = (item.getImagePath() != null && !item.getImagePath().trim().isEmpty())
                                   ? item.getImagePath()
                                   : "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300&auto=format&fit=crop&q=80";
                  
                  boolean isBestseller = (itemPrice >= 240 && itemPrice <= 350) || (totalItemCounter % 3 == 0);
          %>
          <!-- Dynamic Dish Card -->
          <article class="menu-item-card <%= isAvailable ? "" : "unavailable" %>" 
                   data-name="<%= itemName %>" 
                   data-desc="<%= itemDesc %>" 
                   data-veg="<%= isVeg %>">
            <div class="menu-item-info">
              <div>
                <span class="dietary-badge <%= isVeg ? "veg" : "nonveg" %>"></span>
                <% if (isBestseller) { %>
                  <span class="item-bestseller-tag"><i class="fa-solid fa-star text-warning"></i> BESTSELLER</span>
                <% } %>
              </div>
              <h3 class="menu-item-name"><%= itemName %></h3>
              <div class="menu-item-price">₹<%= (int)itemPrice %></div>
              <p class="menu-item-desc"><%= itemDesc %></p>
              <% if (!isAvailable) { %>
                <div class="unavailable-badge">Currently Sold Out</div>
              <% } %>
            </div>
            <div class="menu-item-media">
              <img src="<%= imgPath %>" alt="<%= itemName %>" class="menu-item-img" onerror="this.src='<%= request.getContextPath() %>/frontend/public/auth-food-showcase.jpg'" <%= isAvailable ? "" : "style=\"filter: grayscale(1);\"" %>>
              <div class="item-add-container">
                <% if (isAvailable) { %>
                  <button type="button" class="btn-add-item" id="add-btn-<%= item.getMenuID() %>" 
                          data-id="item-<%= item.getMenuID() %>" 
                          data-menuid="<%= item.getMenuID() %>" 
                          data-restaurantid="<%= item.getRestaurantID() %>" 
                          data-name="<%= itemName %>" 
                          data-price="<%= (int)itemPrice %>" 
                          data-restaurant="<%= resName %>">ADD +</button>
                  <div class="qty-stepper" id="stepper-<%= item.getMenuID() %>">
                    <button type="button" class="qty-btn">−</button>
                    <span class="qty-val" id="qty-val-<%= item.getMenuID() %>">1</span>
                    <button type="button" class="qty-btn">+</button>
                  </div>
                <% } else { %>
                  <button type="button" class="btn-add-item" disabled style="cursor: not-allowed; opacity: 0.5;">ADD +</button>
                <% } %>
              </div>
            </div>
          </article>
          <%  } %>
        </div>
      </section>
      <%
              }
          } else {
      %>
        <div style="text-align: center; padding: 60px 20px;">
          <div style="font-size: 48px; margin-bottom: 16px; color: var(--color-text-muted);"><i class="fa-solid fa-utensils"></i></div>
          <h2 style="font-size: var(--font-size-h2); font-weight: 700; margin-bottom: 8px;">No Menu Items Found</h2>
          <p style="color: var(--color-text-secondary); font-size: var(--font-size-body);">Please check back soon for freshly updated menu items.</p>
        </div>
      <%  } %>

    </div>
  </main>

  <!-- =========================================================================
       4. Sticky Bottom Cart Bar
       ========================================================================= -->
  <aside class="sticky-cart-bar" id="sticky-cart-bar" aria-label="Current Cart Summary">
    <div class="sticky-cart-bar-inner">
      <div class="cart-bar-info">
        <span style="font-size: 20px;"><i class="fa-solid fa-bag-shopping"></i></span>
        <div>
          <div class="cart-bar-items-count" id="cart-bar-item-count">0 items in cart</div>
          <div style="font-size: var(--font-size-caption); color: #B3B3B3;">From: <%= resName %></div>
        </div>
      </div>

      <div style="display: flex; align-items: center; gap: 16px;">
        <div class="cart-bar-total-price" id="cart-bar-total-amount">₹0</div>
        <a href="<%= request.getContextPath() %>/cart" class="btn btn-primary btn-checkout-nav" id="btn-sticky-checkout" style="text-decoration: none;">
          View Cart & Checkout <i class="fa-solid fa-arrow-right"></i>
        </a>
      </div>
    </div>
  </aside>

  <!-- =========================================================================
       5. Global Footer
       ========================================================================= -->
  <footer class="footer">
    <div class="container">
      <div class="footer-grid">
        <div>
          <div class="footer-brand-title"><span style="color: var(--color-primary);"><i class="fa-solid fa-bolt-lightning"></i></span> FoodRush</div>
          <p class="footer-brand-desc">FoodRush connects you with top local restaurants and favorite food spots with unmatched delivery speed.</p>
        </div>
        <div>
          <h4 class="footer-col-title">Company</h4>
          <ul class="footer-links">
            <li><a href="<%= request.getContextPath() %>/home#about" class="footer-link">About Us</a></li>
            <li><a href="<%= request.getContextPath() %>/home#careers" class="footer-link">Careers</a></li>
          </ul>
        </div>
        <div>
          <h4 class="footer-col-title">For You</h4>
          <ul class="footer-links">
            <li><a href="<%= request.getContextPath() %>/home#partner" class="footer-link">Partner With Us</a></li>
            <li><a href="<%= request.getContextPath() %>/home#privacy" class="footer-link">Privacy Policy</a></li>
          </ul>
        </div>
        <div>
          <h4 class="footer-col-title">Get in Touch</h4>
          <button type="button" class="btn btn-outline btn-sm">
            <i class="fa-solid fa-headset"></i> 24/7 Support
          </button>
        </div>
      </div>
      <div class="footer-bottom">
        <div>© 2026 FoodRush Technologies Pvt Ltd. All rights reserved.</div>
      </div>
    </div>
  </footer>

  <!-- =========================================================================
       6. Popups & Drawers
       ========================================================================= -->

  <!-- Modal: Location Picker Popup -->
  <div class="modal-overlay" id="location-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog">
      <div class="modal-header">
        <h3 class="modal-title"><i class="fa-solid fa-location-dot text-primary"></i> Select Delivery Location</h3>
        <button type="button" class="modal-close-btn"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="modal-body">
        <input type="text" class="nav-search-input" placeholder="Type locality (e.g. Indiranagar)" style="padding: 10px 16px; margin-bottom: 12px;">
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <button type="button" class="btn btn-secondary" style="justify-content: flex-start;">
            <i class="fa-solid fa-building text-primary" style="margin-right: 8px;"></i> <strong>Koramangala</strong>, Bangalore (Current)
          </button>
          <button type="button" class="btn btn-secondary" style="justify-content: flex-start;">
            <i class="fa-solid fa-location-dot text-primary" style="margin-right: 8px;"></i> <strong>Indiranagar</strong>, Bangalore
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal: Sign In Modal -->
  <div class="modal-overlay" id="login-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog">
      <div class="modal-header">
        <h3 class="modal-title">Welcome to FoodRush</h3>
        <button type="button" class="modal-close-btn"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="modal-body">
        <form action="<%= request.getContextPath() %>/login" method="POST">
          <div style="margin-bottom: 12px;">
            <label style="display: block; font-size: var(--font-size-caption); font-weight: bold; margin-bottom: 4px;">Email or Phone</label>
            <input type="text" class="nav-search-input" name="email" placeholder="foodlover@example.com" required style="padding: 10px 14px;">
          </div>
          <div style="margin-bottom: 16px;">
            <label style="display: block; font-size: var(--font-size-caption); font-weight: bold; margin-bottom: 4px;">Password</label>
            <div class="password-input-wrapper" style="position: relative; display: flex; align-items: center; width: 100%;">
              <input type="password" id="menu-modal-password" class="nav-search-input" name="password" placeholder="••••••••" required style="padding: 10px 44px 10px 14px; width: 100%;">
              <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('menu-modal-password', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-muted); font-size: 15px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;">
                <i class="fa-solid fa-eye" style="pointer-events: none;"></i>
              </button>
            </div>
          </div>
          <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">Sign In</button>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal: Restaurant Cart Conflict Modal -->
  <div class="modal-overlay" id="cart-conflict-modal" role="dialog" aria-modal="true" style="z-index: 10000;">
    <div class="modal-dialog" style="max-width: 440px; text-align: center; padding: 28px 24px; border-radius: var(--radius-lg); background: var(--color-surface);">
      <div style="font-size: 42px; margin-bottom: 12px; color: #f59e0b;"><i class="fa-solid fa-triangle-exclamation"></i></div>
      <h3 class="modal-title" style="font-size: var(--font-size-h3); font-weight: 800; margin-bottom: 8px;">Items already in cart</h3>
      <p style="color: var(--color-text-secondary); font-size: var(--font-size-body-sm); line-height: 1.5; margin-bottom: 24px;" id="conflict-modal-desc">
        Your cart contains items from <strong id="conflict-current-res" style="color: var(--color-text-primary);">another restaurant</strong>. Would you like to reset your cart and start a fresh order from <strong id="conflict-new-res" style="color: var(--color-primary);"><%= resName %></strong>?
      </p>
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
        <button type="button" class="btn btn-outline" id="conflict-cancel-btn" style="padding: 10px 16px; border-radius: var(--radius-pill);">No, Keep Cart</button>
        <button type="button" class="btn btn-primary" id="conflict-confirm-btn" style="padding: 10px 16px; border-radius: var(--radius-pill);">Yes, Start Fresh</button>
      </div>
    </div>
  </div>

  <!-- Drawer: Cart Drawer -->
  <div class="drawer-overlay" id="cart-drawer">
    <div class="drawer-panel">
      <div class="drawer-header">
        <h3 style="font-size: var(--font-size-h3); font-weight: bold;"><i class="fa-solid fa-bag-shopping text-primary"></i> Your Cart</h3>
        <button type="button" class="modal-close-btn"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="drawer-body">
        <div style="border-bottom: 1px solid var(--color-border); padding-bottom: 12px; margin-bottom: 16px;">
          <div style="font-weight: bold; font-size: var(--font-size-body);"><%= resName %></div>
          <div style="font-size: var(--font-size-caption); color: var(--color-text-muted);"><%= address %></div>
        </div>

        <div style="background-color: var(--color-surface-soft); padding: 12px; border-radius: var(--radius-sm); margin-top: 24px;">
          <div style="display: flex; justify-content: space-between; font-size: var(--font-size-caption); margin-bottom: 6px;">
            <span>Delivery Fee</span>
            <span style="color: var(--color-success); font-weight: bold;">FREE</span>
          </div>
        </div>
      </div>
      <div class="drawer-footer">
        <a href="<%= request.getContextPath() %>/cart" class="btn btn-primary" style="width: 100%; padding: 14px; text-decoration: none;">
          Proceed to Cart & Checkout <i class="fa-solid fa-arrow-right"></i>
        </a>
      </div>
    </div>
  </div>

  <!-- Drawer: Mobile Nav -->
  <div class="drawer-overlay" id="mobile-nav-drawer">
    <div class="drawer-panel">
      <div class="drawer-header">
        <div class="brand-logo"><div class="brand-icon"><i class="fa-solid fa-bolt-lightning text-primary"></i></div><span>Food<span class="brand-name-highlight">Rush</span></span></div>
        <button type="button" class="modal-close-btn"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="drawer-body">
        <ul style="list-style: none; display: flex; flex-direction: column; gap: 16px; font-size: var(--font-size-body-lg); font-weight: 600;">
          <li><a href="<%= request.getContextPath() %>/home"><i class="fa-solid fa-house"></i> Home</a></li>
          <li><a href="<%= request.getContextPath() %>/restaurants" class="text-brand"><i class="fa-solid fa-utensils"></i> Restaurants</a></li>
          <li><a href="<%= request.getContextPath() %>/orders"><i class="fa-solid fa-box"></i> Orders</a></li>
          <li><a href="<%= request.getContextPath() %>/profile"><i class="fa-solid fa-user"></i> Profile</a></li>
          <li><a href="<%= request.getContextPath() %>/login"><i class="fa-solid fa-key"></i> Sign In / Account</a></li>
        </ul>
      </div>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Global Context and Vanilla JavaScript Handlers -->
  <script>
    window.FOODRUSH_CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js?v=<%= System.currentTimeMillis() %>"></script>
  <script src="<%= request.getContextPath() %>/frontend/js/restaurant-detail.js?v=5.3"></script>
</body>
</html>
