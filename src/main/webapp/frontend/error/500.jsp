<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>500 - Server Error | FoodRush</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/variables.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/global.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/frontend/css/components.css">
  <style>
    .error-container {
      min-height: 80vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      text-align: center;
      padding: var(--space-8) var(--space-4);
    }
    .error-badge {
      font-size: var(--font-size-7xl, 5rem);
      font-weight: 900;
      line-height: 1;
      background: linear-gradient(135deg, #e17055, var(--color-primary, #ff4757));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: var(--space-4);
      letter-spacing: -2px;
    }
    .error-title {
      font-size: var(--font-size-3xl, 1.875rem);
      font-weight: 800;
      color: var(--color-text-main, #2d3436);
      margin-bottom: var(--space-3);
    }
    .error-desc {
      font-size: var(--font-size-lg, 1.125rem);
      color: var(--color-text-muted, #636e72);
      max-width: 520px;
      margin-bottom: var(--space-6);
      line-height: 1.6;
    }
    .error-actions {
      display: flex;
      gap: var(--space-4);
      flex-wrap: wrap;
      justify-content: center;
    }
  </style>
</head>
<body>
  <div class="error-container">
    <div class="error-badge">500</div>
    <h1 class="error-title">Our Kitchen Hit a Hiccup</h1>
    <p class="error-desc">
      Something unexpected happened while preparing your request. Our culinary engineering team has been notified.
    </p>
    <div class="error-actions">
      <a href="<%= request.getContextPath() %>/home" class="btn btn-primary">
        Return to Safety
      </a>
      <button onclick="window.location.reload();" class="btn btn-outline">
        Try Again
      </button>
    </div>
  </div>
</body>
</html>
