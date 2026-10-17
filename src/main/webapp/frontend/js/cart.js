/**
 * FoodRush Cart Operations & Dynamic Bill Calculation
 * Full bidirectional synchronization with CartServlet backend session
 */

function getContextPath() {
  if (typeof window.FOODRUSH_CONTEXT_PATH === 'string') {
    return window.FOODRUSH_CONTEXT_PATH;
  }
  const p = window.location.pathname.split('/');
  return (p.length > 2 && p[1] !== 'frontend') ? '/' + p[1] : '';
}

function applyServerBillData(data) {
  const itemTotalEl = document.getElementById('bill-item-total');
  const deliveryFeeEl = document.getElementById('bill-delivery-fee');
  const platformFeeEl = document.getElementById('bill-platform-fee');
  const taxesEl = document.getElementById('bill-taxes');
  const grandTotalEl = document.getElementById('bill-grand-total');
  const discountRow = document.getElementById('bill-discount-row');
  const discountVal = document.getElementById('bill-discount-val');
  const emptyState = document.getElementById('cart-empty-state');
  const mainLayout = document.getElementById('cart-main-layout');
  const freeDeliveryFill = document.querySelector('.free-delivery-bar-fill');
  const freeDeliveryTitle = document.querySelector('.free-delivery-title');

  if (data.totalCount === 0) {
    if (mainLayout) mainLayout.style.display = 'none';
    if (emptyState) emptyState.style.display = 'block';
  } else {
    if (mainLayout) mainLayout.style.display = 'grid';
    if (emptyState) emptyState.style.display = 'none';
  }

  if (itemTotalEl) itemTotalEl.textContent = '₹' + Math.round(data.itemTotal || 0);
  if (deliveryFeeEl) {
    const isFree = (data.deliveryFee || 0) === 0;
    deliveryFeeEl.textContent = isFree ? 'FREE' : '₹' + Math.round(data.deliveryFee);
    deliveryFeeEl.style.color = isFree ? 'var(--color-success)' : 'var(--color-text-primary)';
  }
  if (platformFeeEl) platformFeeEl.textContent = '₹' + Math.round(data.platformFee || 0);
  if (taxesEl) taxesEl.textContent = '₹' + Math.round(data.gstTax || 0);
  if (grandTotalEl) grandTotalEl.textContent = '₹' + Math.round(data.grandTotal || 0);

  if (discountRow && discountVal) {
    if ((data.discount || 0) > 0) {
      discountRow.style.display = 'flex';
      discountVal.textContent = '-₹' + Math.round(data.discount);
    } else {
      discountRow.style.display = 'none';
    }
  }

  // Free delivery progress bar
  const itemTotal = data.itemTotal || 0;
  const isFreeDelivery = itemTotal >= 400;
  if (freeDeliveryFill && freeDeliveryTitle) {
    if (isFreeDelivery) {
      freeDeliveryFill.style.width = '100%';
      freeDeliveryTitle.innerHTML = '<i class="fa-solid fa-gift text-success"></i> <strong>Congratulations!</strong> You unlocked <strong>FREE Delivery!</strong>';
    } else {
      const remaining = 400 - itemTotal;
      const percent = Math.min(100, Math.round((itemTotal / 400) * 100));
      freeDeliveryFill.style.width = percent + '%';
      freeDeliveryTitle.innerHTML = 'Add <strong>₹' + Math.round(remaining) + '</strong> more to unlock <strong>FREE Delivery!</strong>';
    }
  }

  // Update global nav badges
  document.querySelectorAll('.cart-count').forEach(el => {
    const count = parseInt(data.totalCount, 10) || 0;
    if (count > 0) {
      el.textContent = count;
      el.setAttribute('data-count', count);
      el.classList.remove('is-empty');
      el.style.display = 'inline-flex';
    } else {
      el.textContent = '';
      el.setAttribute('data-count', '0');
      el.classList.add('is-empty');
      el.style.display = 'none';
    }
  });
}

// Global functions invoked by onclick in cart.jsp
window.updateCartItem = function (menuId, newQty) {
  if (newQty <= 0) {
    window.removeCartItem(menuId);
    return;
  }

  fetch(getContextPath() + '/cart?action=update&menuId=' + menuId + '&quantity=' + newQty + '&format=json')
    .then(res => res.json())
    .then(data => {
      if (data && data.success) {
        applyServerBillData(data);
        const row = document.querySelector('.cart-item-row[data-id="' + menuId + '"]');
        if (row) {
          const qtyVal = row.querySelector('.qty-val');
          if (qtyVal) qtyVal.textContent = newQty;

          const unitPriceEl = row.querySelector('.cart-item-unit-price');
          const unitPrice = unitPriceEl ? (parseInt(unitPriceEl.textContent.replace(/[^\d]/g, ''), 10) || 0) : 0;
          const totalDisplay = row.querySelector('.cart-item-total');
          if (totalDisplay) totalDisplay.textContent = '₹' + (unitPrice * newQty);

          // Update onclick handlers for next increments
          const minusBtn = row.querySelector('.qty-stepper .qty-btn:first-child');
          const plusBtn = row.querySelector('.qty-stepper .qty-btn:last-child');
          if (minusBtn) minusBtn.setAttribute('onclick', 'updateCartItem(' + menuId + ', ' + (newQty - 1) + ')');
          if (plusBtn) plusBtn.setAttribute('onclick', 'updateCartItem(' + menuId + ', ' + (newQty + 1) + ')');
        }
      }
    })
    .catch(err => console.error('Error updating cart item:', err));
};

window.removeCartItem = function (menuId) {
  fetch(getContextPath() + '/cart?action=remove&menuId=' + menuId + '&format=json')
    .then(res => res.json())
    .then(data => {
      if (data && data.success) {
        const row = document.querySelector('.cart-item-row[data-id="' + menuId + '"]');
        if (row) row.remove();
        applyServerBillData(data);
        if (window.FoodRush && window.FoodRush.showToast) {
          window.FoodRush.showToast('Item removed from cart', 'info');
        }
      }
    })
    .catch(err => console.error('Error removing cart item:', err));
};

window.clearCart = function () {
  fetch(getContextPath() + '/cart?action=clear&format=json')
    .then(res => res.json())
    .then(data => {
      if (data && data.success) {
        const container = document.getElementById('cart-items-container');
        if (container) container.innerHTML = '';
        applyServerBillData(data);
        if (window.FoodRush && window.FoodRush.showToast) {
          window.FoodRush.showToast('Cart cleared', 'info');
        }
      }
    })
    .catch(err => console.error('Error clearing cart:', err));
};

window.addAddonItem = function (menuId, name, price) {
  fetch(getContextPath() + '/cart?action=add&menuId=' + menuId + '&name=' + encodeURIComponent(name) + '&price=' + price + '&quantity=1&format=json')
    .then(res => res.json())
    .then(data => {
      if (data && data.success) {
        window.location.reload();
      }
    })
    .catch(err => console.error('Error adding addon:', err));
};

window.removeCoupon = function () {
  fetch(getContextPath() + '/cart?action=coupon&couponCode=&format=json')
    .then(res => res.json())
    .then(data => {
      if (data && data.success) {
        applyServerBillData(data);
        const appliedPill = document.getElementById('applied-coupon-display');
        const couponInput = document.getElementById('coupon-input-field');
        if (appliedPill) appliedPill.style.display = 'none';
        if (couponInput) couponInput.value = '';
        if (window.FoodRush && window.FoodRush.showToast) {
          window.FoodRush.showToast('Coupon removed', 'info');
        }
      }
    })
    .catch(err => console.error('Error removing coupon:', err));
};

document.addEventListener('DOMContentLoaded', () => {
  initCouponEngine();
});

function initCouponEngine() {
  const couponInput = document.getElementById('coupon-input-field');
  const applyBtn = document.getElementById('btn-apply-coupon');
  const appliedPill = document.getElementById('applied-coupon-display');
  const appliedCodeText = document.getElementById('applied-coupon-code-text');

  if (!applyBtn || !couponInput) return;

  applyBtn.addEventListener('click', () => {
    const code = couponInput.value.trim().toUpperCase();
    if (!code) {
      if (window.FoodRush && window.FoodRush.showToast) {
        window.FoodRush.showToast('Please enter a coupon code.', 'warning');
      }
      return;
    }

    fetch(getContextPath() + '/cart?action=coupon&couponCode=' + encodeURIComponent(code) + '&format=json')
      .then(res => res.json())
      .then(data => {
        if (data && data.success) {
          if ((data.discount || 0) > 0) {
            applyServerBillData(data);
            if (appliedPill) appliedPill.style.display = 'flex';
            if (appliedCodeText) {
              appliedCodeText.textContent = code + ' Applied (-₹' + Math.round(data.discount) + ')';
            }
            if (window.FoodRush && window.FoodRush.showToast) {
              window.FoodRush.showToast('Coupon ' + code + ' Applied! Saved ₹' + Math.round(data.discount), 'success');
            }
          } else {
            if (window.FoodRush && window.FoodRush.showToast) {
              window.FoodRush.showToast('Invalid Coupon Code. Try "RUSH50" or "FEAST100"', 'error');
            }
          }
        }
      })
      .catch(err => {
        console.error('Coupon apply error:', err);
        if (window.FoodRush && window.FoodRush.showToast) {
          window.FoodRush.showToast('Error verifying coupon', 'error');
        }
      });
  });
}
