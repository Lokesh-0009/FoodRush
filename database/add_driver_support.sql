-- =============================================================================
-- FoodRush Migration: Add Driver / Delivery Partner Support (Option A)
-- Target Database: foodrush_db
-- =============================================================================

USE `foodrush_db`;

-- -----------------------------------------------------------------------------
-- 0. Ensure `role` column in `user` table supports 'DRIVER' (converts from ENUM to VARCHAR(50))
-- -----------------------------------------------------------------------------
ALTER TABLE `user` MODIFY COLUMN `role` VARCHAR(50) DEFAULT 'CUSTOMER';

-- -----------------------------------------------------------------------------
-- 1. Create the dedicated `driver` profile table
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- 2. Add driverID column and Foreign Key to `orders` table
-- Note: If you get "Duplicate column name 'driverID'", this step was already done.
-- -----------------------------------------------------------------------------
ALTER TABLE `orders` 
  ADD COLUMN `driverID` INT NULL DEFAULT NULL AFTER `restaurantID`;

ALTER TABLE `orders` 
  ADD CONSTRAINT `fk_orders_driver` FOREIGN KEY (`driverID`) REFERENCES `driver` (`driverID`) ON DELETE SET NULL;

-- -----------------------------------------------------------------------------
-- 3. Insert 3 Sample Drivers for immediate testing (Password: driver@123)
-- -----------------------------------------------------------------------------
INSERT INTO `user` (id, name, email, password, phone, role, address, createdDate, lastloginDate) VALUES
(31, 'Ramesh Kumar', 'ramesh.driver@foodrush.com', 'driver@123', '9876500001', 'DRIVER', 'Indiranagar, Bengaluru', NOW(), NOW()),
(32, 'Suresh Verma', 'suresh.driver@foodrush.com', 'driver@123', '9876500002', 'DRIVER', 'Koramangala, Bengaluru', NOW(), NOW()),
(33, 'Amit Patel', 'amit.driver@foodrush.com', 'driver@123', '9876500003', 'DRIVER', 'HSR Layout, Bengaluru', NOW(), NOW())
ON DUPLICATE KEY UPDATE name=VALUES(name);

INSERT INTO `driver` (driverID, userID, vehicleType, vehicleNumber, licenseNumber, status, rating) VALUES
(1, 31, 'EV Scooter', 'KA-05-EV-8492', 'DL-KA05-2021-001', 'AVAILABLE', 4.9),
(2, 32, 'Motorcycle', 'KA-01-AB-1234', 'DL-KA01-2020-002', 'AVAILABLE', 4.8),
(3, 33, 'Bike', 'KA-03-CD-5678', 'DL-KA03-2022-003', 'AVAILABLE', 5.0)
ON DUPLICATE KEY UPDATE vehicleNumber=VALUES(vehicleNumber);
