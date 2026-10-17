/**
 * FoodRush Global JavaScript Utilities
 * Handles modals, drawers, location pickers, theme toggle, toast notifications, and shared UI state.
 */

// Immediate execution to prevent flash of light theme
(function () {
  const savedTheme = localStorage.getItem('foodrush_theme');
  if (savedTheme === 'dark' || (!savedTheme && window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    document.documentElement.setAttribute('data-theme', 'dark');
  } else {
    document.documentElement.removeAttribute('data-theme');
  }
})();

// Global modal helper functions
window.openModal = window.openModal || function (modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.classList.add('open');
    modal.classList.add('active');
    modal.style.display = 'flex';
    modal.style.opacity = '1';
    modal.style.visibility = 'visible';
    modal.style.pointerEvents = 'auto';
    const firstInput = modal.querySelector('input:not([type="hidden"]), select, textarea');
    if (firstInput) {
      setTimeout(() => firstInput.focus(), 50);
    }
  }
};

window.closeModal = window.closeModal || function (modalId) {
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
};

// Global Password Visibility Toggle
window.togglePasswordVisibility = function (inputRef, btnRef, e) {
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
};
window.togglePassVisibility = window.togglePasswordVisibility;

document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  initLocationModal();
  initMobileDrawer();
  initLoginModal();
  initNavScroll();
  initCartBadges();
  initNavSearch();
  initUserDropdown();
});

/* --------------------------------------------------------------------------
   0. Theme Manager (Dark / Light Mode)
   -------------------------------------------------------------------------- */
function initTheme() {
  const savedTheme = localStorage.getItem('foodrush_theme');
  const systemPrefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  const currentTheme = savedTheme || (systemPrefersDark ? 'dark' : 'light');

  applyTheme(currentTheme);

  // Bind to all theme toggle buttons on page
  const toggleBtns = document.querySelectorAll('.theme-toggle-btn');
  toggleBtns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
      const newTheme = isDark ? 'light' : 'dark';
      applyTheme(newTheme);
      localStorage.setItem('foodrush_theme', newTheme);
      showToast(newTheme === 'dark' ? 'Dark mode enabled' : 'Light mode enabled', 'info');
    });
  });
}

function applyTheme(theme) {
  if (theme === 'dark') {
    document.documentElement.setAttribute('data-theme', 'dark');
  } else {
    document.documentElement.removeAttribute('data-theme');
  }
  updateMobileThemeLabels(theme);
}

function updateMobileThemeLabels(theme) {
  const labels = document.querySelectorAll('.theme-toggle-label');
  labels.forEach((label) => {
    label.textContent = theme === 'dark' ? 'Light Mode' : 'Dark Mode';
  });
}

/* --------------------------------------------------------------------------
   1. Location Picker Modal
   -------------------------------------------------------------------------- */
function initLocationModal() {
  const trigger = document.querySelector('.location-trigger');
  const modal = document.getElementById('location-modal');
  if (!trigger || !modal) return;

  const closeBtn = modal.querySelector('.modal-close-btn');
  const locationText = document.querySelector('.selected-location-text');
  const locationButtons = modal.querySelectorAll('.modal-body .btn');

  trigger.addEventListener('click', (e) => {
    e.preventDefault();
    modal.classList.add('active');
  });

  if (closeBtn) {
    closeBtn.addEventListener('click', () => {
      modal.classList.remove('active');
    });
  }

  // Close on backdrop click
  modal.addEventListener('click', (e) => {
    if (e.target === modal) {
      modal.classList.remove('active');
    }
  });

  // Select location buttons
  locationButtons.forEach((btn) => {
    btn.addEventListener('click', () => {
      const strongText = btn.querySelector('strong');
      const locality = strongText ? strongText.textContent.trim() : btn.textContent.trim();
      if (locationText) {
        locationText.textContent = `${locality}, Bangalore`;
      }
      modal.classList.remove('active');
      showToast(`Delivery location updated to ${locality}`, 'info');
    });
  });
}

/* --------------------------------------------------------------------------
   2. Mobile Drawer Navigation
   -------------------------------------------------------------------------- */
function initMobileDrawer() {
  const toggleBtn = document.getElementById('mobile-menu-toggle');
  const drawer = document.getElementById('mobile-nav-drawer');
  if (!toggleBtn || !drawer) return;

  const closeBtn = drawer.querySelector('.modal-close-btn');

  toggleBtn.addEventListener('click', () => {
    drawer.classList.add('active');
  });

  if (closeBtn) {
    closeBtn.addEventListener('click', () => {
      drawer.classList.remove('active');
    });
  }

  drawer.addEventListener('click', (e) => {
    if (e.target === drawer) {
      drawer.classList.remove('active');
    }
  });
}

/* --------------------------------------------------------------------------
   3. Sign In Modal
   -------------------------------------------------------------------------- */
function initLoginModal() {
  const modal = document.getElementById('login-modal');
  if (!modal) return;

  const closeBtn = modal.querySelector('.modal-close-btn');

  if (closeBtn) {
    closeBtn.addEventListener('click', () => {
      modal.classList.remove('active');
    });
  }

  modal.addEventListener('click', (e) => {
    if (e.target === modal) {
      modal.classList.remove('active');
    }
  });
}

/* --------------------------------------------------------------------------
   4. Navbar Scroll Elevation Shadow
   -------------------------------------------------------------------------- */
function initNavScroll() {
  const navbar = document.getElementById('main-navbar');
  if (!navbar) return;

  window.addEventListener('scroll', () => {
    if (window.scrollY > 20) {
      navbar.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.08)';
    } else {
      navbar.style.boxShadow = 'none';
    }
  }, { passive: true });
}

/* --------------------------------------------------------------------------
   5. Global Cart Badge Counter
   -------------------------------------------------------------------------- */
function initCartBadges() {
  updateCartBadgeDisplay();
}

function updateCartBadgeDisplay() {
  const cartBadges = document.querySelectorAll('.cart-count');
  if (!cartBadges.length) return;

  let totalCount = 0;
  const storedCart = localStorage.getItem('foodrush_cart');
  if (storedCart) {
    try {
      const items = JSON.parse(storedCart);
      if (Array.isArray(items) && items.length > 0) {
        totalCount = items.reduce((sum, item) => sum + (item.qty || 1), 0);
      }
    } catch (e) {
      // Fallback
    }
  } else {
    // If no localStorage cart, preserve existing server-side count if > 0
    const firstBadge = cartBadges[0];
    const initialCount = parseInt(firstBadge.getAttribute('data-count') || firstBadge.textContent.trim(), 10);
    if (!isNaN(initialCount) && initialCount > 0) {
      totalCount = initialCount;
    }
  }

  cartBadges.forEach((badge) => {
    if (totalCount > 0) {
      badge.textContent = totalCount;
      badge.setAttribute('data-count', totalCount);
      badge.classList.remove('is-empty');
      badge.style.display = 'inline-flex';
    } else {
      badge.textContent = '';
      badge.setAttribute('data-count', '0');
      badge.classList.add('is-empty');
      badge.style.display = 'none';
    }
  });
}

/* --------------------------------------------------------------------------
   6. Toast Notification Helper
   -------------------------------------------------------------------------- */
function showToast(message, type) {
  if (!type) type = 'success';
  var container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    container.className = 'toast-container';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.style.cssText = `
    display: flex;
    align-items: center;
    gap: 10px;
    background: linear-gradient(135deg, #1C0508, #0E0304);
    color: #FFFFFF;
    padding: 12px 18px;
    border-radius: 12px;
    border: 1px solid rgba(255, 46, 77, 0.3);
    border-left: 4px solid var(--color-primary);
    box-shadow: 0 8px 24px rgba(0,0,0,0.5), 0 0 12px rgba(229,9,20,0.25);
    margin-bottom: 10px;
    font-size: 14px;
    font-weight: 600;
    animation: toastIn 0.3s ease-out forwards;
    z-index: 9999;
  `;

  let iconHtml = '<i class="fa-solid fa-circle-info" style="color: #60A5FA;"></i>';
  if (type === 'success') {
    iconHtml = '<i class="fa-solid fa-circle-check" style="color: #10B981;"></i>';
  } else if (type === 'error') {
    iconHtml = '<i class="fa-solid fa-circle-xmark" style="color: #EF4444;"></i>';
  } else if (type === 'warning') {
    iconHtml = '<i class="fa-solid fa-triangle-exclamation" style="color: #F59E0B;"></i>';
  }
  toast.innerHTML = `<span style="font-size: 16px; display: inline-flex; align-items: center;">${iconHtml}</span> <span>${message}</span>`;

  container.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(-10px)';
    toast.style.transition = 'all 0.3s ease';
    setTimeout(() => toast.remove(), 300);
  }, 3200);
}

function getGlobalContextPath() {
  if (typeof window.FOODRUSH_CONTEXT_PATH === 'string') {
    return window.FOODRUSH_CONTEXT_PATH;
  }
  const pathSegments = window.location.pathname.split('/');
  if (pathSegments.length > 1 && pathSegments[1] && pathSegments[1] !== 'frontend') {
    return '/' + pathSegments[1];
  }
  return '';
}

/* --------------------------------------------------------------------------
   7. Top Navbar Search Handler (Redirect to Restaurants Listing)
   -------------------------------------------------------------------------- */
function initNavSearch() {
  const navInput = document.getElementById('nav-search-input');
  if (!navInput) return;

  navInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      const val = navInput.value.trim();
      if (val) {
        const cp = getGlobalContextPath();
        window.location.href = `${cp}/restaurants?search=${encodeURIComponent(val)}`;
      }
    }
  });
}

/* --------------------------------------------------------------------------
   8. Navbar User Dropdown Menu
   -------------------------------------------------------------------------- */
function initUserDropdown() {
  const dropdown = document.getElementById('nav-user-dropdown');
  const trigger = document.getElementById('nav-user-pill');
  const menu = document.getElementById('user-dropdown-menu');
  if (!dropdown || !trigger || !menu) return;

  trigger.addEventListener('click', (e) => {
    e.stopPropagation();
    const isShown = menu.classList.contains('show');
    if (isShown) {
      menu.classList.remove('show');
      trigger.classList.remove('active');
      trigger.setAttribute('aria-expanded', 'false');
    } else {
      menu.classList.add('show');
      trigger.classList.add('active');
      trigger.setAttribute('aria-expanded', 'true');
    }
  });

  // Close when clicking anywhere outside
  document.addEventListener('click', (e) => {
    if (!dropdown.contains(e.target)) {
      menu.classList.remove('show');
      trigger.classList.remove('active');
      trigger.setAttribute('aria-expanded', 'false');
    }
  });

  // Close on Escape key
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && menu.classList.contains('show')) {
      menu.classList.remove('show');
      trigger.classList.remove('active');
      trigger.setAttribute('aria-expanded', 'false');
    }
  });
}

// Global expose
window.FoodRush = {
  showToast,
  updateCartBadgeDisplay
};
