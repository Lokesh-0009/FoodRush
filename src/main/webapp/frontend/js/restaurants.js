/**
 * FoodRush Restaurant Listing — Swiggy-Style Top Filter & Live Sorting Engine
 */

document.addEventListener('DOMContentLoaded', () => {
  initRestaurantListingEngine();
});

function initRestaurantListingEngine() {
  const grid = document.getElementById('restaurant-grid-container') || document.querySelector('.restaurants-grid-4cols') || document.querySelector('.grid');
  if (!grid) return;

  const cards = Array.from(grid.querySelectorAll('.restaurant-card'));
  const countDisplay = document.getElementById('restaurant-result-count');
  const emptyState = document.getElementById('listing-empty-state');
  const chipsWrap = document.getElementById('active-filter-chips-wrap');
  const searchInput = document.getElementById('listing-search-input');
  const activeFilterBadge = document.getElementById('active-filter-badge');
  const filterModal = document.getElementById('filter-modal');

  // Filter State
  const state = {
    sort: 'default', // default | delivery-asc | rating-desc | price-asc | price-desc
    rushDelivery: false,
    offersOnly: false,
    minRating: 0,
    priceRange: 'all', // all | 0-300 | 300-600 | 600-9999
    dietary: 'all', // all | veg | nonveg
    cuisines: [],
    search: ''
  };

  // 1. Initial State from URL params
  const urlParams = new URLSearchParams(window.location.search);
  const searchParam = urlParams.get('search');
  const cuisineParam = urlParams.get('cuisine');

  if (searchParam && searchInput) {
    searchInput.value = searchParam;
    state.search = searchParam.toLowerCase().trim();
  }
  if (cuisineParam) {
    state.cuisines.push(cuisineParam.toLowerCase().trim());
  }

  // 2. Bind Quick Filter Pills
  initQuickPills();

  // 3. Bind Dropdowns (Sort By & Cuisines)
  initTopDropdowns();

  // 4. Bind Filter Modal (Image 4 Design)
  initFilterModal();

  // 5. Bind Live Search
  if (searchInput) {
    searchInput.addEventListener('input', () => {
      state.search = searchInput.value.toLowerCase().trim();
      applyAllFiltersAndSort();
    });
  }

  // Initial Filter & Sort Run
  applyAllFiltersAndSort();

  /* --------------------------------------------------------------------------
     A. Quick Filter Pills Logic
     -------------------------------------------------------------------------- */
  function initQuickPills() {
    // Rush Delivery Pill
    const rushBtn = document.getElementById('pill-rush-delivery');
    if (rushBtn) {
      rushBtn.addEventListener('click', () => {
        state.rushDelivery = !state.rushDelivery;
        rushBtn.classList.toggle('active', state.rushDelivery);
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    // Offers Pill
    const offersBtn = document.getElementById('pill-offers');
    if (offersBtn) {
      offersBtn.addEventListener('click', () => {
        state.offersOnly = !state.offersOnly;
        offersBtn.classList.toggle('active', state.offersOnly);
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    // Rating 4.0+ Pill
    const rating4Btn = document.getElementById('pill-rating-4');
    if (rating4Btn) {
      rating4Btn.addEventListener('click', () => {
        state.minRating = state.minRating === 4.0 ? 0 : 4.0;
        rating4Btn.classList.toggle('active', state.minRating === 4.0);
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    // Price Rs 300 - Rs 600 Pill
    const priceMidBtn = document.getElementById('pill-price-mid');
    if (priceMidBtn) {
      priceMidBtn.addEventListener('click', () => {
        state.priceRange = state.priceRange === '300-600' ? 'all' : '300-600';
        updatePricePills();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    // Price Less than Rs 300 Pill
    const priceLowBtn = document.getElementById('pill-price-low');
    if (priceLowBtn) {
      priceLowBtn.addEventListener('click', () => {
        state.priceRange = state.priceRange === '0-300' ? 'all' : '0-300';
        updatePricePills();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    // Pure Veg Pill
    const vegBtn = document.getElementById('pill-pure-veg');
    if (vegBtn) {
      vegBtn.addEventListener('click', () => {
        state.dietary = state.dietary === 'veg' ? 'all' : 'veg';
        updateDietaryPills();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    // Non Veg Pill
    const nonVegBtn = document.getElementById('pill-non-veg');
    if (nonVegBtn) {
      nonVegBtn.addEventListener('click', () => {
        state.dietary = state.dietary === 'nonveg' ? 'all' : 'nonveg';
        updateDietaryPills();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }
  }

  function updatePricePills() {
    const mid = document.getElementById('pill-price-mid');
    const low = document.getElementById('pill-price-low');
    if (mid) mid.classList.toggle('active', state.priceRange === '300-600');
    if (low) low.classList.toggle('active', state.priceRange === '0-300');
  }

  function updateDietaryPills() {
    const veg = document.getElementById('pill-pure-veg');
    const nonveg = document.getElementById('pill-non-veg');
    if (veg) veg.classList.toggle('active', state.dietary === 'veg');
    if (nonveg) nonveg.classList.toggle('active', state.dietary === 'nonveg');
  }

  /* --------------------------------------------------------------------------
     B. Top Bar Dropdown Menus
     -------------------------------------------------------------------------- */
  function initTopDropdowns() {
    const sortPillBtn = document.getElementById('sort-pill-btn');
    const sortMenu = document.getElementById('sort-dropdown-menu');
    const cuisinePillBtn = document.getElementById('cuisine-pill-btn');
    const cuisineMenu = document.getElementById('cuisine-dropdown-menu');

    function toggleMenu(menu) {
      const isCurrentlyOpen = menu.style.display === 'flex' || menu.classList.contains('open');
      closeAllDropdowns();
      if (!isCurrentlyOpen) {
        menu.style.display = 'flex';
        menu.classList.add('open');
      }
    }

    function closeAllDropdowns() {
      const menus = document.querySelectorAll('.filter-dropdown-menu');
      menus.forEach(menu => {
        menu.style.display = 'none';
        menu.classList.remove('open');
      });
    }

    // Sort Dropdown
    if (sortPillBtn && sortMenu) {
      sortPillBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        toggleMenu(sortMenu);
      });

      const sortRadios = sortMenu.querySelectorAll('input[name="quick-sort"]');
      sortRadios.forEach(radio => {
        radio.addEventListener('change', () => {
          state.sort = radio.value;
          updateSortLabels();
          closeAllDropdowns();
          syncModalInputs();
          applyAllFiltersAndSort();
        });
      });
    }

    // Cuisines Dropdown
    if (cuisinePillBtn && cuisineMenu) {
      cuisinePillBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        toggleMenu(cuisineMenu);
      });

      const cuisineCheckboxes = cuisineMenu.querySelectorAll('.top-cuisine-checkbox');
      cuisineCheckboxes.forEach(cb => {
        cb.addEventListener('change', () => {
          const val = cb.value.toLowerCase();
          if (cb.checked) {
            if (!state.cuisines.includes(val)) state.cuisines.push(val);
          } else {
            state.cuisines = state.cuisines.filter(c => c !== val);
          }
          cuisinePillBtn.classList.toggle('active', state.cuisines.length > 0);
          syncModalInputs();
          applyAllFiltersAndSort();
        });
      });
    }

    // Close on document click
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.filter-dropdown-wrap')) {
        closeAllDropdowns();
      }
    });
  }

  function updateSortLabels() {
    const sortLabel = document.getElementById('sort-pill-label');
    const sortBtn = document.getElementById('sort-pill-btn');
    const sortMap = {
      'default': 'Sort By',
      'delivery-asc': 'Delivery Time',
      'rating-desc': 'Rating: High to Low',
      'price-asc': 'Cost: Low to High',
      'price-desc': 'Cost: High to Low'
    };

    if (sortLabel) {
      sortLabel.textContent = sortMap[state.sort] || 'Sort By';
    }
    if (sortBtn) {
      sortBtn.classList.toggle('active', state.sort !== 'default');
    }
  }

  /* --------------------------------------------------------------------------
     C. Multi-Tab Filter Modal (Image 4 Implementation)
     -------------------------------------------------------------------------- */
  function initFilterModal() {
    const openBtn = document.getElementById('open-filter-modal-btn');
    const closeBtn = document.getElementById('close-filter-modal-btn');
    const clearBtn = document.getElementById('modal-clear-all-btn');
    const applyBtn = document.getElementById('modal-apply-filters-btn');

    if (!filterModal) return;

    // Open / Close
    if (openBtn) {
      openBtn.addEventListener('click', (e) => {
        e.preventDefault();
        syncModalInputs();
        filterModal.classList.add('active');
      });
    }

    if (closeBtn) {
      closeBtn.addEventListener('click', () => {
        filterModal.classList.remove('active');
      });
    }

    filterModal.addEventListener('click', (e) => {
      if (e.target === filterModal) {
        filterModal.classList.remove('active');
      }
    });

    // Tab Switching inside Modal
    const tabLinks = filterModal.querySelectorAll('.filter-tab-link');
    const tabPanes = filterModal.querySelectorAll('.filter-tab-pane');

    tabLinks.forEach(tab => {
      tab.addEventListener('click', () => {
        const targetId = tab.getAttribute('data-target-tab');

        tabLinks.forEach(t => t.classList.remove('active'));
        tabPanes.forEach(p => p.classList.remove('active'));

        tab.classList.add('active');
        const targetPane = document.getElementById(targetId);
        if (targetPane) targetPane.classList.add('active');
      });
    });

    // Clear All inside Modal
    if (clearBtn) {
      clearBtn.addEventListener('click', () => {
        resetAllFilters();
        syncModalInputs();
        applyAllFiltersAndSort();
        filterModal.classList.remove('active');
      });
    }

    // Apply Button inside Modal
    if (applyBtn) {
      applyBtn.addEventListener('click', () => {
        // Read Sort
        const sortRadio = filterModal.querySelector('input[name="modal-sort"]:checked');
        if (sortRadio) state.sort = sortRadio.value;

        // Read Delivery
        const delRadio = filterModal.querySelector('input[name="modal-delivery"]:checked');
        state.rushDelivery = delRadio && delRadio.value === '25';

        // Read Offers
        const offerToggle = document.getElementById('modal-offers-toggle');
        state.offersOnly = offerToggle ? offerToggle.checked : false;

        // Read Rating
        const ratingRadio = filterModal.querySelector('input[name="modal-rating"]:checked');
        state.minRating = ratingRadio ? parseFloat(ratingRadio.value) : 0;

        // Read Cost
        const costRadio = filterModal.querySelector('input[name="modal-cost"]:checked');
        state.priceRange = costRadio ? costRadio.value : 'all';

        // Read Diet
        const dietRadio = filterModal.querySelector('input[name="modal-diet"]:checked');
        state.dietary = dietRadio ? dietRadio.value : 'all';

        // Read Cuisines
        const cuisineCheckboxes = filterModal.querySelectorAll('.modal-cuisine-checkbox:checked');
        state.cuisines = Array.from(cuisineCheckboxes).map(cb => cb.value.toLowerCase());

        // Sync pills
        syncPillsToState();
        filterModal.classList.remove('active');
        applyAllFiltersAndSort();
      });
    }
  }

  function syncModalInputs() {
    if (!filterModal) return;

    // Sort
    const sortRadio = filterModal.querySelector(`input[name="modal-sort"][value="${state.sort}"]`);
    if (sortRadio) sortRadio.checked = true;

    // Delivery
    const delVal = state.rushDelivery ? '25' : '999';
    const delRadio = filterModal.querySelector(`input[name="modal-delivery"][value="${delVal}"]`);
    if (delRadio) delRadio.checked = true;

    // Offers
    const offerToggle = document.getElementById('modal-offers-toggle');
    if (offerToggle) offerToggle.checked = state.offersOnly;

    // Rating
    const ratingRadio = filterModal.querySelector(`input[name="modal-rating"][value="${state.minRating}"]`);
    if (ratingRadio) ratingRadio.checked = true;

    // Cost
    const costRadio = filterModal.querySelector(`input[name="modal-cost"][value="${state.priceRange}"]`);
    if (costRadio) costRadio.checked = true;

    // Diet
    const dietRadio = filterModal.querySelector(`input[name="modal-diet"][value="${state.dietary}"]`);
    if (dietRadio) dietRadio.checked = true;

    // Cuisines in Modal
    const modalCuisineCbs = filterModal.querySelectorAll('.modal-cuisine-checkbox');
    modalCuisineCbs.forEach(cb => {
      cb.checked = state.cuisines.includes(cb.value.toLowerCase());
    });

    // Cuisines in Top Dropdown
    const topCuisineCbs = document.querySelectorAll('.top-cuisine-checkbox');
    topCuisineCbs.forEach(cb => {
      cb.checked = state.cuisines.includes(cb.value.toLowerCase());
    });

    // Sort in Top Dropdown
    const topSortRadio = document.querySelector(`input[name="quick-sort"][value="${state.sort}"]`);
    if (topSortRadio) topSortRadio.checked = true;
  }

  function syncPillsToState() {
    const rushBtn = document.getElementById('pill-rush-delivery');
    const offersBtn = document.getElementById('pill-offers');
    const rating4Btn = document.getElementById('pill-rating-4');
    const cuisinePillBtn = document.getElementById('cuisine-pill-btn');

    if (rushBtn) rushBtn.classList.toggle('active', state.rushDelivery);
    if (offersBtn) offersBtn.classList.toggle('active', state.offersOnly);
    if (rating4Btn) rating4Btn.classList.toggle('active', state.minRating >= 4.0);
    if (cuisinePillBtn) cuisinePillBtn.classList.toggle('active', state.cuisines.length > 0);

    updatePricePills();
    updateDietaryPills();
    updateSortLabels();
  }

  function resetAllFilters() {
    state.sort = 'default';
    state.rushDelivery = false;
    state.offersOnly = false;
    state.minRating = 0;
    state.priceRange = 'all';
    state.dietary = 'all';
    state.cuisines = [];
    state.search = '';
    if (searchInput) searchInput.value = '';
    syncPillsToState();
  }

  /* --------------------------------------------------------------------------
     D. Filter & Sort Execution Engine
     -------------------------------------------------------------------------- */
  function applyAllFiltersAndSort() {
    let visibleCount = 0;

    cards.forEach(card => {
      const titleEl = card.querySelector('.card-title');
      const cuisineEl = card.querySelector('.card-cuisine');
      const ratingEl = card.querySelector('.badge-rating');
      const etaEl = card.querySelector('.card-eta');
      const priceEl = card.querySelector('.card-price-two');

      const name = (card.dataset.name || (titleEl ? titleEl.textContent : '') || '').toLowerCase();
      const cuisine = (card.dataset.cuisine || (cuisineEl ? cuisineEl.textContent : '') || '').toLowerCase();
      const ratingText = (ratingEl && ratingEl.textContent) ? ratingEl.textContent.replace(/[^0-9.]/g, '') : '0';
      const rating = parseFloat(card.dataset.rating || ratingText || '0');
      const etaText = (etaEl && etaEl.textContent) ? etaEl.textContent.replace(/[^0-9]/g, '') : '30';
      const delivery = parseInt(card.dataset.deliveryTime || etaText || '30', 10);
      const priceText = (priceEl && priceEl.textContent) ? priceEl.textContent.replace(/[^0-9]/g, '') : '300';
      const price = parseInt(card.dataset.price || priceText || '300', 10);
      const isVeg = card.dataset.veg === 'true' || cuisine.includes('pure veg') || cuisine.includes('veg');

      // 1. Search filter
      const matchesSearch = !state.search || name.includes(state.search) || cuisine.includes(state.search);

      // 2. Rush Delivery (<= 30 mins)
      const matchesDelivery = !state.rushDelivery || delivery <= 30;

      // 3. Offers
      const hasOffer = card.querySelector('.badge-offer') !== null || card.dataset.offer === 'true';
      const matchesOffers = !state.offersOnly || hasOffer;

      // 4. Rating filter
      const matchesRating = state.minRating === 0 || rating >= state.minRating;

      // 5. Dietary filter
      let matchesDiet = true;
      if (state.dietary === 'veg') matchesDiet = isVeg;
      else if (state.dietary === 'nonveg') matchesDiet = !isVeg;

      // 6. Price Range filter
      let matchesPrice = true;
      if (state.priceRange === '0-300') matchesPrice = price <= 300;
      else if (state.priceRange === '300-600') matchesPrice = price >= 300 && price <= 600;
      else if (state.priceRange === '600-9999') matchesPrice = price >= 600;

      // 7. Cuisines filter
      const matchesCuisine = state.cuisines.length === 0 || state.cuisines.some(c => cuisine.includes(c));

      if (matchesSearch && matchesDelivery && matchesOffers && matchesRating && matchesDiet && matchesPrice && matchesCuisine) {
        card.style.setProperty('display', 'flex', 'important');
        card.classList.remove('is-hidden');
        visibleCount++;
      } else {
        card.style.setProperty('display', 'none', 'important');
        card.classList.add('is-hidden');
      }
    });

    // Sort visible cards
    const visibleCards = cards.filter(c => !c.classList.contains('is-hidden') && c.style.display !== 'none');

    visibleCards.sort((a, b) => {
      const aTitleEl = a.querySelector('.card-title');
      const bTitleEl = b.querySelector('.card-title');
      const aCuisineEl = a.querySelector('.card-cuisine');
      const bCuisineEl = b.querySelector('.card-cuisine');

      const aTitle = (a.dataset.name || (aTitleEl ? aTitleEl.textContent : '') || '').toLowerCase().trim();
      const bTitle = (b.dataset.name || (bTitleEl ? bTitleEl.textContent : '') || '').toLowerCase().trim();
      const aCuisine = (a.dataset.cuisine || (aCuisineEl ? aCuisineEl.textContent : '') || '').toLowerCase().trim();
      const bCuisine = (b.dataset.cuisine || (bCuisineEl ? bCuisineEl.textContent : '') || '').toLowerCase().trim();

      // 1. Prioritize Search Relevance if user entered a search query
      if (state.search) {
        const query = state.search.toLowerCase().trim();
        const getScore = (title, cuisine) => {
          if (title === query) return 100;                 // Exact Name Match
          if (title.startsWith(query)) return 80;          // Name Starts With Query
          if (title.includes(query)) return 60;            // Name Contains Query
          if (cuisine.startsWith(query)) return 40;        // Cuisine Starts With Query
          if (cuisine.includes(query)) return 20;          // Cuisine Contains Query
          return 0;
        };

        const scoreA = getScore(aTitle, aCuisine);
        const scoreB = getScore(bTitle, bCuisine);

        if (scoreA !== scoreB) {
          return scoreB - scoreA; // Higher relevance score comes first (on top)
        }
      }

      // 2. Secondary Filter Sorting
      const aRatingEl = a.querySelector('.badge-rating');
      const bRatingEl = b.querySelector('.badge-rating');
      const aEtaEl = a.querySelector('.card-eta');
      const bEtaEl = b.querySelector('.card-eta');
      const aPriceEl = a.querySelector('.card-price-two');
      const bPriceEl = b.querySelector('.card-price-two');

      const aRatingText = (aRatingEl && aRatingEl.textContent) ? aRatingEl.textContent.replace(/[^0-9.]/g, '') : '0';
      const bRatingText = (bRatingEl && bRatingEl.textContent) ? bRatingEl.textContent.replace(/[^0-9.]/g, '') : '0';
      const ratingA = parseFloat(a.dataset.rating || aRatingText || '0');
      const ratingB = parseFloat(b.dataset.rating || bRatingText || '0');

      const aEtaText = (aEtaEl && aEtaEl.textContent) ? aEtaEl.textContent.replace(/[^0-9]/g, '') : '30';
      const bEtaText = (bEtaEl && bEtaEl.textContent) ? bEtaEl.textContent.replace(/[^0-9]/g, '') : '30';
      const delA = parseInt(a.dataset.deliveryTime || aEtaText || '30', 10);
      const delB = parseInt(b.dataset.deliveryTime || bEtaText || '30', 10);

      const aPriceText = (aPriceEl && aPriceEl.textContent) ? aPriceEl.textContent.replace(/[^0-9]/g, '') : '300';
      const bPriceText = (bPriceEl && bPriceEl.textContent) ? bPriceEl.textContent.replace(/[^0-9]/g, '') : '300';
      const priceA = parseInt(a.dataset.price || aPriceText || '300', 10);
      const priceB = parseInt(b.dataset.price || bPriceText || '300', 10);

      if (state.sort === 'rating-desc') return ratingB - ratingA;
      if (state.sort === 'delivery-asc') return delA - delB;
      if (state.sort === 'price-asc') return priceA - priceB;
      if (state.sort === 'price-desc') return priceB - priceA;
      return 0;
    });

    // Reorder DOM nodes: matching cards first, then hidden cards
    visibleCards.forEach(c => grid.appendChild(c));
    cards.filter(c => c.classList.contains('is-hidden')).forEach(c => grid.appendChild(c));

    // Update Result Count
    if (countDisplay) {
      countDisplay.textContent = `Showing ${visibleCount} restaurant${visibleCount === 1 ? '' : 's'}`;
    }

    // Toggle Empty State
    if (emptyState) {
      emptyState.classList.toggle('visible', visibleCount === 0);
    }

    // Update Filter Active Badge
    updateActiveFilterCount();

    // Render Active Chips
    renderFilterChips();
  }

  function updateActiveFilterCount() {
    let count = 0;
    if (state.sort !== 'default') count++;
    if (state.rushDelivery) count++;
    if (state.offersOnly) count++;
    if (state.minRating > 0) count++;
    if (state.priceRange !== 'all') count++;
    if (state.dietary !== 'all') count++;
    if (state.cuisines.length > 0) count += state.cuisines.length;

    const mainBtn = document.getElementById('open-filter-modal-btn');
    if (activeFilterBadge) {
      if (count > 0) {
        activeFilterBadge.textContent = count;
        activeFilterBadge.classList.add('visible');
      } else {
        activeFilterBadge.classList.remove('visible');
      }
    }
    if (mainBtn) {
      mainBtn.classList.toggle('active', count > 0);
    }
  }

  function renderFilterChips() {
    if (!chipsWrap) return;
    chipsWrap.innerHTML = '';

    let hasChips = false;

    if (state.search) {
      hasChips = true;
      addChip(`Search: "${state.search}"`, () => {
        state.search = '';
        if (searchInput) searchInput.value = '';
        applyAllFiltersAndSort();
      });
    }

    if (state.sort !== 'default') {
      hasChips = true;
      const sortMap = {
        'delivery-asc': 'Fastest Delivery',
        'rating-desc': 'Top Rated',
        'price-asc': 'Cost: Low to High',
        'price-desc': 'Cost: High to Low'
      };
      addChip(`Sort: ${sortMap[state.sort]}`, () => {
        state.sort = 'default';
        updateSortLabels();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    if (state.rushDelivery) {
      hasChips = true;
      addChip('<i class="fa-solid fa-bolt-lightning text-warning"></i> Rush Delivery', () => {
        state.rushDelivery = false;
        syncPillsToState();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    if (state.offersOnly) {
      hasChips = true;
      addChip('Offers & Discounts', () => {
        state.offersOnly = false;
        syncPillsToState();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    if (state.minRating > 0) {
      hasChips = true;
      addChip(`Rating: ${state.minRating}+ <i class="fa-solid fa-star text-warning"></i>`, () => {
        state.minRating = 0;
        syncPillsToState();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    if (state.priceRange !== 'all') {
      hasChips = true;
      const priceMap = {
        '0-300': 'Less than ₹300',
        '300-600': '₹300 - ₹600',
        '600-9999': 'Above ₹600'
      };
      addChip(priceMap[state.priceRange] || state.priceRange, () => {
        state.priceRange = 'all';
        syncPillsToState();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    if (state.dietary === 'veg') {
      hasChips = true;
      addChip('<i class="fa-solid fa-leaf text-success"></i> Pure Veg Only', () => {
        state.dietary = 'all';
        syncPillsToState();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    } else if (state.dietary === 'nonveg') {
      hasChips = true;
      addChip('<i class="fa-solid fa-drumstick-bite text-brand"></i> Non-Veg Only', () => {
        state.dietary = 'all';
        syncPillsToState();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    }

    state.cuisines.forEach(c => {
      hasChips = true;
      addChip(c.charAt(0).toUpperCase() + c.slice(1), () => {
        state.cuisines = state.cuisines.filter(item => item !== c);
        syncPillsToState();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
    });

    if (hasChips) {
      const clearBtn = document.createElement('button');
      clearBtn.type = 'button';
      clearBtn.className = 'clear-all-btn';
      clearBtn.textContent = 'Reset All';
      clearBtn.addEventListener('click', () => {
        resetAllFilters();
        syncModalInputs();
        applyAllFiltersAndSort();
      });
      chipsWrap.appendChild(clearBtn);
    }
  }

  function addChip(label, onRemove) {
    const chip = document.createElement('span');
    chip.className = 'filter-chip';
    chip.innerHTML = `<span>${label}</span> <span class="filter-chip-remove" role="button" aria-label="Remove filter"><i class="fa-solid fa-xmark"></i></span>`;
    chip.querySelector('.filter-chip-remove').addEventListener('click', onRemove);
    chipsWrap.appendChild(chip);
  }
}
