/**
 * FoodRush Admin Portal JavaScript Controller
 * Handles live filtering, modals, search, Kanban workflows, and store status
 */

document.addEventListener('DOMContentLoaded', () => {
  initAdminSidebar();
  initStoreToggle();
  initModals();
  initRestaurantsFilter();
  initMenuFilter();
  initUsersFilter();
  initKanbanFilter();
});

/* --------------------------------------------------------------------------
   1. Mobile Sidebar Toggle
   -------------------------------------------------------------------------- */
function initAdminSidebar() {
  const toggleBtn = document.getElementById('admin-sidebar-toggle');
  const sidebar = document.getElementById('admin-sidebar');

  if (toggleBtn && sidebar) {
    toggleBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      sidebar.classList.toggle('open');
    });

    document.addEventListener('click', (e) => {
      if (sidebar.classList.contains('open') && !sidebar.contains(e.target) && e.target !== toggleBtn) {
        sidebar.classList.remove('open');
      }
    });
  }
}

/* --------------------------------------------------------------------------
   2. Store Online/Offline Toggle
   -------------------------------------------------------------------------- */
function initStoreToggle() {
  const storeToggle = document.getElementById('admin-store-toggle');
  const statusLabel = document.getElementById('store-status-label');

  if (storeToggle && statusLabel) {
    storeToggle.addEventListener('change', () => {
      if (storeToggle.checked) {
        statusLabel.innerHTML = '<i class="fa-solid fa-circle text-success" style="font-size: 8px; margin-right: 4px;"></i>Accepting Orders';
        statusLabel.style.color = 'var(--color-success)';
        if (typeof showToast === 'function') {
          showToast('Store is now OPEN and accepting online orders', 'success');
        }
      } else {
        statusLabel.innerHTML = '<i class="fa-solid fa-circle text-danger" style="font-size: 8px; margin-right: 4px;"></i>Store Offline';
        statusLabel.style.color = 'var(--color-error)';
        if (typeof showToast === 'function') {
          showToast('Store is now OFFLINE. New orders are paused.', 'warning');
        }
      }
    });
  }
}

/* --------------------------------------------------------------------------
   3. Modal Controllers
   -------------------------------------------------------------------------- */
function initModals() {
  // Close buttons inside modals
  document.querySelectorAll('.modal-close-btn, .modal-footer .btn-secondary').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const modal = btn.closest('.modal-overlay');
      if (modal) {
        modal.classList.remove('open');
        if (window.location.hash) {
          history.pushState('', document.title, window.location.pathname + window.location.search);
        }
      }
    });
  });

  // Close on backdrop click
  document.querySelectorAll('.modal-overlay').forEach(modal => {
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        modal.classList.remove('open');
        if (window.location.hash) {
          history.pushState('', document.title, window.location.pathname + window.location.search);
        }
      }
    });
  });

  // Close on ESC
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      document.querySelectorAll('.modal-overlay.open, .modal-overlay:target').forEach(modal => {
        modal.classList.remove('open');
      });
      if (window.location.hash) {
        history.pushState('', document.title, window.location.pathname + window.location.search);
      }
    }
  });
}

function openModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.classList.add('open');
    modal.classList.add('active');
    modal.style.display = 'flex';
    modal.style.opacity = '1';
    modal.style.visibility = 'visible';
    modal.style.pointerEvents = 'auto';

    // Focus first input field if available
    const firstInput = modal.querySelector('input:not([type="hidden"]), select, textarea');
    if (firstInput) {
      setTimeout(() => firstInput.focus(), 50);
    }
  }
}

function closeModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.classList.remove('open');
    modal.classList.remove('active');
    modal.style.display = 'none';
    modal.style.opacity = '0';
    modal.style.visibility = 'hidden';
    modal.style.pointerEvents = 'none';
    if (window.location.hash) {
      history.pushState('', document.title, window.location.pathname + window.location.search);
    }
  }
}

window.openModal = openModal;
window.closeModal = closeModal;

/* --------------------------------------------------------------------------
   4. Restaurants Filter Controller (DOM & Live search)
   -------------------------------------------------------------------------- */
function initRestaurantsFilter() {
  const searchInput = document.getElementById('restaurant-search-input');
  const statusFilter = document.getElementById('status-filter');
  const cuisineFilter = document.getElementById('cuisine-filter');
  const tbody = document.getElementById('restaurants-table-body');
  const countLabel = document.getElementById('restaurant-count-label');

  if (!tbody) return;

  function filterRestaurants() {
    const q = searchInput ? searchInput.value.toLowerCase().trim() : '';
    const status = statusFilter ? statusFilter.value.toUpperCase() : 'ALL';
    const cuisine = cuisineFilter ? cuisineFilter.value.toLowerCase() : 'all';

    let visibleCount = 0;
    const rows = tbody.querySelectorAll('tr');
    rows.forEach(row => {
      const text = row.textContent.toLowerCase();
      const matchQ = !q || text.includes(q);
      const matchStatus = (status === 'ALL') ||
                          (status === 'ACTIVE' && text.includes('active') && !text.includes('inactive')) ||
                          (status === 'INACTIVE' && text.includes('inactive'));
      const matchCuisine = (cuisine === 'all') || text.includes(cuisine);

      if (matchQ && matchStatus && matchCuisine) {
        row.style.display = '';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    });

    if (countLabel) countLabel.textContent = visibleCount;
  }

  if (searchInput) searchInput.addEventListener('input', filterRestaurants);
  if (statusFilter) statusFilter.addEventListener('change', filterRestaurants);
  if (cuisineFilter) cuisineFilter.addEventListener('change', filterRestaurants);
}

/* --------------------------------------------------------------------------
   5. Menu Catalog Filter Controller
   -------------------------------------------------------------------------- */
function initMenuFilter() {
  const searchInput = document.getElementById('menu-search-input');
  const restFilter = document.getElementById('restaurant-filter');
  const catFilter = document.getElementById('category-filter');
  const availFilter = document.getElementById('availability-filter');
  const tbody = document.getElementById('menu-table-body');
  const countLabel = document.getElementById('menu-count-label');

  if (!tbody) return;

  function filterMenu() {
    const q = searchInput ? searchInput.value.toLowerCase().trim() : '';
    const rest = restFilter ? restFilter.options[restFilter.selectedIndex].text.toLowerCase() : 'all';
    const isAllRest = restFilter ? (restFilter.value === 'ALL') : true;
    const cat = catFilter ? catFilter.value.toLowerCase() : 'all';
    const avail = availFilter ? availFilter.value.toUpperCase() : 'ALL';

    let visibleCount = 0;
    const rows = tbody.querySelectorAll('tr');
    rows.forEach(row => {
      const text = row.textContent.toLowerCase();
      const matchQ = !q || text.includes(q);
      const matchRest = isAllRest || text.includes(rest);
      const matchCat = (cat === 'all') || text.includes(cat);
      const matchAvail = (avail === 'ALL') ||
                         (avail === 'AVAILABLE' && text.includes('in stock')) ||
                         (avail === 'UNAVAILABLE' && text.includes('sold out'));

      if (matchQ && matchRest && matchCat && matchAvail) {
        row.style.display = '';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    });

    if (countLabel) countLabel.textContent = visibleCount;
  }

  if (searchInput) searchInput.addEventListener('input', filterMenu);
  if (restFilter) restFilter.addEventListener('change', filterMenu);
  if (catFilter) catFilter.addEventListener('change', filterMenu);
  if (availFilter) availFilter.addEventListener('change', filterMenu);
}

/* --------------------------------------------------------------------------
   6. Users Filter Controller
   -------------------------------------------------------------------------- */
function initUsersFilter() {
  const searchInput = document.getElementById('user-search-input');
  const roleFilter = document.getElementById('user-role-filter');
  const statusFilter = document.getElementById('user-status-filter');
  const tbody = document.getElementById('users-table-body');
  const countLabel = document.getElementById('user-count-label');

  if (!tbody) return;

  function filterUsers() {
    const q = searchInput ? searchInput.value.toLowerCase().trim() : '';
    const role = roleFilter ? roleFilter.value.toLowerCase() : 'all';
    const status = statusFilter ? statusFilter.value.toLowerCase() : 'all';

    let visibleCount = 0;
    const rows = tbody.querySelectorAll('tr');
    rows.forEach(row => {
      const text = row.textContent.toLowerCase();
      const matchQ = !q || text.includes(q);
      const matchRole = (role === 'all') || text.includes(role);
      const matchStatus = (status === 'all') || (status === 'active' && text.includes('active')) || (status === 'suspended' && text.includes('suspended'));

      if (matchQ && matchRole && matchStatus) {
        row.style.display = '';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    });

    if (countLabel) countLabel.textContent = visibleCount;
  }

  if (searchInput) searchInput.addEventListener('input', filterUsers);
  if (roleFilter) roleFilter.addEventListener('change', filterUsers);
  if (statusFilter) statusFilter.addEventListener('change', filterUsers);
}

/* --------------------------------------------------------------------------
   7. Kanban Board Controller
   -------------------------------------------------------------------------- */
function initKanbanFilter() {
  const restFilter = document.getElementById('kitchen-restaurant-filter');
  const payFilter = document.getElementById('kitchen-payment-filter');
  const countLabel = document.getElementById('total-active-orders');

  function filterKanban() {
    const rest = restFilter ? restFilter.value.toLowerCase() : 'all';
    const pay = payFilter ? payFilter.value.toLowerCase() : 'all';

    let activeCount = 0;
    document.querySelectorAll('.kanban-column:not(.kanban-col-delivered) .kanban-card').forEach(card => {
      const text = card.textContent.toLowerCase();
      const matchRest = (rest === 'all') || text.includes(rest);
      const matchPay = (pay === 'all') || (pay === 'paid' && (text.includes('upi') || text.includes('card'))) || (pay === 'cod' && text.includes('cod'));

      if (matchRest && matchPay) {
        card.style.display = '';
        activeCount++;
      } else {
        card.style.display = 'none';
      }
    });

    if (countLabel) countLabel.textContent = activeCount + ' Orders';
  }

  if (restFilter) restFilter.addEventListener('change', filterKanban);
  if (payFilter) payFilter.addEventListener('change', filterKanban);
}
