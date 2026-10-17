<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection, com.foodRush.model.Cart, com.foodRush.model.CartItem"%>
<%
    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }
    if (cart == null) {
        cart = new Cart();
    }

    boolean isEmpty = cart.isEmpty();
    double itemTotal = cart.getItemTotal();
    double deliveryFee = cart.getDeliveryFee();
    double platformFee = cart.getPlatformFee();
    double gstTax = cart.getGstTax();
    double discount = cart.getDiscountAmount();
    double grandTotal = cart.getGrandTotal();
    int totalCount = cart.getTotalCount();
    String resName = (cart.getRestaurantName() != null && !cart.getRestaurantName().isEmpty()) 
                     ? cart.getRestaurantName() 
                     : "Your Selected Restaurant";
    int resId = cart.getRestaurantID() > 0 ? cart.getRestaurantID() : 1;

    boolean isFreeDelivery = itemTotal >= 400;
    int remainingForFreeDelivery = (int) Math.max(0, 400 - itemTotal);
    int freeDeliveryPercent = (int) Math.min(100, Math.round((itemTotal / 400.0) * 100));
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Review your FoodRush order cart, apply discount coupons, and proceed to secure checkout.">
  <title>Your Cart (<%= totalCount %> items) — FoodRush</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Core CSS Design System & Font Awesome 6 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/cart.css">

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

      <!-- Right: Links, Cart & Auth -->
      <div class="nav-right">
        <nav aria-label="Main Navigation">
          <ul class="nav-menu-links">
            <li><a href="<%= request.getContextPath() %>/home" class="nav-link-item">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/restaurants" class="nav-link-item">Restaurants</a></li>
            <li><a href="<%= request.getContextPath() %>/orders" class="nav-link-item">Orders</a></li>
          </ul>
        </nav>

        <!-- Theme Toggle Button (Light / Dark Mode) -->
        <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
          <span class="theme-icon sun-icon"><i class="fa-solid fa-sun"></i></span>
          <span class="theme-icon moon-icon"><i class="fa-solid fa-moon"></i></span>
        </button>

        <!-- Cart Button (Active) -->
        <a href="<%= request.getContextPath() %>/cart" class="nav-cart-btn" style="background-color: var(--color-primary-soft); color: var(--color-primary);" title="View Cart">
          <span><i class="fa-solid fa-bag-shopping"></i></span>
          <span>Cart</span>
          <span class="cart-count<%= totalCount <= 0 ? " is-empty" : "" %>" data-count="<%= totalCount %>" style="<%= totalCount <= 0 ? "display: none;" : "" %>"><%= totalCount > 0 ? totalCount : "" %></span>
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
        <a href="<%= request.getContextPath() %>/restaurants" class="breadcrumb-link">Restaurants</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Your Cart</span>
      </nav>

      <h1 class="heading-1" style="margin-bottom: var(--space-4);">Your Order Cart</h1>

      <!-- Main 2-Column Cart Layout -->
      <div class="cart-layout" id="cart-main-layout" style="<%= isEmpty ? "display: none;" : "display: grid;" %>">
        
        <!-- Left: Selected Restaurant & Item List -->
        <div>
          <!-- Free Delivery Incentive Progress Card -->
          <div class="free-delivery-card">
            <div class="free-delivery-header">
              <div class="free-delivery-icon"><i class="fa-solid fa-truck-fast text-primary"></i></div>
              <div>
                <div class="free-delivery-title">
                  <% if (isFreeDelivery) { %>
                    <i class="fa-solid fa-circle-check text-success" style="margin-right: 4px;"></i> <strong>Congratulations!</strong> You unlocked <strong>FREE Delivery!</strong>
                  <% } else { %>
                    Add <strong>₹<%= remainingForFreeDelivery %></strong> more to unlock <strong>FREE Delivery!</strong>
                  <% } %>
                </div>
                <div class="free-delivery-sub">
                  <%= isFreeDelivery ? "You saved ₹40 delivery fee on this order" : "Save ₹40 delivery partner charges by adding items worth ₹400" %>
                </div>
              </div>
            </div>
            <div class="free-delivery-bar-track">
              <div class="free-delivery-bar-fill" style="width: <%= freeDeliveryPercent %>%;"></div>
            </div>
          </div>

          <div class="cart-card">
            
            <!-- Restaurant Info Header -->
            <div class="cart-restaurant-header" style="display: flex; align-items: center; justify-content: space-between;">
              <div style="display: flex; align-items: center; gap: var(--space-4);">
                <div style="font-size: 28px; background: var(--color-primary-soft); border-radius: var(--radius-md); padding: 8px 12px; display: flex; align-items: center; color: var(--color-primary);"><i class="fa-solid fa-utensils"></i></div>
                <div>
                  <h2 class="cart-restaurant-title" id="cart-restaurant-heading"><%= resName %></h2>
                  <p class="cart-restaurant-loc"><i class="fa-solid fa-location-dot text-primary" style="margin-right: 4px;"></i> Bangalore • Est. Delivery in 30-35 mins</p>
                </div>
              </div>
              <button type="button" class="btn btn-outline btn-sm" style="color: var(--color-error); border-color: rgba(239, 68, 68, 0.4); border-radius: var(--radius-pill); font-size: 12px; padding: 6px 12px;" onclick="clearCart()">
                <i class="fa-solid fa-trash-can" style="margin-right: 4px;"></i> Clear Cart
              </button>
            </div>

            <!-- Items Container -->
            <div class="cart-items-list" id="cart-items-container">
              <%
                  if (!isEmpty) {
                      for (CartItem item : cart.getCartItems()) {
                          String itemImg = (item.getImagePath() != null && !item.getImagePath().trim().isEmpty())
                                           ? item.getImagePath()
                                           : request.getContextPath() + "/frontend/public/auth-food-showcase.jpg";
              %>
                <!-- Dynamic Cart Item Row -->
                <div class="cart-item-row" data-id="<%= item.getMenuID() %>">
                  <div class="cart-item-main">
                    <img src="<%= itemImg %>" alt="<%= item.getItemName() %>" class="cart-item-thumb" onerror="this.src='<%= request.getContextPath() %>/frontend/public/auth-food-showcase.jpg'">
                    <div class="cart-item-details">
                      <span class="cart-item-name"><%= item.isVeg() ? "<i class=\"fa-solid fa-leaf text-success\" style=\"margin-right: 4px;\"></i>" : "<i class=\"fa-solid fa-drumstick-bite text-primary\" style=\"margin-right: 4px;\"></i>" %><%= item.getItemName() %></span>
                      <span class="cart-item-unit-price">₹<%= (int) item.getUnitPrice() %></span>
                    </div>
                  </div>
                  <div class="cart-item-actions">
                    <div class="qty-stepper active" style="display: flex; align-items: center; border: 1px solid var(--color-primary); border-radius: var(--radius-sm); overflow: hidden;">
                      <button type="button" class="qty-btn" style="padding: 4px 10px; background: none; border: none; font-weight: bold; color: var(--color-primary); cursor: pointer;" onclick="updateCartItem(<%= item.getMenuID() %>, <%= item.getQuantity() - 1 %>)">−</button>
                      <span class="qty-val" style="padding: 0 8px; font-weight: bold; font-size: 13px;"><%= item.getQuantity() %></span>
                      <button type="button" class="qty-btn" style="padding: 4px 10px; background: none; border: none; font-weight: bold; color: var(--color-primary); cursor: pointer;" onclick="updateCartItem(<%= item.getMenuID() %>, <%= item.getQuantity() + 1 %>)">+</button>
                    </div>
                    <span class="cart-item-total">₹<%= (int) item.getItemTotal() %></span>
                    <button type="button" class="btn-remove-item" title="Remove item" onclick="removeCartItem(<%= item.getMenuID() %>)"><i class="fa-solid fa-trash-can"></i></button>
                  </div>
                </div>
              <%
                      }
                  }
              %>
            </div>

            <!-- Add More Items Link -->
            <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= resId %>" class="add-more-items-link">
              <span><i class="fa-solid fa-plus" style="margin-right: 6px;"></i></span> Add more items from <%= resName %>
            </a>

          </div>

          <!-- Suggested Add-ons (Upsell) -->
          <div class="cart-card">
            <h3 class="addon-title">Complete your meal with delicious extras</h3>
            
            <div class="addon-grid">
              
              <!-- Add-on 1 -->
              <div class="addon-card">
                <div>
                  <div class="addon-info-name">Extra Mirchi Salan</div>
                  <div class="addon-info-price">₹40</div>
                </div>
                <button type="button" class="btn btn-outline btn-sm" onclick="addAddonItem(991, 'Extra Mirchi Salan', 40)">
                  + Add
                </button>
              </div>

              <!-- Add-on 2 -->
              <div class="addon-card">
                <div>
                  <div class="addon-info-name">Chilled Sweet Lassi</div>
                  <div class="addon-info-price">₹60</div>
                </div>
                <button type="button" class="btn btn-outline btn-sm" onclick="addAddonItem(992, 'Chilled Sweet Lassi', 60)">
                  + Add
                </button>
              </div>

              <!-- Add-on 3 -->
              <div class="addon-card">
                <div>
                  <div class="addon-info-name">Mint Onion Raita</div>
                  <div class="addon-info-price">₹30</div>
                </div>
                <button type="button" class="btn btn-outline btn-sm" onclick="addAddonItem(993, 'Mint Onion Raita', 30)">
                  + Add
                </button>
              </div>

            </div>
          </div>

          <!-- Cooking & Delivery Instructions with Quick Tags -->
          <div class="cart-card cart-instructions-box">
            <h3 class="addon-title">Delivery Instructions & Preferences</h3>
            <div class="delivery-tags-grid">
              <label class="instruction-tag-pill">
                <input type="checkbox" name="delivery_tag" value="no-bell">
                <span class="tag-content"><i class="fa-solid fa-bell-slash" style="margin-right: 6px;"></i> Avoid calling / Don't ring bell</span>
              </label>
              <label class="instruction-tag-pill">
                <input type="checkbox" name="delivery_tag" value="leave-door" checked>
                <span class="tag-content"><i class="fa-solid fa-door-open" style="margin-right: 6px;"></i> Leave at the door</span>
              </label>
              <label class="instruction-tag-pill">
                <input type="checkbox" name="delivery_tag" value="leave-guard">
                <span class="tag-content"><i class="fa-solid fa-user-shield" style="margin-right: 6px;"></i> Leave with guard</span>
              </label>
            </div>
            <input type="text" class="instruction-input" placeholder="Add custom notes (e.g. Landmark, spicy level, gate code)..." style="margin-top: 14px;">
          </div>

        </div>

        <!-- Right: Sticky Order Summary & Coupon -->
        <aside class="cart-summary-sidebar">
          
          <!-- Coupon Application Box -->
          <div class="coupon-box">
            <div class="coupon-title">
              <span><i class="fa-solid fa-ticket text-primary" style="margin-right: 6px;"></i></span> Apply Discount Coupon
            </div>
            
            <div class="coupon-input-group">
              <input type="text" id="coupon-input-field" class="coupon-input" placeholder="Enter coupon code (e.g. RUSH50)" value="<%= cart.getCouponCode() != null ? cart.getCouponCode() : "" %>">
              <button type="button" class="btn btn-primary btn-sm" id="btn-apply-coupon">Apply</button>
            </div>

            <!-- Applied Coupon Status Indicator -->
            <div class="applied-coupon-pill" id="applied-coupon-display" style="<%= discount > 0 ? "display: flex;" : "display: none;" %>">
              <span id="applied-coupon-code-text"><%= cart.getCouponCode() %> Applied (-₹<%= (int)discount %>)</span>
              <button type="button" style="background:none; border:none; color:var(--color-error); cursor:pointer; font-weight:bold;" onclick="removeCoupon()"><i class="fa-solid fa-xmark"></i></button>
            </div>

            <div style="font-size: 11px; color: var(--color-text-muted); margin-top: 8px;">
              Tip: Use <strong>RUSH50</strong> for ₹50 off, or <strong>FEAST100</strong> for ₹100 off!
            </div>
          </div>

          <!-- Bill Details Summary -->
          <div class="bill-summary-card">
            <h2 class="bill-title">Bill Details</h2>

            <div class="bill-row">
              <span>Item Total</span>
              <span id="bill-item-total">₹<%= (int) itemTotal %></span>
            </div>

            <div class="bill-row">
              <span>Delivery Partner Fee</span>
              <span id="bill-delivery-fee" style="<%= isFreeDelivery ? "color: var(--color-success); font-weight: bold;" : "" %>">
                <%= isFreeDelivery ? "FREE" : "₹" + (int) deliveryFee %>
              </span>
            </div>

            <div class="bill-row">
              <span>Platform Fee</span>
              <span id="bill-platform-fee">₹<%= (int) platformFee %></span>
            </div>

            <div class="bill-row">
              <span>GST & Restaurant Taxes (5%)</span>
              <span id="bill-taxes">₹<%= (int) gstTax %></span>
            </div>

            <!-- Discount Row (Dynamic) -->
            <div class="bill-row discount" id="bill-discount-row" style="<%= discount > 0 ? "display: flex;" : "display: none;" %>">
              <span>Coupon Discount</span>
              <span id="bill-discount-val">-₹<%= (int) discount %></span>
            </div>

            <div class="bill-divider"></div>

            <div class="bill-row-grand">
              <span>To Pay</span>
              <span class="total-val" id="bill-grand-total">₹<%= (int) grandTotal %></span>
            </div>

            <p class="cancellation-note">
              <i class="fa-solid fa-shield-halved text-success" style="margin-right: 4px;"></i> 100% Secure Checkout. Free cancellation available within 60 seconds of placing order.
            </p>

            <!-- Proceed to Checkout Action -->
            <a href="<%= request.getContextPath() %>/checkout" class="btn btn-primary btn-lg" id="btn-proceed-checkout" style="width: 100%; text-decoration: none;">
              Proceed to Checkout →
            </a>
          </div>

        </aside>

      </div>

      <!-- Empty Cart View (Shown when cart is empty) -->
      <div class="cart-empty-view <%= isEmpty ? "visible" : "" %>" id="cart-empty-state" style="<%= isEmpty ? "display: block;" : "display: none;" %>">
        <div class="cart-empty-icon"><i class="fa-solid fa-bag-shopping"></i></div>
        <h2 class="cart-empty-title">Your cart is empty</h2>
        <p class="cart-empty-desc">Explore top-rated restaurants and add delicious dishes to satisfy your cravings.</p>
        <a href="<%= request.getContextPath() %>/restaurants" class="btn btn-primary btn-lg">
          Explore Restaurants
        </a>
      </div>

    </div>
  </main>

  <!-- =========================================================================
       3. Global Footer
       ========================================================================= -->
  <footer class="footer">
    <div class="container">
      <div class="footer-grid">
        <div>
          <div class="footer-brand-title"><i class="fa-solid fa-bolt-lightning text-primary" style="margin-right: 4px;"></i> FoodRush</div>
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
            <i class="fa-solid fa-headset" style="margin-right: 6px;"></i> 24/7 Support
          </button>
        </div>
      </div>
      <div class="footer-bottom">
        <div>© 2026 FoodRush Technologies Pvt Ltd. All rights reserved.</div>
      </div>
    </div>
  </footer>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Cart Management JavaScript -->
  <script>
    var contextPath = '<%= request.getContextPath() %>';
    window.FOODRUSH_CONTEXT_PATH = contextPath;

    // Synchronize client localStorage from authoritative server session cart
    (function syncStorageFromSession() {
      try {
        var serverIsEmpty = <%= isEmpty %>;
        if (serverIsEmpty) {
          localStorage.removeItem('foodrush_cart');
          localStorage.removeItem('foodrush_cart_restaurant');
        } else {
          <%
            StringBuilder jsonCartBuilder = new StringBuilder("[");
            if (!isEmpty) {
              int idx = 0;
              for (CartItem ci : cart.getCartItems()) {
                if (idx > 0) jsonCartBuilder.append(",");
                jsonCartBuilder.append(String.format("{\"id\":\"item-%d\",\"menuid\":\"%d\",\"name\":\"%s\",\"price\":%d,\"qty\":%d,\"restaurantId\":\"%d\",\"restaurantName\":\"%s\"}",
                  ci.getMenuID(), ci.getMenuID(), ci.getItemName().replace("\"", "\\\""), (int)ci.getUnitPrice(), ci.getQuantity(), ci.getRestaurantID(), cart.getRestaurantName() != null ? cart.getRestaurantName().replace("\"", "\\\"") : ""));
                idx++;
              }
            }
            jsonCartBuilder.append("]");
          %>
          var serverCart = <%= jsonCartBuilder.toString() %>;
          localStorage.setItem('foodrush_cart', JSON.stringify(serverCart));
          localStorage.setItem('foodrush_cart_restaurant', JSON.stringify({
            restaurantId: '<%= cart.getRestaurantID() %>',
            restaurantName: '<%= cart.getRestaurantName() != null ? cart.getRestaurantName().replace("'", "\\'") : "" %>'
          }));
        }
        if (window.FoodRush && typeof window.FoodRush.updateCartBadgeDisplay === 'function') {
          window.FoodRush.updateCartBadgeDisplay();
        }
      } catch (err) {
        console.warn('Storage sync error:', err);
      }
    })();

    function updateCartItem(menuId, quantity) {
      if (quantity <= 0) {
        removeCartItem(menuId);
        return;
      }
      var updateUrl = contextPath + '/cart?action=update&menuId=' + menuId + '&quantity=' + quantity + '&format=json';
      fetch(updateUrl)
        .then(function (res) { return res.json(); })
        .then(function (data) {
          if (data.success) {
            if (data.totalCount === 0) {
              localStorage.removeItem('foodrush_cart');
              localStorage.removeItem('foodrush_cart_restaurant');
            }
            window.location.reload();
          }
        })
        .catch(function (err) {
          window.location.href = contextPath + '/cart?action=update&menuId=' + menuId + '&quantity=' + quantity;
        });
    }

    function removeCartItem(menuId) {
      var removeUrl = contextPath + '/cart?action=remove&menuId=' + menuId + '&format=json';
      fetch(removeUrl)
        .then(function (res) { return res.json(); })
        .then(function (data) {
          if (data.success) {
            if (data.totalCount === 0) {
              localStorage.removeItem('foodrush_cart');
              localStorage.removeItem('foodrush_cart_restaurant');
            }
            window.location.reload();
          }
        })
        .catch(function (err) {
          window.location.href = contextPath + '/cart?action=remove&menuId=' + menuId;
        });
    }

    function addAddonItem(addonId, name, price) {
      var addonUrl = contextPath + '/cart?action=add&menuId=' + addonId + '&quantity=1&restaurantId=<%= resId %>&name=' + encodeURIComponent(name) + '&price=' + price + '&forceReset=false&format=json';
      fetch(addonUrl)
        .then(function (res) { return res.json(); })
        .then(function (data) {
          if (data.success) {
            if (window.FoodRush) window.FoodRush.showToast('Added ' + name + ' to your meal!');
            setTimeout(function () { window.location.reload(); }, 300);
          }
        })
        .catch(function () {
          window.location.href = contextPath + '/cart?action=add&menuId=' + addonId + '&quantity=1&restaurantId=<%= resId %>&name=' + encodeURIComponent(name) + '&price=' + price;
        });
    }

    function removeCoupon() {
      var couponUrl = contextPath + '/cart?action=coupon&couponCode=&format=json';
      fetch(couponUrl)
        .then(function (res) { return res.json(); })
        .then(function (data) {
          window.location.reload();
        });
    }

    function clearCart() {
      if (confirm('Are you sure you want to remove all items and clear your cart?')) {
        var clearUrl = contextPath + '/cart?action=clear&format=json';
        fetch(clearUrl)
          .then(function (res) { return res.json(); })
          .then(function (data) {
            localStorage.removeItem('foodrush_cart');
            localStorage.removeItem('foodrush_cart_restaurant');
            window.location.reload();
          })
          .catch(function () {
            window.location.href = contextPath + '/cart?action=clear';
          });
      }
    }

    document.addEventListener('DOMContentLoaded', function () {
      var applyBtn = document.getElementById('btn-apply-coupon');
      var couponInput = document.getElementById('coupon-input-field');

      if (applyBtn && couponInput) {
        applyBtn.addEventListener('click', function () {
          var code = couponInput.value.trim();
          if (code) {
            var applyUrl = contextPath + '/cart?action=coupon&couponCode=' + encodeURIComponent(code) + '&format=json';
            fetch(applyUrl)
              .then(function (res) { return res.json(); })
              .then(function (data) {
                if (data.discount > 0) {
                  if (window.FoodRush) window.FoodRush.showToast('Coupon ' + code + ' applied! Saved ₹' + data.discount, 'success');
                  setTimeout(function () { window.location.reload(); }, 400);
                } else {
                  if (window.FoodRush) window.FoodRush.showToast('Invalid Coupon Code. Try "RUSH50" or "FEAST100"', 'error');
                }
              });
          }
        });
      }
    });
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js?v=5.1"></script>
</body>
</html>
