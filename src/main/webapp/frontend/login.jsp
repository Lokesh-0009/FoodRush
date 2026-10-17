<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodRush.model.User"%>
<%
    User loggedInUser = (User) session.getAttribute("user");
    String redirectParam = request.getParameter("redirect");
    if (redirectParam == null || redirectParam.trim().isEmpty()) {
        redirectParam = (String) request.getAttribute("redirect");
    }
    if (redirectParam == null || redirectParam.trim().isEmpty()) {
        redirectParam = (String) session.getAttribute("redirectAfterLogin");
    }

    if (loggedInUser != null && loggedInUser.getId() <= 0) {
        session.removeAttribute("user");
        loggedInUser = null;
    }

    if (loggedInUser != null) {
        if (redirectParam != null && !redirectParam.trim().isEmpty()) {
            String target = redirectParam.startsWith("/") ? redirectParam : "/" + redirectParam;
            response.sendRedirect(request.getContextPath() + target);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
        return;
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    if (successMessage == null || successMessage.trim().isEmpty()) {
        successMessage = (String) session.getAttribute("loginSuccessMessage");
        if (successMessage != null) {
            session.removeAttribute("loginSuccessMessage");
        }
    }
    if (successMessage == null || successMessage.trim().isEmpty()) {
        if ("true".equalsIgnoreCase(request.getParameter("resetSuccess"))) {
            successMessage = "Password has been reset successfully! Please sign in with your new password.";
        }
    }
    String activeTab = (String) request.getAttribute("activeTab");
    boolean isSignUpTab = "signup".equalsIgnoreCase(activeTab) || "register".equalsIgnoreCase(activeTab);

    String prefillEmail = (String) request.getAttribute("email");
    if (prefillEmail == null || prefillEmail.trim().isEmpty()) {
        prefillEmail = request.getParameter("email");
    }
    String prefillName = (String) request.getAttribute("name");
    String prefillPhone = (String) request.getAttribute("phone");
    String prefillAddress = (String) request.getAttribute("address");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Sign in or create an account on FoodRush to order delicious meals and track deliveries in real-time.">
  <title>Sign In & Register — FoodRush</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Core CSS Design System & Font Awesome 6 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css?v=<%= System.currentTimeMillis() %>">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/auth.css?v=<%= System.currentTimeMillis() %>">
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

  <div class="auth-page-wrapper">
    <div class="auth-split-layout">

      <!-- =====================================================================
           1. Left Branding & Showcase Panel
           ===================================================================== -->
      <aside class="auth-brand-sidebar">

        <div class="auth-sidebar-top" style="display: flex; justify-content: space-between; align-items: center;">
          <a href="<%= request.getContextPath() %>/home" class="brand-logo" title="Back to Home">
            <div class="brand-icon"><i class="fa-solid fa-bolt-lightning text-primary"></i></div>
            <span>Food<span class="brand-name-highlight">Rush</span></span>
          </a>
          <!-- Theme Toggle Button -->
          <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
            <span class="theme-icon sun-icon"><i class="fa-solid fa-sun"></i></span>
            <span class="theme-icon moon-icon"><i class="fa-solid fa-moon"></i></span>
          </button>
        </div>

        <div class="auth-sidebar-hero">
          <div class="hero-pill-tag">
            <i class="fa-solid fa-star text-warning" style="margin-right: 6px;"></i> Trusted by 50,000+ Foodies
          </div>

          <h1 class="auth-hero-title">
            Delicious food, <br>
            <span class="text-brand">delivered in minutes.</span>
          </h1>

          <p class="auth-hero-desc">
            Sign in to track live delivery, save multiple addresses, reorder your favorite biryanis and pizzas in one
            click, and access exclusive Rush deals.
          </p>
        </div>

        <!-- Glossy Hero Food Showcase Visual -->
        <div class="auth-food-visual-card">
          <img src="<%= request.getContextPath() %>/frontend/public/auth-food-showcase.jpg" alt="Steaming Dum Biryani, Gourmet Burger & Artisanal Pizza"
            class="auth-food-visual-img" onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&auto=format&fit=crop&q=80'">
          <div class="auth-food-visual-overlay">
            <div class="auth-food-visual-badge">
              <span><i class="fa-solid fa-fire text-primary"></i></span>
              <span>Freshly Prepared & Delivered Hot in 25 Mins</span>
            </div>
          </div>
        </div>

        <!-- Customer Testimonial Card -->
        <div class="auth-testimonial-card">
          <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80"
            alt="Priya S." class="auth-user-avatar">
          <div>
            <p class="auth-testimonial-text">
              "FoodRush is lightning fast! My hot biryani arrived in just 22 minutes with fresh packaging."
            </p>
            <div class="auth-testimonial-author">Priya S. • Foodie from Koramangala</div>
          </div>
        </div>

      </aside>

      <!-- =====================================================================
           2. Right Auth Form Area
           ===================================================================== -->
      <main class="auth-form-container">
        <div class="auth-form-card">

          <!-- Mobile Brand Header -->
          <div class="auth-mobile-header">
            <a href="<%= request.getContextPath() %>/home" class="brand-logo">
              <div class="brand-icon"><i class="fa-solid fa-bolt-lightning text-primary"></i></div>
              <span>Food<span class="brand-name-highlight">Rush</span></span>
            </a>
            <a href="<%= request.getContextPath() %>/home" class="btn btn-secondary btn-sm">← Back</a>
          </div>

          <!-- Pure CSS Tab Switching Controllers -->
          <input type="radio" name="auth-tab-choice" id="tab-choice-login" class="auth-tab-radio" <%= !isSignUpTab ? "checked" : "" %>>
          <input type="radio" name="auth-tab-choice" id="tab-choice-register" class="auth-tab-radio" <%= isSignUpTab ? "checked" : "" %>>

          <!-- Dynamic Form Header -->
          <div class="auth-header-wrap">
            <div class="login-header">
              <h2 class="auth-header-title">Welcome back</h2>
              <p class="auth-header-subtitle">
                <% if (redirectParam != null && redirectParam.contains("checkout")) { %>
                  <span style="color: var(--color-primary); font-weight: 600;"><i class="fa-solid fa-lock" style="margin-right: 6px;"></i> Please sign in to complete your checkout</span>
                <% } else { %>
                  Sign in to your account to continue ordering
                <% } %>
              </p>
            </div>
            <div class="register-header">
              <h2 class="auth-header-title">Create an Account</h2>
              <p class="auth-header-subtitle">
                <% if (redirectParam != null && redirectParam.contains("checkout")) { %>
                  <span style="color: var(--color-primary); font-weight: 600;"><i class="fa-solid fa-lock" style="margin-right: 6px;"></i> Sign up in seconds to complete your order</span>
                <% } else { %>
                  Sign up to order delicious meals and track deliveries
                <% } %>
              </p>
            </div>
          </div>

          <!-- Success Alert Message -->
          <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
          <div style="background-color: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; padding: 12px 16px; border-radius: var(--radius-md); margin-bottom: var(--space-4); font-size: var(--font-size-body-sm); display: flex; align-items: center; gap: 8px;">
            <span><i class="fa-solid fa-circle-check"></i></span>
            <span><%= successMessage %></span>
          </div>
          <% } %>

          <!-- Error Alert Message -->
          <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
          <div style="background-color: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; padding: 12px 16px; border-radius: var(--radius-md); margin-bottom: var(--space-4); font-size: var(--font-size-body-sm); display: flex; align-items: center; gap: 8px;">
            <span><i class="fa-solid fa-triangle-exclamation"></i></span>
            <span><%= errorMessage %></span>
          </div>
          <% } %>

          <!-- Auth Tab Switcher -->
          <div class="auth-tabs-bar" role="tablist">
            <label for="tab-choice-login" class="auth-tab-button" id="tab-btn-login">
              Sign In
            </label>
            <label for="tab-choice-register" class="auth-tab-button" id="tab-btn-register">
              Create Account
            </label>
          </div>

          <div class="auth-forms-wrap">
            <!-- =================================================================
                 Tab 1: Login Form
                 ================================================================= -->
            <form id="login-form-container" class="auth-form" action="<%= request.getContextPath() %>/login" method="POST">
              <input type="hidden" name="action" value="login">
              <input type="hidden" name="redirect" value="<%= redirectParam != null ? redirectParam : "" %>">

              <!-- Email -->
              <div class="form-field-group">
                <label for="login-email" class="form-field-label">Email Address</label>
                <div class="form-input-wrapper">
                  <span class="form-input-icon"><i class="fa-solid fa-envelope"></i></span>
                  <input type="email" id="login-email" name="email" class="auth-input"
                    placeholder="e.g. amitabh.sen@gmail.com" value="<%= prefillEmail != null ? prefillEmail : "" %>" required>
                </div>
              </div>

              <!-- Password -->
              <div class="form-field-group">
                <div class="form-field-label" style="display: flex; justify-content: space-between;">
                  <span>Password</span>
                  <a href="#forgot-password-modal" onclick="openForgotPasswordModal(event)" style="color: var(--color-primary); font-weight: 500; font-size: 12px;">Forgot?</a>
                </div>
                <div class="form-input-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                  <span class="form-input-icon"><i class="fa-solid fa-lock"></i></span>
                  <input type="password" id="login-password" name="password" class="auth-input has-toggle"
                    placeholder="Enter your password" required style="padding-right: 44px;">
                  <button type="button" class="password-toggle-btn form-input-toggle" onclick="togglePasswordVisibility('login-password', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-muted); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;">
                    <i class="fa-solid fa-eye" style="pointer-events: none;"></i>
                  </button>
                </div>
              </div>

              <!-- Remember Me -->
              <div style="display: flex; align-items: center; gap: 8px; margin-top: 4px;">
                <input type="checkbox" id="remember-me" name="remember" class="filter-checkbox" checked>
                <label for="remember-me"
                  style="font-size: var(--font-size-body-sm); color: var(--color-text-secondary); cursor: pointer;">
                  Keep me signed in on this device
                </label>
              </div>

              <!-- Submit Button -->
              <button type="submit" class="btn btn-primary btn-lg" id="login-submit-btn"
                style="width: 100%; margin-top: var(--space-2);">
                Sign In to FoodRush →
              </button>

              <!-- Fast Demo Credentials Helper -->
              <div class="demo-logins-box" style="margin-top: 20px; padding: 12px; background-color: var(--color-surface-soft); border: 1px dashed var(--color-border); border-radius: var(--radius-md);">
                <span class="demo-logins-title" style="display: block; font-size: 11px; font-weight: bold; color: var(--color-text-secondary); margin-bottom: 8px;">
                  <i class="fa-solid fa-bolt-lightning text-primary" style="margin-right: 4px;"></i> Instant Demo Credentials (1-Click Fill)
                </span>
                <div class="demo-btn-group" style="display: flex; gap: 8px;">
                  <button type="button" class="btn btn-secondary btn-sm" style="flex: 1; text-align: center; font-size: 11px; padding: 6px 4px;"
                    onclick="document.getElementById('login-email').value='amitabh.sen@gmail.com'; document.getElementById('login-password').value='pass1234';">
                    <i class="fa-solid fa-user" style="margin-right: 4px;"></i> Customer Demo
                  </button>
                  <button type="button" class="btn btn-secondary btn-sm" style="flex: 1; text-align: center; font-size: 11px; padding: 6px 4px;"
                    onclick="document.getElementById('login-email').value='ramesh.driver@foodrush.com'; document.getElementById('login-password').value='driver@123';">
                    <i class="fa-solid fa-motorcycle" style="margin-right: 4px;"></i> Driver Demo
                  </button>
                  <button type="button" class="btn btn-secondary btn-sm" style="flex: 1; text-align: center; font-size: 11px; padding: 6px 4px;"
                    onclick="document.getElementById('login-email').value='admin@foodrush.com'; document.getElementById('login-password').value='admin@123';">
                    <i class="fa-solid fa-shield-halved" style="margin-right: 4px;"></i> Admin Demo
                  </button>
                </div>
              </div>

            </form>

            <!-- =================================================================
                 Tab 2: Register Form
                 ================================================================= -->
            <form id="register-form-container" class="auth-form" action="<%= request.getContextPath() %>/register" method="POST">
              <input type="hidden" name="action" value="register">
              <input type="hidden" name="redirect" value="<%= redirectParam != null ? redirectParam : "" %>">

              <!-- Full Name -->
              <div class="form-field-group">
                <label for="reg-name" class="form-field-label">Full Name</label>
                <div class="form-input-wrapper">
                  <span class="form-input-icon"><i class="fa-solid fa-user"></i></span>
                  <input type="text" id="reg-name" name="name" class="auth-input" placeholder="e.g. Rahul Sharma"
                    value="<%= prefillName != null ? prefillName : "" %>" required>
                </div>
              </div>

              <!-- Email Address -->
              <div class="form-field-group">
                <label for="reg-email" class="form-field-label">Email Address</label>
                <div class="form-input-wrapper">
                  <span class="form-input-icon"><i class="fa-solid fa-envelope"></i></span>
                  <input type="email" id="reg-email" name="email" class="auth-input"
                    placeholder="e.g. rahul@example.com" value="<%= prefillEmail != null ? prefillEmail : "" %>" required>
                </div>
              </div>

              <!-- Phone Number -->
              <div class="form-field-group">
                <label for="reg-phone" class="form-field-label">Phone Number (10 digits)</label>
                <div class="form-input-wrapper">
                  <span class="form-input-icon"><i class="fa-solid fa-phone"></i></span>
                  <input type="tel" id="reg-phone" name="phone" class="auth-input" placeholder="e.g. 9845012399"
                    pattern="[0-9]{10}" value="<%= prefillPhone != null ? prefillPhone : "" %>" required>
                </div>
              </div>

              <!-- Password -->
              <div class="form-field-group">
                <label for="reg-password" class="form-field-label">Create Password</label>
                <div class="form-input-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                  <span class="form-input-icon"><i class="fa-solid fa-lock"></i></span>
                  <input type="password" id="reg-password" name="password" class="auth-input has-toggle"
                    placeholder="Minimum 6 characters" minlength="6" required style="padding-right: 44px;">
                  <button type="button" class="password-toggle-btn form-input-toggle" onclick="togglePasswordVisibility('reg-password', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-muted); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;">
                    <i class="fa-solid fa-eye" style="pointer-events: none;"></i>
                  </button>
                </div>
              </div>

              <!-- Delivery Address -->
              <div class="form-field-group">
                <label for="reg-address" class="form-field-label">Default Delivery Address</label>
                <div class="form-input-wrapper">
                  <span class="form-input-icon"><i class="fa-solid fa-location-dot"></i></span>
                  <input type="text" id="reg-address" name="address" class="auth-input"
                    placeholder="Flat / House No, Street, Locality, Bangalore"
                    value="<%= prefillAddress != null ? prefillAddress : "" %>" required>
                </div>
              </div>

              <!-- Terms agreement -->
              <div style="display: flex; align-items: flex-start; gap: 8px; margin-top: 4px;">
                <input type="checkbox" id="reg-terms" class="filter-checkbox" required style="margin-top: 3px;" checked>
                <label for="reg-terms"
                  style="font-size: var(--font-size-caption); color: var(--color-text-secondary); line-height: 1.4;">
                  I agree to the FoodRush <a href="#" class="text-brand">Terms of Service</a> and <a href="#"
                    class="text-brand">Privacy Policy</a>.
                </label>
              </div>

              <!-- Submit Button -->
              <button type="submit" class="btn btn-primary btn-lg" id="reg-submit-btn"
                style="width: 100%; margin-top: var(--space-2);">
                Create FoodRush Account →
              </button>

            </form>
          </div>

        </div>
      </main>

    </div>
  </div>

  <!-- Modal: Forgot Password Interactive 2-Step Popup -->
  <div class="modal-overlay" id="forgot-password-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog" style="max-width: 440px;">
      <div class="modal-header">
        <h3 class="modal-title" id="fp-modal-title"><i class="fa-solid fa-key text-primary" style="margin-right: 8px;"></i> Reset Password</h3>
        <button type="button" class="modal-close-btn" id="fp-modal-close" onclick="closeForgotPasswordModal(event)" aria-label="Close" style="background: none; border: none; font-size: 20px; cursor: pointer; color: var(--color-text-muted); width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-xmark"></i></button>
      </div>
      <div class="modal-body" style="padding: 20px;">

        <!-- Step 1: Email Request -->
        <div id="fp-modal-step1">
          <p style="font-size: var(--font-size-body-sm); color: var(--color-text-secondary); margin-bottom: 16px;">
            Enter your registered FoodRush email address to receive a secure 6-digit verification code.
          </p>

          <div id="fp-step1-error" style="display: none; background-color: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; padding: 10px 14px; border-radius: var(--radius-md); margin-bottom: 14px; font-size: 13px;"></div>

          <form id="fp-modal-form-step1">
            <div class="form-field-group" style="margin-bottom: 16px;">
              <label class="form-field-label">Registered Email</label>
              <input type="email" id="fp-modal-email" class="nav-search-input" placeholder="e.g. amitabh.sen@gmail.com" required
                style="padding: 10px 14px; width: 100%; border: 1px solid var(--color-border); border-radius: var(--radius-md);">
            </div>
            <button type="submit" id="fp-step1-btn" class="btn btn-primary" style="width: 100%; padding: 12px; font-weight: 600;">
              Send Recovery Code →
            </button>
            <div style="text-align: center; margin-top: 12px;">
              <a href="<%= request.getContextPath() %>/forgot-password" style="font-size: 12px; color: var(--color-text-muted); text-decoration: none;">
                Open dedicated recovery page ↗
              </a>
            </div>
          </form>
        </div>

        <!-- Step 2: OTP Verification & New Password -->
        <div id="fp-modal-step2" style="display: none;">
          <div id="fp-step2-alert" style="background-color: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; padding: 10px 14px; border-radius: var(--radius-md); margin-bottom: 14px; font-size: 13px;">
            <div id="fp-step2-msg"><i class="fa-solid fa-circle-check" style="margin-right: 6px;"></i> Verification code sent!</div>
            <div id="fp-demo-otp-banner" style="margin-top: 4px; font-weight: bold;"></div>
          </div>

          <div id="fp-step2-error" style="display: none; background-color: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; padding: 10px 14px; border-radius: var(--radius-md); margin-bottom: 14px; font-size: 13px;"></div>

          <form id="fp-modal-form-step2">
            <div class="form-field-group" style="margin-bottom: 12px;">
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                <label class="form-field-label">6-Digit Verification Code</label>
                <a href="#" id="fp-resend-link" style="font-size: 12px; color: var(--color-primary); text-decoration: none;">Resend Code</a>
              </div>
              <input type="text" id="fp-modal-otp" class="nav-search-input" placeholder="123456" maxlength="6" pattern="[0-9]{6}" required
                style="padding: 10px 14px; width: 100%; border: 1px solid var(--color-border); border-radius: var(--radius-md); letter-spacing: 4px; font-weight: bold; text-align: center; font-size: 16px;">
            </div>

            <div class="form-field-group" style="margin-bottom: 12px;">
              <label class="form-field-label">New Password (min 6 characters)</label>
              <div class="form-input-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                <span class="form-input-icon"><i class="fa-solid fa-lock"></i></span>
                <input type="password" id="fp-modal-new-pw" class="auth-input has-toggle" placeholder="Enter new password" minlength="6" required style="padding-right: 44px;">
                <button type="button" class="password-toggle-btn form-input-toggle" onclick="togglePasswordVisibility('fp-modal-new-pw', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-muted); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;">
                  <i class="fa-solid fa-eye" style="pointer-events: none;"></i>
                </button>
              </div>
            </div>

            <div class="form-field-group" style="margin-bottom: 16px;">
              <label class="form-field-label">Confirm New Password</label>
              <div class="form-input-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                <span class="form-input-icon"><i class="fa-solid fa-lock"></i></span>
                <input type="password" id="fp-modal-confirm-pw" class="auth-input has-toggle" placeholder="Confirm new password" minlength="6" required style="padding-right: 44px;">
                <button type="button" class="password-toggle-btn form-input-toggle" onclick="togglePasswordVisibility('fp-modal-confirm-pw', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-muted); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;">
                  <i class="fa-solid fa-eye" style="pointer-events: none;"></i>
                </button>
              </div>
            </div>

            <button type="submit" id="fp-step2-btn" class="btn btn-primary" style="width: 100%; padding: 12px; font-weight: 600;">
              Update Password & Sign In →
            </button>
          </form>
        </div>

      </div>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Vanilla JavaScript Handlers with Cache-Buster -->
  <script src="<%= request.getContextPath() %>/frontend/js/global.js?v=<%= System.currentTimeMillis() %>"></script>

  <!-- Interactive Forgot Password Modal Controller -->
  <script>
    (function () {
      const step1Wrap = document.getElementById('fp-modal-step1');
      const step2Wrap = document.getElementById('fp-modal-step2');
      const formStep1 = document.getElementById('fp-modal-form-step1');
      const formStep2 = document.getElementById('fp-modal-form-step2');
      const emailInput = document.getElementById('fp-modal-email');
      const otpInput = document.getElementById('fp-modal-otp');
      const newPwInput = document.getElementById('fp-modal-new-pw');
      const confirmPwInput = document.getElementById('fp-modal-confirm-pw');
      const step1Error = document.getElementById('fp-step1-error');
      const step2Error = document.getElementById('fp-step2-error');
      const demoOtpBanner = document.getElementById('fp-demo-otp-banner');
      const step1Btn = document.getElementById('fp-step1-btn');
      const step2Btn = document.getElementById('fp-step2-btn');
      const resendLink = document.getElementById('fp-resend-link');
      const modalClose = document.getElementById('fp-modal-close');

      let currentEmail = '';

      window.openForgotPasswordModal = function (e) {
        if (e) e.preventDefault();
        const modal = document.getElementById('forgot-password-modal');
        if (modal) {
          modal.classList.add('active', 'open');
          modal.style.display = 'flex';
          modal.style.opacity = '1';
          modal.style.visibility = 'visible';
          modal.style.pointerEvents = 'auto';
          const emailField = document.getElementById('fp-modal-email');
          if (emailField) setTimeout(() => emailField.focus(), 80);
        }
      };

      window.closeForgotPasswordModal = function (e) {
        if (e) {
          e.preventDefault();
          e.stopPropagation();
        }
        const modal = document.getElementById('forgot-password-modal');
        if (modal) {
          modal.classList.remove('active', 'open');
          modal.style.display = 'none';
          modal.style.opacity = '0';
          modal.style.visibility = 'hidden';
          modal.style.pointerEvents = 'none';
        }
        if (window.closeModal) {
          window.closeModal('forgot-password-modal');
        }
        if (window.location.hash) {
          try {
            history.pushState('', document.title, window.location.pathname + window.location.search);
          } catch (err) {
            window.location.hash = '';
          }
        }
      };

      if (modalClose) {
        modalClose.addEventListener('click', window.closeForgotPasswordModal);
      }

      const fpModalEl = document.getElementById('forgot-password-modal');
      if (fpModalEl) {
        fpModalEl.addEventListener('click', function (e) {
          if (e.target === fpModalEl) {
            window.closeForgotPasswordModal(e);
          }
        });
      }

      document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' || e.key === 'Esc') {
          const m = document.getElementById('forgot-password-modal');
          if (m && (m.classList.contains('active') || m.style.display === 'flex')) {
            window.closeForgotPasswordModal(e);
          }
        }
      });

      if (formStep1) {
        formStep1.addEventListener('submit', function (e) {
          e.preventDefault();
          if (step1Error) step1Error.style.display = 'none';
          currentEmail = (emailInput.value || '').trim();
          if (!currentEmail) return;

          step1Btn.disabled = true;
          step1Btn.textContent = 'Sending Code...';

          fetch('<%= request.getContextPath() %>/forgot-password?action=sendOtp&email=' + encodeURIComponent(currentEmail) + '&format=json', {
            method: 'POST'
          })
          .then(res => res.json())
          .then(data => {
            step1Btn.disabled = false;
            step1Btn.textContent = 'Send Recovery Code →';
            if (data && data.success) {
              step1Wrap.style.display = 'none';
              step2Wrap.style.display = 'block';
              const alertMsg = document.getElementById('fp-step2-msg');
              if (data.emailSent) {
                if (alertMsg) alertMsg.innerHTML = '<i class="fa-solid fa-envelope" style="margin-right: 6px;"></i> Verification code sent to <strong>' + (data.email || currentEmail) + '</strong>! Please check your inbox and spam folder.';
                if (demoOtpBanner) demoOtpBanner.style.display = 'none';
              } else {
                if (alertMsg) alertMsg.innerHTML = '<i class="fa-solid fa-bolt-lightning text-primary" style="margin-right: 6px;"></i> Verification code generated!';
                if (data.demoOtp && demoOtpBanner) {
                  demoOtpBanner.style.display = 'block';
                  demoOtpBanner.innerHTML = 'Test OTP code is: <code style="background: rgba(0,0,0,0.08); padding: 2px 6px; border-radius: 4px; font-size: 14px; font-weight: bold;">' + data.demoOtp + '</code>';
                }
              }
              if (otpInput) otpInput.focus();
            } else {
              if (step1Error) {
                step1Error.textContent = (data && data.message) ? data.message : 'Error sending recovery code.';
                step1Error.style.display = 'block';
              }
            }
          })
          .catch(err => {
            step1Btn.disabled = false;
            step1Btn.textContent = 'Send Recovery Code →';
            if (step1Error) {
              step1Error.textContent = 'Network error. Please try again.';
              step1Error.style.display = 'block';
            }
          });
        });
      }

      if (resendLink) {
        resendLink.addEventListener('click', function (e) {
          e.preventDefault();
          if (!currentEmail) {
            step1Wrap.style.display = 'block';
            step2Wrap.style.display = 'none';
            return;
          }
          resendLink.textContent = 'Resending...';
          fetch('<%= request.getContextPath() %>/forgot-password?action=sendOtp&email=' + encodeURIComponent(currentEmail) + '&format=json', {
            method: 'POST'
          })
          .then(res => res.json())
          .then(data => {
            resendLink.textContent = 'Resend Code';
            if (data && data.success && data.demoOtp && demoOtpBanner) {
              demoOtpBanner.innerHTML = 'New OTP code: <code style="background: rgba(0,0,0,0.08); padding: 2px 6px; border-radius: 4px; font-size: 14px; font-weight: bold;">' + data.demoOtp + '</code>';
              if (window.FoodRush) window.FoodRush.showToast('New code generated: ' + data.demoOtp);
            }
          })
          .catch(() => { resendLink.textContent = 'Resend Code'; });
        });
      }

      if (formStep2) {
        formStep2.addEventListener('submit', function (e) {
          e.preventDefault();
          if (step2Error) step2Error.style.display = 'none';
          const otp = (otpInput.value || '').trim();
          const newPw = newPwInput.value;
          const confirmPw = confirmPwInput.value;

          if (newPw.length < 6) {
            if (step2Error) {
              step2Error.textContent = 'Password must be at least 6 characters.';
              step2Error.style.display = 'block';
            }
            return;
          }
          if (newPw !== confirmPw) {
            if (step2Error) {
              step2Error.textContent = 'Passwords do not match.';
              step2Error.style.display = 'block';
            }
            return;
          }

          step2Btn.disabled = true;
          step2Btn.textContent = 'Updating Password...';

          const params = new URLSearchParams();
          params.append('action', 'verifyAndReset');
          params.append('email', currentEmail);
          params.append('otp', otp);
          params.append('newPassword', newPw);
          params.append('confirmPassword', confirmPw);
          params.append('format', 'json');

          fetch('<%= request.getContextPath() %>/forgot-password', {
            method: 'POST',
            body: params
          })
          .then(res => res.json())
          .then(data => {
            step2Btn.disabled = false;
            step2Btn.textContent = 'Update Password & Sign In →';
            if (data && data.success) {
              // Redirect directly to login page with success notification!
              window.location.href = '<%= request.getContextPath() %>/login?resetSuccess=true&email=' + encodeURIComponent(currentEmail);
            } else {
              if (step2Error) {
                step2Error.textContent = (data && data.message) ? data.message : 'Error updating password.';
                step2Error.style.display = 'block';
              }
            }
          })
          .catch(err => {
            step2Btn.disabled = false;
            step2Btn.textContent = 'Update Password & Sign In →';
            if (step2Error) {
              step2Error.textContent = 'Network error. Please try again.';
              step2Error.style.display = 'block';
            }
          });
        });
      }
    })();
  </script>
</body>
</html>
