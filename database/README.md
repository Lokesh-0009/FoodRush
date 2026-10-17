# FoodRush Database Scripts

This folder contains the database setup and seed scripts for MySQL.

### Files
1. **`foodrush_schema.sql`**:
   - Contains the DDL statements (`CREATE DATABASE`, `CREATE TABLE`, foreign keys, and indexes).
   - Use this on a fresh MySQL instance to create the database structure (`foodrush_db`).

2. **`foodrush_seed_data.sql`**:
   - Contains sample data for initial testing:
     - 30 sample users (including admin and customer accounts).
     - 30 sample restaurants across categories and cities.
     - 330 sample menu items with image links and categories.

### How to Import via MySQL CLI
```bash
mysql -u root -p < database/foodrush_schema.sql
mysql -u root -p < database/foodrush_seed_data.sql
```

> **Note:** The running Java EE application connects directly to MySQL via JDBC (`com.foodRush.util.DBConnection`). These files are not read at runtime and serve as setup/backup scripts.
