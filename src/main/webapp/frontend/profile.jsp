<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.foodRush.model.User" %>
<%@ page import="com.foodRush.model.Cart" %>
<%
    User loggedInUser = (User) request.getAttribute("profileUser");
    if (loggedInUser == null) {
        loggedInUser = (User) session.getAttribute("user");
    }
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/login?redirect=profile");
        return;
    }

    Integer ordersCountObj = (Integer) request.getAttribute("ordersCount");
    int ordersCount = (ordersCountObj != null) ? ordersCountObj : 0;

    Cart sessionCart = (Cart) session.getAttribute("cart");
    int cartCount = (sessionCart != null) ? sessionCart.getTotalCount() : 0;

    String successMsg = (String) session.getAttribute("profileSuccessMessage");
    if (successMsg != null) {
        session.removeAttribute("profileSuccessMessage");
    }

    String errorMsg = (String) session.getAttribute("profileErrorMessage");
    if (errorMsg != null) {
        session.removeAttribute("profileErrorMessage");
    }

    String userName = loggedInUser.getName() != null ? loggedInUser.getName() : "Customer";
    String userEmail = loggedInUser.getEmail() != null ? loggedInUser.getEmail() : "";
    String userPhone = loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "";
    String userAddress = loggedInUser.getAddress() != null ? loggedInUser.getAddress() : "";
    String userRole = loggedInUser.getRole() != null ? loggedInUser.getRole().toUpperCase() : "CUSTOMER";

    boolean isDriver = userRole.contains("DRIVER") || userRole.contains("DELIVERY");
    boolean isAdmin = userRole.contains("ADMIN") || userRole.contains("MANAGER");

    String firstName = userName.split(" ")[0];
    String initial = !userName.isEmpty() ? userName.substring(0, 1).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Manage your FoodRush customer profile, security settings, saved addresses, and profile photo.">
  <title>My Profile — FoodRush</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Font Awesome 6 Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- Core CSS Design System -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css?v=2">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css?v=2">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css?v=2">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/profile.css?v=<%= System.currentTimeMillis() %>">
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
          <span class="loc-text selected-location-text">Bangalore, India</span>
          <span class="loc-arrow"><i class="fa-solid fa-chevron-down" style="font-size: 10px;"></i></span>
        </button>
      </div>

      <!-- Right: Links, Cart & Profile -->
      <div class="nav-right">
        <nav aria-label="Main Navigation">
          <ul class="nav-menu-links">
            <li><a href="<%= request.getContextPath() %>/home" class="nav-link-item">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/restaurants" class="nav-link-item">Restaurants</a></li>
            <li><a href="<%= request.getContextPath() %>/orders" class="nav-link-item">Orders</a></li>
          </ul>
        </nav>

        <!-- Theme Toggle Button -->
        <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
          <span class="theme-icon sun-icon"><i class="fa-solid fa-sun"></i></span>
          <span class="theme-icon moon-icon"><i class="fa-solid fa-moon"></i></span>
        </button>

        <!-- Cart Button -->
        <a href="<%= request.getContextPath() %>/cart" class="nav-cart-btn" title="View Cart">
          <span><i class="fa-solid fa-bag-shopping"></i></span>
          <span>Cart</span>
          <span class="cart-count<%= cartCount <= 0 ? " is-empty" : "" %>" data-count="<%= cartCount %>" style="<%= cartCount <= 0 ? "display: none;" : "" %>"><%= cartCount > 0 ? cartCount : "" %></span>
        </a>

        <!-- User Dropdown Slot -->
        <div class="nav-auth-slot" id="nav-auth-slot">
          <div class="nav-user-dropdown" id="nav-user-dropdown">
            <button type="button" class="nav-user-pill" id="nav-user-pill" aria-expanded="false" aria-haspopup="true" title="Account Menu">
              <span class="user-avatar-initial"><%= initial %></span>
              <span class="nav-user-name"><%= firstName %></span>
              <span class="dropdown-chevron"><i class="fa-solid fa-chevron-down" style="font-size: 10px;"></i></span>
            </button>

            <div class="user-dropdown-menu" id="user-dropdown-menu" role="menu">
              <div class="user-dropdown-header">
                <div class="user-dropdown-fullname"><%= userName %></div>
                <div class="user-dropdown-email"><%= userEmail %></div>
                <span class="user-dropdown-role"><%= isAdmin ? "<i class='fa-solid fa-bolt text-primary'></i> Admin" : (isDriver ? "<i class='fa-solid fa-motorcycle text-warning'></i> Delivery Partner" : "FoodRush Member") %></span>
              </div>
              <hr class="user-dropdown-divider">
              <a href="<%= request.getContextPath() %>/profile" role="menuitem" style="color: var(--color-primary); font-weight: 600;">
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
              <a href="javascript:void(0)" onclick="openLogoutModal()" role="menuitem" style="color: var(--color-error); font-weight: 600;">
                <span><i class="fa-solid fa-right-from-bracket"></i></span> <span>Sign Out</span>
              </a>
            </div>
          </div>
        </div>

      </div>

    </div>
  </header>

  <!-- =========================================================================
       2. Main Profile Content Area
       ========================================================================= -->
  <main class="profile-page-main" id="profile-page-main">
    <div class="container">

      <!-- Breadcrumbs -->
      <nav class="profile-breadcrumb-bar" aria-label="Breadcrumb">
        <a href="<%= request.getContextPath() %>/home">Home</a>
        <span>/</span>
        <span class="profile-breadcrumb-current">My Account</span>
      </nav>

      <!-- Alert Banners -->
      <% if (successMsg != null && !successMsg.isEmpty()) { %>
        <div style="background: rgba(16, 185, 129, 0.15); border: 1px solid #10B981; color: #10B981; padding: 12px 18px; border-radius: var(--radius-md); margin-bottom: 24px; font-weight: 600; display: flex; align-items: center; gap: 8px;">
          <span><i class="fa-solid fa-circle-check"></i></span>
          <span><%= successMsg %></span>
        </div>
      <% } %>

      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div style="background: rgba(239, 68, 68, 0.15); border: 1px solid #EF4444; color: #EF4444; padding: 12px 18px; border-radius: var(--radius-md); margin-bottom: 24px; font-weight: 600; display: flex; align-items: center; gap: 8px;">
          <span><i class="fa-solid fa-triangle-exclamation"></i></span>
          <span><%= errorMsg %></span>
        </div>
      <% } %>

      <!-- =======================================================================
           Profile Hero Showcase HUD
           ======================================================================= -->
      <section class="profile-hero-hud" id="profile-hero-hud">
        <div class="profile-hero-inner">
          <div class="profile-user-summary">
            <!-- User Avatar with Photo Upload Trigger -->
            <div class="profile-avatar-holder" id="hero-avatar-holder" onclick="switchProfileTab('photo')" title="Click to Change Photo">
              <div class="profile-avatar-fallback" id="hero-avatar-fallback">
                <%= initial %>
              </div>
              <img src="" alt="Profile Photo" class="profile-avatar-img" id="hero-avatar-img" style="display: none;">
              <div class="avatar-camera-btn"><i class="fa-solid fa-camera"></i> Edit</div>
            </div>

            <!-- User Meta & Roles -->
            <div class="profile-hero-meta">
              <h1 class="profile-hero-name" id="hero-user-name">
                <%= userName %>
                <% if (isDriver) { %>
                  <span class="badge-role-driver"><i class="fa-solid fa-motorcycle"></i> Delivery Partner</span>
                <% } else if (isAdmin) { %>
                  <span class="badge-role-admin"><i class="fa-solid fa-bolt"></i> System Admin</span>
                <% } else { %>
                  <span class="badge-role-gold"><i class="fa-solid fa-crown"></i> FoodRush Gold</span>
                <% } %>
              </h1>
              <div class="profile-hero-contact">
                <span><i class="fa-solid fa-envelope"></i> <%= userEmail %></span>
                <% if (!userPhone.isEmpty()) { %>
                  <span>• <i class="fa-solid fa-phone"></i> <%= userPhone %></span>
                <% } %>
              </div>
            </div>
          </div>

          <!-- Hero Action Buttons -->
          <div class="profile-hero-actions">
            <a href="<%= request.getContextPath() %>/orders" class="btn-hero-order">
              <span><i class="fa-solid fa-box"></i></span> View Orders (<%= ordersCount %>)
            </a>
            <% if (isDriver) { %>
              <a href="<%= request.getContextPath() %>/driver/dashboard" class="btn-hero-order" style="border-color: #10B981; color: #34D399;">
                <span><i class="fa-solid fa-motorcycle"></i></span> Rider Hub
              </a>
            <% } %>
            <% if (isAdmin) { %>
              <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn-hero-order" style="border-color: #EF4444; color: #F87171;">
                <span><i class="fa-solid fa-bolt"></i></span> Admin Hub
              </a>
            <% } %>
          </div>
        </div>

        <!-- 4 Quick KPI Stat Tiles -->
        <div class="profile-kpi-row">
          <div class="profile-kpi-pill">
            <div class="kpi-pill-icon" style="color: #EF4444;"><i class="fa-solid fa-box"></i></div>
            <div class="kpi-pill-details">
              <span class="kpi-pill-val"><%= ordersCount %> Orders</span>
              <span class="kpi-pill-label">Total Deliveries Placed</span>
            </div>
          </div>

          <div class="profile-kpi-pill">
            <div class="kpi-pill-icon" style="color: #3B82F6;"><i class="fa-solid fa-location-dot"></i></div>
            <div class="kpi-pill-details">
              <span class="kpi-pill-val"><%= userAddress != null && !userAddress.isEmpty() ? "Default Set" : "Not Set" %></span>
              <span class="kpi-pill-label">Saved Delivery Hub</span>
            </div>
          </div>

          <div class="profile-kpi-pill">
            <div class="kpi-pill-icon" style="color: #F59E0B;"><i class="fa-solid fa-star"></i></div>
            <div class="kpi-pill-details">
              <span class="kpi-pill-val">VIP Foodie</span>
              <span class="kpi-pill-label">Loyalty Tier Status</span>
            </div>
          </div>
        </div>
      </section>

      <!-- =======================================================================
           Main 2-Column Grid Layout (Sidebar Tabs + Content Box)
           ======================================================================= -->
      <div class="profile-main-grid">

        <!-- Left Sidebar Navigation -->
        <aside class="profile-sidebar-card" aria-label="Profile Sections">
          <ul class="profile-nav-links">
            <li>
              <button type="button" class="profile-tab-button active" id="tab-btn-personal" onclick="switchProfileTab('personal')">
                <div class="profile-tab-btn-content">
                  <span class="profile-tab-btn-icon"><i class="fa-solid fa-user"></i></span>
                  <span>Personal Details</span>
                </div>
                <span><i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i></span>
              </button>
            </li>
            <li>
              <button type="button" class="profile-tab-button" id="tab-btn-photo" onclick="switchProfileTab('photo')">
                <div class="profile-tab-btn-content">
                  <span class="profile-tab-btn-icon"><i class="fa-solid fa-camera"></i></span>
                  <span>Profile Photo</span>
                </div>
                <span><i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i></span>
              </button>
            </li>
            <li>
              <button type="button" class="profile-tab-button" id="tab-btn-addresses" onclick="switchProfileTab('addresses')">
                <div class="profile-tab-btn-content">
                  <span class="profile-tab-btn-icon"><i class="fa-solid fa-location-dot"></i></span>
                  <span>Saved Addresses</span>
                </div>
                <span><i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i></span>
              </button>
            </li>
            <li>
              <button type="button" class="profile-tab-button" id="tab-btn-security" onclick="switchProfileTab('security')">
                <div class="profile-tab-btn-content">
                  <span class="profile-tab-btn-icon"><i class="fa-solid fa-lock"></i></span>
                  <span>Security & Password</span>
                </div>
                <span><i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i></span>
              </button>
            </li>
            <li>
              <button type="button" class="profile-tab-button" id="tab-btn-notifications" onclick="switchProfileTab('notifications')">
                <div class="profile-tab-btn-content">
                  <span class="profile-tab-btn-icon"><i class="fa-solid fa-bell"></i></span>
                  <span>Preferences</span>
                </div>
                <span><i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i></span>
              </button>
            </li>

            <li class="profile-nav-divider"></li>

            <li>
              <button type="button" class="profile-tab-button logout" onclick="openLogoutModal()">
                <div class="profile-tab-btn-content">
                  <span class="profile-tab-btn-icon"><i class="fa-solid fa-right-from-bracket"></i></span>
                  <span>Sign Out</span>
                </div>
              </button>
            </li>
          </ul>
        </aside>

        <!-- Right Content Panels Container -->
        <section class="profile-content-box">

          <!-- ===================================================================
               Tab 1: Personal Details Form
               =================================================================== -->
          <div class="tab-pane active" id="pane-personal">
            <div class="tab-heading-block">
              <h2 class="tab-main-title">Personal Details</h2>
              <p class="tab-sub-title">Manage your display name, primary contact number, and default delivery location.</p>
            </div>

            <form action="<%= request.getContextPath() %>/updateProfile" method="POST" class="profile-form-grid" id="form-personal-profile">
              <!-- Name Input -->
              <div class="input-field-group">
                <label for="profile-name-input" class="input-field-label">Full Name</label>
                <div class="input-icon-wrapper">
                  <span class="input-leading-icon"><i class="fa-solid fa-user"></i></span>
                  <input type="text" id="profile-name-input" name="name" class="profile-text-input" value="<%= userName %>" placeholder="Enter full name" required>
                </div>
              </div>

              <!-- Email Input (Readonly) -->
              <div class="input-field-group">
                <label for="profile-email-input" class="input-field-label">
                  <span>Email Address</span>
                  <span class="field-locked-tag"><i class="fa-solid fa-lock"></i> Primary Account ID</span>
                </label>
                <div class="input-icon-wrapper">
                  <span class="input-leading-icon"><i class="fa-solid fa-envelope"></i></span>
                  <input type="email" id="profile-email-input" name="email" class="profile-text-input" value="<%= userEmail %>" readonly title="Email cannot be changed">
                </div>
                <span class="input-field-hint">Your email is tied to your login credentials and order receipts.</span>
              </div>

              <!-- Phone Input -->
              <div class="input-field-group">
                <label for="profile-phone-input" class="input-field-label">Mobile Phone Number</label>
                <div class="input-icon-wrapper">
                  <span class="input-leading-icon"><i class="fa-solid fa-phone"></i></span>
                  <input type="tel" id="profile-phone-input" name="phone" class="profile-text-input" value="<%= userPhone %>" pattern="[0-9]{10}" placeholder="10-digit mobile number" required>
                </div>
                <span class="input-field-hint">Used by delivery partners for arrival calls and OTP verification.</span>
              </div>

              <!-- Delivery Address Input -->
              <div class="input-field-group">
                <label for="profile-addr-input" class="input-field-label">Default Delivery Address</label>
                <div class="input-icon-wrapper">
                  <span class="input-leading-icon"><i class="fa-solid fa-location-dot"></i></span>
                  <input type="text" id="profile-addr-input" name="address" class="profile-text-input" value="<%= userAddress %>" placeholder="House/Flat No, Landmark, City">
                </div>
                <span class="input-field-hint">Auto-filled during 1-click checkout.</span>
              </div>

              <div>
                <button type="submit" class="btn-save-profile">
                  <span><i class="fa-solid fa-floppy-disk"></i></span> Save Changes
                </button>
              </div>
            </form>
          </div>

          <!-- ===================================================================
               Tab 2: Profile Photo Manager
               =================================================================== -->
          <div class="tab-pane" id="pane-photo">
            <div class="tab-heading-block">
              <h2 class="tab-main-title">Profile Photo & Avatars</h2>
              <p class="tab-sub-title">Personalize your identity across live tracking and account navigation.</p>
            </div>

            <div class="photo-manager-layout">
              <!-- Active Photo Preview Card -->
              <div class="photo-preview-card">
                <div style="position: relative;">
                  <img src="" alt="Active Photo" class="photo-big-preview" id="photo-manager-preview" style="display: none;">
                  <div class="photo-big-preview" id="photo-manager-fallback" style="display: flex; align-items: center; justify-content: center; font-size: 42px; font-weight: 800; color: #FFF; background: linear-gradient(135deg, #E50914, #990012);">
                    <%= initial %>
                  </div>
                </div>

                <div class="photo-preview-text">
                  <h4>Upload Your Custom Photo</h4>
                  <p>Choose a clear photo from your computer or phone (JPG, PNG, WebP). Your picture will be resized and optimized automatically.</p>
                  
                  <div class="photo-btn-group">
                    <!-- Hidden File Input -->
                    <input type="file" id="avatar-file-input" accept="image/*" style="display: none;" onchange="handlePhotoUpload(this)">
                    <button type="button" class="btn-upload-photo" onclick="document.getElementById('avatar-file-input').click();">
                      <span><i class="fa-solid fa-folder-open"></i></span> Upload Photo
                    </button>
                    <button type="button" class="btn-remove-photo" id="btn-remove-avatar" onclick="removeCustomPhoto()">
                      <span><i class="fa-solid fa-trash-can"></i></span> Remove Photo
                    </button>
                  </div>
                </div>
              </div>

              <!-- Avatar Presets Gallery -->
              <div class="avatar-presets-section">
                <div class="presets-title">Or Pick a FoodRush Character Preset:</div>
                <div class="avatar-presets-grid">
                  <button type="button" class="avatar-preset-btn" onclick="applyPresetAvatar('bolt')" title="FoodRush Bolt"><i class="fa-solid fa-bolt text-primary"></i></button>
                  <button type="button" class="avatar-preset-btn" onclick="applyPresetAvatar('burger')" title="Burger Master"><i class="fa-solid fa-burger text-warning"></i></button>
                  <button type="button" class="avatar-preset-btn" onclick="applyPresetAvatar('pizza')" title="Pizza Slice"><i class="fa-solid fa-pizza-slice text-primary"></i></button>
                  <button type="button" class="avatar-preset-btn" onclick="applyPresetAvatar('bowl')" title="Ramen Ninja"><i class="fa-solid fa-bowl-food" style="color: #ef4444;"></i></button>
                  <button type="button" class="avatar-preset-btn" onclick="applyPresetAvatar('leaf')" title="Green Bowl"><i class="fa-solid fa-leaf text-success"></i></button>
                  <button type="button" class="avatar-preset-btn" onclick="applyPresetAvatar('cookie')" title="Sweet Donut"><i class="fa-solid fa-cookie text-warning"></i></button>
                </div>
              </div>
            </div>
          </div>

          <!-- ===================================================================
               Tab 3: Saved Addresses
               =================================================================== -->
          <div class="tab-pane" id="pane-addresses">
            <div class="tab-heading-block">
              <h2 class="tab-main-title">Saved Delivery Addresses</h2>
              <p class="tab-sub-title">Save destinations for lightning-fast checkout without typing each time.</p>
            </div>

            <div class="addresses-grid">
              <!-- Primary Card -->
              <div class="address-card-item">
                <div>
                  <div class="address-card-header">
                    <span class="address-type-tag"><i class="fa-solid fa-house"></i> Primary Delivery</span>
                    <span class="badge-default-address">DEFAULT</span>
                  </div>
                  <p class="address-text-body" style="margin-top: 8px;">
                    <%= (userAddress != null && !userAddress.trim().isEmpty()) ? userAddress : "No default address set yet." %>
                  </p>
                </div>
                <div class="address-actions-row">
                  <button type="button" class="btn-addr-action" onclick="switchProfileTab('personal')"><i class="fa-solid fa-pen-to-square"></i> Edit in Personal Info</button>
                </div>
              </div>

              <!-- Work Card -->
              <div class="address-card-item">
                <div>
                  <div class="address-card-header">
                    <span class="address-type-tag"><i class="fa-solid fa-briefcase"></i> Work & Office</span>
                  </div>
                  <p class="address-text-body" style="margin-top: 8px;">
                    Prestige Tech Park, Marathahalli-Sarjapur Outer Ring Road, Bengaluru - 560103
                  </p>
                </div>
                <div class="address-actions-row">
                  <button type="button" class="btn-addr-action" onclick="setAsDefaultAddress('Prestige Tech Park, Marathahalli-Sarjapur Outer Ring Road, Bengaluru - 560103')">Set as Default</button>
                </div>
              </div>
            </div>
          </div>

          <!-- ===================================================================
               Tab 4: Security & Password
               =================================================================== -->
          <div class="tab-pane" id="pane-security">
            <div class="tab-heading-block">
              <h2 class="tab-main-title">Security & Password</h2>
              <p class="tab-sub-title">Keep your account safe by setting a strong, unique password.</p>
            </div>

            <form action="<%= request.getContextPath() %>/changePassword" method="POST" class="profile-form-grid" id="form-password-change">
              <!-- Current Password -->
              <div class="input-field-group">
                <label for="pass-current" class="input-field-label">Current Password</label>
                <div class="input-icon-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                  <span class="input-leading-icon"><i class="fa-solid fa-lock"></i></span>
                  <input type="password" id="pass-current" name="currentPassword" class="profile-text-input" placeholder="Enter current password" required style="padding-right: 44px; width: 100%;">
                  <button type="button" class="input-trailing-action password-toggle-btn" onclick="togglePasswordVisibility('pass-current', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-secondary); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;"><i class="fa-solid fa-eye" style="pointer-events: none;"></i></button>
                </div>
              </div>

              <!-- New Password -->
              <div class="input-field-group">
                <label for="pass-new" class="input-field-label">New Password</label>
                <div class="input-icon-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                  <span class="input-leading-icon"><i class="fa-solid fa-key"></i></span>
                  <input type="password" id="pass-new" name="newPassword" class="profile-text-input" placeholder="At least 6 characters" minlength="6" required oninput="checkPassStrength(this.value)" style="padding-right: 44px; width: 100%;">
                  <button type="button" class="input-trailing-action password-toggle-btn" onclick="togglePasswordVisibility('pass-new', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-secondary); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;"><i class="fa-solid fa-eye" style="pointer-events: none;"></i></button>
                </div>

                <!-- Password Strength Meter Bar -->
                <div class="password-meter-wrap">
                  <div class="password-meter-bar">
                    <div class="password-meter-fill" id="pass-meter-fill"></div>
                  </div>
                  <div class="password-meter-label">
                    <span>Strength: <strong id="pass-meter-text">Too short</strong></span>
                    <span>Min 6 characters</span>
                  </div>
                </div>
              </div>

              <!-- Confirm Password -->
              <div class="input-field-group">
                <label for="pass-confirm" class="input-field-label">Confirm New Password</label>
                <div class="input-icon-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                  <span class="input-leading-icon"><i class="fa-solid fa-key"></i></span>
                  <input type="password" id="pass-confirm" name="confirmPassword" class="profile-text-input" placeholder="Re-enter new password" minlength="6" required oninput="checkPassMatch()" style="padding-right: 44px; width: 100%;">
                  <button type="button" class="input-trailing-action password-toggle-btn" onclick="togglePasswordVisibility('pass-confirm', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-secondary); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;"><i class="fa-solid fa-eye" style="pointer-events: none;"></i></button>
                </div>
                <span class="input-field-hint" id="pass-match-hint" style="color: var(--color-text-secondary);">Must match new password</span>
              </div>

              <div>
                <button type="submit" class="btn-save-profile" id="btn-update-password">
                  <span><i class="fa-solid fa-lock"></i></span> Update Password
                </button>
              </div>
            </form>
          </div>

          <!-- ===================================================================
               Tab 5: Notification Preferences
               =================================================================== -->
          <div class="tab-pane" id="pane-notifications">
            <div class="tab-heading-block">
              <h2 class="tab-main-title">Notification Preferences</h2>
              <p class="tab-sub-title">Customize how and when you receive order alerts, live rider location, and deals.</p>
            </div>

            <div class="prefs-rows-list">
              <div class="pref-item-row">
                <div>
                  <div class="pref-title"><i class="fa-brands fa-whatsapp text-success" style="color: #25D366; font-size: 18px; margin-right: 6px;"></i> WhatsApp Live Tracking</div>
                  <div class="pref-desc">Receive real-time order tracking links and rider updates on your registered phone.</div>
                </div>
                <label class="switch-control">
                  <input type="checkbox" id="pref-whatsapp" checked onchange="saveNotificationPref('whatsapp', this.checked)">
                  <span class="switch-slider"></span>
                </label>
              </div>

              <div class="pref-item-row">
                <div>
                  <div class="pref-title"><i class="fa-solid fa-comment-sms text-primary" style="font-size: 18px; margin-right: 6px;"></i> SMS Delivery Alerts</div>
                  <div class="pref-desc">Get critical delivery OTPs and dispatch confirmations via SMS.</div>
                </div>
                <label class="switch-control">
                  <input type="checkbox" id="pref-sms" checked onchange="saveNotificationPref('sms', this.checked)">
                  <span class="switch-slider"></span>
                </label>
              </div>

              <div class="pref-item-row">
                <div>
                  <div class="pref-title"><i class="fa-solid fa-envelope-open-text text-warning" style="font-size: 18px; margin-right: 6px;"></i> Exclusive Rush Deals & Invoices</div>
                  <div class="pref-desc">Weekly curated discounts, coupon codes, and itemized billing PDFs via email.</div>
                </div>
                <label class="switch-control">
                  <input type="checkbox" id="pref-email" checked onchange="saveNotificationPref('email', this.checked)">
                  <span class="switch-slider"></span>
                </label>
              </div>
            </div>
          </div>

        </section>

      </div>

    </div>
  </main>

  <!-- =========================================================================
       3. Logout Confirmation Dialog Modal
       ========================================================================= -->
  <div class="modal-overlay" id="logout-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog" style="max-width: 440px;">
      <div class="modal-header">
        <h3 class="modal-title" style="margin: 0; font-size: 18px; font-weight: 700; color: var(--color-text-primary);"><i class="fa-solid fa-right-from-bracket"></i> Confirm Sign Out</h3>
        <button type="button" class="modal-close-btn" onclick="closeLogoutModal()"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="modal-body">
        <p style="font-size: 14px; color: var(--color-text-secondary); line-height: 1.5; margin: 0 0 20px;">
          Are you sure you want to sign out of your FoodRush account? You will need to log back in to place orders and track deliveries.
        </p>
        <div style="display: flex; gap: 12px; justify-content: flex-end;">
          <button type="button" class="btn btn-secondary btn-sm" onclick="closeLogoutModal()">Cancel</button>
          <a href="<%= request.getContextPath() %>/logout" class="btn btn-primary btn-sm" style="background-color: var(--color-error); border-color: var(--color-error); text-decoration: none;">
            Sign Out
          </a>
        </div>
      </div>
    </div>
  </div>

  <!-- =========================================================================
       4. Client-Side Interactivity Script
       ========================================================================= -->
  <script>
    const currentUserId = <%= loggedInUser.getId() %>;
    const avatarStorageKey = 'foodrush_user_avatar_' + currentUserId;

    // Tab Switching
    function switchProfileTab(tabName) {
      document.querySelectorAll('.profile-tab-button').forEach(btn => btn.classList.remove('active'));
      document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('active'));

      const activeBtn = document.getElementById('tab-btn-' + tabName);
      const activePane = document.getElementById('pane-' + tabName);

      if (activeBtn) activeBtn.classList.add('active');
      if (activePane) activePane.classList.add('active');

      if (history.replaceState) {
        history.replaceState(null, null, '#' + tabName);
      }
    }

    // Auto-select tab if in URL hash
    window.addEventListener('DOMContentLoaded', () => {
      const hash = window.location.hash.replace('#', '');
      if (hash && document.getElementById('pane-' + hash)) {
        switchProfileTab(hash);
      }
      loadSavedPhoto();
    });

    // -------------------------------------------------------------------------
    // Photo Upload, Preview, & LocalStorage Persistence
    // -------------------------------------------------------------------------
    function handlePhotoUpload(input) {
      if (input.files && input.files[0]) {
        const file = input.files[0];
        
        // Max size 5MB
        if (file.size > 5 * 1024 * 1024) {
          alert('Photo size exceeds 5MB limit. Please choose a smaller image.');
          return;
        }

        const reader = new FileReader();
        reader.onload = function(e) {
          const dataUrl = e.target.result;
          setAvatarImage(dataUrl);
          localStorage.setItem(avatarStorageKey, dataUrl);
          if (window.FoodRush && window.FoodRush.showToast) {
            window.FoodRush.showToast('Profile photo updated successfully!', 'success');
          }
        };
        reader.readAsDataURL(file);
      }
    }

    function applyPresetAvatar(presetKey) {
      const svgPresets = {
        bolt: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="48" fill="#1C0508" stroke="#E50914" stroke-width="4"/><path fill="#FF1E42" d="M54 22L34 50h14l-6 28 26-34H52z"/></svg>',
        burger: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="48" fill="#1C1917" stroke="#F59E0B" stroke-width="4"/><path fill="#F59E0B" d="M30 42c0-11 9-20 20-20s20 9 20 20H30zm-2 16h44c2 0 4 2 4 4s-2 4-4 4H28c-2 0-4-2-4-4s2-4 4-4zm4 12h36c0 6-7 10-18 10s-18-4-18-10z"/></svg>',
        pizza: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="48" fill="#1C0508" stroke="#E50914" stroke-width="4"/><path fill="#E50914" d="M50 24L72 70c-7 4-15 6-22 6s-15-2-22-6l22-46z"/><circle cx="50" cy="48" r="4" fill="#FDE047"/><circle cx="44" cy="62" r="3" fill="#FDE047"/><circle cx="58" cy="60" r="3" fill="#FDE047"/></svg>',
        bowl: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="48" fill="#18181B" stroke="#3B82F6" stroke-width="4"/><path fill="#60A5FA" d="M26 44h48c0 14-11 26-24 26S26 58 26 44zm14-14h4v10h-4zm10-4h4v14h-4zm10 4h4v10h-4z"/></svg>',
        leaf: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="48" fill="#052E16" stroke="#10B981" stroke-width="4"/><path fill="#10B981" d="M68 32c-20 0-36 16-36 36 0 0 16 0 36-16s0-20 0-20z"/></svg>',
        cookie: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="48" fill="#292524" stroke="#D97706" stroke-width="4"/><circle cx="50" cy="50" r="24" fill="#B45309"/><circle cx="44" cy="42" r="3" fill="#78350F"/><circle cx="56" cy="46" r="3" fill="#78350F"/><circle cx="48" cy="58" r="3" fill="#78350F"/></svg>'
      };
      const svg = svgPresets[presetKey] || svgPresets['bolt'];
      const dataUrl = 'data:image/svg+xml;utf8,' + encodeURIComponent(svg);
      setAvatarImage(dataUrl);
      localStorage.setItem(avatarStorageKey, dataUrl);
      if (window.FoodRush && window.FoodRush.showToast) {
        window.FoodRush.showToast('Avatar preset updated!', 'success');
      }
    }

    function removeCustomPhoto() {
      localStorage.removeItem(avatarStorageKey);
      resetToDefaultAvatar();
      if (window.FoodRush && window.FoodRush.showToast) {
        window.FoodRush.showToast('Profile photo reset to default initial.', 'info');
      }
    }

    function setAvatarImage(url) {
      // Hero avatar
      const heroImg = document.getElementById('hero-avatar-img');
      const heroFallback = document.getElementById('hero-avatar-fallback');
      if (heroImg && heroFallback) {
        heroImg.src = url;
        heroImg.style.display = 'block';
        heroFallback.style.display = 'none';
      }

      // Manager Preview avatar
      const mgrImg = document.getElementById('photo-manager-preview');
      const mgrFallback = document.getElementById('photo-manager-fallback');
      if (mgrImg && mgrFallback) {
        mgrImg.src = url;
        mgrImg.style.display = 'block';
        mgrFallback.style.display = 'none';
      }
    }

    function resetToDefaultAvatar() {
      const heroImg = document.getElementById('hero-avatar-img');
      const heroFallback = document.getElementById('hero-avatar-fallback');
      if (heroImg && heroFallback) {
        heroImg.style.display = 'none';
        heroFallback.style.display = 'flex';
      }

      const mgrImg = document.getElementById('photo-manager-preview');
      const mgrFallback = document.getElementById('photo-manager-fallback');
      if (mgrImg && mgrFallback) {
        mgrImg.style.display = 'none';
        mgrFallback.style.display = 'flex';
      }
    }

    function loadSavedPhoto() {
      const saved = localStorage.getItem(avatarStorageKey);
      if (saved) {
        setAvatarImage(saved);
      }
    }

    // -------------------------------------------------------------------------
    // Password Strength & Toggle Visibility
    // -------------------------------------------------------------------------
    function togglePassVisibility(inputId, btn) {
      const input = document.getElementById(inputId);
      if (!input) return;
      if (input.type === 'password') {
        input.type = 'text';
        btn.innerHTML = '<i class="fa-solid fa-eye-slash"></i>';
      } else {
        input.type = 'password';
        btn.innerHTML = '<i class="fa-solid fa-eye"></i>';
      }
    }

    function checkPassStrength(val) {
      const fill = document.getElementById('pass-meter-fill');
      const text = document.getElementById('pass-meter-text');
      if (!fill || !text) return;

      fill.className = 'password-meter-fill';

      if (!val || val.length < 6) {
        text.textContent = 'Too short';
        text.style.color = '#EF4444';
        fill.classList.add('fill-weak');
        return;
      }

      let score = 0;
      if (val.length >= 8) score++;
      if (/[0-9]/.test(val)) score++;
      if (/[A-Z]/.test(val)) score++;
      if (/[^A-Za-z0-9]/.test(val)) score++;

      if (score <= 1) {
        fill.classList.add('fill-weak');
        text.textContent = 'Weak';
        text.style.color = '#EF4444';
      } else if (score <= 2) {
        fill.classList.add('fill-medium');
        text.textContent = 'Moderate';
        text.style.color = '#F59E0B';
      } else {
        fill.classList.add('fill-strong');
        text.innerHTML = 'Strong <i class="fa-solid fa-shield-halved"></i>';
        text.style.color = '#10B981';
      }
    }

    function checkPassMatch() {
      const newPass = document.getElementById('pass-new').value;
      const confirmPass = document.getElementById('pass-confirm').value;
      const hint = document.getElementById('pass-match-hint');

      if (!hint) return;
      if (confirmPass.length === 0) {
        hint.textContent = 'Must match new password';
        hint.style.color = 'var(--color-text-secondary)';
      } else if (newPass === confirmPass) {
        hint.innerHTML = '<i class="fa-solid fa-circle-check"></i> Passwords match';
        hint.style.color = '#10B981';
      } else {
        hint.innerHTML = '<i class="fa-solid fa-circle-xmark"></i> Passwords do not match';
        hint.style.color = '#EF4444';
      }
    }

    function setAsDefaultAddress(addr) {
      const addrInput = document.getElementById('profile-addr-input');
      if (addrInput) {
        addrInput.value = addr;
        switchProfileTab('personal');
        if (window.FoodRush && window.FoodRush.showToast) {
          window.FoodRush.showToast('Address filled in default field! Click Save Changes.', 'info');
        }
      }
    }

    function saveNotificationPref(type, enabled) {
      localStorage.setItem('foodrush_pref_' + type, enabled);
      if (window.FoodRush && window.FoodRush.showToast) {
        window.FoodRush.showToast('Preference saved!', 'success');
      }
    }

    // Modal controls
    function openLogoutModal() {
      const m = document.getElementById('logout-modal');
      if (m) m.classList.add('active');
    }
    function closeLogoutModal() {
      const m = document.getElementById('logout-modal');
      if (m) m.classList.remove('active');
    }

    // Theme toggle
    const themeBtn = document.getElementById('theme-toggle-btn');
    if (themeBtn) {
      themeBtn.addEventListener('click', () => {
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
  <!-- Global Context and Vanilla JavaScript Handlers -->
  <script>
    window.FOODRUSH_CONTEXT_PATH = '<%= request.getContextPath() %>';
  </script>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
