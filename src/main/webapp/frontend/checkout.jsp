<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Collection, com.foodRush.model.Cart, com.foodRush.model.CartItem, com.foodRush.model.User"%>
<%
    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }

    User user = (User) session.getAttribute("user");
    String userName = (user != null && user.getName() != null) ? user.getName() : "FoodRush Customer";
    String userPhone = (user != null && user.getPhone() != null) ? user.getPhone() : "9876543210";
    String userAddress = (user != null && user.getAddress() != null && !user.getAddress().isEmpty()) 
                         ? user.getAddress() 
                         : "#42, 2nd Floor, 5th Cross, Koramangala 5th Block, Bangalore - 560095";

    String resName = (cart.getRestaurantName() != null && !cart.getRestaurantName().isEmpty()) 
                     ? cart.getRestaurantName() 
                     : "Selected Restaurant";
    int resId = cart.getRestaurantID() > 0 ? cart.getRestaurantID() : 1;
    double itemTotal = cart.getItemTotal();
    double deliveryFee = cart.getDeliveryFee();
    double platformFee = cart.getPlatformFee();
    double gstTax = cart.getGstTax();
    double discount = cart.getDiscountAmount();
    double grandTotal = cart.getGrandTotal();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Secure Checkout - Complete your FoodRush order with your preferred payment method and delivery address.">
  <title>Checkout — FoodRush</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Core CSS Design System & Font Awesome 6 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/checkout.css">

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

      <!-- Right: User Nav & Help -->
      <div class="nav-right" style="display: flex; align-items: center; gap: 12px;">
        <!-- Theme Toggle Button (Light / Dark Mode) -->
        <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
          <span class="theme-icon sun-icon"><i class="fa-solid fa-sun"></i></span>
          <span class="theme-icon moon-icon"><i class="fa-solid fa-moon"></i></span>
        </button>

        <div class="nav-auth-slot" id="nav-auth-slot">
          <%
             if (user != null) {
               String firstName = userName.split(" ")[0];
               String initial = !userName.isEmpty() ? userName.substring(0, 1).toUpperCase() : "U";
               boolean isAdmin = user.getRole() != null && 
                   (user.getRole().equalsIgnoreCase("Admin") || 
                    user.getRole().equalsIgnoreCase("ADMIN") || 
                    user.getRole().equalsIgnoreCase("Super_Admin") || 
                    user.getRole().equalsIgnoreCase("Restaurant_Admin"));
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
                   <div class="user-dropdown-email"><%= user.getEmail() != null ? user.getEmail() : "" %></div>
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
        <a href="<%= request.getContextPath() %>/cart" class="breadcrumb-link">Cart</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Checkout</span>
      </nav>

      <h1 class="heading-1" style="margin-bottom: var(--space-6);">Complete Your Order</h1>

      <!-- Checkout Unified Form (Ready for OrderServlet with Razorpay Integration) -->
      <form action="<%= request.getContextPath() %>/order" method="POST" id="checkout-form"
            data-razorpay-key="rzp_test_TorDTG5nabgUh5"
            data-user-name="<%= userName %>"
            data-user-email="<%= user != null && user.getEmail() != null ? user.getEmail() : "customer@foodrush.com" %>"
            data-user-phone="<%= userPhone %>"
            data-res-name="<%= resName %>">
        <input type="hidden" name="restaurantID" value="<%= resId %>">
        <input type="hidden" name="totalAmount" id="hidden-total-amount" value="<%= (int) grandTotal %>">
        <input type="hidden" name="status" value="Placed">
        <input type="hidden" name="razorpayPaymentId" id="razorpay-payment-id" value="">
        <input type="hidden" name="razorpayOrderId" id="razorpay-order-id" value="">
        <input type="hidden" name="razorpaySignature" id="razorpay-signature" value="">

        <!-- Checkout 2-Column Layout -->
        <div class="checkout-layout">
          
          <!-- Left: Steps (Address & Payment) -->
          <div>
            
            <!-- Step 1: Delivery Address -->
            <section class="checkout-step-card" aria-labelledby="step1-title">
              <div class="step-header">
                <div class="step-number">1</div>
                <h2 class="step-title" id="step1-title">Select Delivery Address</h2>
              </div>

              <div class="address-grid" id="address-grid-container">
                
                <!-- Address 1: Home (Default Active) -->
                <label class="address-option-card active" style="cursor: pointer;">
                  <div style="display: flex; gap: 8px; align-items: flex-start;">
                    <input type="radio" name="address" value="<%= userAddress %>" checked style="margin-top: 4px;">
                    <div>
                      <div class="address-type-tag"><i class="fa-solid fa-house" style="margin-right: 4px;"></i> Delivery Address</div>
                      <p class="address-details"><%= userAddress %></p>
                    </div>
                  </div>
                  <span class="caption-text font-semibold text-brand"><i class="fa-solid fa-check" style="margin-right: 4px;"></i> Selected for delivery</span>
                </label>

                <!-- Address 2: Work -->
                <label class="address-option-card" style="cursor: pointer;">
                  <div style="display: flex; gap: 8px; align-items: flex-start;">
                    <input type="radio" name="address" value="Building 7, Embassy TechVillage, Outer Ring Road, Devarabisanahalli, Bangalore" style="margin-top: 4px;">
                    <div>
                      <div class="address-type-tag"><i class="fa-solid fa-building" style="margin-right: 4px;"></i> Work / Office</div>
                      <p class="address-details">Building 7, Embassy TechVillage, Outer Ring Road, Devarabisanahalli, Bangalore</p>
                    </div>
                  </div>
                  <span class="caption-text font-semibold text-light">Click to select</span>
                </label>

                <!-- Add New Address Button -->
                <a href="#add-address-modal" class="address-btn-add" id="btn-add-address-trigger" style="text-decoration: none; text-align: center;">
                  <span style="font-size: 20px;"><i class="fa-solid fa-plus"></i></span>
                  <span>Add New Address</span>
                </a>

              </div>
            </section>

            <!-- Step 2: Delivery Contact & Delivery Partner Tip -->
            <section class="checkout-step-card" aria-labelledby="step2-title">
              <div class="step-header">
                <div class="step-number">2</div>
                <h2 class="step-title" id="step2-title">Delivery Contact & Tip</h2>
              </div>

              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4); margin-bottom: var(--space-5);">
                <div>
                  <label for="contact-name" style="display: block; font-size: var(--font-size-caption); font-weight: bold; margin-bottom: 4px;">Contact Name</label>
                  <input type="text" id="contact-name" name="contactName" class="auth-input" value="<%= userName %>" style="padding: 10px 12px;" required>
                </div>
                <div>
                  <label for="contact-phone" style="display: block; font-size: var(--font-size-caption); font-weight: bold; margin-bottom: 4px;">Phone Number</label>
                  <input type="tel" id="contact-phone" name="phone" class="auth-input" value="<%= userPhone %>" style="padding: 10px 12px;" required>
                </div>
              </div>

              <!-- Delivery Partner Tip Section -->
              <div class="tip-section-box">
                <div class="tip-section-header">
                  <div>
                    <div class="tip-title"><i class="fa-solid fa-motorcycle text-primary" style="margin-right: 6px;"></i> Say thanks to your delivery hero with a Tip</div>
                    <div class="tip-sub">100% of your tip goes directly to your rider's payout</div>
                  </div>
                </div>

                <div class="tip-pills-grid">
                  <label class="tip-pill-label">
                    <input type="radio" name="tipAmount" value="0" class="tip-radio" checked>
                    <span class="tip-pill-inner">
                      <span class="tip-val">No Tip</span>
                    </span>
                  </label>
                  <label class="tip-pill-label">
                    <input type="radio" name="tipAmount" value="20" class="tip-radio">
                    <span class="tip-pill-inner">
                      <span class="tip-emoji"><i class="fa-solid fa-mug-hot"></i></span>
                      <span class="tip-val">₹20</span>
                    </span>
                  </label>
                  <label class="tip-pill-label">
                    <input type="radio" name="tipAmount" value="30" class="tip-radio">
                    <span class="tip-pill-inner">
                      <span class="tip-emoji"><i class="fa-solid fa-glass-water"></i></span>
                      <span class="tip-val">₹30</span>
                      <span class="tip-popular-badge">Popular</span>
                    </span>
                  </label>
                  <label class="tip-pill-label">
                    <input type="radio" name="tipAmount" value="50" class="tip-radio">
                    <span class="tip-pill-inner">
                      <span class="tip-emoji"><i class="fa-solid fa-bowl-food"></i></span>
                      <span class="tip-val">₹50</span>
                    </span>
                  </label>
                  <label class="tip-pill-label">
                    <input type="radio" name="tipAmount" value="100" class="tip-radio">
                    <span class="tip-pill-inner">
                      <span class="tip-emoji"><i class="fa-solid fa-heart" style="color: #e11d48;"></i></span>
                      <span class="tip-val">₹100</span>
                    </span>
                  </label>
                </div>
              </div>
            </section>

            <!-- Step 3: Payment Methods -->
            <section class="checkout-step-card" aria-labelledby="step3-title">
              <div class="step-header">
                <div class="step-number">3</div>
                <h2 class="step-title" id="step3-title">Choose Payment Method</h2>
              </div>

              <div class="payment-methods-list">
                
                <!-- Payment 1: UPI (Active Default) -->
                <label class="payment-method-item active" style="display: block; cursor: pointer;">
                  <div class="payment-method-header">
                    <div class="payment-method-title">
                      <span><i class="fa-solid fa-bolt text-primary"></i></span>
                      <span>UPI (Google Pay, PhonePe, Paytm, QR)</span>
                    </div>
                    <input type="radio" name="paymentMethod" value="UPI" checked>
                  </div>
                  <div class="payment-method-content">
                    <p style="font-size: var(--font-size-caption); color: var(--color-text-secondary); margin-bottom: 10px; line-height: 1.5;">
                      Fast &amp; secure instant payment via any UPI app or dynamic QR code. Powered by Razorpay Payment Gateway.
                    </p>
                    <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                      <span style="padding: 5px 12px; background: var(--color-surface-soft); border: 1px solid var(--color-border); border-radius: var(--radius-sm); font-size: 12px; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;"><i class="fa-brands fa-google text-success"></i> Google Pay</span>
                      <span style="padding: 5px 12px; background: var(--color-surface-soft); border: 1px solid var(--color-border); border-radius: var(--radius-sm); font-size: 12px; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;"><i class="fa-solid fa-mobile-screen text-primary"></i> PhonePe</span>
                      <span style="padding: 5px 12px; background: var(--color-surface-soft); border: 1px solid var(--color-border); border-radius: var(--radius-sm); font-size: 12px; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;"><i class="fa-solid fa-wallet text-info"></i> Paytm</span>
                      <span style="padding: 5px 12px; background: var(--color-surface-soft); border: 1px solid var(--color-border); border-radius: var(--radius-sm); font-size: 12px; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;"><i class="fa-solid fa-qrcode text-primary"></i> Scan QR</span>
                    </div>
                  </div>
                </label>

                <!-- Payment 2: Credit / Debit Card -->
                <label class="payment-method-item" style="display: block; cursor: pointer;">
                  <div class="payment-method-header">
                    <div class="payment-method-title">
                      <span><i class="fa-solid fa-credit-card text-primary"></i></span>
                      <span>Credit or Debit Card (Visa, Mastercard, RuPay)</span>
                    </div>
                    <input type="radio" name="paymentMethod" value="CARD">
                  </div>
                  <div class="payment-method-content">
                    <p style="font-size: var(--font-size-caption); color: var(--color-text-secondary); margin-bottom: 10px; line-height: 1.5;">
                      Pay securely with your Credit or Debit card using standard 3D-Secure OTP verification.
                    </p>
                    <div style="display: flex; gap: 8px; flex-wrap: wrap; align-items: center;">
                      <span style="padding: 5px 12px; background: var(--color-surface-soft); border: 1px solid var(--color-border); border-radius: var(--radius-sm); font-size: 12px; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;"><i class="fa-brands fa-cc-visa text-primary"></i> Visa</span>
                      <span style="padding: 5px 12px; background: var(--color-surface-soft); border: 1px solid var(--color-border); border-radius: var(--radius-sm); font-size: 12px; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;"><i class="fa-brands fa-cc-mastercard" style="color: #ea580c;"></i> Mastercard</span>
                      <span style="padding: 5px 12px; background: var(--color-surface-soft); border: 1px solid var(--color-border); border-radius: var(--radius-sm); font-size: 12px; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;"><i class="fa-solid fa-credit-card text-success"></i> RuPay</span>
                    </div>
                  </div>
                </label>

                <!-- Payment 3: Cash on Delivery -->
                <label class="payment-method-item" style="display: block; cursor: pointer;">
                  <div class="payment-method-header">
                    <div class="payment-method-title">
                      <span><i class="fa-solid fa-money-bill-wave text-success"></i></span>
                      <span>Cash on Delivery (Pay cash or scan QR upon delivery)</span>
                    </div>
                    <input type="radio" name="paymentMethod" value="COD">
                  </div>
                  <div class="payment-method-content">
                    <p style="font-size: var(--font-size-body-sm); color: var(--color-text-secondary);">
                      No online payment required now. Please keep exact cash ready or scan our delivery partner's QR code upon delivery.
                    </p>
                  </div>
                </label>

              </div>
            </section>

          </div>

          <!-- Right: Order Summary Sidebar & Place Order CTA -->
          <aside class="checkout-summary-sidebar" data-base-total="<%= (int) grandTotal %>">
            <div class="bill-summary-card">
              
              <!-- Restaurant Info -->
              <div class="checkout-restaurant-banner">
                <div style="font-size: 28px; background: var(--color-primary-soft); border-radius: var(--radius-md); padding: 8px 12px; display: flex; align-items: center; color: var(--color-primary);"><i class="fa-solid fa-utensils"></i></div>
                <div>
                  <h3 style="font-size: var(--font-size-body); font-weight: bold;"><%= resName %></h3>
                  <div style="font-size: var(--font-size-caption); color: var(--color-text-muted);">Bangalore • Fast Rush Delivery</div>
                </div>
              </div>

              <!-- Delivery Time Banner -->
              <div class="delivery-eta-badge">
                <span><i class="fa-solid fa-clock text-primary"></i></span>
                <span>Estimated Delivery: <strong>25-30 mins</strong></span>
              </div>

              <!-- Items Compact List -->
              <div class="checkout-items-preview">
                <% for (CartItem item : cart.getCartItems()) { %>
                <div class="checkout-item-line">
                  <span><%= item.getQuantity() %> × <%= item.getItemName() %></span>
                  <span class="font-semibold">₹<%= (int) item.getItemTotal() %></span>
                </div>
                <% } %>
              </div>

              <div class="bill-divider"></div>

              <!-- Bill Breakdown -->
              <div class="bill-row">
                <span>Item Total</span>
                <span>₹<%= (int) itemTotal %></span>
              </div>

              <div class="bill-row">
                <span>Delivery Fee</span>
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

              <% if (discount > 0) { %>
              <div class="bill-row discount" style="color: var(--color-success); font-weight: bold;">
                <span>Coupon Discount (<%= cart.getCouponCode() %>)</span>
                <span>-₹<%= (int) discount %></span>
              </div>
              <% } %>

              <!-- Delivery Tip Row (Dynamic) -->
              <div class="bill-row" id="bill-tip-row" style="display: none; color: var(--color-primary); font-weight: 600;">
                <span>Rider Tip</span>
                <span id="bill-tip-val">₹0</span>
              </div>

              <div class="bill-divider"></div>

              <div class="bill-row-grand">
                <span>Grand Total</span>
                <span class="total-val" id="checkout-grand-total">₹<%= (int) grandTotal %></span>
              </div>

              <!-- Place Order CTA -->
              <button type="submit" class="btn btn-primary btn-lg" id="btn-place-order" style="width: 100%; margin-top: var(--space-4);">
                Place Order (₹<%= (int) grandTotal %>) →
              </button>

              <div style="font-size: 11px; text-align: center; color: var(--color-text-muted); margin-top: 10px;">
                By placing this order, you agree to FoodRush's Terms of Service.
              </div>

            </div>
          </aside>

        </div>
      </form>

    </div>
  </main>

  <!-- =========================================================================
       3. Modals: Add Address Popup
       ========================================================================= -->
  <div class="modal-overlay" id="add-address-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog">
      <div class="modal-header">
        <h3 class="modal-title"><i class="fa-solid fa-location-dot text-primary" style="margin-right: 6px;"></i> Add New Delivery Address</h3>
        <button type="button" class="modal-close-btn"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="modal-body">
        <form>
          <div class="form-field-group" style="margin-bottom: 12px;">
            <label class="form-field-label">Address Label (e.g. Home, Office, Friend's House)</label>
            <input type="text" id="new-addr-label" class="auth-input" placeholder="e.g. Studio Apartment" required style="padding: 10px 12px;">
          </div>
          <div class="form-field-group" style="margin-bottom: 16px;">
            <label class="form-field-label">Complete Address & Landmark</label>
            <textarea id="new-addr-details" class="auth-input" placeholder="Flat No, Building Name, Street, Landmark, Bangalore" rows="3" required style="padding: 10px 12px; resize: none;"></textarea>
          </div>
          <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">Save & Use This Address</button>
        </form>
      </div>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Razorpay Official Checkout SDK -->
  <script src="https://checkout.razorpay.com/v1/checkout.js"></script>

  <!-- Vanilla JavaScript Handlers -->
  <script>
    window.FOODRUSH_CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js"></script>
  <script src="<%= request.getContextPath() %>/frontend/js/checkout.js"></script>
</body>
</html>
