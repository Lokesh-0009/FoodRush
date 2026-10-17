# FoodRush 

> **A Full-Stack Online Food Ordering & Delivery Management Platform built with Java EE (Servlets & JSP), Modern Vanilla CSS Design System, MySQL, and BCrypt Authentication.**

---

## Key Features

- **Customer Experience:**
  - Dynamic Restaurant & Menu Explorer with search and category filters.
  - Interactive Shopping Cart with item counters, subtotal calculations, and conflict resolution.
  - Multi-tab Checkout with order confirmation and live delivery tracking.
  - Profile Management, order history, and instant password toggle reveal.
  - Automated 6-digit OTP Password Recovery via Gmail SMTP.

- **Driver Delivery Portal:**
  - Dedicated delivery rider dashboard (`/driver/dashboard`).
  - Active delivery queue management with real-time status transitions (*Accepted -> Picked Up -> Out for Delivery -> Delivered*).
  - Earnings overview, delivery history, and live customer contact details.

- **Admin Operations Suite:**
  - Comprehensive business analytics with sales volume, average order value, and order status counts.
  - Full CRUD management for Restaurants, Menus, Dishes, and Users.
  - Real-time order dispatch and assignment to available drivers.

- **Security & Reliability:**
  - Secure **BCrypt password hashing** (salt rounds: 12) for all user accounts.
  - Protected role-based authorization filters (`CUSTOMER`, `DRIVER`, `ADMIN`).
  - Native browser reveal suppression for consistent password visibility toggling.
  - Clean separation of sensitive configuration through environment properties.

---

## Technology Stack

| Layer | Technology |
| :--- | :--- |
| **Backend** | Java 21, Jakarta Servlet 5.0 / 6.0, Jakarta Mail 2.0.1, jBCrypt 0.4 |
| **Frontend** | JSP, Modern Vanilla CSS3 (Custom Design System, Dark/Light Mode), FontAwesome 6 |
| **Database** | MySQL 8.0+ / 9.0 (InnoDB, Foreign Key Constraints, Transactions) |
| **Server** | Apache Tomcat 10.1+ (Jakarta EE Namespace) |
| **IDE** | Eclipse IDE for Enterprise Java and Web Developers |

---

## Project Structure

```text
JEE/
├── database/
│   ├── foodrush_schema.sql         # Database schema (tables & constraints)
│   ├── foodrush_seed_data.sql       # Initial seed data (restaurants, menus, users)
│   ├── add_driver_support.sql       # Driver migration schema & sample partners
│   └── README.md                    # Database setup instructions
├── src/
│   └── main/
│       ├── java/com/foodRush/
│       │   ├── controller/          # Servlets (Home, Menu, Cart, Checkout, Driver, Admin, etc.)
│       │   ├── DAO/ & DAOImpl/      # Data Access Objects (User, Order, Menu, Restaurant, Driver)
│       │   ├── model/               # Entity models (User, Orders, OrderItem, Menu, Cart, Driver)
│       │   └── util/                # DBConnection, EmailService, BCrypt utilities
│       ├── resources/
│       │   ├── db.properties.example    # Database config template
│       │   └── email.properties.example # SMTP email config template
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml          # Servlet mappings & deployment descriptor
│           │   └── lib/             # Required JAR dependencies
│           └── frontend/            # Responsive JSPs, CSS stylesheets, and JavaScript
├── .gitignore                       # Ignored build outputs and sensitive secrets
└── README.md
```

---

## Getting Started

### 1. Database Setup
1. Ensure **MySQL Server 8.0+** is running locally.
2. Open your MySQL client (MySQL Workbench, HeidiSQL, or CLI):
   ```sql
   CREATE DATABASE foodrush_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE foodrush_db;
   SOURCE database/foodrush_schema.sql;
   SOURCE database/foodrush_seed_data.sql;
   SOURCE database/add_driver_support.sql;
   ```

### 2. Configuration
1. Copy the database configuration template:
   ```bash
   cp src/main/resources/db.properties.example src/main/resources/db.properties
   ```
   Update `db.url`, `db.user`, and `db.password` with your MySQL credentials.

2. *(Optional)* Configure real SMTP email delivery for OTP verification:
   ```bash
   cp src/main/resources/email.properties.example src/main/resources/email.properties
   ```
   Add your Gmail address and 16-character Google App Password.

### 3. Running in Eclipse & Tomcat
1. Open **Eclipse IDE for Enterprise Java**.
2. Go to **File -> Import... -> General -> Existing Projects into Workspace** and select this directory.
3. Configure **Apache Tomcat 10.1+** as the runtime environment in **Server runtime environments**.
4. Right-click the project -> **Run As -> Run on Server**.
5. Access the application in your browser:
   ```text
   http://localhost:8080/JEE/home
   ```

---

## Demo Credentials (1-Click Fill Available on Login)

| Role | Email | Password | Destination |
| :--- | :--- | :--- | :--- |
| **Customer** | `amitabh.sen@gmail.com` | `pass1234` | `/home` |
| **Driver** | `ramesh.driver@foodrush.com` | `driver@123` | `/driver/dashboard` |
| **Admin** | `admin@foodrush.com` | `admin@123` | `/admin/dashboard` |

---

## License & Author
Developed by **Lokesh** ([@Lokesh-0009](https://github.com/Lokesh-0009)).
All rights reserved.
