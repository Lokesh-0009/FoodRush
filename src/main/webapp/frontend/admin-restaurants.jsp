<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.foodRush.model.Restaurant"%>
<%@ page import="com.foodRush.model.User"%>

<%
    User loggedUser = (User) session.getAttribute("user");
    String adminName = (loggedUser != null && loggedUser.getName() != null) ? loggedUser.getName() : "System Admin";
    String adminEmail = (loggedUser != null && loggedUser.getEmail() != null) ? loggedUser.getEmail() : "admin@foodrush.com";

    List<Restaurant> restaurantsList = (List<Restaurant>) request.getAttribute("restaurantsList");
    Integer totalCountObj = (Integer) request.getAttribute("totalCount");
    int totalCount = (totalCountObj != null) ? totalCountObj : (restaurantsList != null ? restaurantsList.size() : 6);

    Long activeCountObj = (Long) request.getAttribute("activeCount");
    long activeCount = (activeCountObj != null) ? activeCountObj : 5;

    Long inactiveCountObj = (Long) request.getAttribute("inactiveCount");
    long inactiveCount = (inactiveCountObj != null) ? inactiveCountObj : 1;

    String avgRating = (String) request.getAttribute("avgRating");
    if (avgRating == null) avgRating = "4.7";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="FoodRush Admin Portal - Restaurant Management. Add, edit, manage outlet operating statuses and assign managers.">
  <title>Restaurant Outlets — FoodRush Admin</title>

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
            <a href="<%= request.getContextPath() %>/admin/restaurants" class="admin-nav-link active">
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
            <a href="<%= request.getContextPath() %>/admin/users" class="admin-nav-link">
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
              <span style="color: var(--color-primary); font-weight: 600;">Restaurants</span>
            </div>
            <h1 style="font-size: var(--font-size-h3); font-weight: bold; margin-bottom: 2px;">Restaurant Outlets</h1>
          </div>
        </div>

        <div style="display: flex; align-items: center; gap: 12px;">
          <!-- Theme Toggle Button -->
          <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
            <i class="fa-solid fa-sun sun-icon"></i>
            <i class="fa-solid fa-moon moon-icon"></i>
          </button>
          <button type="button" class="btn btn-primary btn-sm" onclick="openNewRestaurantModal()" style="display: flex; align-items: center; gap: 6px; padding: 8px 16px; font-weight: 700;">
            <i class="fa-solid fa-plus"></i> Add Restaurant
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
        <section class="kpi-grid" aria-label="Restaurant Statistics">
          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Total Outlets</span>
              <div class="kpi-icon-box"><i class="fa-solid fa-building"></i></div>
            </div>
            <div class="kpi-value" id="kpi-total-restaurants"><%= totalCount %></div>
            <div class="kpi-trend neutral"><span>Registered in database</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Active & Open</span>
              <div class="kpi-icon-box success"><i class="fa-solid fa-door-open"></i></div>
            </div>
            <div class="kpi-value" id="kpi-active-restaurants" style="color: var(--color-success);"><%= activeCount %></div>
            <div class="kpi-trend positive"><span>Accepting deliveries now</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Inactive / Closed</span>
              <div class="kpi-icon-box warning"><i class="fa-solid fa-door-closed"></i></div>
            </div>
            <div class="kpi-value" id="kpi-inactive-restaurants" style="color: var(--color-error);"><%= inactiveCount %></div>
            <div class="kpi-trend neutral"><span>Temporarily offline</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Top Avg Rating</span>
              <div class="kpi-icon-box"><i class="fa-solid fa-star"></i></div>
            </div>
            <div class="kpi-value" style="color: var(--color-warning);"><%= avgRating %> <i class="fa-solid fa-star" style="font-size: 16px;"></i></div>
            <div class="kpi-trend positive"><span>High customer trust</span></div>
          </div>
        </section>

        <!-- Filter & Search Controls Bar -->
        <div class="admin-filter-bar">
          <div class="admin-search-wrap">
            <i class="fa-solid fa-magnifying-glass" style="color: var(--color-text-muted);"></i>
            <input type="text" id="restaurant-search-input" placeholder="Search by restaurant name, cuisine or address...">
          </div>

          <div class="admin-filter-group">
            <!-- Status Filter -->
            <select id="status-filter" class="form-select">
              <option value="ALL">All Statuses</option>
              <option value="ACTIVE">Active Only</option>
              <option value="INACTIVE">Inactive Only</option>
            </select>

            <!-- Cuisine Filter -->
            <select id="cuisine-filter" class="form-select">
              <option value="ALL">All Cuisines</option>
              <option value="Indian">North Indian</option>
              <option value="Italian">Italian / Pizza</option>
              <option value="American">American / Burgers</option>
              <option value="Chinese">Chinese / Asian</option>
              <option value="Healthy">Healthy / Bowls</option>
              <option value="Biryani">Biryani</option>
            </select>

            <!-- Reset Button -->
            <button type="button" class="btn btn-secondary btn-sm" onclick="document.getElementById('restaurant-search-input').value=''; document.getElementById('status-filter').value='ALL'; document.getElementById('cuisine-filter').value='ALL'; window.location.reload();">
              Reset Filters
            </button>
          </div>
        </div>

        <!-- Restaurants Data Table -->
        <section class="admin-card">
          <div class="admin-card-header">
            <div>
              <h2 style="font-size: var(--font-size-h3); font-weight: bold; margin-bottom: 2px;">Registered Outlets (<span id="restaurant-count-label"><%= totalCount %></span>)</h2>
              <p style="font-size: var(--font-size-caption); color: var(--color-text-secondary);">Manage restaurant partners, delivery zones, active listings, and assigned owners</p>
            </div>
          </div>

          <div class="admin-table-wrapper">
            <table class="admin-table">
              <thead>
                <tr>
                  <th>Outlet Details</th>
                  <th>Cuisine Category</th>
                  <th>Location / Address</th>
                  <th>Avg Delivery</th>
                  <th>Rating</th>
                  <th>Status</th>
                  <th>Owner Admin</th>
                  <th style="text-align: right;">Actions</th>
                </tr>
              </thead>
              <tbody id="restaurants-table-body">
                <%
                    if (restaurantsList != null && !restaurantsList.isEmpty()) {
                        for (Restaurant r : restaurantsList) {
                            String img = (r.getImagePath() != null && !r.getImagePath().trim().isEmpty())
                                         ? r.getImagePath()
                                         : "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=100&auto=format&fit=crop&q=80";
                            boolean isActive = (r.getIsActive() == 1 || r.isActive() == 1);
                %>
                <tr>
                  <td>
                    <div class="user-profile-cell">
                      <img src="<%= img %>" alt="<%= r.getName() %>" class="dish-thumb" style="border-radius: var(--radius-sm);">
                      <div>
                        <strong><%= r.getName() %></strong>
                        <div style="font-size: 11px; color: var(--color-text-muted);">ID: #<%= r.getRestaurantID() %></div>
                      </div>
                    </div>
                  </td>
                  <td><span class="badge" style="background: var(--color-primary-soft); color: var(--color-primary); font-weight: 600;"><%= r.getCuisineType() %></span></td>
                  <td><span style="font-size: 12px; color: var(--color-text-secondary);"><i class="fa-solid fa-location-dot" style="margin-right: 4px; color: var(--color-text-muted);"></i><%= r.getAddress() %></span></td>
                  <td><strong><%= r.getDeliveryTime() %> mins</strong></td>
                  <td><span class="rating-pill"><i class="fa-solid fa-star text-warning" style="margin-right: 3px;"></i><%= r.getRating() %></span></td>
                  <td>
                    <span class="status-pill <%= isActive ? "active" : "inactive" %>">
                      <%= isActive ? "<i class=\"fa-solid fa-circle text-success\" style=\"font-size: 8px; margin-right: 4px;\"></i>Active" : "<i class=\"fa-solid fa-circle text-danger\" style=\"font-size: 8px; margin-right: 4px;\"></i>Inactive" %>
                    </span>
                  </td>
                  <td><span style="font-size: 12px; color: var(--color-text-secondary);">Admin ID: #<%= r.getAdminUserID() %></span></td>
                  <td style="text-align: right;">
                    <div class="action-btn-group">
                      <button type="button" class="btn btn-ghost btn-sm" style="color: var(--color-primary-light); display: inline-flex; align-items: center; gap: 4px;"
                              onclick="openEditRestaurantModal('<%= r.getRestaurantID() %>', '<%= r.getName().replace("'", "\\'") %>', '<%= r.getCuisineType().replace("'", "\\'") %>', '<%= r.getDeliveryTime() %>', '<%= r.getAddress().replace("'", "\\'") %>', '<%= r.getRating() %>', '<%= r.getAdminUserID() %>', '<%= isActive ? 1 : 0 %>', '<%= img.replace("'", "\\'") %>')">
                        <i class="fa-solid fa-pen-to-square"></i> Edit
                      </button>
                      <button type="button" class="btn btn-ghost btn-sm" style="color: var(--color-error); display: inline-flex; align-items: center; gap: 4px;"
                              onclick="openDeleteRestaurantModal('<%= r.getRestaurantID() %>', '<%= r.getName().replace("'", "\\'") %>')">
                        <i class="fa-solid fa-ban"></i> Deactivate
                      </button>
                    </div>
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
       3. Add / Edit Restaurant Modal
       ========================================================================= -->
  <div class="modal-overlay" id="restaurant-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog" style="max-width: 580px;">
      <div class="modal-header">
        <h3 class="modal-title" id="modal-title">Add New Restaurant</h3>
        <button type="button" class="modal-close-btn" onclick="closeModal('restaurant-modal')"><i class="fa-solid fa-xmark"></i></button>
      </div>

      <form id="restaurant-form" action="<%= request.getContextPath() %>/admin/restaurant/save" method="POST">
        <div class="modal-body" style="display: flex; flex-direction: column; gap: var(--space-4);">
          <input type="hidden" name="restaurantID" id="restaurant-id" value="">

          <div class="form-group">
            <label class="form-label" for="rest-name">Restaurant Name *</label>
            <input type="text" id="rest-name" name="name" class="form-input" required placeholder="e.g. Spice Symphony">
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4);">
            <div class="form-group">
              <label class="form-label" for="rest-cuisine">Cuisine *</label>
              <input type="text" id="rest-cuisine" name="cuisineType" class="form-input" required placeholder="e.g. North Indian, Tandoor">
            </div>
            <div class="form-group">
              <label class="form-label" for="rest-delivery">Avg Delivery Time (mins) *</label>
              <input type="number" id="rest-delivery" name="deliveryTime" class="form-input" required placeholder="30" value="30">
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="rest-address">Address & City *</label>
            <input type="text" id="rest-address" name="address" class="form-input" required placeholder="e.g. Koramangala, Bangalore">
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4);">
            <div class="form-group">
              <label class="form-label" for="rest-rating">Rating (0.0 to 5.0)</label>
              <input type="number" step="0.1" min="1.0" max="5.0" id="rest-rating" name="rating" class="form-input" value="4.5">
            </div>
            <div class="form-group">
              <label class="form-label" for="rest-owner">Assigned Owner/Admin ID</label>
              <input type="number" id="rest-owner" name="adminUserID" class="form-input" value="1" placeholder="Admin/Owner User ID">
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="rest-image">Cover Image URL</label>
            <input type="url" id="rest-image" name="imageUrl" class="form-input" placeholder="https://images.unsplash.com/...">
          </div>

          <div class="form-group" style="display: flex; align-items: center; gap: 8px; margin-top: 4px;">
            <input type="checkbox" id="rest-active" name="isActive" value="1" checked style="accent-color: var(--color-success); width: 18px; height: 18px;">
            <label for="rest-active" style="font-size: 14px; font-weight: 600; cursor: pointer;">Outlet is Active & Accepting Orders</label>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" onclick="closeModal('restaurant-modal')">Cancel</button>
          <button type="submit" class="btn btn-primary btn-sm" style="font-weight: 700;">Save Restaurant</button>
        </div>
      </form>
    </div>
  </div>

  <!-- =========================================================================
       4. Soft Delete Confirmation Modal
       ========================================================================= -->
  <div class="modal-overlay" id="delete-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog" style="max-width: 440px;">
      <div class="modal-header">
        <div style="display: flex; align-items: center; gap: 10px;">
          <span style="font-size: 20px; color: var(--color-error);"><i class="fa-solid fa-triangle-exclamation"></i></span>
          <h3 class="modal-title">Deactivate Restaurant?</h3>
        </div>
        <button type="button" class="modal-close-btn" onclick="closeModal('delete-modal')"><i class="fa-solid fa-xmark"></i></button>
      </div>

      <form id="delete-form" action="<%= request.getContextPath() %>/admin/restaurant/delete" method="POST">
        <input type="hidden" name="restaurantID" id="delete-restaurant-id" value="">
        <input type="hidden" name="action" value="delete">

        <div class="modal-body">
          <p style="font-size: 14px; color: var(--color-text-secondary); line-height: 1.5;">
            Are you sure you want to remove <strong id="delete-restaurant-name" style="color: var(--color-text-primary);">this outlet</strong> from customer search listings? Existing order history will remain preserved in the database.
          </p>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" onclick="closeModal('delete-modal')">Cancel</button>
          <button type="submit" class="btn btn-primary btn-sm" id="confirm-delete-btn" style="background: var(--color-error); border-color: var(--color-error);">Deactivate Outlet</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Modal Helpers -->
  <script>
    function openNewRestaurantModal() {
      const modal = document.getElementById('restaurant-modal');
      if (!modal) return;

      const idEl = document.getElementById('restaurant-id');
      const nameEl = document.getElementById('rest-name');
      const cuisineEl = document.getElementById('rest-cuisine');
      const delEl = document.getElementById('rest-delivery');
      const addrEl = document.getElementById('rest-address');
      const rateEl = document.getElementById('rest-rating');
      const ownerEl = document.getElementById('rest-owner');
      const imgEl = document.getElementById('rest-image');
      const actEl = document.getElementById('rest-active');
      const titleEl = document.getElementById('modal-title');

      if (idEl) idEl.value = '';
      if (nameEl) nameEl.value = '';
      if (cuisineEl) cuisineEl.value = '';
      if (delEl) delEl.value = '30';
      if (addrEl) addrEl.value = '';
      if (rateEl) rateEl.value = '4.5';
      if (ownerEl) ownerEl.value = '1';
      if (imgEl) imgEl.value = '';
      if (actEl) actEl.checked = true;
      if (titleEl) titleEl.textContent = 'Add New Restaurant';

      if (typeof openModal === 'function') {
        openModal('restaurant-modal');
      } else {
        modal.classList.add('open');
        modal.classList.add('active');
        modal.style.display = 'flex';
        modal.style.opacity = '1';
        modal.style.visibility = 'visible';
        modal.style.pointerEvents = 'auto';
      }
    }

    function openEditRestaurantModal(id, name, cuisine, delivery, address, rating, adminId, active, image) {
      const modal = document.getElementById('restaurant-modal');
      if (!modal) return;

      const idEl = document.getElementById('restaurant-id');
      const nameEl = document.getElementById('rest-name');
      const cuisineEl = document.getElementById('rest-cuisine');
      const delEl = document.getElementById('rest-delivery');
      const addrEl = document.getElementById('rest-address');
      const rateEl = document.getElementById('rest-rating');
      const ownerEl = document.getElementById('rest-owner');
      const imgEl = document.getElementById('rest-image');
      const actEl = document.getElementById('rest-active');
      const titleEl = document.getElementById('modal-title');

      if (idEl) idEl.value = id;
      if (nameEl) nameEl.value = name;
      if (cuisineEl) cuisineEl.value = cuisine;
      if (delEl) delEl.value = delivery;
      if (addrEl) addrEl.value = address;
      if (rateEl) rateEl.value = rating;
      if (ownerEl) ownerEl.value = adminId;
      if (imgEl) imgEl.value = image;
      if (actEl) actEl.checked = (active === '1' || active === 1 || active === true || active === 'true');
      if (titleEl) titleEl.textContent = 'Edit Restaurant: ' + name;

      if (typeof openModal === 'function') {
        openModal('restaurant-modal');
      } else {
        modal.classList.add('open');
        modal.classList.add('active');
        modal.style.display = 'flex';
        modal.style.opacity = '1';
        modal.style.visibility = 'visible';
        modal.style.pointerEvents = 'auto';
      }
    }

    function openDeleteRestaurantModal(id, name) {
      const modal = document.getElementById('delete-modal');
      if (!modal) return;

      const idEl = document.getElementById('delete-restaurant-id');
      const nameEl = document.getElementById('delete-restaurant-name');
      if (idEl) idEl.value = id;
      if (nameEl) nameEl.textContent = name;

      if (typeof openModal === 'function') {
        openModal('delete-modal');
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
