/**
 * FoodRush Restaurant Detail & Menu Management
 * Handles interactive item quantity steppers, smart floating cart bar, and menu search.
 */

document.addEventListener('DOMContentLoaded', function () {
  initMenuSteppers();
  initMenuSearch();
  initCategoryTabs();
  initDietaryFilters();
});

function initMenuSteppers() {
  var menuCards = document.querySelectorAll('.menu-item-card:not(.unavailable)');
  var bottomBar = document.getElementById('sticky-cart-bar');
  var bottomCount = document.getElementById('cart-bar-item-count');
  var bottomTotal = document.getElementById('cart-bar-total-amount');

  var cart = {};
  var pendingOperations = [];

  // Load existing cart from localStorage
  var stored = localStorage.getItem('foodrush_cart');
  if (stored) {
    try {
      var parsed = JSON.parse(stored);
      parsed.forEach(function (item) {
        cart[item.id] = item;
      });
    } catch (e) {}
  }

  var conflictModal = document.getElementById('cart-conflict-modal');
  var conflictDesc = document.getElementById('conflict-modal-desc');
  var conflictCancelBtn = document.getElementById('conflict-cancel-btn');
  var conflictConfirmBtn = document.getElementById('conflict-confirm-btn');

  function showConflictModal(currResName, newResName, onConfirm) {
    if (!conflictModal) {
      if (confirm('Your cart contains items from "' + currResName + '". Do you want to reset your cart to add items from "' + newResName + '"?')) {
        onConfirm();
      }
      return;
    }

    if (conflictDesc) {
      conflictDesc.innerHTML = 'Your cart contains items from <strong style="color: var(--color-text-primary);">' + currResName + '</strong>. Would you like to reset your cart and start a fresh order from <strong style="color: var(--color-primary);">' + newResName + '</strong>?';
    }

    conflictModal.classList.add('active');

    var handleConfirm = function () {
      conflictModal.classList.remove('active');
      conflictConfirmBtn.removeEventListener('click', handleConfirm);
      conflictCancelBtn.removeEventListener('click', handleCancel);
      onConfirm();
    };

    var handleCancel = function () {
      conflictModal.classList.remove('active');
      conflictConfirmBtn.removeEventListener('click', handleConfirm);
      conflictCancelBtn.removeEventListener('click', handleCancel);
    };

    conflictConfirmBtn.addEventListener('click', handleConfirm);
    conflictCancelBtn.addEventListener('click', handleCancel);
  }

  function resetAllMenuSteppers() {
    menuCards.forEach(function (card) {
      var btn = card.querySelector('.btn-add-item');
      var stp = card.querySelector('.qty-stepper');
      if (btn) btn.style.display = 'inline-flex';
      if (stp) stp.style.display = 'none';
    });
  }

  // Intercept checkout navigation to ensure all in-flight adds are settled on the server
  var checkoutButtons = document.querySelectorAll('.btn-checkout-nav, #btn-sticky-checkout, #sticky-cart-bar a, .nav-cart-btn, #cart-drawer a');
  checkoutButtons.forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      if (pendingOperations.length > 0) {
        e.preventDefault();
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Loading Cart...';
        Promise.all(pendingOperations.slice()).then(function () {
          var targetHref = btn.getAttribute('href');
          if (!targetHref || targetHref === '#') {
            targetHref = (typeof window.FOODRUSH_CONTEXT_PATH === 'string' ? window.FOODRUSH_CONTEXT_PATH : '') + '/cart';
          }
          window.location.href = targetHref;
        }).catch(function () {
          var targetHref = btn.getAttribute('href') || '/cart';
          window.location.href = targetHref;
        });
      }
    });
  });

  menuCards.forEach(function (card, index) {
    var addBtn = card.querySelector('.btn-add-item');
    var itemId = (addBtn && addBtn.dataset.id) ? addBtn.dataset.id : 'item-' + (index + 101);
    var nameEl = card.querySelector('.menu-item-name');
    var name = (addBtn && addBtn.dataset.name) ? addBtn.dataset.name : (nameEl ? nameEl.textContent.trim() : 'Food Item');
    var priceEl = card.querySelector('.menu-item-price');
    var priceText = priceEl ? priceEl.textContent : '₹200';
    var price = (addBtn && addBtn.dataset.price) ? parseInt(addBtn.dataset.price, 10) : (parseInt(priceText.replace(/[^\d]/g, ''), 10) || 200);
    var resName = (addBtn && addBtn.dataset.restaurant) ? addBtn.dataset.restaurant : 'Selected Restaurant';

    var stepper = card.querySelector('.qty-stepper');
    var qtyVal = card.querySelector('.qty-val');
    var stepperBtns = stepper ? stepper.querySelectorAll('.qty-btn') : [];
    var minusBtn = stepperBtns[0];
    var plusBtn = stepperBtns[1];

    if (!addBtn || !stepper || !qtyVal) return;

    var menuIdNum = addBtn.dataset.menuid || itemId.replace('item-', '');
    var resIdNum = addBtn.dataset.restaurantid || '1';

    var contextPath = (typeof window.FOODRUSH_CONTEXT_PATH === 'string')
      ? window.FOODRUSH_CONTEXT_PATH
      : (function () {
          var pathSegments = window.location.pathname.split('/');
          return (pathSegments.length > 2 && pathSegments[1] !== 'frontend') ? '/' + pathSegments[1] : '';
        })();

    // Check if this item is in cart
    if (cart[itemId] && cart[itemId].qty > 0) {
      addBtn.style.display = 'none';
      stepper.style.display = 'flex';
      qtyVal.textContent = cart[itemId].qty;
    }

    function doAddItem(forceReset) {
      var isForceReset = (forceReset === true);
      if (isForceReset) {
        cart = {};
        resetAllMenuSteppers();
        localStorage.removeItem('foodrush_cart');
      }

      cart[itemId] = { id: itemId, name: name, price: price, qty: 1, restaurantId: resIdNum, restaurantName: resName };
      addBtn.style.display = 'none';
      stepper.style.display = 'flex';
      qtyVal.textContent = '1';

      localStorage.setItem('foodrush_cart_restaurant', JSON.stringify({ restaurantId: resIdNum, restaurantName: resName }));
      syncCart();

      var addPromise = fetch(contextPath + '/cart?action=add&menuId=' + menuIdNum + '&quantity=1&restaurantId=' + resIdNum + '&name=' + encodeURIComponent(name) + '&price=' + price + '&forceReset=' + isForceReset + '&format=json')
        .then(function (res) { return res.json(); })
        .then(function (data) {
          if (data && data.conflict) {
            // Server reported restaurant conflict -> revert optimistic add until user confirms
            delete cart[itemId];
            addBtn.style.display = 'inline-flex';
            stepper.style.display = 'none';
            syncCart();
            showConflictModal(data.currentRestaurant || 'previous restaurant', data.newRestaurant || resName, function () {
              doAddItem(true);
            });
          } else if (data && data.success) {
            syncCart();
          }
        })
        .catch(function (err) {
          console.error('Cart add error:', err);
        })
        .finally(function () {
          var idx = pendingOperations.indexOf(addPromise);
          if (idx > -1) pendingOperations.splice(idx, 1);
        });

      pendingOperations.push(addPromise);

      if (window.FoodRush) {
        window.FoodRush.showToast(isForceReset ? 'Cart started fresh with ' + name + '!' : 'Added ' + name + ' to cart!');
      }
    }

    // Add button click
    addBtn.addEventListener('click', function (e) {
      e.preventDefault();

      var storedRes = localStorage.getItem('foodrush_cart_restaurant');
      var hasConflict = false;
      var currResName = 'another restaurant';

      if (storedRes && Object.keys(cart).length > 0) {
        try {
          var parsed = JSON.parse(storedRes);
          if (parsed.restaurantId && String(parsed.restaurantId) !== String(resIdNum)) {
            hasConflict = true;
            currResName = parsed.restaurantName || 'another restaurant';
          }
        } catch (e) {}
      }

      if (hasConflict) {
        showConflictModal(currResName, resName, function () {
          doAddItem(true);
        });
      } else {
        doAddItem(false);
      }
    });

    // Plus button click
    if (plusBtn) {
      plusBtn.addEventListener('click', function (e) {
        e.preventDefault();
        if (!cart[itemId]) cart[itemId] = { id: itemId, name: name, price: price, qty: 0, restaurantId: resIdNum, restaurantName: resName };
        cart[itemId].qty += 1;
        qtyVal.textContent = cart[itemId].qty;
        syncCart();
        var p = fetch(contextPath + '/cart?action=update&menuId=' + menuIdNum + '&quantity=' + cart[itemId].qty + '&format=json')
          .catch(function () {})
          .finally(function () {
            var idx = pendingOperations.indexOf(p);
            if (idx > -1) pendingOperations.splice(idx, 1);
          });
        pendingOperations.push(p);
      });
    }

    // Minus button click
    if (minusBtn) {
      minusBtn.addEventListener('click', function (e) {
        e.preventDefault();
        if (cart[itemId]) {
          cart[itemId].qty -= 1;
          var currentQty = cart[itemId].qty;
          var p;
          if (currentQty <= 0) {
            delete cart[itemId];
            stepper.style.display = 'none';
            addBtn.style.display = 'inline-flex';
            p = fetch(contextPath + '/cart?action=remove&menuId=' + menuIdNum + '&format=json');
          } else {
            qtyVal.textContent = currentQty;
            p = fetch(contextPath + '/cart?action=update&menuId=' + menuIdNum + '&quantity=' + currentQty + '&format=json');
          }
          syncCart();
          p.catch(function () {}).finally(function () {
            var idx = pendingOperations.indexOf(p);
            if (idx > -1) pendingOperations.splice(idx, 1);
          });
          pendingOperations.push(p);
        }
      });
    }
  });

  function syncCart() {
    var itemsList = Object.values(cart);
    if (itemsList.length === 0) {
      localStorage.removeItem('foodrush_cart');
      localStorage.removeItem('foodrush_cart_restaurant');
    } else {
      localStorage.setItem('foodrush_cart', JSON.stringify(itemsList));
    }

    var totalCount = itemsList.reduce(function (sum, it) { return sum + it.qty; }, 0);
    var totalPrice = itemsList.reduce(function (sum, it) { return sum + (it.price * it.qty); }, 0);

    // Update bottom sticky cart bar
    if (bottomBar && bottomCount && bottomTotal) {
      if (totalCount > 0) {
        bottomBar.style.display = 'block';
        bottomCount.textContent = totalCount + ' item' + (totalCount === 1 ? '' : 's') + ' in cart';
        bottomTotal.textContent = '₹' + totalPrice;
      } else {
        bottomBar.style.display = 'none';
      }
    }

    // Update global badge
    if (window.FoodRush) window.FoodRush.updateCartBadgeDisplay();
  }

  // Initial sync
  syncCart();
}

/* --------------------------------------------------------------------------
   Menu Live Search Filter
   -------------------------------------------------------------------------- */
function initMenuSearch() {
  var searchInput = document.querySelector('.menu-search-input');
  if (!searchInput) return;

  var items = document.querySelectorAll('.menu-item-card');

  searchInput.addEventListener('input', function () {
    var term = searchInput.value.toLowerCase().trim();

    items.forEach(function (item) {
      var nameEl = item.querySelector('.menu-item-name');
      var name = (item.dataset.name || (nameEl ? nameEl.textContent : '')).toLowerCase();
      var descEl = item.querySelector('.menu-item-desc');
      var desc = (item.dataset.desc || (descEl ? descEl.textContent : '')).toLowerCase();

      if (!term || name.indexOf(term) > -1 || desc.indexOf(term) > -1) {
        item.style.display = 'flex';
      } else {
        item.style.display = 'none';
      }
    });
  });
}

/* --------------------------------------------------------------------------
   Category Tabs Navigation
   -------------------------------------------------------------------------- */
function initCategoryTabs() {
  var tabs = document.querySelectorAll('.category-tab-btn');
  tabs.forEach(function (tab) {
    tab.addEventListener('click', function () {
      tabs.forEach(function (t) { t.classList.remove('active'); });
      tab.classList.add('active');
    });
  });
}

/* --------------------------------------------------------------------------
   Dietary Filter Buttons (Veg / Non-Veg)
   -------------------------------------------------------------------------- */
function initDietaryFilters() {
  var vegBtn = document.getElementById('filter-veg-btn');
  var nonvegBtn = document.getElementById('filter-nonveg-btn');
  var items = document.querySelectorAll('.menu-item-card');

  var vegActive = false;
  var nonvegActive = false;

  function applyDietaryFilter() {
    items.forEach(function (item) {
      var isVeg = item.dataset.veg === 'true';
      if (vegActive && !nonvegActive) {
        item.style.display = isVeg ? 'flex' : 'none';
      } else if (nonvegActive && !vegActive) {
        item.style.display = !isVeg ? 'flex' : 'none';
      } else {
        item.style.display = 'flex';
      }
    });
  }

  if (vegBtn) {
    vegBtn.addEventListener('click', function () {
      vegActive = !vegActive;
      if (vegActive) nonvegActive = false;

      vegBtn.style.backgroundColor = vegActive ? 'var(--color-primary)' : '';
      vegBtn.style.color = vegActive ? '#FFFFFF' : '';
      if (nonvegBtn) {
        nonvegBtn.style.backgroundColor = '';
        nonvegBtn.style.color = '';
      }
      applyDietaryFilter();
    });
  }

  if (nonvegBtn) {
    nonvegBtn.addEventListener('click', function () {
      nonvegActive = !nonvegActive;
      if (nonvegActive) vegActive = false;

      nonvegBtn.style.backgroundColor = nonvegActive ? 'var(--color-primary)' : '';
      nonvegBtn.style.color = nonvegActive ? '#FFFFFF' : '';
      if (vegBtn) {
        vegBtn.style.backgroundColor = '';
        vegBtn.style.color = '';
      }
      applyDietaryFilter();
    });
  }
}
