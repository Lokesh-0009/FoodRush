/**
 * FoodRush Auth & Registration Form Validation
 */

document.addEventListener('DOMContentLoaded', () => {
  const registerForm = document.getElementById('register-form') || document.getElementById('register-form-container');
  if (!registerForm) return;

  const passInput = document.getElementById('reg-password');
  const confirmInput = document.getElementById('reg-confirm-password');
  const phoneInput = document.getElementById('reg-phone');

  registerForm.addEventListener('submit', (e) => {
    if (passInput && confirmInput && passInput.value !== confirmInput.value) {
      e.preventDefault();
      if (window.FoodRush) {
        window.FoodRush.showToast('Passwords do not match! Please check.', 'error');
      } else {
        alert('Passwords do not match!');
      }
      confirmInput.focus();
      return;
    }

    if (phoneInput && phoneInput.value.replace(/\D/g, '').length < 10) {
      e.preventDefault();
      if (window.FoodRush) {
        window.FoodRush.showToast('Please enter a valid 10-digit mobile number.', 'error');
      } else {
        alert('Please enter a valid 10-digit mobile number.');
      }
      phoneInput.focus();
    }
  });
});
