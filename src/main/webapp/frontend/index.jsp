<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.util.stream.Collectors, com.foodRush.model.Restaurant, com.foodRush.model.Cart, com.foodRush.DAOImpl.RestaurantDAOImpl"%>
<%
    Cart sessionCart = (Cart) session.getAttribute("cart");
    int sessionCartCount = (sessionCart != null) ? sessionCart.getTotalCount() : 0;

    List<Restaurant> topRatedList = (List<Restaurant>) request.getAttribute("topRatedList");
    List<Restaurant> fastestList = (List<Restaurant>) request.getAttribute("fastestList");
    if (topRatedList == null || topRatedList.isEmpty()) {
        try {
            List<Restaurant> all = new RestaurantDAOImpl().getAllRestaurants();
            if (all != null && !all.isEmpty()) {
                topRatedList = all.stream()
                                  .sorted((a, b) -> Double.compare(b.getRating(), a.getRating()))
                                  .limit(4)
                                  .collect(Collectors.toList());
                fastestList = all.stream()
                                 .sorted((a, b) -> Integer.compare(a.getDeliveryTime(), b.getDeliveryTime()))
                                 .limit(4)
                                 .collect(Collectors.toList());
            }
        } catch (Exception e) {
            topRatedList = new ArrayList<Restaurant>();
            fastestList = new ArrayList<Restaurant>();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description"
    content="FoodRush - Order delicious food online from top restaurants near you. Fast delivery, fresh meals, and live order tracking.">
  <title>FoodRush — Delicious Food Delivered Fast</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
    rel="stylesheet">

  <!-- Font Awesome 6 Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- Core CSS Design System -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/home.css">
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

        <!-- Location Trigger (Opens Location Modal) -->
        <button type="button" class="location-trigger" title="Change Delivery Location">
          <span class="loc-icon"><i class="fa-solid fa-location-dot text-primary"></i></span>
          <span class="loc-text selected-location-text">Koramangala, Bangalore</span>
          <span class="loc-arrow"><i class="fa-solid fa-chevron-down" style="font-size: 10px;"></i></span>
        </button>
      </div>

      <!-- Center: Search Bar -->
      <div class="nav-search-bar">
        <span class="nav-search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
        <input type="text" class="nav-search-input" placeholder="Search for biryani, pizza, restaurant..."
          id="nav-search-input">
      </div>

      <!-- Right: Links, Cart & Auth -->
      <div class="nav-right">
        <nav aria-label="Main Navigation">
          <ul class="nav-menu-links">
            <li><a href="<%= request.getContextPath() %>/home" class="nav-link-item active">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/restaurants" class="nav-link-item">Restaurants</a></li>
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
             boolean isDriver = currentUser.getRole() != null && 
                    (currentUser.getRole().equalsIgnoreCase("Driver") || 
                     currentUser.getRole().equalsIgnoreCase("DRIVER") || 
                     currentUser.getRole().equalsIgnoreCase("Delivery_Partner"));
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
                   <span class="user-dropdown-role"><%= isAdmin ? "<i class='fa-solid fa-bolt text-primary'></i> Admin" : (isDriver ? "<i class='fa-solid fa-motorcycle text-warning'></i> Delivery Partner" : "FoodRush Member") %></span>
                 </div>
                 <hr class="user-dropdown-divider">
                 <a href="<%= request.getContextPath() %>/profile" role="menuitem">
                   <span><i class="fa-solid fa-user"></i></span> <span>My Profile</span>
                 </a>
                 <a href="<%= request.getContextPath() %>/orders" role="menuitem">
                   <span><i class="fa-solid fa-box"></i></span> <span>My Orders</span>
                 </a>
                 <% if (isDriver) { %>
                   <a href="<%= request.getContextPath() %>/driver/dashboard" role="menuitem" style="color: #F59E0B; font-weight: 600;">
                     <span><i class="fa-solid fa-motorcycle"></i></span> <span>Driver Portal</span>
                   </a>
                 <% } %>
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
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
            stroke-linecap="round" stroke-linejoin="round">
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
  <main class="main-content">

    <!-- Hero Section -->
    <section class="hero-section">
      <!-- Background Video (Autoplay, Loop, Muted) -->
      <video class="hero-bg-video" autoplay loop muted playsinline poster="<%= request.getContextPath() %>/frontend/public/hero-bg.png">
        <source src="<%= request.getContextPath() %>/frontend/public/background-video.mp4" type="video/mp4">
        <source src="<%= request.getContextPath() %>/frontend/public/background Video.mp4" type="video/mp4">
      </video>
      <div class="hero-video-overlay"></div>

      <div class="container hero-container">

        <!-- Hero Text & Search Box -->
        <div class="hero-content">
          <div class="hero-pill-tag">
            <span><i class="fa-solid fa-fire text-primary"></i></span> Superfast 30-min Delivery
          </div>

          <h1 class="hero-headline">
            Craving something delicious? <br>
            <span class="highlight">FoodRush</span> delivers it fast.
          </h1>

          <p class="hero-subtitle">
            Explore hundreds of top-rated restaurants, authentic cuisines, and street food favorites delivered fresh and
            hot right to your doorstep.
          </p>

          <!-- Hero Search Box -->
          <div class="hero-search-box">
            <div class="hero-location-select">
              <span><i class="fa-solid fa-location-dot text-primary"></i></span>
              <span class="selected-location-text">Koramangala</span>
              <span style="font-size: 10px; color: var(--color-text-muted);"><i class="fa-solid fa-chevron-down"></i></span>
            </div>

            <input type="text" id="hero-search-input" class="hero-input-field"
              placeholder="Search dish, cuisine, or restaurant...">

            <button type="button" class="btn btn-primary" onclick="window.location.href='<%= request.getContextPath() %>/restaurants?search=' + encodeURIComponent(document.getElementById('hero-search-input').value)">
              Find Food
            </button>
          </div>

          <!-- Quick Cuisine Suggestions -->
          <div class="hero-quick-tags">
            <span class="hero-tag-label">Popular searches:</span>
            <a href="<%= request.getContextPath() %>/restaurants?search=Biryani" class="hero-tag-pill">Biryani</a>
            <a href="<%= request.getContextPath() %>/restaurants?search=Pizza" class="hero-tag-pill">Pizza</a>
            <a href="<%= request.getContextPath() %>/restaurants?search=Burger" class="hero-tag-pill">Burgers</a>
            <a href="<%= request.getContextPath() %>/restaurants?search=Chinese" class="hero-tag-pill">Chinese</a>
            <a href="<%= request.getContextPath() %>/restaurants?search=South Indian" class="hero-tag-pill">South Indian</a>
          </div>
        </div>

      </div>
    </section>

    <!-- Cuisine Categories Carousel / Grid -->
    <section class="section">
      <div class="container">

        <div class="section-header">
          <div>
            <h2 class="section-title">Inspiration for your first order</h2>
            <p class="section-subtitle">Explore top curated cuisines from verified kitchens</p>
          </div>
          <a href="<%= request.getContextPath() %>/restaurants" class="section-link">
            See all categories <span><i class="fa-solid fa-arrow-right"></i></span>
          </a>
        </div>

        <div class="categories-grid">
          <!-- Category 1: Biryani -->
          <a href="<%= request.getContextPath() %>/restaurants?cuisine=biryani" class="category-card">
            <div class="category-avatar">
              <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=200&auto=format&fit=crop&q=80"
                alt="Biryani">
            </div>
            <span class="category-title">Biryani</span>
          </a>

          <!-- Category 2: Pizza -->
          <a href="<%= request.getContextPath() %>/restaurants?cuisine=italian" class="category-card">
            <div class="category-avatar">
              <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200&auto=format&fit=crop&q=80"
                alt="Pizza">
            </div>
            <span class="category-title">Pizza</span>
          </a>

          <!-- Category 3: Burgers -->
          <a href="<%= request.getContextPath() %>/restaurants?cuisine=burgers" class="category-card">
            <div class="category-avatar">
              <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&auto=format&fit=crop&q=80"
                alt="Burgers">
            </div>
            <span class="category-title">Burgers</span>
          </a>

          <!-- Category 4: North Indian -->
          <a href="<%= request.getContextPath() %>/restaurants?cuisine=north indian" class="category-card">
            <div class="category-avatar">
              <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=200&auto=format&fit=crop&q=80"
                alt="North Indian">
            </div>
            <span class="category-title">North Indian</span>
          </a>

          <!-- Category 5: South Indian -->
          <a href="<%= request.getContextPath() %>/restaurants?cuisine=south indian" class="category-card">
            <div class="category-avatar">
              <img src="https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=200&auto=format&fit=crop&q=80"
                alt="South Indian">
            </div>
            <span class="category-title">South Indian</span>
          </a>

          <!-- Category 6: Chinese -->
          <a href="<%= request.getContextPath() %>/restaurants?cuisine=chinese" class="category-card">
            <div class="category-avatar">
              <img src="https://images.unsplash.com/photo-1585032226651-759b368d7246?w=200&auto=format&fit=crop&q=80"
                alt="Chinese">
            </div>
            <span class="category-title">Chinese</span>
          </a>

          <!-- Category 7: Desserts -->
          <a href="<%= request.getContextPath() %>/restaurants?cuisine=desserts" class="category-card">
            <div class="category-avatar">
              <img src="https://images.unsplash.com/photo-1551024601-bec78aea704b?w=200&auto=format&fit=crop&q=80"
                alt="Desserts">
            </div>
            <span class="category-title">Desserts</span>
          </a>

          <!-- Category 8: Rolls & Wraps -->
          <a href="<%= request.getContextPath() %>/restaurants?cuisine=biryani" class="category-card">
            <div class="category-avatar">
              <img src="https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=200&auto=format&fit=crop&q=80"
                alt="Rolls & Wraps">
            </div>
            <span class="category-title">Rolls</span>
          </a>
        </div>

      </div>
    </section>

    <!-- Top Rated Near You Section (Dynamic from Database) -->
    <section class="section" id="restaurants-section" style="background-color: var(--color-surface-soft);">
      <div class="container">

        <div class="section-header">
          <div>
            <h2 class="section-title">Top Rated Restaurants Near You</h2>
            <p class="section-subtitle">Highest rated food spots loved by local customers</p>
          </div>
          <a href="<%= request.getContextPath() %>/restaurants" class="section-link">
            View all restaurants <span><i class="fa-solid fa-arrow-right"></i></span>
          </a>
        </div>

        <div class="grid grid-cols-4">

          <%
              if (topRatedList != null && !topRatedList.isEmpty()) {
                  for (Restaurant r : topRatedList) {
                      String img = (r.getImagePath() != null && !r.getImagePath().trim().isEmpty()) 
                                   ? r.getImagePath() 
                                   : request.getContextPath() + "/frontend/public/auth-food-showcase.jpg";
                      String cuisine = (r.getCuisineType() != null) ? r.getCuisineType() : "Multicuisine";
                      boolean isVeg = cuisine.toLowerCase().contains("pure veg") || cuisine.toLowerCase().contains("south indian");
          %>
          <!-- Dynamic Top Rated Restaurant Card -->
          <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= r.getRestaurantID() %>" class="restaurant-card">
            <div class="card-media">
              <img src="<%= img %>"
                alt="<%= r.getName() %>" class="card-img" onerror="this.src='<%= request.getContextPath() %>/frontend/public/auth-food-showcase.jpg'">
              <div class="card-overlay-badges">
                <% if (r.getRating() >= 4.7) { %>
                  <span class="badge badge-offer"><i class="fa-solid fa-star text-warning"></i> TOP RATED</span>
                <% } else if (isVeg) { %>
                  <span class="badge badge-offer" style="background: #2E8B57;"><i class="fa-solid fa-leaf text-success"></i> PURE VEG</span>
                <% } else { %>
                  <span class="badge badge-offer">50% OFF UPTO ₹100</span>
                <% } %>
                <span class="badge badge-rating"><i class="fa-solid fa-star text-warning"></i> <%= String.format("%.1f", r.getRating()) %></span>
              </div>
            </div>
            <div class="card-content">
              <div class="card-header">
                <h3 class="card-title"><%= r.getName() %></h3>
              </div>
              <p class="card-cuisine"><%= cuisine %></p>
              <div class="card-footer">
                <span class="card-eta"><i class="fa-solid fa-clock"></i> <%= r.getDeliveryTime() %> mins</span>
                <span class="card-price-two">View Menu <i class="fa-solid fa-arrow-right"></i></span>
              </div>
            </div>
          </a>
          <%
                  }
              } else {
          %>
            <!-- Fallback static preview if database is loading -->
            <a href="<%= request.getContextPath() %>/restaurants" class="restaurant-card">
              <div class="card-media">
                <img src="https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80"
                  alt="Royal Biryani Palace" class="card-img">
                <div class="card-overlay-badges">
                  <span class="badge badge-offer">50% OFF UPTO ₹100</span>
                  <span class="badge badge-rating"><i class="fa-solid fa-star text-warning"></i> 4.8</span>
                </div>
              </div>
              <div class="card-content">
                <div class="card-header">
                  <h3 class="card-title">Royal Biryani Palace</h3>
                </div>
                <p class="card-cuisine">Biryani, North Indian, Mughlai</p>
                <div class="card-footer">
                  <span class="card-eta"><i class="fa-solid fa-clock"></i> 30-35 mins</span>
                  <span class="card-price-two">₹350 for two</span>
                </div>
              </div>
            </a>
          <%
              }
          %>

        </div>

      </div>
    </section>

    <!-- Promotional Discount Banner -->
    <section class="section" style="padding-top: var(--space-8); padding-bottom: var(--space-8);">
      <div class="container">
        <div class="promo-banner">
          <div>
            <span class="promo-badge-tag">Special Offer</span>
            <h2 class="promo-title">Get 50% OFF on your first 3 orders!</h2>
            <p class="promo-desc">Use coupon code <strong style="color: var(--color-primary);">RUSH50</strong> during
              checkout to unlock maximum savings.</p>
          </div>
          <a href="<%= request.getContextPath() %>/restaurants" class="btn btn-primary btn-lg" style="text-decoration: none;">
            Claim Offer Now
          </a>
        </div>
      </div>
    </section>

    <!-- Fastest Delivery Section (Dynamic from Database) -->
    <section class="section" style="padding-top: var(--space-4);">
      <div class="container">

        <div class="section-header">
          <div>
            <h2 class="section-title"><i class="fa-solid fa-bolt-lightning text-primary"></i> Fastest Delivery</h2>
            <p class="section-subtitle">Speedy kitchens delivering in 25 minutes or less</p>
          </div>
          <a href="<%= request.getContextPath() %>/restaurants" class="section-link">
            See all quick bites <span><i class="fa-solid fa-arrow-right"></i></span>
          </a>
        </div>

        <div class="grid grid-cols-4">

          <%
              if (fastestList != null && !fastestList.isEmpty()) {
                  for (Restaurant r : fastestList) {
                      String img = (r.getImagePath() != null && !r.getImagePath().trim().isEmpty()) 
                                   ? r.getImagePath() 
                                   : request.getContextPath() + "/frontend/public/auth-food-showcase.jpg";
                      String cuisine = (r.getCuisineType() != null) ? r.getCuisineType() : "Fast Food, Street Food";
          %>
          <!-- Dynamic Fast Delivery Card -->
          <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= r.getRestaurantID() %>" class="restaurant-card">
            <div class="card-media">
              <img src="<%= img %>"
                alt="<%= r.getName() %>" class="card-img" onerror="this.src='<%= request.getContextPath() %>/frontend/public/auth-food-showcase.jpg'">
              <div class="card-overlay-badges">
                <span class="badge badge-eta"
                  style="background: #FFFFFF; font-weight: bold; color: var(--color-primary);"><i class="fa-solid fa-bolt-lightning text-primary"></i> <%= r.getDeliveryTime() %> mins</span>
                <span class="badge badge-rating"><i class="fa-solid fa-star text-warning"></i> <%= String.format("%.1f", r.getRating()) %></span>
              </div>
            </div>
            <div class="card-content">
              <div class="card-header">
                <h3 class="card-title"><%= r.getName() %></h3>
              </div>
              <p class="card-cuisine"><%= cuisine %></p>
              <div class="card-footer">
                <span class="card-eta"><i class="fa-solid fa-clock"></i> <%= r.getDeliveryTime() %> mins</span>
                <span class="card-price-two">View Menu <i class="fa-solid fa-arrow-right"></i></span>
              </div>
            </div>
          </a>
          <%
                  }
              }
          %>

        </div>

      </div>
    </section>

    <!-- Why FoodRush / Value Propositions -->
    <section class="section" style="background-color: var(--color-surface-soft); margin-top: var(--space-12);">
      <div class="container">

        <div class="section-header"
          style="justify-content: center; text-align: center; margin-bottom: var(--space-10);">
          <div>
            <h2 class="section-title">Why food lovers choose FoodRush</h2>
            <p class="section-subtitle">Experience lightning fast service with guaranteed freshness</p>
          </div>
        </div>

        <div class="value-props-grid">

          <div class="value-prop-card">
            <div class="value-icon-box"><i class="fa-solid fa-bolt-lightning text-primary"></i></div>
            <h3 class="value-card-title">Superfast Delivery</h3>
            <p class="value-card-desc">Our dedicated rush delivery fleet ensures your hot meals arrive in 30 minutes or
              less with insulated thermal packaging.</p>
          </div>

          <div class="value-prop-card">
            <div class="value-icon-box"><i class="fa-solid fa-shield-halved text-primary"></i></div>
            <h3 class="value-card-title">Hygiene & Safety Assured</h3>
            <p class="value-card-desc">Every partner kitchen adheres to rigorous quality and hygiene checks, maintaining
              zero-compromise safety standards.</p>
          </div>

          <div class="value-prop-card">
            <div class="value-icon-box"><i class="fa-solid fa-location-dot text-primary"></i></div>
            <h3 class="value-card-title">Real-Time Live Tracking</h3>
            <p class="value-card-desc">Know precisely when your food is placed, cooking in the kitchen, picked up, and
              arriving at your doorstep.</p>
          </div>

        </div>

      </div>
    </section>

  </main>

  <!-- =========================================================================
       3. Global Footer
       ========================================================================= -->
  <footer class="footer">
    <div class="container">

      <div class="footer-grid">

        <!-- Col 1: Brand Info -->
        <div>
          <div class="footer-brand-title">
            <span style="color: var(--color-primary);"><i class="fa-solid fa-bolt-lightning"></i></span> FoodRush
          </div>
          <p class="footer-brand-desc">
            FoodRush connects you with top local restaurants and favorite food spots with unmatched delivery speed and
            reliable convenience.
          </p>
          <div style="font-size: var(--font-size-body-sm); color: #888;">
            Made for foodies with <i class="fa-solid fa-heart" style="color: #ef4444;"></i>
          </div>
        </div>

        <!-- Col 2: Company -->
        <div>
          <h4 class="footer-col-title">Company</h4>
          <ul class="footer-links">
            <li><a href="#about" class="footer-link">About Us</a></li>
            <li><a href="#careers" class="footer-link">Careers</a></li>
            <li><a href="#team" class="footer-link">Team</a></li>
            <li><a href="#blog" class="footer-link">FoodRush Blog</a></li>
          </ul>
        </div>

        <!-- Col 3: For Foodies & Partners -->
        <div>
          <h4 class="footer-col-title">For You</h4>
          <ul class="footer-links">
            <li><a href="#partner" class="footer-link">Partner With Us</a></li>
            <li><a href="#ride" class="footer-link">Ride With Us</a></li>
            <li><a href="#privacy" class="footer-link">Privacy Policy</a></li>
            <li><a href="#terms" class="footer-link">Terms & Conditions</a></li>
          </ul>
        </div>

        <!-- Col 4: Contact & Help -->
        <div>
          <h4 class="footer-col-title">Get in Touch</h4>
          <p style="font-size: var(--font-size-body-sm); color: #B3B3B3; line-height: 1.6; margin-bottom: 12px;">
            Have questions or need support? Our 24/7 helpline is always ready to assist.
          </p>
          <button type="button" class="btn btn-outline btn-sm">
            <i class="fa-solid fa-headset"></i> 24/7 Support
          </button>
        </div>

      </div>

      <div class="footer-bottom">
        <div>© 2026 FoodRush Technologies Pvt Ltd. All rights reserved.</div>
        <div style="display: flex; gap: 16px;">
          <a href="#facebook" class="footer-link"><i class="fa-brands fa-facebook"></i> Facebook</a>
          <a href="#twitter" class="footer-link"><i class="fa-brands fa-x-twitter"></i> Twitter</a>
          <a href="#instagram" class="footer-link"><i class="fa-brands fa-instagram"></i> Instagram</a>
        </div>
      </div>

    </div>
  </footer>

  <!-- =========================================================================
       4. Popups & Modals (Vanilla JS Managed)
       ========================================================================= -->

  <!-- Modal 1: Location Picker Popup -->
  <div class="modal-overlay" id="location-modal" role="dialog" aria-modal="true" aria-labelledby="loc-modal-title">
    <div class="modal-dialog">
      <div class="modal-header">
        <h3 class="modal-title" id="loc-modal-title"><i class="fa-solid fa-location-dot text-primary"></i> Select Delivery Location</h3>
        <button type="button" class="modal-close-btn" aria-label="Close modal"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="modal-body">
        <p
          style="font-size: var(--font-size-body-sm); color: var(--color-text-secondary); margin-bottom: var(--space-4);">
          Choose your delivery area to see restaurant availability and exact delivery times.
        </p>

        <!-- Search Input -->
        <input type="text" class="nav-search-input" placeholder="Type city or locality (e.g. Indiranagar)"
          style="padding: 10px 16px; margin-bottom: var(--space-4);">

        <!-- Popular Locations List -->
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <button type="button" class="btn btn-secondary" style="justify-content: flex-start; text-align: left;">
            <i class="fa-solid fa-building text-primary" style="margin-right: 8px;"></i> <strong>Koramangala</strong>, Bangalore (Current)
          </button>
          <button type="button" class="btn btn-secondary" style="justify-content: flex-start; text-align: left;">
            <i class="fa-solid fa-location-dot text-primary" style="margin-right: 8px;"></i> <strong>Indiranagar</strong>, 100ft Road, Bangalore
          </button>
          <button type="button" class="btn btn-secondary" style="justify-content: flex-start; text-align: left;">
            <i class="fa-solid fa-location-dot text-primary" style="margin-right: 8px;"></i> <strong>HSR Layout</strong>, Sector 2, Bangalore
          </button>
          <button type="button" class="btn btn-secondary" style="justify-content: flex-start; text-align: left;">
            <i class="fa-solid fa-location-dot text-primary" style="margin-right: 8px;"></i> <strong>Whitefield</strong>, ITPL Main Rd, Bangalore
          </button>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary">Cancel</button>
      </div>
    </div>
  </div>

  <!-- Modal 2: Quick Sign In Modal -->
  <div class="modal-overlay" id="login-modal" role="dialog" aria-modal="true" aria-labelledby="login-modal-title">
    <div class="modal-dialog">
      <div class="modal-header">
        <h3 class="modal-title" id="login-modal-title">Welcome to FoodRush</h3>
        <button type="button" class="modal-close-btn" aria-label="Close modal"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="modal-body">
        <p
          style="font-size: var(--font-size-body-sm); color: var(--color-text-secondary); margin-bottom: var(--space-4);">
          Sign in with your email or phone to track your orders and manage saved addresses.
        </p>

        <form action="<%= request.getContextPath() %>/login" method="POST">
          <input type="hidden" name="action" value="login">
          <div style="margin-bottom: var(--space-3);">
            <label
              style="display: block; font-size: var(--font-size-caption); font-weight: bold; margin-bottom: 4px;">Email
              or Phone Number</label>
            <input type="text" name="email" class="nav-search-input" placeholder="e.g. amitabh.sen@gmail.com"
              style="padding: 10px 14px;" required>
          </div>

          <div style="margin-bottom: var(--space-4);">
            <label
              style="display: block; font-size: var(--font-size-caption); font-weight: bold; margin-bottom: 4px;">Password</label>
            <div class="password-input-wrapper" style="position: relative; display: flex; align-items: center; width: 100%;">
              <input type="password" id="index-modal-password" name="password" class="nav-search-input" placeholder="••••••••" style="padding: 10px 44px 10px 14px; width: 100%;" required>
              <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('index-modal-password', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-muted); font-size: 15px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;">
                <i class="fa-solid fa-eye" style="pointer-events: none;"></i>
              </button>
            </div>
          </div>

          <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">
            Continue to FoodRush
          </button>
        </form>
      </div>
      <div class="modal-footer" style="justify-content: center;">
        <span style="font-size: var(--font-size-caption); color: var(--color-text-secondary);">
          Don't have an account? <a href="<%= request.getContextPath() %>/login?tab=signup" class="text-brand font-semibold">Sign up</a>
        </span>
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
        <ul
          style="list-style: none; display: flex; flex-direction: column; gap: 16px; font-size: var(--font-size-body-lg); font-weight: 600;">
          <li><a href="<%= request.getContextPath() %>/home" class="text-brand"><i class="fa-solid fa-house"></i> Home</a></li>
          <li><a href="<%= request.getContextPath() %>/restaurants"><i class="fa-solid fa-utensils"></i> Restaurants</a></li>
          <li><a href="<%= request.getContextPath() %>/orders"><i class="fa-solid fa-box"></i> Orders</a></li>
          <li><a href="<%= request.getContextPath() %>/profile"><i class="fa-solid fa-user"></i> Profile</a></li>
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

  <!-- Vanilla JavaScript Handlers -->
  <script>
    window.FOODRUSH_CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js?v=<%= System.currentTimeMillis() %>"></script>
  <script src="<%= request.getContextPath() %>/frontend/js/home.js"></script>
</body>

</html>
