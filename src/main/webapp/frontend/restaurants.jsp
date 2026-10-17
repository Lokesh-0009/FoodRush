<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.foodRush.model.Restaurant, com.foodRush.model.Cart"%>
<%
    List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("restaurantList");
    int totalCount = (restaurantList != null) ? restaurantList.size() : 0;
    Cart sessionCart = (Cart) session.getAttribute("cart");
    int sessionCartCount = (sessionCart != null) ? sessionCart.getTotalCount() : 0;
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description"
    content="Explore and order food from top restaurants near you. Filter by cuisine, ratings, delivery time, and cost on FoodRush.">
  <title>All Restaurants — FoodRush</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
    rel="stylesheet">

  <!-- Font Awesome 6 Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- Design System CSS with Cache Busters -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css?v=6.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css?v=6.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css?v=6.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/restaurants.css?v=6.0">

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

        <!-- Location Trigger (Opens Location Modal) -->
        <button type="button" class="location-trigger"
          title="Change Delivery Location">
          <span class="loc-icon"><i class="fa-solid fa-location-dot text-primary"></i></span>
          <span class="loc-text selected-location-text">Koramangala, Bangalore</span>
          <span class="loc-arrow"><i class="fa-solid fa-chevron-down" style="font-size: 10px;"></i></span>
        </button>
      </div>

      <!-- Center: Search Bar -->
      <div class="nav-search-bar">
        <span class="nav-search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
        <input type="text" class="nav-search-input" placeholder="Search dish, cuisine, or restaurant..."
          id="listing-search-input">
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
  <main class="main-content section" style="padding-top: var(--space-4);">
    <div class="container">

      <!-- Breadcrumb Navigation -->
      <nav class="breadcrumb-nav" aria-label="Breadcrumb">
        <a href="<%= request.getContextPath() %>/home" class="breadcrumb-link">Home</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Restaurants in Bangalore</span>
      </nav>

      <!-- Listing Page Header -->
      <div class="listing-header">
        <div class="listing-header-top">
          <div class="listing-title-wrap">
            <h1 class="heading-1">Restaurants with online food delivery in Bangalore</h1>
            <p class="section-subtitle" id="restaurant-result-count">Showing <%= totalCount %> restaurants</p>
          </div>
        </div>

        <!-- Swiggy-Style Top Filter & Sort Pill Bar -->
        <div class="top-filter-bar">
          
          <!-- (1) Filter Button (Opens Image 4 Multi-Tab Modal) -->
          <button type="button" class="filter-pill-btn filter-main-btn" id="open-filter-modal-btn">
            <span class="filter-count-badge" id="active-filter-badge">1</span>
            <span>Filter</span>
            <span style="font-size: 13px;"><i class="fa-solid fa-sliders"></i></span>
          </button>

          <!-- (2) Sort By Dropdown -->
          <div class="filter-dropdown-wrap">
            <button type="button" class="filter-pill-btn" id="sort-pill-btn">
              <span id="sort-pill-label">Sort By</span>
              <span class="pill-arrow"><i class="fa-solid fa-chevron-down" style="font-size: 10px;"></i></span>
            </button>
            <div class="filter-dropdown-menu" id="sort-dropdown-menu" style="display: none;">
              <label class="filter-dropdown-item"><input type="radio" name="quick-sort" value="default" checked> <span>Relevance (Default)</span></label>
              <label class="filter-dropdown-item"><input type="radio" name="quick-sort" value="delivery-asc"> <span>Delivery Time</span></label>
              <label class="filter-dropdown-item"><input type="radio" name="quick-sort" value="rating-desc"> <span>Rating: High to Low</span></label>
              <label class="filter-dropdown-item"><input type="radio" name="quick-sort" value="price-asc"> <span>Cost: Low to High</span></label>
              <label class="filter-dropdown-item"><input type="radio" name="quick-sort" value="price-desc"> <span>Cost: High to Low</span></label>
            </div>
          </div>

          <!-- (3) Rush Delivery -->
          <button type="button" class="filter-pill-btn" id="pill-rush-delivery">
            <span><i class="fa-solid fa-bolt-lightning text-primary"></i> Rush Delivery</span>
          </button>

          <!-- (4) Offers -->
          <button type="button" class="filter-pill-btn" id="pill-offers">
            <span>Offers</span>
          </button>

          <!-- (5) Ratings 4.0+ -->
          <button type="button" class="filter-pill-btn" id="pill-rating-4">
            <span>Ratings 4.0+</span>
          </button>

          <!-- (6) Rs. 300 - Rs. 600 -->
          <button type="button" class="filter-pill-btn" id="pill-price-mid">
            <span>Rs. 300-Rs. 600</span>
          </button>

          <!-- (7) Less than Rs. 300 -->
          <button type="button" class="filter-pill-btn" id="pill-price-low">
            <span>Less than Rs. 300</span>
          </button>

          <!-- (8) Pure Veg -->
          <button type="button" class="filter-pill-btn" id="pill-pure-veg">
            <span><i class="fa-solid fa-leaf text-success"></i> Pure Veg</span>
          </button>

          <!-- (9) Non Veg -->
          <button type="button" class="filter-pill-btn" id="pill-non-veg">
            <span><i class="fa-solid fa-drumstick-bite text-primary"></i> Non Veg</span>
          </button>

          <!-- (10) Cuisines Dropdown -->
          <div class="filter-dropdown-wrap">
            <button type="button" class="filter-pill-btn" id="cuisine-pill-btn">
              <span>Cuisines</span>
              <span class="pill-arrow"><i class="fa-solid fa-chevron-down" style="font-size: 10px;"></i></span>
            </button>
            <div class="filter-dropdown-menu" id="cuisine-dropdown-menu" style="display: none;">
              <label class="filter-dropdown-item"><input type="checkbox" value="biryani" class="top-cuisine-checkbox"> <span>Biryani</span></label>
              <label class="filter-dropdown-item"><input type="checkbox" value="north indian" class="top-cuisine-checkbox"> <span>North Indian</span></label>
              <label class="filter-dropdown-item"><input type="checkbox" value="south indian" class="top-cuisine-checkbox"> <span>South Indian</span></label>
              <label class="filter-dropdown-item"><input type="checkbox" value="chinese" class="top-cuisine-checkbox"> <span>Chinese & Asian</span></label>
              <label class="filter-dropdown-item"><input type="checkbox" value="italian" class="top-cuisine-checkbox"> <span>Italian & Pizzas</span></label>
              <label class="filter-dropdown-item"><input type="checkbox" value="burgers" class="top-cuisine-checkbox"> <span>Burgers & Fast Food</span></label>
              <label class="filter-dropdown-item"><input type="checkbox" value="desserts" class="top-cuisine-checkbox"> <span>Desserts & Sweets</span></label>
              <label class="filter-dropdown-item"><input type="checkbox" value="seafood" class="top-cuisine-checkbox"> <span>Seafood & Coastal</span></label>
            </div>
          </div>

        </div>

        <!-- Active Filter Chips Display -->
        <div class="active-filters-bar" id="active-filter-chips-wrap"></div>
      </div>

      <!-- Main Layout: Full-Width 4-Column Restaurant Grid -->
      <div class="restaurants-full-container">
        <div class="restaurants-grid-4cols grid-cols-4" id="restaurant-grid-container" style="display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 22px; width: 100%;">

          <%
              if (restaurantList != null && !restaurantList.isEmpty()) {
                  for (Restaurant r : restaurantList) {
                      String img = (r.getImagePath() != null && !r.getImagePath().trim().isEmpty()) 
                                   ? r.getImagePath() 
                                   : request.getContextPath() + "/frontend/public/auth-food-showcase.jpg";
                      String cuisine = (r.getCuisineType() != null) ? r.getCuisineType() : "Multicuisine";
                      boolean isVeg = cuisine.toLowerCase().contains("pure veg") || cuisine.toLowerCase().contains("south indian");
          %>
            <!-- Dynamic Restaurant Card (4 Per Row) -->
            <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= r.getRestaurantID() %>" class="restaurant-card restaurant-listing-card"
              data-cuisine="<%= cuisine.toLowerCase() %>" 
              data-rating="<%= r.getRating() %>" 
              data-veg="<%= isVeg %>" 
              data-delivery-time="<%= r.getDeliveryTime() %>"
              data-name="<%= r.getName() %>">
              <div class="card-media">
                <img src="<%= img %>"
                  alt="<%= r.getName() %>" class="card-img" onerror="this.src='<%= request.getContextPath() %>/frontend/public/auth-food-showcase.jpg'">
                <div class="card-overlay-badges">
                  <% if (r.getRating() >= 4.7) { %>
                    <span class="badge badge-offer"><i class="fa-solid fa-star text-warning"></i> TOP RATED</span>
                  <% } else if (isVeg) { %>
                    <span class="badge badge-offer" style="background: #2E8B57;"><i class="fa-solid fa-leaf text-success"></i> PURE VEG</span>
                  <% } else { %>
                    <span class="badge badge-offer"><i class="fa-solid fa-bolt-lightning text-primary"></i> RUSH DELIVERY</span>
                  <% } %>
                  <span class="badge badge-rating"><i class="fa-solid fa-star text-warning"></i> <%= String.format("%.1f", r.getRating()) %></span>
                </div>
              </div>
              <div class="card-content">
                <div class="card-header">
                  <h3 class="card-title"><%= r.getName() %></h3>
                </div>
                <p class="card-cuisine"><%= cuisine %></p>
                <p class="card-address">
                  <i class="fa-solid fa-location-dot text-primary"></i> <%= (r.getAddress() != null) ? r.getAddress() : "Bangalore" %>
                </p>
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
            <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px;">
              <div style="font-size: 48px; margin-bottom: 16px; color: var(--color-text-muted);"><i class="fa-solid fa-utensils"></i></div>
              <h2 style="font-size: var(--font-size-h2); font-weight: 700; margin-bottom: 8px;">No Restaurants Found</h2>
              <p style="color: var(--color-text-secondary); font-size: var(--font-size-body);">Please check back soon or ensure database data is populated.</p>
            </div>
          <%
              }
          %>

          </div>

        <!-- Empty State (Shown when no restaurants match filter) -->
        <div class="empty-state" id="listing-empty-state">
          <div class="empty-state-icon" style="color: var(--color-text-muted);"><i class="fa-solid fa-utensils fa-2x"></i></div>
          <h3 class="empty-state-title">No restaurants found</h3>
          <p class="empty-state-desc">We couldn't find any food spots matching your active filters. Try adjusting or clearing your filters.</p>
          <button type="button" class="btn btn-primary" onclick="document.getElementById('modal-clear-all-btn').click();">Reset All Filters</button>
        </div>

      </div>

    </div>
  </main>

  <!-- =========================================================================
       3. Modals & Drawers
       ========================================================================= -->

  <!-- Swiggy-Style Multi-Tab Filter Modal (Image 4 Design) -->
  <div class="modal-overlay" id="filter-modal" role="dialog" aria-modal="true" aria-labelledby="filter-modal-title">
    <div class="modal-dialog filter-modal-dialog">
      <div class="modal-header">
        <h3 class="modal-title" id="filter-modal-title">Filter</h3>
        <button type="button" class="modal-close-btn" id="close-filter-modal-btn" aria-label="Close filter modal"><i class="fa-solid fa-xmark"></i></button>
      </div>
      
      <div class="filter-modal-body">
        <!-- Left Navigation Tabs -->
        <div class="filter-tabs-col">
          <button type="button" class="filter-tab-link active" data-target-tab="tab-sort">
            <span>Sort</span>
          </button>
          <button type="button" class="filter-tab-link" data-target-tab="tab-delivery">
            <span>15-25 mins</span>
          </button>
          <button type="button" class="filter-tab-link" data-target-tab="tab-offers">
            <span>Offers</span>
          </button>
          <button type="button" class="filter-tab-link" data-target-tab="tab-ratings">
            <span>Ratings</span>
          </button>
          <button type="button" class="filter-tab-link" data-target-tab="tab-cost">
            <span>Cost for two</span>
          </button>
          <button type="button" class="filter-tab-link" data-target-tab="tab-veg">
            <span>Veg / Non-Veg</span>
          </button>
          <button type="button" class="filter-tab-link" data-target-tab="tab-cuisines">
            <span>Cuisines</span>
          </button>
        </div>

        <!-- Right Panes -->
        <div class="filter-content-col">
          <!-- 1. Sort Pane -->
          <div class="filter-tab-pane active" id="tab-sort">
            <div class="filter-pane-title">SORT BY</div>
            <label class="filter-modal-option"><input type="radio" name="modal-sort" value="default" checked> <span>Relevance (Default)</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-sort" value="delivery-asc"> <span>Delivery Time</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-sort" value="rating-desc"> <span>Rating</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-sort" value="price-asc"> <span>Cost: Low to High</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-sort" value="price-desc"> <span>Cost: High to Low</span></label>
          </div>

          <!-- 2. Delivery Time Pane -->
          <div class="filter-tab-pane" id="tab-delivery">
            <div class="filter-pane-title">DELIVERY TIME</div>
            <label class="filter-modal-option"><input type="radio" name="modal-delivery" value="999" checked> <span>All Delivery Times</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-delivery" value="25"> <span><i class="fa-solid fa-bolt-lightning text-primary"></i> Rush Delivery (&lt; 30 mins)</span></label>
          </div>

          <!-- 3. Offers Pane -->
          <div class="filter-tab-pane" id="tab-offers">
            <div class="filter-pane-title">SPECIAL OFFERS</div>
            <label class="filter-modal-option"><input type="checkbox" id="modal-offers-toggle"> <span>Restaurants with Discounts & Offers</span></label>
          </div>

          <!-- 4. Ratings Pane -->
          <div class="filter-tab-pane" id="tab-ratings">
            <div class="filter-pane-title">RATINGS</div>
            <label class="filter-modal-option"><input type="radio" name="modal-rating" value="0" checked> <span>All Ratings</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-rating" value="4.5"> <span>Ratings 4.5+ <i class="fa-solid fa-star text-warning"></i></span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-rating" value="4.0"> <span>Ratings 4.0+ <i class="fa-solid fa-star text-warning"></i></span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-rating" value="3.5"> <span>Ratings 3.5+ <i class="fa-solid fa-star text-warning"></i></span></label>
          </div>

          <!-- 5. Cost for Two Pane -->
          <div class="filter-tab-pane" id="tab-cost">
            <div class="filter-pane-title">COST FOR TWO</div>
            <label class="filter-modal-option"><input type="radio" name="modal-cost" value="all" checked> <span>Any Cost</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-cost" value="0-300"> <span>Less than ₹300</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-cost" value="300-600"> <span>₹300 - ₹600</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-cost" value="600-9999"> <span>Greater than ₹600</span></label>
          </div>

          <!-- 6. Veg / Non-Veg Pane -->
          <div class="filter-tab-pane" id="tab-veg">
            <div class="filter-pane-title">VEG / NON-VEG</div>
            <label class="filter-modal-option"><input type="radio" name="modal-diet" value="all" checked> <span>All Options</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-diet" value="veg"> <span><i class="fa-solid fa-leaf text-success"></i> Pure Veg Only</span></label>
            <label class="filter-modal-option"><input type="radio" name="modal-diet" value="nonveg"> <span><i class="fa-solid fa-drumstick-bite text-primary"></i> Non-Veg Only</span></label>
          </div>

          <!-- 7. Cuisines Pane -->
          <div class="filter-tab-pane" id="tab-cuisines">
            <div class="filter-pane-title">CUISINES</div>
            <div class="modal-cuisines-grid">
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="biryani"> <span>Biryani</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="north indian"> <span>North Indian</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="south indian"> <span>South Indian</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="chinese"> <span>Chinese & Asian</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="italian"> <span>Italian & Pizzas</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="burgers"> <span>Burgers & Fast Food</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="desserts"> <span>Desserts & Sweets</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="seafood"> <span>Seafood & Coastal</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="healthy"> <span>Healthy & Salads</span></label>
              <label class="filter-modal-option"><input type="checkbox" class="modal-cuisine-checkbox" value="beverages"> <span>Beverages & Cafe</span></label>
            </div>
          </div>
        </div>
      </div>

      <div class="filter-modal-footer">
        <button type="button" class="clear-filters-link" id="modal-clear-all-btn">Clear Filters</button>
        <button type="button" class="btn btn-primary" id="modal-apply-filters-btn" style="padding: 10px 24px;">Apply</button>
      </div>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Vanilla JavaScript Handlers -->
  <script>
    window.FOODRUSH_CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js?v=5.1"></script>
  <script src="<%= request.getContextPath() %>/frontend/js/restaurants.js?v=5.1"></script>
</body>

</html>
