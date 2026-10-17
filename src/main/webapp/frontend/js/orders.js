/**
 * FoodRush Orders Page Filter Tabs
 */

document.addEventListener('DOMContentLoaded', function () {
  var tabs = document.querySelectorAll('.order-tab-btn');
  var cards = document.querySelectorAll('.order-history-card');
  var filterEmptyState = document.getElementById('orders-filter-empty-state');

  tabs.forEach(function (tab) {
    tab.addEventListener('click', function () {
      tabs.forEach(function (t) { t.classList.remove('active'); });
      tab.classList.add('active');

      var filter = tab.dataset.filter || 'all';
      var visible = 0;

      cards.forEach(function (card) {
        var status = card.dataset.status;
        if (filter === 'all' || status === filter) {
          card.style.display = 'block';
          visible++;
        } else {
          card.style.display = 'none';
        }
      });

      if (filterEmptyState) {
        filterEmptyState.style.display = (visible === 0 && cards.length > 0) ? 'block' : 'none';
      }
    });
  });
});
