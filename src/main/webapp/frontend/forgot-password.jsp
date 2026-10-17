<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String step = (String) request.getAttribute("step");
    if (step == null || step.trim().isEmpty()) {
        step = "1";
    }
    String email = (String) request.getAttribute("email");
    if (email == null) {
        email = (String) session.getAttribute("fp_email");
    }
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    String demoOtp = (String) request.getAttribute("demoOtp");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Reset your FoodRush password securely with a one-time verification code.">
  <title>Reset Password — FoodRush</title>

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

      <!-- Left Branding & Showcase Panel -->
      <aside class="auth-brand-sidebar">
        <div class="auth-sidebar-top" style="display: flex; justify-content: space-between; align-items: center;">
          <a href="<%= request.getContextPath() %>/home" class="brand-logo" title="Back to Home">
            <div class="brand-icon"><i class="fa-solid fa-bolt-lightning text-primary"></i></div>
            <span>Food<span class="brand-name-highlight">Rush</span></span>
          </a>
          <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
            <span class="theme-icon sun-icon"><i class="fa-solid fa-sun"></i></span>
            <span class="theme-icon moon-icon"><i class="fa-solid fa-moon"></i></span>
          </button>
        </div>

        <div class="auth-brand-content">
          <div class="brand-badge-pill"><i class="fa-solid fa-shield-halved" style="margin-right: 6px;"></i> Secure Account Recovery</div>
          <h1 class="brand-heading">
            Forgot your password?<br>
            <span class="gradient-text">We've got you covered.</span>
          </h1>
          <p class="brand-subtext">
            Enter your registered email address and verify your identity with a secure 6-digit code to choose a new password.
          </p>
        </div>

        <div class="auth-sidebar-footer">
          <p class="copyright-text">© 2026 FoodRush Inc. All rights reserved.</p>
        </div>
      </aside>

      <!-- Right Form Container Panel -->
      <main class="auth-form-panel">
        <div class="auth-form-container">

          <div class="auth-header-block">
            <div style="display: inline-flex; align-items: center; justify-content: center; width: 48px; height: 48px; border-radius: 12px; background: var(--color-primary-soft); color: var(--color-primary); font-size: 24px; margin-bottom: 12px;">
              <i class="fa-solid fa-key"></i>
            </div>
            <h2 class="auth-header-title">Reset Your Password</h2>
            <p class="auth-header-subtitle">
              <%= "2".equals(step) ? "Enter the verification code and your new password." : "Enter your registered email to receive a recovery code." %>
            </p>
          </div>

          <!-- Error Alert Message -->
          <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
          <div style="background-color: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; padding: 12px 16px; border-radius: var(--radius-md); margin-bottom: var(--space-4); font-size: var(--font-size-body-sm); display: flex; align-items: center; gap: 8px;">
            <span><i class="fa-solid fa-triangle-exclamation"></i></span>
            <span><%= errorMessage %></span>
          </div>
          <% } %>

          <!-- Success / Demo OTP Alert Message -->
          <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
          <div style="background-color: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; padding: 12px 16px; border-radius: var(--radius-md); margin-bottom: var(--space-4); font-size: var(--font-size-body-sm); display: flex; align-items: center; gap: 8px;">
            <span><i class="fa-solid fa-circle-check"></i></span>
            <div>
              <strong><%= successMessage %></strong>
              <% if (demoOtp != null && !demoOtp.isEmpty()) { %>
                <div style="margin-top: 4px; font-size: 12px;">
                  Test OTP Code: <code style="background: rgba(0,0,0,0.06); padding: 2px 6px; border-radius: 4px; font-weight: bold; font-size: 13px;"><%= demoOtp %></code>
                </div>
              <% } %>
            </div>
          </div>
          <% } %>

          <!-- Step 1: Request Code -->
          <% if (!"2".equals(step)) { %>
          <form action="<%= request.getContextPath() %>/forgot-password" method="POST" class="auth-form" id="fp-step1-form">
            <input type="hidden" name="action" value="sendOtp">

            <div class="form-field-group">
              <label for="fp-email" class="form-field-label">Registered Email Address</label>
              <div class="form-input-wrapper">
                <span class="form-input-icon"><i class="fa-solid fa-envelope"></i></span>
                <input type="email" id="fp-email" name="email" class="auth-input"
                  placeholder="e.g. amitabh.sen@gmail.com" value="<%= email != null ? email : "" %>" required autofocus>
              </div>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-top: 8px; font-weight: 600;">
              Send Recovery Code →
            </button>
          </form>
          <% } else { %>
          <!-- Step 2: Verify Code & Reset -->
          <form action="<%= request.getContextPath() %>/forgot-password" method="POST" class="auth-form" id="fp-step2-form">
            <input type="hidden" name="action" value="verifyAndReset">
            <input type="hidden" name="email" value="<%= email != null ? email : "" %>">

            <div class="form-field-group">
              <label class="form-field-label">Recovery Email</label>
              <div class="form-input-wrapper" style="opacity: 0.85;">
                <span class="form-input-icon"><i class="fa-solid fa-envelope"></i></span>
                <input type="email" class="auth-input" value="<%= email != null ? email : "" %>" readonly style="background: var(--color-surface-soft);">
              </div>
            </div>

            <div class="form-field-group">
              <div class="form-field-label" style="display: flex; justify-content: space-between;">
                <span>6-Digit Verification Code</span>
                <a href="<%= request.getContextPath() %>/forgot-password" style="font-size: 12px; color: var(--color-primary); text-decoration: none;">Change Email</a>
              </div>
              <div class="form-input-wrapper">
                <span class="form-input-icon"><i class="fa-solid fa-shield-halved"></i></span>
                <input type="text" id="fp-otp" name="otp" class="auth-input"
                  placeholder="123456" maxlength="6" pattern="[0-9]{6}" required autofocus
                  style="letter-spacing: 4px; font-weight: bold; font-size: 16px;">
              </div>
            </div>

            <div class="form-field-group">
              <label for="fp-new-password" class="form-field-label">New Password (min 6 characters)</label>
              <div class="form-input-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                <span class="form-input-icon"><i class="fa-solid fa-lock"></i></span>
                <input type="password" id="fp-new-password" name="newPassword" class="auth-input has-toggle"
                  placeholder="Enter new password" minlength="6" required style="padding-right: 44px;">
                <button type="button" class="password-toggle-btn form-input-toggle" onclick="togglePasswordVisibility('fp-new-password', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-muted); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;">
                  <i class="fa-solid fa-eye" style="pointer-events: none;"></i>
                </button>
              </div>
            </div>

            <div class="form-field-group">
              <label for="fp-confirm-password" class="form-field-label">Confirm New Password</label>
              <div class="form-input-wrapper password-input-wrapper" style="position: relative; display: flex; align-items: center;">
                <span class="form-input-icon"><i class="fa-solid fa-lock"></i></span>
                <input type="password" id="fp-confirm-password" name="confirmPassword" class="auth-input has-toggle"
                  placeholder="Confirm new password" minlength="6" required style="padding-right: 44px;">
                <button type="button" class="password-toggle-btn form-input-toggle" onclick="togglePasswordVisibility('fp-confirm-password', this, event)" aria-label="Toggle password visibility" title="Show/Hide Password" style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: transparent; border: none; outline: none; box-shadow: none; padding: 4px; cursor: pointer; color: var(--color-text-muted); font-size: 16px; display: inline-flex; align-items: center; justify-content: center; z-index: 15;">
                  <i class="fa-solid fa-eye" style="pointer-events: none;"></i>
                </button>
              </div>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-top: 8px; font-weight: 600;">
              Reset Password & Sign In →
            </button>
          </form>
          <% } %>

          <div style="text-align: center; margin-top: var(--space-6); font-size: var(--font-size-body-sm); color: var(--color-text-secondary);">
            Remember your password?
            <a href="<%= request.getContextPath() %>/login" style="color: var(--color-primary); font-weight: 600; text-decoration: none;">
              Back to Sign In
            </a>
          </div>

        </div>
      </main>

    </div>
  </div>

  <div class="toast-container" id="toast-container"></div>
  <script src="<%= request.getContextPath() %>/frontend/js/global.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
