<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.foodRush.model.Menu"%>
<%@ page import="com.foodRush.model.Restaurant"%>
<%@ page import="com.foodRush.model.User"%>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || loggedUser.getRole() == null ||
        (!loggedUser.getRole().toUpperCase().contains("ADMIN") &&
         !loggedUser.getRole().toUpperCase().contains("MANAGER") &&
         !loggedUser.getRole().toUpperCase().contains("SUPER"))) {
        response.sendRedirect(request.getContextPath() + "/login?redirect=admin/menu");
        return;
    }
    if (request.getAttribute("menuList") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/menu");
        return;
    }
    String adminName = (loggedUser.getName() != null) ? loggedUser.getName() : "System Admin";
    String adminEmail = (loggedUser.getEmail() != null) ? loggedUser.getEmail() : "admin@foodrush.com";

    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    List<Restaurant> restaurantsList = (List<Restaurant>) request.getAttribute("restaurantsList");
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");

    Integer totalDishesObj = (Integer) request.getAttribute("totalDishes");
    int totalDishes = (totalDishesObj != null) ? totalDishesObj : (menuList != null ? menuList.size() : 10);

    Long availableDishesObj = (Long) request.getAttribute("availableDishes");
    long availableDishes = (availableDishesObj != null) ? availableDishesObj : 9;

    Long soldOutDishesObj = (Long) request.getAttribute("soldOutDishes");
    long soldOutDishes = (soldOutDishesObj != null) ? soldOutDishesObj : 1;

    Integer avgPriceObj = (Integer) request.getAttribute("avgPrice");
    int avgPrice = (avgPriceObj != null) ? avgPriceObj : 295;
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="FoodRush Admin Portal - Menu & Dish Management. Add dishes, configure pricing, manage categories and availability.">
  <title>Menu Management — FoodRush Admin</title>

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
            <a href="<%= request.getContextPath() %>/admin/menu" class="admin-nav-link active">
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
          <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=80"
            alt="Admin Avatar" class="admin-avatar">
          <div style="font-size: var(--font-size-caption); min-width: 0;">
            <div style="color: #FFFFFF; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
              <%= adminName %>
            </div>
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
          <button type="button" class="btn btn-secondary btn-sm" id="admin-sidebar-toggle"
            style="display: none; padding: 6px 10px;">
            <i class="fa-solid fa-bars"></i>
          </button>
          <div>
            <div style="font-size: 12px; color: var(--color-text-muted); display: flex; align-items: center; gap: 6px; margin-bottom: 4px;">
              <a href="<%= request.getContextPath() %>/admin/dashboard" style="color: var(--color-text-secondary); text-decoration: none;">Dashboard</a>
              <span>/</span>
              <span style="color: var(--color-primary); font-weight: 600;">Menu</span>
            </div>
            <h1 style="font-size: var(--font-size-h3); font-weight: bold; margin-bottom: 2px;">Menu & Dish Catalog</h1>
          </div>
        </div>

        <div style="display: flex; align-items: center; gap: 12px;">
          <!-- Theme Toggle Button -->
          <button type="button" class="theme-toggle-btn" id="theme-toggle-btn" aria-label="Toggle Dark/Light Mode" title="Toggle theme">
            <i class="fa-solid fa-sun sun-icon"></i>
            <i class="fa-solid fa-moon moon-icon"></i>
          </button>
          <button type="button" class="btn btn-primary btn-sm" id="btn-add-dish-topbar" onclick="openNewMenuModal()"
            style="display: flex; align-items: center; gap: 6px; padding: 8px 16px; font-weight: 700; cursor: pointer;">
            <i class="fa-solid fa-plus"></i> Add Dish
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
        <section class="kpi-grid" aria-label="Menu Statistics">
          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Total Dishes</span>
              <div class="kpi-icon-box"><i class="fa-solid fa-bowl-food"></i></div>
            </div>
            <div class="kpi-value" id="kpi-total-dishes"><%= totalDishes %></div>
            <div class="kpi-trend neutral"><span>In database catalog</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Available in Stock</span>
              <div class="kpi-icon-box success"><i class="fa-solid fa-circle-check"></i></div>
            </div>
            <div class="kpi-value" id="kpi-available-dishes" style="color: var(--color-success);"><%= availableDishes %></div>
            <div class="kpi-trend positive"><span>Ready for ordering</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Sold Out / Inactive</span>
              <div class="kpi-icon-box warning"><i class="fa-solid fa-circle-xmark"></i></div>
            </div>
            <div class="kpi-value" id="kpi-soldout-dishes" style="color: var(--color-error);"><%= soldOutDishes %></div>
            <div class="kpi-trend neutral"><span>Hidden from customer cart</span></div>
          </div>

          <div class="kpi-card">
            <div class="kpi-card-header">
              <span class="kpi-label">Avg Dish Price</span>
              <div class="kpi-icon-box"><i class="fa-solid fa-wallet"></i></div>
            </div>
            <div class="kpi-value" style="color: var(--color-primary-light);">₹<%= avgPrice %></div>
            <div class="kpi-trend positive"><span>Across all outlets</span></div>
          </div>
        </section>

        <!-- Filter & Search Controls Bar -->
        <div class="admin-filter-bar">
          <div class="admin-search-wrap">
            <i class="fa-solid fa-magnifying-glass" style="color: var(--color-text-muted);"></i>
            <input type="text" id="menu-search-input" placeholder="Search dish name or description...">
          </div>

          <div class="admin-filter-group">
            <!-- Restaurant Filter -->
            <select id="restaurant-filter" class="form-select">
              <option value="ALL">All Restaurants</option>
              <%
                  if (restaurantsList != null) {
                      for (Restaurant r : restaurantsList) {
              %>
              <option value="<%= r.getRestaurantID() %>"><%= r.getName() %></option>
              <%
                      }
                  }
              %>
            </select>

            <!-- Category Filter -->
            <select id="category-filter" class="form-select">
              <option value="ALL">All Categories</option>
              <option value="Main Course">Main Course</option>
              <option value="Starters">Starters & Appetizers</option>
              <option value="Pizza">Pizzas</option>
              <option value="Burgers">Burgers</option>
              <option value="Biryani">Biryani</option>
              <option value="Desserts">Desserts</option>
              <option value="Beverages">Beverages</option>
            </select>

            <!-- Availability Filter -->
            <select id="availability-filter" class="form-select">
              <option value="ALL">All Availability</option>
              <option value="AVAILABLE">In Stock Only</option>
              <option value="UNAVAILABLE">Out of Stock Only</option>
            </select>

            <button type="button" class="btn btn-secondary btn-sm" onclick="document.getElementById('menu-search-input').value=''; document.getElementById('restaurant-filter').value='ALL'; document.getElementById('category-filter').value='ALL'; document.getElementById('availability-filter').value='ALL'; window.location.reload();">
              Reset Filters
            </button>
          </div>
        </div>

        <!-- Notification Banners -->
        <% if (request.getParameter("added") != null) { %>
          <div style="background: rgba(22, 163, 74, 0.15); border: 1px solid rgba(22, 163, 74, 0.3); color: var(--color-success); padding: 12px 16px; border-radius: var(--radius-lg); margin-bottom: var(--space-4); display: flex; align-items: center; justify-content: space-between;">
            <div style="display: flex; align-items: center; gap: 8px; font-weight: 600; font-size: 14px;">
              <span><i class="fa-solid fa-circle-check"></i></span> <span>New dish added to menu catalog successfully!</span>
            </div>
            <a href="<%= request.getContextPath() %>/admin/menu" style="color: var(--color-success); text-decoration: none; font-size: 13px; font-weight: 700;"><i class="fa-solid fa-xmark"></i></a>
          </div>
        <% } else if (request.getParameter("updated") != null) { %>
          <div style="background: rgba(59, 130, 246, 0.15); border: 1px solid rgba(59, 130, 246, 0.3); color: #60A5FA; padding: 12px 16px; border-radius: var(--radius-lg); margin-bottom: var(--space-4); display: flex; align-items: center; justify-content: space-between;">
            <div style="display: flex; align-items: center; gap: 8px; font-weight: 600; font-size: 14px;">
              <span><i class="fa-solid fa-circle-check"></i></span> <span>Dish details updated successfully!</span>
            </div>
            <a href="<%= request.getContextPath() %>/admin/menu" style="color: #60A5FA; text-decoration: none; font-size: 13px; font-weight: 700;"><i class="fa-solid fa-xmark"></i></a>
          </div>
        <% } else if (request.getParameter("error") != null) { %>
          <div style="background: rgba(229, 9, 20, 0.15); border: 1px solid rgba(229, 9, 20, 0.3); color: var(--color-error); padding: 12px 16px; border-radius: var(--radius-lg); margin-bottom: var(--space-4); display: flex; align-items: center; justify-content: space-between;">
            <div style="display: flex; align-items: center; gap: 8px; font-weight: 600; font-size: 14px;">
              <span><i class="fa-solid fa-triangle-exclamation"></i></span> <span>Action failed: <%= request.getParameter("error") %></span>
            </div>
            <a href="<%= request.getContextPath() %>/admin/menu" style="color: var(--color-error); text-decoration: none; font-size: 13px; font-weight: 700;"><i class="fa-solid fa-xmark"></i></a>
          </div>
        <% } %>

        <!-- Menu Data Table -->
        <section class="admin-card">
          <div class="admin-card-header" style="display: flex; justify-content: space-between; align-items: center;">
            <div>
              <h2 style="font-size: var(--font-size-h3); font-weight: bold; margin-bottom: 2px;">Menu Catalog (<span
                  id="menu-count-label"><%= totalDishes %></span> dishes)</h2>
              <p style="font-size: var(--font-size-caption); color: var(--color-text-secondary);">Add, edit prices, dietary tags, and stock status across all restaurant outlets</p>
            </div>
            <button type="button" class="btn btn-primary btn-sm" id="btn-add-dish-table" onclick="openNewMenuModal()" style="display: flex; align-items: center; gap: 6px; padding: 7px 14px; font-weight: 700; cursor: pointer;">
              <i class="fa-solid fa-plus"></i> Add New Dish
            </button>
          </div>

          <div class="admin-table-wrapper">
            <table class="admin-table">
              <thead>
                <tr>
                  <th>Dish & Description</th>
                  <th>Restaurant Outlet</th>
                  <th>Category</th>
                  <th>Price</th>
                  <th>Dietary Tag</th>
                  <th>Stock Status</th>
                  <th style="text-align: right;">Actions</th>
                </tr>
              </thead>
              <tbody id="menu-table-body">
                <%
                    if (menuList != null && !menuList.isEmpty()) {
                        for (Menu m : menuList) {
                            String img = (m.getImagePath() != null && !m.getImagePath().trim().isEmpty())
                                         ? m.getImagePath()
                                         : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100&auto=format&fit=crop&q=80";

                            String restName = "Outlet #" + m.getRestaurantID();
                            if (restaurantMap != null && restaurantMap.containsKey(m.getRestaurantID())) {
                                restName = restaurantMap.get(m.getRestaurantID()).getName();
                            }

                            boolean isAvail = (m.getIsAvailable() == 1);
                            String itemNameLower = m.getItemName().toLowerCase();
                            boolean isVeg = itemNameLower.contains("veg") || itemNameLower.contains("paneer") || itemNameLower.contains("margherita") || itemNameLower.contains("jamun");
                %>
                <tr>
                  <td>
                    <div class="user-profile-cell">
                      <img src="<%= img %>" alt="<%= m.getItemName() %>" class="dish-thumb">
                      <div>
                        <strong><%= m.getItemName() %></strong>
                        <div style="font-size: 11px; color: var(--color-text-muted); max-width: 280px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                          <%= (m.getDescription() != null) ? m.getDescription() : "" %>
                        </div>
                      </div>
                    </div>
                  </td>
                  <td><span style="font-size: 13px; font-weight: 500;"><%= restName %></span></td>
                  <td><span class="badge" style="background: var(--color-surface-soft); color: var(--color-text-secondary); border: 1px solid var(--color-border);"><%= m.getCategory() %></span></td>
                  <td><strong style="color: var(--color-primary-light); font-size: 15px;">₹<%= (int)m.getPrice() %></strong></td>
                  <td>
                    <span class="badge <%= isVeg ? "veg" : "non-veg" %>" style="font-weight: 700; display: inline-flex; align-items: center; gap: 4px;">
                      <%= isVeg ? "<i class=\"fa-solid fa-leaf text-success\"></i> VEG" : "<i class=\"fa-solid fa-drumstick-bite text-primary\"></i> NON-VEG" %>
                    </span>
                  </td>
                  <td>
                    <span class="status-pill <%= isAvail ? "active" : "inactive" %>">
                      <%= isAvail ? "<i class=\"fa-solid fa-circle text-success\" style=\"font-size: 8px; margin-right: 4px;\"></i>In Stock" : "<i class=\"fa-solid fa-circle text-danger\" style=\"font-size: 8px; margin-right: 4px;\"></i>Sold Out" %>
                    </span>
                  </td>
                  <td style="text-align: right;">
                    <div class="action-btn-group">
                      <button type="button" class="btn btn-ghost btn-sm" style="color: var(--color-primary-light); display: inline-flex; align-items: center; gap: 4px;"
                              onclick="openEditMenuModal('<%= m.getMenuID() %>', '<%= m.getRestaurantID() %>', '<%= m.getItemName().replace("'", "\\'") %>', '<%= (m.getDescription() != null ? m.getDescription().replace("'", "\\'") : "") %>', '<%= (int)m.getPrice() %>', '<%= m.getCategory() %>', '<%= isAvail ? 1 : 0 %>', '<%= img.replace("'", "\\'") %>')">
                        <i class="fa-solid fa-pen-to-square"></i> Edit
                      </button>
                      <button type="button" class="btn btn-ghost btn-sm" style="color: var(--color-error); display: inline-flex; align-items: center; gap: 4px;"
                              onclick="openDeleteMenuModal('<%= m.getMenuID() %>', '<%= m.getItemName().replace("'", "\\'") %>')">
                        <i class="fa-solid fa-trash-can"></i> Remove
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
       3. Add / Edit Dish Modal
       ========================================================================= -->
  <div class="modal-overlay" id="menu-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog" style="max-width: 580px;">
      <div class="modal-header">
        <h3 class="modal-title" id="menu-modal-title">Add New Dish</h3>
        <button type="button" class="modal-close-btn" onclick="closeModal('menu-modal')"><i class="fa-solid fa-xmark"></i></button>
      </div>

      <form id="menu-form" action="<%= request.getContextPath() %>/admin/menu/save" method="POST">
        <div class="modal-body" style="display: flex; flex-direction: column; gap: var(--space-4);">
          <input type="hidden" name="menuID" id="menu-item-id" value="">

          <div class="form-group">
            <label class="form-label" for="menu-item-name">Dish Name *</label>
            <input type="text" id="menu-item-name" name="itemName" class="form-input" required placeholder="e.g. Butter Chicken Special">
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4);">
            <div class="form-group">
              <label class="form-label" for="menu-restaurant-id">Restaurant Outlet *</label>
              <select id="menu-restaurant-id" name="restaurantID" class="form-select" required>
                <%
                    if (restaurantsList != null) {
                        for (Restaurant r : restaurantsList) {
                %>
                <option value="<%= r.getRestaurantID() %>"><%= r.getName() %></option>
                <%
                        }
                    }
                %>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label" for="menu-category">Category *</label>
              <select id="menu-category" name="category" class="form-select" required>
                <option value="Main Course">Main Course</option>
                <option value="Starters">Starters & Appetizers</option>
                <option value="Pizza">Pizza</option>
                <option value="Burgers">Burgers</option>
                <option value="Biryani">Biryani</option>
                <option value="Desserts">Desserts</option>
                <option value="Beverages">Beverages</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="menu-description">Description & Ingredients</label>
            <textarea id="menu-description" name="description" class="form-input" rows="3" placeholder="Rich creamy tomato gravy with aromatic spices..."></textarea>
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-4);">
            <div class="form-group">
              <label class="form-label" for="menu-price">Price (₹) *</label>
              <input type="number" step="1" min="1" id="menu-price" name="price" class="form-input" required placeholder="340">
            </div>
            <div class="form-group">
              <label class="form-label" for="menu-diet-type">Dietary Tag</label>
              <select id="menu-diet-type" name="dietType" class="form-select">
                <option value="veg">Pure Vegetarian</option>
                <option value="non-veg">Non-Vegetarian</option>
                <option value="vegan">100% Vegan</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="menu-image">Dish Image URL</label>
            <input type="url" id="menu-image" name="imageUrl" class="form-input" placeholder="https://images.unsplash.com/...">
          </div>

          <div class="form-group" style="display: flex; align-items: center; gap: 8px; margin-top: 4px;">
            <input type="checkbox" id="menu-is-available" name="isAvailable" value="1" checked style="accent-color: var(--color-success); width: 18px; height: 18px;">
            <label for="menu-is-available" style="font-size: 14px; font-weight: 600; cursor: pointer;">Dish is Available (In Stock)</label>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" onclick="closeModal('menu-modal')">Cancel</button>
          <button type="submit" class="btn btn-primary btn-sm" style="font-weight: 700;">Save Dish</button>
        </div>
      </form>
    </div>
  </div>

  <!-- =========================================================================
       4. Soft Delete Confirmation Modal
       ========================================================================= -->
  <div class="modal-overlay" id="menu-delete-modal" role="dialog" aria-modal="true">
    <div class="modal-dialog" style="max-width: 440px;">
      <div class="modal-header">
        <div style="display: flex; align-items: center; gap: 10px;">
          <span style="font-size: 20px; color: var(--color-error);"><i class="fa-solid fa-triangle-exclamation"></i></span>
          <h3 class="modal-title">Deactivate Dish?</h3>
        </div>
        <button type="button" class="modal-close-btn" onclick="closeModal('menu-delete-modal')"><i class="fa-solid fa-xmark"></i></button>
      </div>

      <form id="menu-delete-form" action="<%= request.getContextPath() %>/admin/menu/delete" method="POST">
        <input type="hidden" name="menuID" id="delete-menu-item-id" value="">
        <input type="hidden" name="action" value="delete">

        <div class="modal-body">
          <p style="font-size: 14px; color: var(--color-text-secondary); line-height: 1.5;">
            Are you sure you want to remove <strong id="delete-menu-item-name" style="color: var(--color-text-primary);">this dish</strong> from the active menu catalog? Past order records will remain preserved.
          </p>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" onclick="closeModal('menu-delete-modal')">Cancel</button>
          <button type="submit" class="btn btn-primary btn-sm" style="background: var(--color-error); border-color: var(--color-error);">Deactivate Dish</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Toast Container -->
  <div class="toast-container" id="toast-container"></div>

  <!-- Modal Helpers -->
  <script>
    function openNewMenuModal() {
      const modal = document.getElementById('menu-modal');
      if (!modal) return;
      
      const idEl = document.getElementById('menu-item-id');
      const nameEl = document.getElementById('menu-item-name');
      const descEl = document.getElementById('menu-description');
      const priceEl = document.getElementById('menu-price');
      const catEl = document.getElementById('menu-category');
      const imgEl = document.getElementById('menu-image');
      const availEl = document.getElementById('menu-is-available');
      const titleEl = document.getElementById('menu-modal-title');

      if (idEl) idEl.value = '';
      if (nameEl) nameEl.value = '';
      if (descEl) descEl.value = '';
      if (priceEl) priceEl.value = '250';
      if (catEl) catEl.value = 'Main Course';
      if (imgEl) imgEl.value = '';
      if (availEl) availEl.checked = true;
      if (titleEl) titleEl.textContent = 'Add New Dish';
      
      if (typeof openModal === 'function') {
        openModal('menu-modal');
      } else {
        modal.classList.add('open');
        modal.classList.add('active');
        modal.style.display = 'flex';
        modal.style.opacity = '1';
        modal.style.visibility = 'visible';
        modal.style.pointerEvents = 'auto';
      }
    }

    function openEditMenuModal(id, restId, name, desc, price, category, isAvail, image) {
      const modal = document.getElementById('menu-modal');
      if (!modal) return;

      const idEl = document.getElementById('menu-item-id');
      const restEl = document.getElementById('menu-restaurant-id');
      const nameEl = document.getElementById('menu-item-name');
      const descEl = document.getElementById('menu-description');
      const priceEl = document.getElementById('menu-price');
      const catEl = document.getElementById('menu-category');
      const imgEl = document.getElementById('menu-image');
      const availEl = document.getElementById('menu-is-available');
      const titleEl = document.getElementById('menu-modal-title');

      if (idEl) idEl.value = id;
      if (restEl) restEl.value = restId;
      if (nameEl) nameEl.value = name;
      if (descEl) descEl.value = desc;
      if (priceEl) priceEl.value = price;
      if (catEl) catEl.value = category;
      if (imgEl) imgEl.value = image;
      if (availEl) availEl.checked = (isAvail === '1' || isAvail === 1 || isAvail === true || isAvail === 'true');
      if (titleEl) titleEl.textContent = 'Edit Dish: ' + name;

      if (typeof openModal === 'function') {
        openModal('menu-modal');
      } else {
        modal.classList.add('open');
        modal.classList.add('active');
        modal.style.display = 'flex';
        modal.style.opacity = '1';
        modal.style.visibility = 'visible';
        modal.style.pointerEvents = 'auto';
      }
    }

    function openDeleteMenuModal(id, name) {
      const modal = document.getElementById('menu-delete-modal');
      if (!modal) return;

      const idEl = document.getElementById('delete-menu-item-id');
      const nameEl = document.getElementById('delete-menu-item-name');
      if (idEl) idEl.value = id;
      if (nameEl) nameEl.textContent = name;

      if (typeof openModal === 'function') {
        openModal('menu-delete-modal');
      } else {
        modal.classList.add('open');
        modal.classList.add('active');
        modal.style.display = 'flex';
        modal.style.opacity = '1';
        modal.style.visibility = 'visible';
        modal.style.pointerEvents = 'auto';
      }
    }

    // Attach listeners on load
    document.addEventListener('DOMContentLoaded', function() {
      const btnTop = document.getElementById('btn-add-dish-topbar');
      const btnTable = document.getElementById('btn-add-dish-table');
      if (btnTop) btnTop.addEventListener('click', openNewMenuModal);
      if (btnTable) btnTable.addEventListener('click', openNewMenuModal);
    });
  </script>

  <!-- Vanilla JavaScript Handlers -->
  <script src="<%= request.getContextPath() %>/frontend/js/global.js"></script>
  <script src="<%= request.getContextPath() %>/frontend/js/admin.js"></script>
</body>

</html>
