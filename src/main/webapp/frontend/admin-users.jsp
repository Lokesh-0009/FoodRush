<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.foodRush.model.User"%>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || loggedUser.getRole() == null ||
        (!loggedUser.getRole().toUpperCase().contains("ADMIN") &&
         !loggedUser.getRole().toUpperCase().contains("MANAGER") &&
         !loggedUser.getRole().toUpperCase().contains("SUPER"))) {
        response.sendRedirect(request.getContextPath() + "/login?redirect=admin/users");
        return;
    }
    if (request.getAttribute("userList") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    String adminName = (loggedUser.getName() != null) ? loggedUser.getName() : "System Admin";
    String adminEmail = (loggedUser.getEmail() != null) ? loggedUser.getEmail() : "admin@foodrush.com";

    List<User> userList = (List<User>) request.getAttribute("userList");
    Integer totalUsersObj = (Integer) request.getAttribute("totalUsers");
    int totalUsers = (totalUsersObj != null) ? totalUsersObj : (userList != null ? userList.size() : 8);

    Long customerCountObj = (Long) request.getAttribute("customerCount");
    long customerCount = (customerCountObj != null) ? customerCountObj : 5;

    Long managerCountObj = (Long) request.getAttribute("managerCount");
    long managerCount = (managerCountObj != null) ? managerCountObj : 2;

    Long adminCountObj = (Long) request.getAttribute("adminCount");
    long adminCount = (adminCountObj != null) ? adminCountObj : 1;

    Long driverCountObj = (Long) request.getAttribute("driverCount");
    long driverCount = (driverCountObj != null) ? driverCountObj : 0;

    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="FoodRush Admin Portal - User & Role Management. Manage customer profiles, restaurant managers, and system administrators.">
  <title>User Management — FoodRush Admin</title>

  <!-- Google Fonts: Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Core CSS Design System -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css?v=2.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css?v=2.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css?v=2.0">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/admin.css?v=2.0">

  <!-- Font Awesome 6 (Vector Icons) -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

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

  <div class="admin-layout">
    
    <!-- =========================================================================
         1. Fixed Admin Sidebar
         ========================================================================= -->
    <aside class="admin-sidebar" id="admin-sidebar" aria-label="Admin Navigation">
      <div>
        <div class="admin-sidebar-header">
          <a href="<%= request.getContextPath() %>/admin/dashboard" class="admin-brand-logo">
            <i class="fa-solid fa-bolt-lightning text-primary"></i>
            <span>FoodRush</span>
            <span class="admin-badge-pill">Admin</span>
          </a>
        </div>

        <ul class="admin-nav-menu">
          <li>
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="admin-nav-link">
              <i class="fa-solid fa-chart-line" style="width: 18px; text-align: center;"></i> Dashboard
            </a>
          </li>
          <li>
            <a href="<%= request.getContextPath() %>/admin/restaurants" class="admin-nav-link">
              <i class="fa-solid fa-utensils" style="width: 18px; text-align: center;"></i> Restaurants
            </a>
          </li>
          <li>
            <a href="<%= request.getContextPath() %>/admin/menu" class="admin-nav-link">
              <i class="fa-solid fa-book-open" style="width: 18px; text-align: center;"></i> Menu Management
            </a>
          </li>
          <li>
            <a href="<%= request.getContextPath() %>/admin/orders" class="admin-nav-link">
              <i class="fa-solid fa-box" style="width: 18px; text-align: center;"></i> Live Orders / Kitchen
            </a>
          </li>
          <li>
            <a href="<%= request.getContextPath() %>/admin/users" class="admin-nav-link active">
              <i class="fa-solid fa-users" style="width: 18px; text-align: center;"></i> User Management
            </a>
          </li>
        </ul>
      </div>

      <!-- Bottom Sidebar: Customer App Link & Profile -->
      <div class="admin-sidebar-footer">
        <a href="<%= request.getContextPath() %>/home" class="admin-customer-link">
          <i class="fa-solid fa-house" style="width: 16px; text-align: center;"></i> Back to Customer Site
        </a>

        <div class="admin-profile-pill">
          <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=80" alt="Admin Avatar" class="admin-avatar">
          <div style="font-size: var(--font-size-caption); min-width: 0;">
            <div style="color: #FFFFFF; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= adminName %></div>
            <div style="color: #D4C5C7; font-size: 11px;"><%= adminEmail %></div>
          </div>
        </div>

        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm" style="width: 100%; justify-content: center; color: var(--color-error); border-color: rgba(229, 9, 20, 0.4); text-decoration: none; font-weight: 600; padding: 6px 12px; font-size: 12px; margin-top: 8px; display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-right-from-bracket"></i> Sign Out
        </a>
      </div>
    </aside>

    <!-- =========================================================================
         2. Main Content Area
         ========================================================================= -->
    <div class="admin-main-wrapper">
      
      <!-- Admin Topbar -->
      <header class="admin-topbar">
        <div style="display: flex; align-items: center; gap: 16px;">
          <button type="button" class="btn btn-secondary btn-sm" id="admin-sidebar-toggle" style="display: none; padding: 6px 10px;">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <div style="font-size: 12px; color: var(--color-text-muted); display: flex; align-items: center; gap: 6px; margin-bottom: 4px;">
              <a href="<%= request.getContextPath() %>/admin/dashboard" style="color: var(--color-text-secondary); text-decoration: none;">Dashboard</a>
              <span>/</span>
              <span style="color: var(--color-primary); font-weight: 600;">Users</span>
            </div>
            <h1 style="font-size: var(--font-size-h3); font-weight: bold; margin-bottom: 2px;">User & Role Management</h1>
          </div>
        </div>

        <div style="display: flex; align-items: center; gap: 12px;">
          <!-- Theme Toggle Button -->
          <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
            <i class="fa-solid fa-sun sun-icon"></i>
            <i class="fa-solid fa-moon moon-icon"></i>
          </button>
          <button type="button" class="btn btn-primary btn-sm" onclick="openNewUserModal()" style="display: flex; align-items: center; gap: 6px; padding: 8px 16px; font-weight: 700;">
            <i class="fa-solid fa-user-plus"></i> Add User
          </button>
          <!-- Sign Out Button -->
          <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary btn-sm" style="display: flex; align-items: center; gap: 6px; color: var(--color-error); border-color: rgba(229, 9, 20, 0.3); text-decoration: none; font-weight: 600; padding: 7px 14px;" title="Sign Out">
            <i class="fa-solid fa-right-from-bracket"></i> <span>Sign Out</span>
          </a>
        </div>
      </header>

      <!-- Main Dashboard Content -->
      <main class="admin-page-content">
        
        <!-- Summary Stats Cards -->
        <section class="kpi-grid" aria-label="User Statistics">
          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Total Users</span>
              <div class="kpi-icon-box"><i class="fa-solid fa-users"></i></div>
            </div>
            <div class="kpi-value" id="kpi-total-users"><%= totalUsers %></div>
            <div class="kpi-trend neutral"><span>Registered accounts</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Active Customers</span>
              <div class="kpi-icon-box" style="background-color: var(--color-primary-soft); color: var(--color-primary);"><i class="fa-solid fa-bag-shopping"></i></div>
            </div>
            <div class="kpi-value" id="kpi-customer-count" style="color: var(--color-primary-light);"><%= customerCount %></div>
            <div class="kpi-trend positive"><span>Ordering customers</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Restaurant Managers</span>
              <div class="kpi-icon-box info"><i class="fa-solid fa-utensils"></i></div>
            </div>
            <div class="kpi-value" id="kpi-manager-count" style="color: #60A5FA;"><%= managerCount %></div>
            <div class="kpi-trend neutral"><span>Kitchen outlet staff</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Super Admins</span>
              <div class="kpi-icon-box success"><i class="fa-solid fa-shield-halved"></i></div>
            </div>
            <div class="kpi-value" id="kpi-admin-count" style="color: var(--color-success);"><%= adminCount %></div>
            <div class="kpi-trend positive"><span>Full system control</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Delivery Partners</span>
              <div class="kpi-icon-box" style="background-color: rgba(245, 158, 11, 0.15); color: #F59E0B;"><i class="fa-solid fa-motorcycle"></i></div>
            </div>
            <div class="kpi-value" id="kpi-driver-count" style="color: #FBBF24;"><%= driverCount %></div>
            <div class="kpi-trend positive"><span>Active fleet riders</span></div>
          </div>
        </section>

        <!-- Filter & Search Controls Bar -->
        <div class="admin-filter-bar">
          <div class="admin-search-wrap">
            <i class="fa-solid fa-magnifying-glass" style="color: var(--color-text-muted);"></i>
            <input type="text" id="user-search-input" placeholder="Search by name, email or phone...">
          </div>

          <div class="admin-filter-group">
            <select id="user-role-filter" class="form-select">
              <option value="ALL">All Roles</option>
              <option value="CUSTOMER">Customer</option>
              <option value="RESTAURANT_ADMIN">Restaurant Manager</option>
              <option value="DRIVER">Delivery Partner</option>
              <option value="SUPER_ADMIN">Super Admin</option>
            </select>

            <select id="user-status-filter" class="form-select">
              <option value="ALL">All Statuses</option>
              <option value="ACTIVE">Active Only</option>
              <option value="SUSPENDED">Suspended Only</option>
            </select>

            <button type="button" class="btn btn-secondary btn-sm" onclick="document.getElementById('user-search-input').value=''; document.getElementById('user-role-filter').value='ALL'; document.getElementById('user-status-filter').value='ALL'; window.location.reload();">
              Reset Filters
            </button>
          </div>
        </div>

        <!-- Users Data Table -->
        <section class="admin-card">
          <div class="admin-card-header">
            <div>
              <h2 style="font-size: var(--font-size-h3); font-weight: bold; margin-bottom: 2px;">User Directory (<span id="user-count-label"><%= totalUsers %></span>)</h2>
              <p style="font-size: var(--font-size-caption); color: var(--color-text-secondary);">Manage system permissions, roles, and customer account access</p>
            </div>
          </div>

          <div class="admin-table-wrapper">
            <table class="admin-table">
              <thead>
                <tr>
                  <th>User Profile</th>
                  <th>Email Address</th>
                  <th>Phone Number</th>
                  <th>Assigned Role</th>
                  <th>Joined Date</th>
                  <th>Address</th>
                  <th>Status</th>
                  <th style="text-align: right;">Actions</th>
                </tr>
              </thead>
              <tbody id="users-table-body">
                <%
                    if (userList != null && !userList.isEmpty()) {
                        for (User u : userList) {
                            String role = (u.getRole() != null) ? u.getRole() : "Customer";
                            String roleClass = "customer";
                            String roleDisplay = "Customer";

                            if (role.equalsIgnoreCase("Super_Admin") || role.equalsIgnoreCase("Admin")) {
                                roleClass = "super-admin";
                                roleDisplay = "Super Admin";
                            } else if (role.equalsIgnoreCase("Restaurant_Admin") || role.equalsIgnoreCase("Manager")) {
                                roleClass = "manager";
                                roleDisplay = "Restaurant Admin";
                            } else if (role.equalsIgnoreCase("Driver") || role.equalsIgnoreCase("Delivery_Partner") || role.equalsIgnoreCase("DRIVER")) {
                                roleClass = "driver";
                                roleDisplay = "<i class=\"fa-solid fa-motorcycle\" style=\"margin-right: 4px;\"></i> Delivery Partner";
                            }

                            String joinDate = (u.getCreatedDate() != null) ? sdf.format(u.getCreatedDate()) : "Jan 15, 2025";
                            String address = (u.getAddress() != null && !u.getAddress().trim().isEmpty()) ? u.getAddress() : "Bangalore";
                %>
                <tr>
                  <td>
                    <div style="display: flex; align-items: center; gap: 10px;">
                      <div class="user-avatar-circle">
                        <%= (u.getName() != null && !u.getName().isEmpty()) ? u.getName().substring(0, 1).toUpperCase() : "U" %>
                      </div>
                      <div>
                        <strong><%= u.getName() %></strong>
                        <div style="font-size: 11px; color: var(--color-text-muted);">UID #<%= u.getId() %></div>
                      </div>
                    </div>
                  </td>
                  <td><%= u.getEmail() %></td>
                  <td><%= (u.getPhone() != null ? u.getPhone() : "+91 98765 43210") %></td>
                  <td><span class="role-pill <%= roleClass %>"><%= roleDisplay %></span></td>
                  <td><%= joinDate %></td>
                  <td><span style="font-size: 12px; color: var(--color-text-secondary);"><%= address %></span></td>
                  <td><span class="status-pill active"><i class="fa-solid fa-circle text-success" style="font-size: 8px; margin-right: 4px;"></i>Active</span></td>
                  <td style="text-align: right;">
                    <button type="button" class="btn btn-ghost btn-sm" style="color: var(--color-primary-light); display: inline-flex; align-items: center; gap: 4px;"
                            onclick="openEditUserModal('<%= u.getId() %>', '<%= u.getName().replace("'", "\\'") %>', '<%= u.getEmail().replace("'", "\\'") %>', '<%= (u.getPhone() != null ? u.getPhone() : "") %>', '<%= role %>', '<%= address.replace("'", "\\'") %>')">
                      <i class="fa-solid fa-user-pen"></i> Edit
                    </button>
                    <button type="button" class="btn btn-ghost btn-sm" style="color: var(--color-error); display: inline-flex; align-items: center; gap: 4px;"
                            onclick="openDeleteUserModal('<%= u.getId() %>', '<%= u.getName().replace("'", "\\'") %>')">
                      <i class="fa-solid fa-user-slash"></i> Suspend
                    </button>
                  </td>
                </tr>
                <%
                        }
                    }
                %>
              </tbody>
            </table>
          </div>
        </section>

      </main>
    </div>
  </div>

  <!-- =========================================================================
       3. Add / Edit User Modal
       ========================================================================= -->
  <div class="modal-overlay" id="user-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog" style="max-width: 580px;">
      <div class="modal-header">
        <h3 class="modal-title" id="user-modal-title">Add New User</h3>
        <button type="button" class="modal-close-btn" onclick="closeModal('user-modal')"><i class="fa-solid fa-xmark"></i></button>
      </div>

      <form id="user-form" action="<%= request.getContextPath() %>/admin/user/save" method="POST">
        <div class="modal-body" style="display: flex; flex-direction: column; gap: var(--space-4);">
          <input type="hidden" name="id" id="user-id" value="">
          <input type="hidden" name="password" id="user-password" value="defaultPass123">

          <div class="form-group">
            <label class="form-label" for="user-name">Full Name *</label>
            <input type="text" id="user-name" name="name" class="form-input" required placeholder="e.g. Alex Johnson">
          </div>

          <div class="form-group">
            <label class="form-label" for="user-email">Email Address *</label>
            <input type="email" id="user-email" name="email" class="form-input" required placeholder="alex.j@example.com">
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4);">
            <div class="form-group">
              <label class="form-label" for="user-phone">Phone Number *</label>
              <input type="tel" id="user-phone" name="phone" class="form-input" required placeholder="9876543210">
            </div>
            <div class="form-group">
              <label class="form-label" for="user-role">Role *</label>
              <select id="user-role" name="role" class="form-select" required>
                <option value="Customer">Customer</option>
                <option value="Restaurant_Admin">Restaurant Manager</option>
                <option value="DRIVER">Delivery Partner (Driver)</option>
                <option value="Super_Admin">Super Admin</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="user-address">Address</label>
            <input type="text" id="user-address" name="address" class="form-input" placeholder="e.g. Koramangala, Bangalore" value="Bangalore">
          </div>

          <div class="form-group" style="display: flex; align-items: center; gap: 8px; margin-top: 4px;">
            <input type="checkbox" id="user-is-active" name="isActive" value="1" checked style="accent-color: var(--color-success); width: 18px; height: 18px;">
            <label for="user-is-active" style="font-size: 14px; font-weight: 600; cursor: pointer;">Account is Active & Allowed to Sign In</label>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" onclick="closeModal('user-modal')">Cancel</button>
          <button type="submit" class="btn btn-primary btn-sm" style="font-weight: 700;">Save User</button>
        </div>
      </form>
    </div>
  </div>

  <!-- =========================================================================
       4. Soft Delete / Suspend Confirmation Modal
       ========================================================================= -->
  <div class="modal-overlay" id="user-delete-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog" style="max-width: 440px;">
      <div class="modal-header">
        <div style="display: flex; align-items: center; gap: 10px;">
          <span style="font-size: 20px; color: var(--color-error);"><i class="fa-solid fa-triangle-exclamation"></i></span>
          <h3 class="modal-title">Deactivate User?</h3>
        </div>
        <button type="button" class="modal-close-btn" onclick="closeModal('user-delete-modal')"><i class="fa-solid fa-xmark"></i></button>
      </div>

      <form id="user-delete-form" action="<%= request.getContextPath() %>/admin/user/delete" method="POST">
        <input type="hidden" name="id" id="delete-user-id" value="">
        <input type="hidden" name="action" value="delete">

        <div class="modal-body">
          <p style="font-size: 14px; color: var(--color-text-secondary); line-height: 1.5;">
            Are you sure you want to deactivate <strong id="delete-user-name" style="color: var(--color-text-primary);">this user account</strong>? They will be prevented from accessing the platform.
          </p>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" onclick="closeModal('user-delete-modal')">Cancel</button>
          <button type="submit" class="btn btn-primary btn-sm" style="background: var(--color-error); border-color: var(--color-error);">Deactivate Account</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Modal Helpers -->
  <script>
    function openNewUserModal() {
      const modal = document.getElementById('user-modal');
      if (!modal) return;

      const idEl = document.getElementById('user-id');
      const nameEl = document.getElementById('user-name');
      const emailEl = document.getElementById('user-email');
      const phoneEl = document.getElementById('user-phone');
      const roleEl = document.getElementById('user-role');
      const addrEl = document.getElementById('user-address');
      const actEl = document.getElementById('user-is-active');
      const titleEl = document.getElementById('user-modal-title');

      if (idEl) idEl.value = '';
      if (nameEl) nameEl.value = '';
      if (emailEl) emailEl.value = '';
      if (phoneEl) phoneEl.value = '';
      if (roleEl) roleEl.value = 'Customer';
      if (addrEl) addrEl.value = 'Bangalore';
      if (actEl) actEl.checked = true;
      if (titleEl) titleEl.textContent = 'Add New User';

      if (typeof openModal === 'function') {
        openModal('user-modal');
      } else {
        modal.classList.add('open');
        modal.classList.add('active');
        modal.style.display = 'flex';
        modal.style.opacity = '1';
        modal.style.visibility = 'visible';
        modal.style.pointerEvents = 'auto';
      }
    }

    function openEditUserModal(id, name, email, phone, role, address) {
      const modal = document.getElementById('user-modal');
      if (!modal) return;

      const idEl = document.getElementById('user-id');
      const nameEl = document.getElementById('user-name');
      const emailEl = document.getElementById('user-email');
      const phoneEl = document.getElementById('user-phone');
      const roleEl = document.getElementById('user-role');
      const addrEl = document.getElementById('user-address');
      const actEl = document.getElementById('user-is-active');
      const titleEl = document.getElementById('user-modal-title');

      if (idEl) idEl.value = id;
      if (nameEl) nameEl.value = name;
      if (emailEl) emailEl.value = email;
      if (phoneEl) phoneEl.value = phone;
      if (roleEl) roleEl.value = role;
      if (addrEl) addrEl.value = address;
      if (actEl) actEl.checked = true;
      if (titleEl) titleEl.textContent = 'Edit User: ' + name;

      if (typeof openModal === 'function') {
        openModal('user-modal');
      } else {
        modal.classList.add('open');
        modal.classList.add('active');
        modal.style.display = 'flex';
        modal.style.opacity = '1';
        modal.style.visibility = 'visible';
        modal.style.pointerEvents = 'auto';
      }
    }

    function openDeleteUserModal(id, name) {
      const modal = document.getElementById('user-delete-modal');
      if (!modal) return;

      const idEl = document.getElementById('delete-user-id');
      const nameEl = document.getElementById('delete-user-name');
      if (idEl) idEl.value = id;
      if (nameEl) nameEl.textContent = name;

      if (typeof openModal === 'function') {
        openModal('user-delete-modal');
      } else {
        modal.classList.add('open');
        modal.classList.add('active');
        modal.style.display = 'flex';
        modal.style.opacity = '1';
        modal.style.visibility = 'visible';
        modal.style.pointerEvents = 'auto';
      }
    }
  </script>

  <!-- Vanilla JavaScript Handlers -->
  <script src="<%= request.getContextPath() %>/frontend/js/global.js"></script>
  <script src="<%= request.getContextPath() %>/frontend/js/admin.js"></script>
</body>
</html>
