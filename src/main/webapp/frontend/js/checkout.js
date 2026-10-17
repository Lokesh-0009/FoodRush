/**
 * FoodRush Checkout Interactivity & Dynamic Totals
 */

document.addEventListener('DOMContentLoaded', function () {
  initAddressSelection();
  initTipSelector();
  initPaymentAccordion();
  initAddAddressModal();
  initCheckoutSubmission();
});

/* --------------------------------------------------------------------------
   1. Address Selection Card Highlight
   -------------------------------------------------------------------------- */
function initAddressSelection() {
  var addressCards = document.querySelectorAll('.address-option-card');

  addressCards.forEach(function (card) {
    card.addEventListener('click', function () {
      addressCards.forEach(function (c) {
        c.classList.remove('active');
        var badge = c.querySelector('.caption-text');
        if (badge) {
          badge.className = 'caption-text font-semibold text-light';
          badge.textContent = 'Click to select';
        }
      });

      card.classList.add('active');
      var radio = card.querySelector('input[type="radio"]');
      if (radio) radio.checked = true;

      var currentBadge = card.querySelector('.caption-text');
      if (currentBadge) {
        currentBadge.className = 'caption-text font-semibold text-brand';
        currentBadge.innerHTML = '<i class="fa-solid fa-check"></i> Selected for delivery';
      }
    });
  });
}

/* --------------------------------------------------------------------------
   2. Delivery Partner Tip Selection & Dynamic Grand Total
   -------------------------------------------------------------------------- */
function initTipSelector() {
  var tipRadios = document.querySelectorAll('input[name="tipAmount"]');
  var grandTotalEl = document.getElementById('checkout-grand-total');
  var placeOrderBtn = document.getElementById('btn-place-order');
  var hiddenTotalInput = document.getElementById('hidden-total-amount');
  var tipRow = document.getElementById('bill-tip-row');
  var tipValEl = document.getElementById('bill-tip-val');
  var sidebar = document.querySelector('.checkout-summary-sidebar');

  var baseTotal = 0;
  if (sidebar && sidebar.dataset.baseTotal) {
    baseTotal = parseInt(sidebar.dataset.baseTotal, 10) || 0;
  } else if (hiddenTotalInput && hiddenTotalInput.value) {
    baseTotal = parseInt(hiddenTotalInput.value, 10) || 0;
  }

  function updateTotals(tip) {
    var finalGrandTotal = baseTotal + tip;
    if (grandTotalEl) grandTotalEl.textContent = '₹' + finalGrandTotal;
    if (placeOrderBtn) placeOrderBtn.innerHTML = 'Place Order (₹' + finalGrandTotal + ') <i class="fa-solid fa-arrow-right"></i>';
    if (hiddenTotalInput) hiddenTotalInput.value = finalGrandTotal;

    if (tipRow && tipValEl) {
      if (tip > 0) {
        tipRow.style.display = 'flex';
        tipValEl.textContent = '₹' + tip;
      } else {
        tipRow.style.display = 'none';
      }
    }
  }

  tipRadios.forEach(function (radio) {
    if (radio.checked) {
      var initialTip = parseInt(radio.value, 10) || 0;
      updateTotals(initialTip);
    }

    radio.addEventListener('change', function () {
      var tip = parseInt(radio.value, 10) || 0;
      updateTotals(tip);
      if (window.FoodRush) {
        if (tip > 0) {
          window.FoodRush.showToast('Added ₹' + tip + ' tip for your delivery hero!');
        } else {
          window.FoodRush.showToast('Tip removed');
        }
      }
    });
  });
}

/* --------------------------------------------------------------------------
   3. Payment Method Accordion
   -------------------------------------------------------------------------- */
function initPaymentAccordion() {
  var paymentItems = document.querySelectorAll('.payment-method-item');

  paymentItems.forEach(function (item) {
    var header = item.querySelector('.payment-method-header');
    var radio = item.querySelector('input[type="radio"]');

    if (!header) return;

    header.addEventListener('click', function () {
      paymentItems.forEach(function (p) { p.classList.remove('active'); });
      item.classList.add('active');
      if (radio) radio.checked = true;
    });
  });
}

/* --------------------------------------------------------------------------
   4. Add New Address Modal
   -------------------------------------------------------------------------- */
function initAddAddressModal() {
  var trigger = document.getElementById('btn-add-address-trigger');
  var modal = document.getElementById('add-address-modal');
  var form = modal ? modal.querySelector('form') : null;
  var grid = document.getElementById('address-grid-container');

  if (!trigger || !modal) return;

  trigger.addEventListener('click', function (e) {
    e.preventDefault();
    modal.classList.add('active');
  });

  var closeBtn = modal.querySelector('.modal-close-btn');
  if (closeBtn) {
    closeBtn.addEventListener('click', function () {
      modal.classList.remove('active');
    });
  }

  modal.addEventListener('click', function (e) {
    if (e.target === modal) modal.classList.remove('active');
  });

  if (form && grid) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var labelEl = document.getElementById('new-addr-label');
      var label = (labelEl && labelEl.value) ? labelEl.value : 'Other';
      var detailsEl = document.getElementById('new-addr-details');
      var details = (detailsEl && detailsEl.value) ? detailsEl.value : '';

      if (!details) return;

      var newCard = document.createElement('label');
      newCard.className = 'address-option-card active';
      newCard.style.cursor = 'pointer';
      newCard.innerHTML = 
        '<div style="display: flex; gap: 8px; align-items: flex-start;">' +
          '<input type="radio" name="address" value="' + details.replace(/"/g, '&quot;') + '" checked style="margin-top: 4px;">' +
          '<div>' +
            '<div class="address-type-tag"><i class="fa-solid fa-location-dot"></i> ' + label + '</div>' +
            '<p class="address-details">' + details + '</p>' +
          '</div>' +
        '</div>' +
        '<span class="caption-text font-semibold text-brand"><i class="fa-solid fa-check"></i> Selected for delivery</span>';

      // Deselect existing
      var existing = grid.querySelectorAll('.address-option-card');
      existing.forEach(function (c) {
        c.classList.remove('active');
        var badge = c.querySelector('.caption-text');
        if (badge) {
          badge.className = 'caption-text font-semibold text-light';
          badge.textContent = 'Click to select';
        }
      });

      // Insert before trigger
      grid.insertBefore(newCard, trigger);
      initAddressSelection();

      modal.classList.remove('active');
      form.reset();
      if (window.FoodRush) window.FoodRush.showToast('New delivery address added & selected!');
    });
  }
}

/* --------------------------------------------------------------------------
   5. Razorpay & Checkout Form Submission Handler
   -------------------------------------------------------------------------- */
function initCheckoutSubmission() {
  var form = document.getElementById('checkout-form');
  if (!form) return;

  var btnPlaceOrder = document.getElementById('btn-place-order');
  var hiddenTotalInput = document.getElementById('hidden-total-amount');

  form.addEventListener('submit', function (e) {
    var selectedMethodRadio = form.querySelector('input[name="paymentMethod"]:checked');
    var paymentMethod = selectedMethodRadio ? selectedMethodRadio.value : 'COD';
    var razorpayPaymentIdInput = document.getElementById('razorpay-payment-id');

    // If COD, or if Razorpay payment has already been verified and ID is attached, let form submit naturally
    if (paymentMethod === 'COD' || (razorpayPaymentIdInput && razorpayPaymentIdInput.value)) {
      if (btnPlaceOrder) {
        btnPlaceOrder.disabled = true;
        btnPlaceOrder.innerHTML = '<i class="fa-solid fa-motorcycle"></i> Placing Your Order...';
      }
      return true;
    }

    // Otherwise, online payment via Razorpay (UPI or CARD)
    e.preventDefault();

    if (typeof Razorpay === 'undefined') {
      alert('Razorpay Checkout SDK is still loading. Please check your internet connection or try again in a few seconds.');
      return false;
    }

    // Validate Contact Details & Address
    var contactNameInput = document.getElementById('contact-name');
    var contactPhoneInput = document.getElementById('contact-phone');
    if (contactNameInput && !contactNameInput.value.trim()) {
      if (window.FoodRush && window.FoodRush.showToast) {
        window.FoodRush.showToast('Please enter your contact name', 'warning');
      } else {
        alert('Please enter your contact name');
      }
      contactNameInput.focus();
      return false;
    }
    if (contactPhoneInput && (!contactPhoneInput.value.trim() || !contactPhoneInput.value.trim().match(/^[0-9]{10}$/))) {
      if (window.FoodRush && window.FoodRush.showToast) {
        window.FoodRush.showToast('Please enter a valid 10-digit mobile number', 'warning');
      } else {
        alert('Please enter a valid 10-digit mobile number');
      }
      contactPhoneInput.focus();
      return false;
    }
    var selectedAddress = form.querySelector('input[name="address"]:checked');
    if (!selectedAddress || !selectedAddress.value.trim()) {
      if (window.FoodRush && window.FoodRush.showToast) {
        window.FoodRush.showToast('Please select a delivery address', 'warning');
      } else {
        alert('Please select a delivery address');
      }
      return false;
    }

    var contactName = (contactNameInput && contactNameInput.value) ? contactNameInput.value.trim() : (form.dataset.userName || 'Customer');
    var contactPhone = (contactPhoneInput && contactPhoneInput.value) ? contactPhoneInput.value.trim() : (form.dataset.userPhone || '9876543210');
    var userEmail = form.dataset.userEmail || 'customer@foodrush.com';
    var resName = form.dataset.resName || 'FoodRush Restaurant';
    var razorpayKey = form.dataset.razorpayKey || 'rzp_test_TorDTG5nabgUh5';

    var totalAmount = parseInt(hiddenTotalInput ? hiddenTotalInput.value : '0', 10);
    if (!totalAmount || totalAmount <= 0) {
      var grandTotalEl = document.getElementById('checkout-grand-total');
      if (grandTotalEl) {
        totalAmount = parseInt(grandTotalEl.textContent.replace(/[^\d]/g, ''), 10) || 0;
      }
    }

    var amountInPaise = Math.round(totalAmount * 100);
    var originalBtnText = btnPlaceOrder ? btnPlaceOrder.textContent : 'Place Order';

    if (btnPlaceOrder) {
      btnPlaceOrder.disabled = true;
      btnPlaceOrder.innerHTML = '<i class="fa-solid fa-lock"></i> Connecting to Razorpay...';
    }

    var options = {
      key: razorpayKey,
      amount: amountInPaise,
      currency: 'INR',
      name: 'FoodRush',
      description: 'Order Payment — ' + resName,
      image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=200&auto=format&fit=crop&q=80',
      prefill: {
        name: contactName,
        contact: contactPhone,
        email: userEmail,
        method: paymentMethod === 'UPI' ? 'upi' : 'card'
      },
      theme: {
        color: '#E23744'
      },
      modal: {
        ondismiss: function () {
          if (btnPlaceOrder) {
            btnPlaceOrder.disabled = false;
            btnPlaceOrder.textContent = originalBtnText;
          }
          if (window.FoodRush && window.FoodRush.showToast) {
            window.FoodRush.showToast('Payment window closed. You can retry or choose Cash on Delivery.', 'warning');
          }
        }
      },
      handler: function (response) {
        if (response && response.razorpay_payment_id) {
          if (razorpayPaymentIdInput) {
            razorpayPaymentIdInput.value = response.razorpay_payment_id;
          }
          var orderIdInput = document.getElementById('razorpay-order-id');
          if (orderIdInput && response.razorpay_order_id) {
            orderIdInput.value = response.razorpay_order_id;
          }
          var sigInput = document.getElementById('razorpay-signature');
          if (sigInput && response.razorpay_signature) {
            sigInput.value = response.razorpay_signature;
          }

          if (btnPlaceOrder) {
            btnPlaceOrder.disabled = true;
            btnPlaceOrder.innerHTML = '<i class="fa-solid fa-bolt text-warning"></i> Payment Verified! Placing Order...';
          }

          if (window.FoodRush && window.FoodRush.showToast) {
            window.FoodRush.showToast('Payment Verified (' + response.razorpay_payment_id + ')! Confirming order...', 'success');
          }

          // Trigger submission
          form.submit();
        } else {
          if (btnPlaceOrder) {
            btnPlaceOrder.disabled = false;
            btnPlaceOrder.textContent = originalBtnText;
          }
          alert('Payment was not completed. Please try again.');
        }
      }
    };

    try {
      var rzp = new Razorpay(options);
      rzp.on('payment.failed', function (response) {
        if (btnPlaceOrder) {
          btnPlaceOrder.disabled = false;
          btnPlaceOrder.textContent = originalBtnText;
        }
        var reason = (response.error && response.error.description) ? response.error.description : 'Payment failed';
        if (window.FoodRush && window.FoodRush.showToast) {
          window.FoodRush.showToast('Payment Failed: ' + reason, 'error');
        } else {
          alert('Payment Failed: ' + reason);
        }
      });
      rzp.open();
    } catch (err) {
      console.error('Razorpay open error:', err);
      if (btnPlaceOrder) {
        btnPlaceOrder.disabled = false;
        btnPlaceOrder.textContent = originalBtnText;
      }
      alert('Error launching payment gateway: ' + err.message);
    }
  });
}
