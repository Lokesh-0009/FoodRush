/**
 * FoodRush Homepage Interactivity
 */

document.addEventListener('DOMContentLoaded', () => {
  const searchInput = document.getElementById('hero-search-input');
  const searchBtn = document.querySelector('.hero-search-btn');

  function handleSearch() {
    const query = (searchInput && searchInput.value) ? searchInput.value.trim() : '';
    const basePath = window.location.pathname.includes('/JEE') ? '/JEE/restaurants' : 'restaurants';
    if (query) {
      window.location.href = `${basePath}?search=${encodeURIComponent(query)}`;
    } else {
      window.location.href = basePath;
    }
  }

  if (searchBtn) {
    searchBtn.addEventListener('click', (e) => {
      e.preventDefault();
      handleSearch();
    });
  }

  if (searchInput) {
    searchInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        handleSearch();
      }
    });
  }
});
