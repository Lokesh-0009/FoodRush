-- =============================================================================
-- FoodRush DDL Schema: Complete Table Definitions
-- Target Database: foodrush_db
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `foodrush_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `foodrush_db`;

-- 1. User Table
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) DEFAULT '9876543210',
  `role` VARCHAR(50) DEFAULT 'CUSTOMER',
  `address` VARCHAR(255) DEFAULT 'Bangalore, India',
  `createdDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `lastloginDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_user_email` (`email`),
  INDEX `idx_user_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Restaurant Table
CREATE TABLE IF NOT EXISTS `restaurant` (
  `restaurantID` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `cuisineType` VARCHAR(100) DEFAULT 'Multi-Cuisine',
  `deliveryTime` INT DEFAULT 30,
  `address` VARCHAR(255) DEFAULT 'Bangalore',
  `adminUserID` INT DEFAULT 1,
  `rating` DECIMAL(3, 1) DEFAULT 4.5,
  `isActive` INT DEFAULT 1,
  `imagePath` VARCHAR(255) DEFAULT 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=80',
  INDEX `idx_restaurant_active` (`isActive`),
  INDEX `idx_restaurant_rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Menu Table
CREATE TABLE IF NOT EXISTS `menu` (
  `menuID` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurantID` INT NOT NULL,
  `itemName` VARCHAR(150) NOT NULL,
  `description` TEXT,
  `price` DECIMAL(10, 2) NOT NULL DEFAULT 100.00,
  `isAvailable` INT DEFAULT 1,
  `category` VARCHAR(100) DEFAULT 'Main Course',
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deletedAt` TIMESTAMP NULL DEFAULT NULL,
  `imagePath` VARCHAR(255) DEFAULT 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop&q=80',
  INDEX `idx_menu_restaurant` (`restaurantID`),
  INDEX `idx_menu_category` (`category`),
  INDEX `idx_menu_deleted` (`deletedAt`),
  CONSTRAINT `fk_menu_restaurant` FOREIGN KEY (`restaurantID`) REFERENCES `restaurant` (`restaurantID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Driver Table
CREATE TABLE IF NOT EXISTS `driver` (
  `driverID` INT AUTO_INCREMENT PRIMARY KEY,
  `userID` INT NOT NULL UNIQUE,
  `vehicleType` VARCHAR(50) DEFAULT 'Bike',
  `vehicleNumber` VARCHAR(50) NOT NULL,
  `licenseNumber` VARCHAR(50) DEFAULT NULL,
  `status` VARCHAR(20) DEFAULT 'AVAILABLE',
  `rating` DECIMAL(3, 1) DEFAULT 5.0,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_driver_status` (`status`),
  CONSTRAINT `fk_driver_user` FOREIGN KEY (`userID`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Orders Table
CREATE TABLE IF NOT EXISTS `orders` (
  `orderID` INT AUTO_INCREMENT PRIMARY KEY,
  `userID` INT NOT NULL,
  `restaurantID` INT NOT NULL,
  `driverID` INT NULL DEFAULT NULL,
  `orderDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `totalAmount` DECIMAL(10, 2) NOT NULL,
  `status` VARCHAR(50) DEFAULT 'PLACED',
  `paymentMethod` VARCHAR(50) DEFAULT 'COD',
  `payment_status` VARCHAR(50) DEFAULT 'PENDING',
  INDEX `idx_orders_user` (`userID`),
  INDEX `idx_orders_restaurant` (`restaurantID`),
  INDEX `idx_orders_driver` (`driverID`),
  INDEX `idx_orders_status` (`status`),
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`userID`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_orders_restaurant` FOREIGN KEY (`restaurantID`) REFERENCES `restaurant` (`restaurantID`),
  CONSTRAINT `fk_orders_driver` FOREIGN KEY (`driverID`) REFERENCES `driver` (`driverID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. OrderItem Table
CREATE TABLE IF NOT EXISTS `orderitem` (
  `orderItemID` INT AUTO_INCREMENT PRIMARY KEY,
  `orderID` INT NOT NULL,
  `menuID` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `itemTotal` DECIMAL(10, 2) NOT NULL,
  INDEX `idx_orderitem_order` (`orderID`),
  INDEX `idx_orderitem_menu` (`menuID`),
  CONSTRAINT `fk_orderitem_order` FOREIGN KEY (`orderID`) REFERENCES `orders` (`orderID`) ON DELETE CASCADE,
  CONSTRAINT `fk_orderitem_menu` FOREIGN KEY (`menuID`) REFERENCES `menu` (`menuID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
