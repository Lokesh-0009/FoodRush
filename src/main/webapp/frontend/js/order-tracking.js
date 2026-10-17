/**
 * FoodRush Live Order Tracking & Real-Time GPS Map Navigation Engine
 * Powered by Leaflet.js and OpenStreetMap / CartoDB tiles
 */

document.addEventListener('DOMContentLoaded', function () {
  initLiveDeliveryMap();
  initCancelModal();
  initConfirmationTick();
});

/**
 * Initializes interactive Leaflet map with animated delivery rider marker and route polyline
 */
function initLiveDeliveryMap() {
  var mapElement = document.getElementById('live-delivery-map');
  if (!mapElement) return;

  // If Leaflet is not yet loaded, wait briefly and retry
  if (typeof L === 'undefined') {
    setTimeout(initLiveDeliveryMap, 300);
    return;
  }

  // Real-world GPS Coordinates in Bangalore, India
  // Point A: Restaurant in Koramangala 5th Block
  var restaurantCoord = [12.9352, 77.6245];
  // Point B: Customer Destination in Indiranagar / Domlur
  var destinationCoord = [12.9634, 77.6385];

  // Realistic intermediate road GPS waypoints along Intermediate Ring Road
  var routeWaypoints = [
    [12.9352, 77.6245], // Koramangala 5th Block (Kitchen)
    [12.9385, 77.6268], // Sony World Signal
    [12.9430, 77.6300], // Ejipura Inner Ring Road
    [12.9482, 77.6335], // Intermediate Ring Road Flyover
    [12.9530, 77.6358], // Domlur Club Road
    [12.9580, 77.6372], // Indiranagar 100ft Road Entry
    [12.9610, 77.6380], // 12th Main Road Junction
    [12.9634, 77.6385]  // Customer Doorstep
  ];

  // Initialize Leaflet Map centered between points
  var mapCenter = [
    (restaurantCoord[0] + destinationCoord[0]) / 2,
    (restaurantCoord[1] + destinationCoord[1]) / 2
  ];

  var map = L.map('live-delivery-map', {
    center: mapCenter,
    zoom: 14,
    zoomControl: false,
    attributionControl: false
  });

  // Custom Zoom Control placed on bottom-left to avoid HUD overlap
  L.control.zoom({ position: 'bottomleft' }).addTo(map);

  // CartoDB & OpenStreetMap Tile Layers
  var lightTiles = L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {
    maxZoom: 19,
    subdomains: 'abcd'
  });

  var darkTiles = L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
    maxZoom: 19,
    subdomains: 'abcd'
  });

  var osmFallback = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19
  });

  // Check current theme and add corresponding layer
  var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
  var activeTileLayer = isDark ? darkTiles : lightTiles;
  activeTileLayer.addTo(map);

  // Invalidate map size so it renders full dimensions immediately
  setTimeout(function () {
    map.invalidateSize();
  }, 250);
  setTimeout(function () {
    map.invalidateSize();
  }, 800);
  window.addEventListener('resize', function () {
    map.invalidateSize();
  });

  // Theme change observer to dynamically switch map tiles
  var themeObserver = new MutationObserver(function (mutations) {
    mutations.forEach(function (mutation) {
      if (mutation.attributeName === 'data-theme') {
        var currentDark = document.documentElement.getAttribute('data-theme') === 'dark';
        if (currentDark) {
          if (map.hasLayer(lightTiles)) map.removeLayer(lightTiles);
          darkTiles.addTo(map);
        } else {
          if (map.hasLayer(darkTiles)) map.removeLayer(darkTiles);
          lightTiles.addTo(map);
        }
      }
    });
  });
  themeObserver.observe(document.documentElement, { attributes: true });

  // Custom Icons with HTML DivIcons
  var restaurantIcon = L.divIcon({
    className: 'custom-map-pin-container',
    html: '<div class="custom-map-pin restaurant-pin" title="Restaurant Kitchen" style="width:38px;height:38px;border-radius:50%;background:#E50914;border:2.5px solid #fff;display:flex;align-items:center;justify-content:center;color:#fff;font-size:16px;box-shadow:0 4px 14px rgba(229,9,20,0.45);"><i class="fa-solid fa-utensils"></i></div>',
    iconSize: [38, 38],
    iconAnchor: [19, 19],
    popupAnchor: [0, -20]
  });

  var destinationIcon = L.divIcon({
    className: 'custom-map-pin-container',
    html: '<div class="custom-map-pin customer-pin" title="Delivery Address" style="width:38px;height:38px;border-radius:50%;background:#10B981;border:2.5px solid #fff;display:flex;align-items:center;justify-content:center;color:#fff;font-size:16px;box-shadow:0 4px 14px rgba(0,0,0,0.35);"><i class="fa-solid fa-house"></i></div>',
    iconSize: [38, 38],
    iconAnchor: [19, 19],
    popupAnchor: [0, -20]
  });

  var scooterIcon = L.divIcon({
    className: 'custom-map-pin-container',
    html: '<div class="scooter-pin-wrapper" style="position:relative;display:flex;align-items:center;justify-content:center;">' +
            '<span class="rider-nametag" style="position:absolute;top:-22px;left:50%;transform:translateX(-50%);background:#180306;color:#fff;font-size:10px;font-weight:800;padding:2px 6px;border-radius:4px;white-space:nowrap;border:1px solid #E50914;box-shadow:0 2px 6px rgba(0,0,0,0.4);"><i class="fa-solid fa-bolt text-warning"></i> Ramesh (EV)</span>' +
            '<div class="scooter-pin" style="width:42px;height:42px;background:linear-gradient(135deg,#180306,#0A0708);border:2.5px solid #FF1E42;border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-size:18px;box-shadow:0 4px 16px rgba(229,9,20,0.55);"><i class="fa-solid fa-motorcycle"></i></div>' +
          '</div>',
    iconSize: [42, 42],
    iconAnchor: [21, 21],
    popupAnchor: [0, -24]
  });

  // Add Restaurant Marker
  var resMarker = L.marker(restaurantCoord, { icon: restaurantIcon }).addTo(map);
  resMarker.bindPopup('<strong><i class="fa-solid fa-utensils text-brand"></i> Restaurant</strong><br>Food is fresh & packed');

  // Add Customer Destination Marker
  var destMarker = L.marker(destinationCoord, { icon: destinationIcon }).addTo(map);
  destMarker.bindPopup('<strong><i class="fa-solid fa-house text-success"></i> Delivery Location</strong><br>Your delivery doorstep');

  // Draw Full Planned Route Polyline (Glowing FoodRush Red)
  var plannedRouteLine = L.polyline(routeWaypoints, {
    color: '#E50914',
    weight: 5,
    opacity: 0.85,
    lineCap: 'round',
    lineJoin: 'round',
    dashArray: '6, 8'
  }).addTo(map);

  // Draw Traversed Route Polyline (Solid Green-Red)
  var traversedRouteLine = L.polyline([routeWaypoints[0]], {
    color: '#22C55E',
    weight: 6,
    opacity: 0.9,
    lineCap: 'round',
    lineJoin: 'round'
  }).addTo(map);

  // Fit map bounds to encompass the full route with padding
  map.fitBounds(plannedRouteLine.getBounds(), { padding: [40, 40] });

  // Add Animated Delivery Scooter Marker starting at 2nd waypoint
  var currentWaypointIndex = 2; // Rider already on the road
  var currentRiderPosition = routeWaypoints[currentWaypointIndex];

  var riderMarker = L.marker(currentRiderPosition, { icon: scooterIcon }).addTo(map);
  riderMarker.bindPopup('<strong><i class="fa-solid fa-motorcycle text-brand"></i> Ramesh Kumar</strong><br>Speed: 28 km/h • On the way');

  // Update Traversed Polyline initially
  traversedRouteLine.setLatLngs(routeWaypoints.slice(0, currentWaypointIndex + 1));

  // Telemetry HUD Elements
  var hudSpeed = document.getElementById('hud-speed');
  var hudDistance = document.getElementById('hud-distance');
  var etaPill = document.getElementById('map-live-eta-pill');

  // Rider Continuous Live Movement Simulation
  var totalPoints = routeWaypoints.length;
  var forwardDirection = true;

  var movementTimer = setInterval(function () {
    if (forwardDirection) {
      currentWaypointIndex++;
      if (currentWaypointIndex >= totalPoints - 1) {
        currentWaypointIndex = totalPoints - 1;
        forwardDirection = false; // Loop back for continuous live demo
      }
    } else {
      currentWaypointIndex--;
      if (currentWaypointIndex <= 1) {
        currentWaypointIndex = 1;
        forwardDirection = true;
      }
    }

    var nextPos = routeWaypoints[currentWaypointIndex];
    riderMarker.setLatLng(nextPos);

    // Update covered polyline
    traversedRouteLine.setLatLngs(routeWaypoints.slice(0, currentWaypointIndex + 1));

    // Dynamic HUD Calculations
    var remainingPoints = totalPoints - 1 - currentWaypointIndex;
    var estKm = Math.max(0.4, (remainingPoints * 0.45)).toFixed(1);
    var estMins = Math.max(3, Math.round(remainingPoints * 3.5));
    var randomSpeed = Math.floor(24 + Math.random() * 10);

    if (hudSpeed) hudSpeed.textContent = randomSpeed + ' km/h';
    if (hudDistance) hudDistance.textContent = estKm + ' km';
    if (etaPill) {
      if (currentWaypointIndex >= totalPoints - 1) {
        etaPill.innerHTML = '<i class="fa-solid fa-circle-check text-success"></i> Arriving at Doorstep!';
        etaPill.style.background = '#ECFDF5';
        etaPill.style.color = '#059669';
        etaPill.style.borderColor = '#A7F3D0';
      } else {
        etaPill.innerHTML = '<i class="fa-solid fa-bolt-lightning text-primary"></i> Express Transit (~' + estMins + ' mins)';
      }
    }
  }, 3200);

  // Recenter Button Action
  var recenterBtn = document.getElementById('map-recenter-btn');
  if (recenterBtn) {
    recenterBtn.addEventListener('click', function () {
      map.panTo(riderMarker.getLatLng(), { animate: true, duration: 0.8 });
      if (window.FoodRush) window.FoodRush.showToast('Recentered on delivery partner', 'info');
    });
  }
}

/**
 * Order Cancellation modal confirmation dialog
 */
function initCancelModal() {
  var wrapper = document.getElementById('cancel-grace-wrapper');
  var cancelBtn = document.getElementById('btn-cancel-order');
  var modal = document.getElementById('cancel-confirm-modal');
  var countdownDisplay = document.getElementById('grace-countdown-display');
  var btnTimerText = document.getElementById('cancel-timer-btn-text');
  var modalCountdown = document.getElementById('modal-grace-countdown');
  var lockedPill = document.getElementById('cancellation-locked-pill');
  var timerBadge = document.getElementById('grace-timer-badge');

  if (!wrapper) return;

  var remaining = parseInt(wrapper.getAttribute('data-remaining') || '0', 10);

  function formatTimer(sec) {
    var s = sec < 10 ? '0' + sec : '' + sec;
    return '00:' + s;
  }

  // Live countdown timer
  if (remaining > 0 && cancelBtn) {
    var timerInterval = setInterval(function () {
      remaining--;
      if (countdownDisplay) countdownDisplay.textContent = formatTimer(remaining);
      if (btnTimerText) btnTimerText.textContent = remaining + 's';
      if (modalCountdown) modalCountdown.textContent = formatTimer(remaining);

      if (remaining <= 0) {
        clearInterval(timerInterval);
        // Grace period expired!
        if (cancelBtn) cancelBtn.style.display = 'none';
        if (timerBadge) timerBadge.style.display = 'none';
        if (lockedPill) lockedPill.style.display = 'flex';
        if (modal && modal.classList.contains('active')) {
          modal.classList.remove('active');
          if (window.FoodRush && window.FoodRush.showToast) {
            window.FoodRush.showToast('Cancellation window has closed. Kitchen has started cooking!', 'info');
          }
        }
      }
    }, 1000);
  }

  if (cancelBtn && modal) {
    cancelBtn.addEventListener('click', function () {
      if (remaining <= 0) {
        if (window.FoodRush && window.FoodRush.showToast) {
          window.FoodRush.showToast('Cancellation period has expired.', 'warning');
        }
        return;
      }
      modal.classList.add('active');
    });

    var closeBtn = modal.querySelector('.modal-close-btn');
    var keepBtn = modal.querySelector('.btn-secondary');

    [closeBtn, keepBtn].forEach(function (b) {
      if (b) {
        b.addEventListener('click', function () { modal.classList.remove('active'); });
      }
    });

    modal.addEventListener('click', function (e) {
      if (e.target === modal) modal.classList.remove('active');
    });
  }
}

/**
 * Interactive Click-to-Replay for Dynamic Confirmation Tick Animation
 */
function initConfirmationTick() {
  var tickEl = document.getElementById('dynamic-confirmation-tick');
  if (!tickEl) return;

  tickEl.addEventListener('click', function () {
    var svg = tickEl.querySelector('.tick-animated-svg');
    var circle = tickEl.querySelector('.tick-circle');
    var check = tickEl.querySelector('.tick-check');
    var aura = tickEl.querySelector('.tick-ripple-aura');
    var sparks = tickEl.querySelectorAll('.tick-spark');

    // Reset animations
    tickEl.style.animation = 'none';
    if (circle) circle.style.animation = 'none';
    if (check) check.style.animation = 'none';
    if (aura) aura.style.animation = 'none';
    sparks.forEach(function (s) { s.style.animation = 'none'; });

    // Force DOM reflow
    void tickEl.offsetWidth;

    // Restart animations
    tickEl.style.animation = '';
    if (circle) circle.style.animation = '';
    if (check) check.style.animation = '';
    if (aura) aura.style.animation = '';
    sparks.forEach(function (s) { s.style.animation = ''; });
  });
}

