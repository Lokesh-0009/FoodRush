-- =============================================================================
-- FoodRush Database Seed Script: Complete Multi-Restaurant Showcase
-- Database: foodrush_db
-- Table: user (30 records: 1 Super Admin, 9 Restaurant Owners/Admins, 20 Customers)
-- Table: restaurant (30 records across major Bengaluru hubs)
-- Table: menu (330 records: 11 curated items for every restaurant)
-- Table: orders (20 sample orders with live status tracking)
-- Table: orderitem (40 line items)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `foodrush_db`;
USE `foodrush_db`;

-- Temporarily disable foreign key checks for clean insertion
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `orderitem`;
TRUNCATE TABLE `orders`;
TRUNCATE TABLE `menu`;
TRUNCATE TABLE `restaurant`;
TRUNCATE TABLE `user`;
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------
-- PHASE 1: INSERT 30 USERS
-- -----------------------------------------------------------------------------
INSERT INTO `user` (id, name, email, password, phone, role, address, createdDate, lastLoginDate) VALUES
-- 1. Super Admin
(1, 'FoodRush Admin', 'admin@foodrush.com', 'admin@123', '9876543210', 'ADMIN', 'FoodRush HQ, 100ft Road, Indiranagar, Bengaluru - 560038', NOW(), NOW()),

-- 2 to 10: Restaurant Owners & Managers (Admin Role)
(2, 'Rahul Sharma', 'rahul.sharma@foodrush.com', 'owner@123', '9811001101', 'ADMIN', 'Koramangala 5th Block, Bengaluru - 560095', NOW(), NOW()),
(3, 'Priya Sundaram', 'priya.s@foodrush.com', 'owner@123', '9811001102', 'ADMIN', '12th Main, Indiranagar, Bengaluru - 560038', NOW(), NOW()),
(4, 'Vikram Reddy', 'vikram.reddy@foodrush.com', 'owner@123', '9811001103', 'ADMIN', 'Sector 3, HSR Layout, Bengaluru - 560102', NOW(), NOW()),
(5, 'Ananya Deshmukh', 'ananya.d@foodrush.com', 'owner@123', '9811001104', 'ADMIN', 'ITPL Main Road, Whitefield, Bengaluru - 560066', NOW(), NOW()),
(6, 'Mohammed Farooq', 'farooq.m@foodrush.com', 'owner@123', '9811001105', 'ADMIN', 'Church Street, Shanthala Nagar, Bengaluru - 560001', NOW(), NOW()),
(7, 'Deepak Hegde', 'deepak.h@foodrush.com', 'owner@123', '9811001106', 'ADMIN', '4th Block, Jayanagar, Bengaluru - 560011', NOW(), NOW()),
(8, 'Sneha Patel', 'sneha.p@foodrush.com', 'owner@123', '9811001107', 'ADMIN', 'Sampige Road, Malleshwaram, Bengaluru - 560003', NOW(), NOW()),
(9, 'Rohan Mehra', 'rohan.m@foodrush.com', 'owner@123', '9811001108', 'ADMIN', 'Phase 1, Electronic City, Bengaluru - 560100', NOW(), NOW()),
(10, 'Kavita Menon', 'kavita.m@foodrush.com', 'owner@123', '9811001109', 'ADMIN', '24th Main, JP Nagar 5th Phase, Bengaluru - 560078', NOW(), NOW()),

-- 11 to 30: Customers across Bengaluru
(11, 'Amitabh Sen', 'amitabh.sen@gmail.com', 'pass1234', '9845012341', 'CUSTOMER', 'Flat 402, Sunshine Apts, Koramangala 7th Block, Bengaluru - 560095', NOW(), NOW()),
(12, 'Divya Nair', 'divya.nair@gmail.com', 'pass1234', '9845012342', 'CUSTOMER', '14, 6th Cross, 100ft Road, Indiranagar, Bengaluru - 560038', NOW(), NOW()),
(13, 'Karthik Rao', 'karthik.rao@outlook.com', 'pass1234', '9845012343', 'CUSTOMER', 'Villa 23, Green Glen Layout, Bellandur, Bengaluru - 560103', NOW(), NOW()),
(14, 'Meera Iyer', 'meera.iyer@gmail.com', 'pass1234', '9845012344', 'CUSTOMER', 'Flat B-201, Shobha Iris, Marathahalli, Bengaluru - 560037', NOW(), NOW()),
(15, 'Arjun Verma', 'arjun.verma@yahoo.com', 'pass1234', '9845012345', 'CUSTOMER', 'House 56, 17th Cross, Sector 4, HSR Layout, Bengaluru - 560102', NOW(), NOW()),
(16, 'Pooja Bhatt', 'pooja.b@gmail.com', 'pass1234', '9845012346', 'CUSTOMER', 'Apartment 108, Prestige Palms, Whitefield, Bengaluru - 560066', NOW(), NOW()),
(17, 'Sanjay Gowda', 'sanjay.gowda@gmail.com', 'pass1234', '9845012347', 'CUSTOMER', '22, 9th Main, Jayanagar 3rd Block, Bengaluru - 560011', NOW(), NOW()),
(18, 'Ritu Agarwal', 'ritu.agarwal@gmail.com', 'pass1234', '9845012348', 'CUSTOMER', 'House 88, 8th Main, Malleshwaram, Bengaluru - 560003', NOW(), NOW()),
(19, 'Naveen Kumar', 'naveen.k@gmail.com', 'pass1234', '9845012349', 'CUSTOMER', 'Flat 304, Silicon Towers, Electronic City Phase 1, Bengaluru - 560100', NOW(), NOW()),
(20, 'Tanvi Joshi', 'tanvi.joshi@outlook.com', 'pass1234', '9845012350', 'CUSTOMER', 'Flat 12A, Brigade Millennium, JP Nagar 7th Phase, Bengaluru - 560078', NOW(), NOW()),
(21, 'Akash Gupta', 'akash.gupta@gmail.com', 'pass1234', '9845012351', 'CUSTOMER', 'Plot 45, Sarjapur Main Road, Bengaluru - 560035', NOW(), NOW()),
(22, 'Swati Kulkarni', 'swati.k@gmail.com', 'pass1234', '9845012352', 'CUSTOMER', '102, Shanthi Niketan, Banashankari 3rd Stage, Bengaluru - 560085', NOW(), NOW()),
(23, 'Rajesh Nambiar', 'rajesh.nambiar@gmail.com', 'pass1234', '9845012353', 'CUSTOMER', '77, 1st Main, Domlur 2nd Stage, Bengaluru - 560071', NOW(), NOW()),
(24, 'Neha Kapoor', 'neha.kapoor@yahoo.com', 'pass1234', '9845012354', 'CUSTOMER', '512, Mantri Espana, Bellandur Outer Ring Road, Bengaluru - 560103', NOW(), NOW()),
(25, 'Abhishek Roy', 'abhishek.roy@gmail.com', 'pass1234', '9845012355', 'CUSTOMER', 'Flat 203, Godrej Woodsman, Hebbal, Bengaluru - 560024', NOW(), NOW()),
(26, 'Shreya Sengupta', 'shreya.s@gmail.com', 'pass1234', '9845012356', 'CUSTOMER', 'House 19, Cunningham Road, Vasanth Nagar, Bengaluru - 560052', NOW(), NOW()),
(27, 'Gautam Singhania', 'gautam.s@gmail.com', 'pass1234', '9845012357', 'CUSTOMER', 'Flat 601, Salarpuria Sattva, Kadubeesanahalli, Bengaluru - 560103', NOW(), NOW()),
(28, 'Ankita Chawla', 'ankita.chawla@gmail.com', 'pass1234', '9845012358', 'CUSTOMER', 'Penthouse 4, Brigade Gateway, Rajajinagar, Bengaluru - 560010', NOW(), NOW()),
(29, 'Manish Tiwari', 'manish.tiwari@gmail.com', 'pass1234', '9845012359', 'CUSTOMER', '34, 14th Main, BTM Layout 2nd Stage, Bengaluru - 560076', NOW(), NOW()),
(30, 'Kavya Murthy', 'kavya.murthy@gmail.com', 'pass1234', '9845012360', 'CUSTOMER', 'Flat 101, Gopalan Residency, Richmond Town, Bengaluru - 560025', NOW(), NOW());

-- -----------------------------------------------------------------------------
-- PHASE 2: INSERT 30 RESTAURANTS (Across Major Bengaluru Hubs)
-- -----------------------------------------------------------------------------
INSERT INTO `restaurant` (RestaurantID, Name, CuisineType, DeliveryTime, Address, AdminUserID, Rating, IsActive, imagePath) VALUES
(1, 'Royal Biryani Palace', 'Biryani, North Indian, Mughlai', 30, '80ft Road, 4th Block, Koramangala, Bengaluru - 560034', 2, 4.8, 1, 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(2, 'OvenFresh Pizza Studio', 'Italian, Pizzas, Pasta', 25, '100ft Road, HAL 2nd Stage, Indiranagar, Bengaluru - 560038', 3, 4.6, 1, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=80'),
(3, 'Spice Symphony Pure Veg', 'South Indian, Chettinad, Dosas', 20, '27th Main, Sector 1, HSR Layout, Bengaluru - 560102', 4, 4.7, 1, 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(4, 'The Burger Club', 'Burgers, Fast Food, Shakes', 22, 'Church Street, Off Brigade Road, Bengaluru - 560001', 6, 4.5, 1, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(5, 'Dragon Wok Asian Kitchen', 'Chinese, Asian, Momos, Noodles', 35, 'ITPL Main Road, Prestige Shantiniketan, Whitefield, Bengaluru - 560066', 5, 4.4, 1, 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(6, 'Punjab Grill House', 'North Indian, Kebabs, Tandoor', 32, '11th Main, 4th Block, Jayanagar, Bengaluru - 560011', 7, 4.6, 1, 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(7, 'Truffles Gourmet Cafe', 'Continental, Burgers, Steaks, Desserts', 28, '5th Block, Jyoti Nivas College Road, Koramangala, Bengaluru - 560095', 2, 4.9, 1, 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(8, 'Nagarjuna Andhra Delicacy', 'Andhra, Biryani, South Indian Non-Veg', 26, 'Residency Road, Shanthala Nagar, Ashok Nagar, Bengaluru - 560025', 1, 4.7, 1, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(9, 'Corner House Ice Creams', 'Desserts, Ice Cream, Shakes, Waffles', 18, '12th Main Road, HAL 2nd Stage, Indiranagar, Bengaluru - 560038', 3, 4.9, 1, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(10, 'Meghana Foods', 'Biryani, Andhra, Seafood, Chinese', 30, '1st Cross, KHB Colony, 5th Block, Koramangala, Bengaluru - 560095', 2, 4.8, 1, 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=600&auto=format&fit=crop&q=80'),
(11, 'Vidyarthi Bhavan Heritage', 'South Indian, Crispy Dosas, Filter Coffee', 20, 'Gandhi Bazaar Main Road, Basavanagudi, Bengaluru - 560004', 7, 4.8, 1, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&auto=format&fit=crop&q=80'),
(12, 'Glen\'s Bakehouse', 'Bakery, Cakes, Red Velvet, Pastas', 24, 'Lavelle Road, Shanthala Nagar, Bengaluru - 560001', 6, 4.7, 1, 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(13, 'Beijing Bites Express', 'Chinese, Thai, Pan-Asian', 32, 'Sampige Road, 7th Cross, Malleshwaram, Bengaluru - 560003', 8, 4.3, 1, 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(14, 'Toit Brewpub Kitchen', 'Continental, Woodfired Pizzas, Pub Bites', 30, '100ft Road, Near CMH Road Junction, Indiranagar, Bengaluru - 560038', 3, 4.8, 1, 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80'),
(15, 'Empire Restaurant', 'Mughlai, North Indian, Grilled Chicken, Biryani', 28, '80ft Road, Near Sony World Signal, Koramangala, Bengaluru - 560095', 2, 4.4, 1, 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(16, 'Green Leaf Healthy Salads', 'Healthy, Salads, Smoothie Bowls, Keto', 22, '14th Main, Sector 4, HSR Layout, Bengaluru - 560102', 4, 4.6, 1, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop&q=80'),
(17, 'Toscano Ristorante Italiano', 'Italian, Gourmet Pizzas, Risotto, Tiramisu', 35, 'UB City, Vittal Mallya Road, Bengaluru - 560001', 1, 4.8, 1, 'https://images.unsplash.com/photo-1579684947550-22e945225d9a?w=600&auto=format&fit=crop&q=80'),
(18, 'Udupi Grand Heritage', 'South Indian, Pure Veg Thali, Tiffin', 18, '10th Main, 4th Block, Jayanagar, Bengaluru - 560011', 7, 4.5, 1, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(19, 'Chai Point & All Day Snacks', 'Beverages, Chai, Snacks, Samosas', 15, 'Outer Ring Road, Kadubeesanahalli, Bellandur, Bengaluru - 560103', 9, 4.4, 1, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(20, 'Mani\'s Dum Biryani', 'Biryani, Andhra, Kebabs', 26, '19th Main, Sector 1, HSR Layout, Bengaluru - 560102', 4, 4.5, 1, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(21, 'Leon\'s Burgers & Wings', 'Burgers, Fried Chicken, Wraps, Fast Food', 24, '80ft Road, 6th Block, Koramangala, Bengaluru - 560095', 2, 4.6, 1, 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=600&auto=format&fit=crop&q=80'),
(22, 'The Fatty Bao Asian Gastrobar', 'Pan-Asian, Baos, Dimsums, Ramen', 38, '12th Main, HAL 2nd Stage, Indiranagar, Bengaluru - 560038', 3, 4.8, 1, 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(23, 'A2B - Adyar Ananda Bhavan', 'South Indian, Sweets, Pure Veg, Chaats', 22, '100ft Ring Road, BTM Layout 1st Stage, Bengaluru - 560068', 10, 4.4, 1, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(24, 'California Burrito', 'Mexican, Burritos, Tacos, Salad Bowls', 20, 'Brigade Road, Civil Station, Bengaluru - 560001', 6, 4.6, 1, 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
(25, 'Dindigul Thalappakatti', 'Biryani, South Indian Non-Veg, Chettinad', 30, 'Neeladri Road, Phase 1, Electronic City, Bengaluru - 560100', 9, 4.4, 1, 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(26, 'Keventers Milkshakes & Desserts', 'Beverages, Milkshakes, Ice Cream Sundaes', 16, 'Orion Mall, Brigade Gateway, Malleshwaram, Bengaluru - 560055', 8, 4.5, 1, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(27, 'Smoke House Deli', 'European, Continental, Breakfast, Burgers', 35, '100ft Road, Doopanahalli, Indiranagar, Bengaluru - 560008', 3, 4.7, 1, 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(28, 'Anjappar Chettinad Restaurant', 'Chettinad, Seafood, South Indian Non-Veg', 30, '24th Main, 5th Phase, JP Nagar, Bengaluru - 560078', 10, 4.3, 1, 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(29, 'Belgian Waffle Co.', 'Waffles, Desserts, Pancakes', 20, 'Marathahalli Main Road, Opposite Innovative Multiplex, Bengaluru - 560037', 5, 4.7, 1, 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(30, 'Karavalli Coastal Kitchen', 'Coastal, Seafood, Mangalorean, Kerala', 40, 'The Gateway Hotel, Residency Road, Bengaluru - 560025', 1, 4.9, 1, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80');

-- -----------------------------------------------------------------------------
-- PHASE 3: INSERT CURATED MENU ITEMS (11 Items per Restaurant = 330 Dishes)
-- -----------------------------------------------------------------------------
INSERT INTO `menu` (MenuID, RestaurantID, ItemName, Description, Price, IsAvailable, Category, CreatedAt, UpdatedAt, imagePath) VALUES
-- =============================================================================
-- Restaurant 1: Royal Biryani Palace (IDs: 1 - 11)
-- =============================================================================
(1, 1, 'Royal Mutton Dum Biryani', 'Slow-cooked succulent mutton marinated in traditional spices layered with fragrant basmati rice.', 420.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(2, 1, 'Chicken Tikka Dum Biryani', 'Tender chicken tikka chunks cooked in a rich saffron-infused dum preparation.', 350.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(3, 1, 'Hyderabadi Dum Chicken Biryani', 'Authentic spicy kacchi yakhni biryani layered with fresh herbs and fried onions.', 320.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=600&auto=format&fit=crop&q=80'),
(4, 1, 'Paneer Tikka Dum Biryani', 'Charcoal-grilled cottage cheese cubes layered with spiced aromatic saffron rice.', 270.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(5, 1, 'Murgh Malai Tikka', 'Boneless chicken cubes marinated in rich cashew cream and mild spices, grilled to perfection.', 310.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(6, 1, 'Galouti Kebab', 'Melt-in-mouth minced lamb kebabs infused with royal Awadhi spices.', 340.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(7, 1, 'Shahi Paneer Butter Masala', 'Fresh cottage cheese cubes cooked in a velvety tomato-cashew satin gravy.', 280.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600&auto=format&fit=crop&q=80'),
(8, 1, 'Murgh Makhani (Butter Chicken)', 'Classic roasted chicken simmered in rich creamy tomato and butter gravy.', 360.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(9, 1, 'Garlic Butter Naan', 'Fresh tandoori leavened flatbread topped with minced garlic and melted butter.', 70.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(10, 1, 'Mirchi Ka Salan & Boondi Raita', 'Traditional Hyderabadi spicy peanut-sesame chili gravy served with cooling spiced yogurt.', 80.00, 1, 'Accompaniments', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(11, 1, 'Shahi Tukda', 'Crispy fried bread soaked in saffron-infused syrup topped with rich rabri and pistachios.', 150.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 2: OvenFresh Pizza Studio (IDs: 12 - 22)
-- =============================================================================
(12, 2, 'Classic Margherita Pizza', 'San Marzano tomato sauce, fresh buffalo mozzarella, fresh basil, and extra virgin olive oil.', 320.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=80'),
(13, 2, 'Pepperoni Feast Pizza', 'Loaded with double spicy pork pepperoni slices and molten mozzarella cheese.', 460.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600&auto=format&fit=crop&q=80'),
(14, 2, 'Farmhouse Fresh Veggie Pizza', 'Loaded with crisp bell peppers, red onions, button mushrooms, sweet corn and black olives.', 380.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1579684947550-22e945225d9a?w=600&auto=format&fit=crop&q=80'),
(15, 2, 'BBQ Smoked Chicken Pizza', 'Smoked chicken cubes, barbecue sauce swirl, red onions, and mozzarella cheese.', 440.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
(16, 2, 'Cheesy Garlic Breadsticks', 'Freshly baked artisan bread smeared with herb-infused garlic butter and melted mozzarella.', 190.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?w=600&auto=format&fit=crop&q=80'),
(17, 2, 'Stuffed Jalapeno Garlic Bread', 'Soft baked pull-apart bread stuffed with cream cheese, sweet corn, and spicy jalapenos.', 220.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?w=600&auto=format&fit=crop&q=80'),
(18, 2, 'Creamy Alfredo Fettuccine', 'Handmade fettuccine tossed in rich parmesan cream sauce with wild mushrooms.', 380.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(19, 2, 'Spicy Penne Arrabbiata', 'Penne tossed in crushed Italian plum tomatoes, fresh basil, garlic, and fiery chili flakes.', 340.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(20, 2, 'Truffle Mushroom Spaghetti', 'Silky spaghetti tossed in garlic olive oil, sautéed button mushrooms, and white truffle oil.', 420.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(21, 2, 'Classic Tiramisu Cup', 'Espresso soaked savoiardi biscuits layered with fluffy mascarpone cream and dusted cocoa.', 210.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&auto=format&fit=crop&q=80'),
(22, 2, 'Sparkling Peach Iced Tea', 'Refreshing brewed black tea infused with real peach nectar and mint leaves.', 140.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 3: Spice Symphony Pure Veg (IDs: 23 - 33)
-- =============================================================================
(23, 3, 'Ghee Roast Masala Dosa', 'Crispy golden crepe roasted in pure desi ghee, stuffed with spiced potato masala.', 140.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(24, 3, 'Rava Onion Dosa', 'Crispy semolina crepe tempered with cumin, crushed peppercorns, green chillies and roasted onions.', 130.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&auto=format&fit=crop&q=80'),
(25, 3, 'Mysore Masala Dosa', 'Crisp crepe lined with spicy red chili-garlic chutney and potato mash.', 150.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(26, 3, 'Cheese Burst Paper Dosa', 'Extra large paper thin dosa loaded with melted mozzarella and cheddar cheese.', 170.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(27, 3, 'Steaming Idli Vada Combo', 'Two soft fluffy steamed idlis with one crispy medu vada served with sambar and coconut chutneys.', 110.00, 1, 'Breakfast', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(28, 3, 'Kanda Poha Special', 'Flattened rice tempered with mustard seeds, curry leaves, crunchy peanuts, and fresh coriander.', 90.00, 1, 'Breakfast', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(29, 3, 'Special South Indian Thali', 'Complete authentic Karnataka meal with rice, sambar, rasam, kootu, poriyal, papad, curd and payasam.', 220.00, 1, 'Meals', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(30, 3, 'Bisi Bele Bath with Boondi', 'Traditional piping hot spiced lentil-rice cooked with desi ghee and served with crispy kara boondi.', 120.00, 1, 'Meals', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(31, 3, 'Creamy Curd Rice', 'Tempered yogurt rice with mustard seeds, ginger, curry leaves, and fresh pomegranate seeds.', 110.00, 1, 'Meals', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(32, 3, 'Mangalore Buns (2 pcs)', 'Mildly sweet fluffy fried banana bread served with spicy coconut chutney.', 80.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(33, 3, 'Kumbakonam Degree Filter Kaapi', 'Authentic frothy South Indian filter coffee brewed with fresh chicory blend.', 45.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 4: The Burger Club (IDs: 34 - 44)
-- =============================================================================
(34, 4, 'Triple Cheese Smash Burger', 'Double grilled patties layered with cheddar, gouda, caramelized onions and secret house sauce.', 290.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(35, 4, 'Crispy Peri Peri Chicken Burger', 'Crunchy fried chicken fillet dusted with fiery peri peri seasoning and spicy jalapeño mayo.', 260.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=600&auto=format&fit=crop&q=80'),
(36, 4, 'Double Smokey Bacon Burger', 'Two smashed beef patties, smoked crisp bacon strips, molten cheddar, and smokey BBQ relish.', 340.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(37, 4, 'Spicy Paneer Crunch Burger', 'Crispy crumb-fried paneer patty topped with chipotle sauce, lettuce, and pickled gherkins.', 230.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(38, 4, 'Truffle Mushroom Swiss Burger', 'Grilled patty topped with sautéed button mushrooms, melted Swiss cheese, and truffle mayo.', 310.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(39, 4, 'Loaded Cheesy French Fries', 'Crispy golden fries smothered in warm cheddar cheese sauce, herbs and jalapeños.', 160.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600&auto=format&fit=crop&q=80'),
(40, 4, 'Peri Peri Crispy Fries', 'Golden French fries tossed in a zesty peri peri spice blend with spicy dip.', 130.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600&auto=format&fit=crop&q=80'),
(41, 4, 'Crunchy Battered Onion Rings', 'Crispy golden breadcrumb-crusted onion rings served with thousand island sauce.', 140.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&auto=format&fit=crop&q=80'),
(42, 4, 'BBQ Glazed Chicken Wings (6 pcs)', 'Juicy fried chicken wings tossed in rich and sticky hickory barbecue sauce.', 240.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&auto=format&fit=crop&q=80'),
(43, 4, 'Belgian Dark Chocolate Shake', 'Thick creamy milkshake blended with authentic Belgian dark cocoa and chocolate gelato.', 180.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(44, 4, 'Salted Caramel Milkshake', 'Rich vanilla ice cream blended with salted golden caramel and topped with whipped cream.', 190.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 5: Dragon Wok Asian Kitchen (IDs: 45 - 55)
-- =============================================================================
(45, 5, 'Chicken Steamed Momos (6 pcs)', 'Delicate Himalayan steamed dumplings stuffed with minced juicy chicken and scallions.', 190.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(46, 5, 'Crispy Veg Fried Momos (6 pcs)', 'Crispy golden dumplings packed with crunchy cabbage, carrots, and spring onions.', 160.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(47, 5, 'Pan Fried Schezwan Momos', 'Crispy bottom dumplings tossed in spicy homemade Schezwan sauce.', 210.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(48, 5, 'Schezwan Chilli Hakka Noodles', 'Wok-tossed noodles with crisp vegetables and fiery home-made Schezwan chili paste.', 230.00, 1, 'Noodles', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(49, 5, 'Burnt Garlic Veg Fried Rice', 'Fragrant jasmine rice tossed with golden roasted garlic, spring onions, and garden vegetables.', 210.00, 1, 'Rice', NOW(), NOW(), 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80'),
(50, 5, 'Kung Pao Crispy Chicken', 'Crispy chicken tossed with bell peppers, dried red chillies, and roasted crunchy peanuts.', 290.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=600&auto=format&fit=crop&q=80'),
(51, 5, 'Chilli Chicken Gravy', 'Crisp diced chicken tossed with green bell peppers, onions, and spicy dark soy-chilli gravy.', 280.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=600&auto=format&fit=crop&q=80'),
(52, 5, 'Veg Manchurian Dry', 'Crispy vegetable dumplings tossed in ginger, garlic, cilantro, and dark soy sauce.', 220.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(53, 5, 'Sweet Corn Chicken Soup', 'Classic comforting thick broth with crushed sweet corn kernels and shredded tender chicken.', 160.00, 1, 'Soups', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(54, 5, 'Honey Chilli Crispy Lotus Stem', 'Crunchy lotus stem slivers tossed with honey, sesame seeds, and spicy red chili glaze.', 240.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=600&auto=format&fit=crop&q=80'),
(55, 5, 'Thai Green Curry with Jasmine Rice', 'Aromatic coconut green curry with exotic Asian vegetables served with steamed jasmine rice.', 340.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 6: Punjab Grill House (IDs: 56 - 66)
-- =============================================================================
(56, 6, 'Tandoori Murgh (Full)', 'Whole chicken marinated in Kashmiri red chilies, mustard oil, yogurt, and roasted in clay oven.', 440.00, 1, 'Tandoor', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(57, 6, 'Paneer Tikka Shashlik', 'Fresh cottage cheese cubes skewered with bell peppers and onions, marinated in spiced mustard curd.', 290.00, 1, 'Tandoor', NOW(), NOW(), 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600&auto=format&fit=crop&q=80'),
(58, 6, 'Murgh Afghani Tikka', 'Boneless chicken chunks marinated in cashew cream, white pepper, and grilled over charcoal.', 330.00, 1, 'Tandoor', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(59, 6, 'Dal Makhani Royal', 'Black lentils slow-cooked overnight on slow tandoor charcoal with white butter and fresh cream.', 260.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600&auto=format&fit=crop&q=80'),
(60, 6, 'Butter Chicken Amritsari', 'Charcoal grilled chicken pieces simmered in rich creamy tomato and kasuri methi gravy.', 370.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(61, 6, 'Kadhai Paneer Special', 'Cottage cheese cubes tossed with freshly pounded coriander seeds, dry red chillies, and capsicum.', 290.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600&auto=format&fit=crop&q=80'),
(62, 6, 'Rawal Pindi Chole', 'Spiced chickpeas cooked in traditional Punjabi dark tea decoction and aromatic spices.', 240.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600&auto=format&fit=crop&q=80'),
(63, 6, 'Butter Naan Basket (2 pcs)', 'Soft tandoori leavened flatbread glazed with generous homemade butter.', 80.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(64, 6, 'Stuffed Amritsari Kulcha', 'Crispy tandoor baked bread stuffed with spiced mashed potatoes and onions, served with butter.', 110.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(65, 6, 'Jeera Rice with Desi Ghee', 'Aromatic basmati rice tempered with roasted cumin seeds and desi ghee.', 150.00, 1, 'Rice', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(66, 6, 'Gulab Jamun with Rabri', 'Warm fried milk dumplings served with thick cardamom-infused reduced milk rabri.', 140.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 7: Truffles Gourmet Cafe (IDs: 67 - 77)
-- =============================================================================
(67, 7, 'All American Cheeseburger', 'Signature juicy grilled patty, melted cheddar slice, lettuce, tomato and gherkins on toasted brioche.', 280.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(68, 7, 'Sloppy Joe Lamb Burger', 'Rich minced lamb bolognese layered with cheddar cheese in a toasted artisan bun.', 340.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(69, 7, 'Veg Whopper Master', 'Crisp vegetable patty with layered cheese, sliced tomatoes, onions, and thousand island spread.', 240.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(70, 7, 'Peri Peri Chicken Steak', 'Grilled chicken breast served with spicy peri peri jus, buttered veggies, and mashed potatoes.', 360.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(71, 7, 'Creamy Alfredo Penne', 'Penne pasta tossed in garlic parmesan cream sauce with grilled broccoli and mushrooms.', 310.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(72, 7, 'Crunchy Chicken Strips Basket', 'Panko-crusted boneless chicken strips served with house barbecue dip and tartar sauce.', 220.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&auto=format&fit=crop&q=80'),
(73, 7, 'Cheesy Loaded Nachos', 'Crispy corn tortilla chips topped with cheese sauce, salsa fresca, jalapenos, and sour cream.', 210.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=600&auto=format&fit=crop&q=80'),
(74, 7, 'Jalapeno Cheese Poppers (6 pcs)', 'Crispy crumb coated fried bites oozing with molten cheese and spicy jalapenos.', 180.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600&auto=format&fit=crop&q=80'),
(75, 7, 'Mississippi Mud Pie', 'Decadent dark chocolate mousse layered over a crunchy fudge cookie crust.', 190.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(76, 7, 'Dutch Truffle Cake Slice', 'Rich dark chocolate sponge cake layered with silky chocolate ganache.', 170.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(77, 7, 'Ferrero Rocher Shake', 'Thick milkshake blended with hazelnut spread, crushed Ferrero Rocher, and vanilla gelato.', 210.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 8: Nagarjuna Andhra Delicacy (IDs: 78 - 88)
-- =============================================================================
(78, 8, 'Nagarjuna Special Mutton Biryani', 'Famous spicy Andhra-style mutton biryani served with spicy gravy and raita.', 430.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(79, 8, 'Andhra Chicken 65', 'Authentic spicy deep-fried chicken cubes tossed with curry leaves, yogurt, and green chillies.', 280.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(80, 8, 'Nagarjuna Special Chicken Biryani', 'Bengaluru legendary green chili spiced Andhra style dum chicken biryani.', 340.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(81, 8, 'Andhra Chilli Chicken (Dry)', 'Spicy chicken morsels tossed with slit green chillies, garlic, and freshly ground spices.', 290.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(82, 8, 'Gongura Mutton Curry', 'Tender mutton pieces simmered in tangy sorrel leaves (gongura) paste and Andhra spices.', 420.00, 1, 'Curries', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(83, 8, 'Nellore Chepala Pulusu (Fish Curry)', 'Fresh fish fillets cooked in tangy tamarind and red chili gravy with methi seeds.', 390.00, 1, 'Curries', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(84, 8, 'Crispy Paneer 65', 'Crispy cottage cheese cubes tossed with curry leaves, green chillies, and Andhra spice blend.', 250.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600&auto=format&fit=crop&q=80'),
(85, 8, 'Authentic Andhra Full Meals', 'Unlimited experience: Rice, Pappu, Sambar, Rasam, Gunpowder with Ghee, Curd, and Sweet.', 240.00, 1, 'Meals', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(86, 8, 'Andhra Tomato Pappu with Ghee', 'Traditional Andhra lentil dal cooked with tomatoes, tempered with mustard, cumin and garlic.', 140.00, 1, 'Curries', NOW(), NOW(), 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600&auto=format&fit=crop&q=80'),
(87, 8, 'Curd Rice with Mustard Tadka', 'Cooling curd rice tempered with mustard, ginger, curry leaves, and fried mor milagai.', 110.00, 1, 'Meals', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(88, 8, 'Meetha Paan Royale', 'Sweet betel leaf filled with gulkand, tutty fruity, and aromatic mouth fresheners.', 50.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 9: Corner House Ice Creams (IDs: 89 - 99)
-- =============================================================================
(89, 9, 'Death by Chocolate (DBC)', 'Rich chocolate cake layered with vanilla ice cream, smothered in hot chocolate fudge and peanuts.', 240.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(90, 9, 'Hot Butterscotch Sundae', 'Vanilla scoops topped with warm roasted cashew nuts and rich golden butterscotch sauce.', 180.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(91, 9, 'Cake Fudge Sundae', 'Fresh chocolate sponge cake topped with vanilla ice cream and warm hot fudge sauce.', 190.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(92, 9, 'Brown Bomb with Hot Chocolate', 'Warm fudgy walnut brownie served under rich vanilla scoops and molten chocolate.', 210.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(93, 9, 'Almond Fudge Delight', 'Vanilla scoops topped with roasted whole almonds and warm Belgian chocolate fudge.', 220.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(94, 9, 'Banana Split Royale', 'Fresh banana boat with scoops of vanilla, strawberry, and chocolate, topped with cherries and fudge.', 230.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(95, 9, 'Belgian Dark Chocolate Scoop', 'Single scoop of dense, premium Belgian dark chocolate ice cream.', 90.00, 1, 'Ice Creams', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(96, 9, 'Alphonso Mango Scoop', 'Single scoop made from real ratnagiri alphonso mango pulp.', 90.00, 1, 'Ice Creams', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(97, 9, 'Fig & Honey Ice Cream Scoop', 'Natural ice cream infused with dried Afghan figs and wild forest honey.', 100.00, 1, 'Ice Creams', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(98, 9, 'Oreo Crunch Thick Shake', 'Thick creamy milkshake blended with crushed Oreo cookies and chocolate drizzle.', 170.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(99, 9, 'Strawberry Sensation Sundae', 'Strawberry and vanilla ice cream layered with strawberry compote and whipped cream.', 180.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 10: Meghana Foods (IDs: 100 - 110)
-- =============================================================================
(100, 10, 'Meghana Special Chicken Biryani', 'Iconic Bengaluru spicy biryani topped with boneless succulent fried chicken and aromatic rice.', 360.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=600&auto=format&fit=crop&q=80'),
(101, 10, 'Meghana Special Mutton Biryani', 'Tender boneless mutton tossed in fiery Andhra gravy layered over flavored basmati rice.', 440.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(102, 10, 'Paneer Tikka Biryani', 'Cottage cheese cubes tossed in spicy tandoori masala and layered with dum biryani rice.', 300.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(103, 10, 'Egg Dum Biryani', 'Golden fried boiled eggs simmered in rich Andhra spiced biryani gravy and long grain basmati rice.', 260.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(104, 10, 'Paneer 555', 'Crispy cottage cheese fingers tossed with crunchy garlic, curry leaves, and spicy red sauce.', 270.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(105, 10, 'Lemon Chicken Dry', 'Crisp chicken strips sautéed with green chillies, curry leaves, and a tangy lemon squeeze.', 290.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=600&auto=format&fit=crop&q=80'),
(106, 10, 'Crispy Apollo Fish', 'Boneless fish fillets marinated in spicy yogurt batter and deep fried with green chillies.', 360.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(107, 10, 'Chicken Boneless 65', 'Juicy boneless chicken tossed with spicy Andhra curd masala and curry leaves.', 310.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(108, 10, 'Butter Chicken Masala', 'Smooth and rich tomato-butter gravy with tender chicken pieces, finished with fresh cream.', 330.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(109, 10, 'Rumali Roti (2 pcs)', 'Handkerchief-thin soft Indian flatbread baked on an inverted tawa.', 70.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(110, 10, 'Steamed Basmati Rice with Dal', 'Fragrant steamed long-grain rice served with comforting yellow tadka dal.', 160.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 11: Vidyarthi Bhavan Heritage (IDs: 111 - 121)
-- =============================================================================
(111, 11, 'Benne Masala Dosa', 'Legendary thick crispy golden dosa roasted with dollops of white butter and potato sagu.', 95.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&auto=format&fit=crop&q=80'),
(112, 11, 'Benne Plain Dosa', 'Crisp golden brown thick dosa roasted in generous desi butter, served with coconut chutney.', 85.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&auto=format&fit=crop&q=80'),
(113, 11, 'Crispy Rava Dosa', 'Lacy thin semolina dosa with roasted cumin, black pepper, and green chillies.', 90.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(114, 11, 'Poori Sagu (3 pcs)', 'Fluffy golden fried pooris served with traditional spiced vegetable sagu and onion.', 80.00, 1, 'Breakfast', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(115, 11, 'Rava Vada with Coconut Chutney', 'Crunchy semolina and spiced lentil fritters served hot with mint-coconut chutney.', 55.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&auto=format&fit=crop&q=80'),
(116, 11, 'Khara Bath (Spiced Upma)', 'Traditional Karnataka roasted semolina upma with garden vegetables and aromatic spices.', 60.00, 1, 'Breakfast', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(117, 11, 'Kesari Bath (Pineapple Shira)', 'Rich semolina sweet pudding prepared with pure ghee, saffron, and juicy pineapple chunks.', 65.00, 1, 'Sweets', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(118, 11, 'Chow Chow Bath Combo', 'The best of both: A scoop of savory Khara Bath alongside sweet aromatic Kesari Bath.', 110.00, 1, 'Breakfast', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(119, 11, 'Gulab Jamun (2 pcs)', 'Melt-in-mouth milk solids dumplings soaked in rose and cardamom flavored sugar syrup.', 60.00, 1, 'Sweets', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(120, 11, 'Authentic Filter Kaapi', 'Traditional South Indian chicory blended decoction frothed with fresh boiled milk in a dabarah.', 40.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(121, 11, 'Warm Badam Milk', 'Rich milk infused with crushed almonds, saffron strands, and green cardamom.', 55.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 12: Glen's Bakehouse (IDs: 122 - 132)
-- =============================================================================
(122, 12, 'Red Velvet Cupcake', 'Bengaluru famous signature red velvet mini-cake with velvety cream cheese frosting.', 85.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(123, 12, 'Red Velvet Mini Cake', 'Classic moist red velvet sponge cake layered with rich cream cheese frosting.', 320.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(124, 12, 'Penne Arrabbiata Pasta', 'Penne pasta tossed in spicy garlic-infused Italian plum tomato sauce with fresh basil and parmesan.', 320.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(125, 12, 'Creamy Mushroom Risotto', 'Arborio rice slow cooked with button mushrooms, white wine reduction, and parmesan.', 380.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(126, 12, 'Baked Chicken Lasagna', 'Layered pasta sheets with minced chicken ragu, béchamel sauce, and bubbling mozzarella cheese.', 390.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(127, 12, 'Smoked Chicken Croissant', 'Buttery flaky French croissant stuffed with smoked chicken, cheddar, and Dijon mayo.', 180.00, 1, 'Savory', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(128, 12, 'Garlic Sourdough Toast', 'Freshly baked artisan sourdough bread toasted with garlic herb butter.', 140.00, 1, 'Savory', NOW(), NOW(), 'https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?w=600&auto=format&fit=crop&q=80'),
(129, 12, 'Blueberry Cheesecake Slice', 'Classic baked New York cheesecake topped with tangy blueberry compote.', 220.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(130, 12, 'Classic Apple Pie with Cinnamon', 'Flaky pastry crust filled with caramelized spiced apples and cinnamon glaze.', 190.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(131, 12, 'Hazelnut Cappuccino', 'Espresso shot with steamed milk foam and roasted hazelnut essence.', 160.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(132, 12, 'Iced Americano', 'Double espresso poured over ice and chilled mineral water.', 140.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 13: Beijing Bites Express (IDs: 133 - 143)
-- =============================================================================
(133, 13, 'Chilli Chicken Gravy', 'Battered chicken tossed with diced onions, capsicum, and spicy soy-chilli gravy.', 270.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=600&auto=format&fit=crop&q=80'),
(134, 13, 'Vegetable Fried Rice', 'Wok-tossed fragrant basmati rice with finely chopped garden vegetables and spring onions.', 210.00, 1, 'Rice', NOW(), NOW(), 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80'),
(135, 13, 'Chicken Fried Rice', 'Wok-tossed long-grain rice with shredded chicken, scrambled eggs, and scallions.', 240.00, 1, 'Rice', NOW(), NOW(), 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80'),
(136, 13, 'Singapore Street Noodles', 'Thin vermicelli noodles stir-fried with curry powder, crisp bell peppers, and scallions.', 250.00, 1, 'Noodles', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(137, 13, 'Crispy Chilli Garlic Momos', 'Crisp fried dumplings tossed in spicy burnt garlic and chili paste.', 190.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(138, 13, 'Dragon Chicken Dry', 'Crispy chicken strips tossed in cashew nuts, dry red chillies, and spicy tangy sauce.', 280.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=600&auto=format&fit=crop&q=80'),
(139, 13, 'Crispy Honey Chicken', 'Shredded crispy fried chicken glazed with honey and roasted sesame seeds.', 290.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=600&auto=format&fit=crop&q=80'),
(140, 13, 'Veg Manchurian in Hot Garlic Sauce', 'Crispy veggie balls simmered in pungent spicy garlic-soy gravy.', 230.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(141, 13, 'Thai Red Curry with Jasmine Rice', 'Rich red coconut curry with bamboo shoots, basil leaves, and steamed jasmine rice.', 350.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(142, 13, 'Manchow Soup with Fried Noodles', 'Dark spicy vegetable soup flavored with ginger, garlic, and topped with crisp fried noodles.', 150.00, 1, 'Soups', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(143, 13, 'Darsaan with Vanilla Ice Cream', 'Crispy honey-glazed fried wonton noodles served with a scoop of vanilla ice cream.', 170.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 14: Toit Brewpub Kitchen (IDs: 144 - 154)
-- =============================================================================
(144, 14, 'Toit Woodfired Pizza', 'Woodfired thin crust pizza loaded with roasted garlic, smoked chicken, and scamorza cheese.', 440.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80'),
(145, 14, 'The Tintin Veggie Pizza', 'Woodfired pizza topped with sun-dried tomatoes, roasted bell peppers, feta, and pesto drizzle.', 410.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=80'),
(146, 14, 'Pepperoni & Jalapeno Pizza', 'Thin crust artisan pizza loaded with spicy pepperoni, pickled jalapenos, and mozzarella.', 490.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600&auto=format&fit=crop&q=80'),
(147, 14, 'Baked Nachos Supreme', 'Crispy tortilla chips baked with salsa, black olives, jalapeños, and melted cheese blend.', 260.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=600&auto=format&fit=crop&q=80'),
(148, 14, 'Toit Baked Chicken Wings', 'Oven-roasted chicken wings glazed with signature smoky spicy dry rub.', 310.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&auto=format&fit=crop&q=80'),
(149, 14, 'Crispy Calamari Fritters', 'Golden fried squid rings dusted with sea salt and paprika, served with garlic aioli.', 360.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(150, 14, 'Beer Battered Fish & Chips', 'Crispy golden fish fillet served with thick-cut potato chips and house tartar sauce.', 420.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(151, 14, 'Mushroom & Cheese Arancini Balls', 'Crispy risotto balls filled with molten cheese and wild mushroom ragu.', 240.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(152, 14, 'Smokey BBQ Pulled Chicken Burger', 'Slow-cooked pulled chicken in barbecue sauce with crispy coleslaw on brioche bun.', 320.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(153, 14, 'Warm Brownie with Vanilla Gelato', 'Gooey dark chocolate brownie served warm with artisan vanilla gelato.', 210.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(154, 14, 'Homemade Ginger Lemon Soda', 'Freshly squeezed lemon juice, crushed ginger root, and sparkling soda water.', 130.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 15: Empire Restaurant (IDs: 155 - 165)
-- =============================================================================
(155, 15, 'Empire Special Ghee Rice', 'Aromatic small-grain rice cooked in pure ghee, fried onions, cashews, and whole spices.', 180.00, 1, 'Rice', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(156, 15, 'Grilled Chicken Breast', 'Bengaluru famous late-night style spiced grilled chicken served with mayonnaise and mint chutney.', 290.00, 1, 'Tandoor', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(157, 15, 'Empire Chicken Biryani', 'Fragrant dum cooked chicken biryani prepared in the signature Empire style.', 280.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(158, 15, 'Empire Mutton Biryani', 'Succulent mutton pieces layered with seasoned aromatic biryani rice and boiled egg.', 380.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(159, 15, 'Brain Dry Fry', 'Signature delicacy sautéed with onions, green chillies, curry leaves, and black pepper.', 290.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(160, 15, 'Chicken Kabab Oil Fry', 'Crispy deep-fried bone-in chicken marinated in secret Bengaluru Empire masala.', 260.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(161, 15, 'Coin Parotta (3 pcs)', 'Flaky mini South Indian layered parottas toasted golden brown on tawa.', 90.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(162, 15, 'Butter Chicken Masala', 'Rich and buttery North Indian gravy with tender shredded tandoori chicken.', 310.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(163, 15, 'Pepper Chicken Gravy', 'Spicy semi-gravy chicken cooked with freshly crushed black pepper and onions.', 290.00, 1, 'Main Course', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(164, 15, 'Jumbo Chicken Shawarma Roll', 'Spit-roasted chicken wrapped in soft kubboos with garlic toum and pickles.', 160.00, 1, 'Quick Bites', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(165, 15, 'Falooda Royale', 'Creamy milk dessert layered with rose syrup, basil seeds, vermicelli, and vanilla ice cream.', 170.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 16: Green Leaf Healthy Salads (IDs: 166 - 176)
-- =============================================================================
(166, 16, 'Greek Feta Crunch Salad', 'Crisp lettuce, cucumbers, cherry tomatoes, kalamata olives, and Greek feta cheese in lemon vinaigrette.', 260.00, 1, 'Salads', NOW(), NOW(), 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop&q=80'),
(167, 16, 'Avocado Quinoa Power Bowl', 'Organic quinoa, fresh sliced Hass avocado, roasted chickpeas, kale, and tahini dressing.', 340.00, 1, 'Bowls', NOW(), NOW(), 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80'),
(168, 16, 'Caesar Salad with Grilled Chicken', 'Romaine lettuce tossed with garlic parmesan dressing, grilled chicken breast, and sourdough croutons.', 290.00, 1, 'Salads', NOW(), NOW(), 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop&q=80'),
(169, 16, 'Mediterranean Falafel & Hummus Bowl', 'Crispy herb falafels, velvety garlic hummus, tabbouleh, pickled turnip, and warm pita wedges.', 280.00, 1, 'Bowls', NOW(), NOW(), 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80'),
(170, 16, 'Roasted Beetroot & Goat Cheese Salad', 'Baby spinach, roasted beets, candied walnuts, and soft goat cheese with balsamic glaze.', 270.00, 1, 'Salads', NOW(), NOW(), 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop&q=80'),
(171, 16, 'Berry Blast Smoothie Bowl', 'Blended blueberries, strawberries, and bananas topped with chia seeds, granola, and sliced kiwi.', 260.00, 1, 'Smoothie Bowls', NOW(), NOW(), 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80'),
(172, 16, 'Tropical Mango Chia Seed Pudding', 'Coconut milk chia seed pudding layered with fresh mango compote and toasted coconut flakes.', 220.00, 1, 'Smoothie Bowls', NOW(), NOW(), 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80'),
(173, 16, 'Grilled Tofu & Edamame Bowl', 'Organic tofu steaks, steamed edamame, brown rice, seaweed, and toasted sesame ginger dressing.', 290.00, 1, 'Bowls', NOW(), NOW(), 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80'),
(174, 16, 'Cold-Pressed ABC Detox Juice', 'Fresh unpasteurized blend of sweet apples, organic beetroot, and crunchy carrots.', 150.00, 1, 'Juices', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(175, 16, 'Green Goddess Detox Juice', 'Revitalizing blend of celery, green cucumber, baby spinach, green apple, and fresh mint.', 150.00, 1, 'Juices', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(176, 16, 'Almond Flour Keto Protein Cookies (2 pcs)', 'Sugar-free cookies baked with almond flour, cocoa, and whey protein isolate.', 120.00, 1, 'Healthy Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 17: Toscano Ristorante Italiano (IDs: 177 - 187)
-- =============================================================================
(177, 17, 'Quattro Formaggi Pizza', 'Four cheese pizza with gorgonzola, mozzarella, parmesan, and creamy goat cheese.', 490.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1579684947550-22e945225d9a?w=600&auto=format&fit=crop&q=80'),
(178, 17, 'Burrata & Parma Truffle Pizza', 'Woodfired pizza with whole artisanal burrata, parma ham, arugula, and truffle drizzle.', 540.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=80'),
(179, 17, 'Rustic Margherita Di Bufala', 'Buffalo mozzarella, San Marzano tomato reduction, and fresh Genovese basil leaves.', 420.00, 1, 'Pizzas', NOW(), NOW(), 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=80'),
(180, 17, 'Classic Italian Tiramisu', 'Espresso-soaked savoiardi ladyfingers layered with rich mascarpone zabaglione and cocoa.', 260.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&auto=format&fit=crop&q=80'),
(181, 17, 'Ravioli Ricotta & Spinach', 'Handcrafted ravioli filled with fresh ricotta and spinach in sage butter sauce.', 440.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(182, 17, 'Spaghetti Alla Carbonara', 'Al dente spaghetti tossed in cured pork pancetta, egg yolk emulsion, and Pecorino Romano.', 460.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(183, 17, 'Saffron Seafood Risotto', 'Carnaroli rice cooked in saffron broth with prawns, calamari, and fresh clams.', 520.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(184, 17, 'Bruschetta Al Pomodoro', 'Grilled artisan bread rubbed with garlic, topped with marinated vine tomatoes and basil.', 240.00, 1, 'Antipasti', NOW(), NOW(), 'https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?w=600&auto=format&fit=crop&q=80'),
(185, 17, 'Rosemary Focaccia with Olive Tapenade', 'Warm oven-baked focaccia bread seasoned with sea salt and rosemary, with black olive dip.', 190.00, 1, 'Antipasti', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(186, 17, 'Panna Cotta with Berry Coulis', 'Silky vanilla bean panna cotta served with wild berry reduction.', 230.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&auto=format&fit=crop&q=80'),
(187, 17, 'San Pellegrino Italian Lemonade', 'Refreshing sparkling Italian mineral water infused with sun-ripened Sicilian lemons.', 160.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 18: Udupi Grand Heritage (IDs: 188 - 198)
-- =============================================================================
(188, 18, 'Bisi Bele Bath with Boondi', 'Traditional Karnataka spiced lentil and vegetable rice cooked in ghee, served with crispy kara boondi.', 110.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(189, 18, 'Crispy Medu Vada (2 pcs)', 'Crispy deep-fried savory lentil doughnuts served with fresh ground coconut chutney and hot sambar.', 75.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&auto=format&fit=crop&q=80'),
(190, 18, 'Set Dosa with Sagu (3 pcs)', 'Soft, spongy trio of dosas served with flavorful mixed vegetable sagu and chutney.', 90.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(191, 18, 'Udupi Onion Rava Masala Dosa', 'Crispy golden semolina dosa with roasted onions and spiced potato filling.', 120.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&auto=format&fit=crop&q=80'),
(192, 18, 'Paper Plain Roast Dosa', 'Ultra-crispy oversized golden dosa served with three types of house chutneys and sambar.', 100.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(193, 18, 'Grand South Indian Lunch Thali', 'Pure veg banquet with rice, poori, sambar, rasam, kootu, dal, curd, papad, and sweet.', 180.00, 1, 'Meals', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(194, 18, 'Vangi Bath (Brinjal Rice)', 'Karnataka style spiced rice cooked with brinjal and special roasted masala powder.', 95.00, 1, 'Meals', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(195, 18, 'Podi Ghee Idlis (10 mini pcs)', 'Bite-sized soft steamed idlis tossed in fragrant spicy gunpowder and melted desi ghee.', 110.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(196, 18, 'Maddur Vada (2 pcs)', 'Crispy savory fritters made with semolina, onions, curry leaves, and crushed spices.', 60.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(197, 18, 'Rich Badam Halwa', 'Decadent royal dessert prepared with pure almond paste, desi ghee, and saffron.', 110.00, 1, 'Sweets', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(198, 18, 'Traditional Filter Coffee', 'Hot frothed South Indian coffee served in brass dabarah and tumbler.', 35.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 19: Chai Point & All Day Snacks (IDs: 199 - 209)
-- =============================================================================
(199, 19, 'Ginger Elaichi Chai Flask', 'Freshly brewed piping hot spiced tea with crushed ginger root and green cardamom in heat-retaining flask.', 120.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(200, 19, 'Masala Chai Heat Flask (500ml)', 'Rich Assam tea simmered with whole cinnamon, clove, black pepper, and cardamom.', 130.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(201, 19, 'Kashmiri Kahwa Green Tea', 'Aromatic green tea infused with whole saffron strands, cinnamon, and slivered almonds.', 110.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(202, 19, 'Punjabi Samosa (2 pcs)', 'Crispy golden pastry crust filled with spiced potatoes, green peas, and whole coriander seeds.', 60.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(203, 19, 'Mumbai Bun Maska with Jam', 'Soft sweet bun smeared with generous Amul butter and mixed fruit jam.', 70.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(204, 19, 'Paneer Tikka Puff', 'Flaky puff pastry filled with spiced tandoori cottage cheese and bell peppers.', 65.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(205, 19, 'Egg & Mayo Grilled Sandwich', 'Toasted sandwich filled with boiled egg chunks, creamy mayo, and black pepper.', 120.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(206, 19, 'Classic Mumbai Vada Pav (2 pcs)', 'Spicy potato fritter stuffed inside soft pav with garlic chutney and fried green chili.', 80.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(207, 19, 'Crispy Mathri with Pickle', 'Flaky savory crackers seasoned with ajwain, served with tangy mango pickle.', 50.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(208, 19, 'Banana Walnut Cake Slice', 'Moist tea cake made with ripe bananas, cinnamon, and crunchy walnut pieces.', 90.00, 1, 'Bakery', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(209, 19, 'Filter Coffee Flask (500ml)', 'Freshly brewed aromatic South Indian filter coffee in a convenient heat flask.', 140.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 20: Mani's Dum Biryani (IDs: 210 - 220)
-- =============================================================================
(210, 20, 'Mani\'s Special Chicken Dum Biryani', 'Slow-cooked spiced basmati rice with tender bone-in chicken marinated in secret spices.', 310.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(211, 20, 'Mani\'s Special Mutton Dum Biryani', 'Flavor-packed dum biryani with soft mutton pieces, served with onion raita and gravy.', 410.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(212, 20, 'Mani\'s Special Egg Biryani', 'Fragrant basmati dum rice cooked with fried boiled eggs and authentic home-ground masala.', 240.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(213, 20, 'Mani\'s Veg Dum Biryani', 'Fresh seasonal vegetables cooked with saffron rice and minty biryani spices.', 220.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(214, 20, 'Chicken Pepper Fry', 'Succulent chicken pieces roasted dry with crushed black pepper, curry leaves, and green chillies.', 270.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(215, 20, 'Guntur Chilli Chicken', 'Fiery Andhra chicken tossed with famous spicy Guntur red chillies and garlic.', 280.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(216, 20, 'Andhra Fish Fry', 'Fresh fish steaks coated with spicy masala paste and shallow fried to crisp perfection.', 340.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(217, 20, 'Chicken Kebab Andhra Style', 'Crispy deep-fried chicken bites tossed with lemon juice and chaat masala.', 260.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(218, 20, 'Andhra Chicken Curry', 'Spicy country style chicken curry simmered with poppy seeds and coconut paste.', 290.00, 1, 'Curries', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(219, 20, 'Phulka with Ghee (3 pcs)', 'Soft, puffy whole wheat flatbreads brushed with warm desi ghee.', 60.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(220, 20, 'Double Ka Meetha', 'Traditional Hyderabadi dessert made with fried bread soaked in saffron rabri and nuts.', 110.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 21: Leon's Burgers & Wings (IDs: 221 - 231)
-- =============================================================================
(221, 21, 'Leon\'s Signature Grilled Chicken Burger', 'Flame-grilled spiced chicken patty with crisp lettuce, pickled gherkins, and smoked chipotle mayo.', 240.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=600&auto=format&fit=crop&q=80'),
(222, 21, 'Royal Mutton Smash Burger', 'Juicy minced lamb smash patty topped with melted cheese, caramelized onions, and BBQ sauce.', 320.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(223, 21, 'Crispy Fried Chicken Zinger Burger', 'Extra crunchy fried chicken breast, spicy mayo, and fresh shredded iceberg lettuce.', 250.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=600&auto=format&fit=crop&q=80'),
(224, 21, 'Cheesy Veggie Supreme Burger', 'Crisp vegetable patty with double melted cheese, tomatoes, and tangy burger relish.', 190.00, 1, 'Burgers', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(225, 21, 'Crispy BBQ Chicken Wings (6 pcs)', 'Crispy fried wings tossed in rich, sticky smoky American barbecue glaze.', 230.00, 1, 'Wings', NOW(), NOW(), 'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&auto=format&fit=crop&q=80'),
(226, 21, 'Fiery Peri Peri Wings (6 pcs)', 'Extra spicy wings tossed in fiery African bird eye chili peri peri sauce.', 240.00, 1, 'Wings', NOW(), NOW(), 'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&auto=format&fit=crop&q=80'),
(227, 21, 'Leon\'s Crispy Chicken Strips (4 pcs)', 'Tender chicken breast fillets battered and deep-fried until golden, with garlic dip.', 210.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1562967914-608f82629710?w=600&auto=format&fit=crop&q=80'),
(228, 21, 'Spicy Chicken Wrap Roll', 'Crispy chicken tenders, lettuce, jalapenos, and chipotle mayo rolled in a warm tortilla.', 200.00, 1, 'Wraps', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(229, 21, 'Cheesy Jalapeno Fries', 'Crispy French fries loaded with molten cheese sauce and sliced spicy pickled jalapenos.', 150.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600&auto=format&fit=crop&q=80'),
(230, 21, 'Garlic Mayo & Peri Dip Combo', 'Creamy garlic aioli and fiery peri peri dipping sauce.', 40.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=600&auto=format&fit=crop&q=80'),
(231, 21, 'KitKat Krush Thick Shake', 'Creamy vanilla shake blended with crispy crushed KitKat chocolate bars.', 180.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 22: The Fatty Bao Asian Gastrobar (IDs: 232 - 242)
-- =============================================================================
(232, 22, 'Teriyaki Chicken Bao (2 pcs)', 'Steamed lotus buns stuffed with glazed teriyaki chicken, pickled cucumber, and sesame seeds.', 290.00, 1, 'Baos', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(233, 22, 'Char Siu Pork Bao (2 pcs)', 'Fluffy steamed buns stuffed with slow-braised barbecue pork belly and scallions.', 320.00, 1, 'Baos', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(234, 22, 'Crispy Tofu & Mushroom Bao (2 pcs)', 'Steamed bao stuffed with crispy spiced tofu, shiitake mushrooms, and spicy mayo.', 260.00, 1, 'Baos', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(235, 22, 'Spicy Miso Ramen Bowl', 'Authentic wheat noodles in rich aromatic miso broth topped with bok choy, soft boiled egg, and scallions.', 390.00, 1, 'Ramen', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(236, 22, 'Tonkotsu Pork Ramen Bowl', 'Slow-cooked rich pork broth with ramen noodles, chashu pork slices, nori, and bamboo shoots.', 440.00, 1, 'Ramen', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(237, 22, 'Prawn & Chive Dimsums (4 pcs)', 'Translucent steamed crystal dumplings packed with juicy prawns and garlic chives.', 340.00, 1, 'Dimsums', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(238, 22, 'Wild Mushroom & Truffle Dimsums (4 pcs)', 'Steamed delicate dumplings stuffed with wild mushrooms and scented with truffle oil.', 310.00, 1, 'Dimsums', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(239, 22, 'Pad Thai Noodles with Tofu', 'Stir-fried flat rice noodles with tamarind, sprouts, crushed peanuts, and fresh lime.', 330.00, 1, 'Noodles', NOW(), NOW(), 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
(240, 22, 'Crispy Duck Rolls with Plum Dip', 'Crispy spring rolls filled with shredded roast duck, served with sweet plum dipping sauce.', 380.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80'),
(241, 22, 'Japanese Katsu Chicken Curry Rice', 'Crispy panko chicken cutlet served with savory Japanese curry sauce and steamed rice.', 390.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80'),
(242, 22, 'Matcha Green Tea Mousse', 'Light and airy dessert infused with Japanese matcha green tea and white chocolate.', 220.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 23: A2B - Adyar Ananda Bhavan (IDs: 243 - 253)
-- =============================================================================
(243, 23, 'Special Mysore Pak Box', 'Traditional melt-in-mouth sweet prepared with pure desi ghee, gram flour, and sugar.', 180.00, 1, 'Sweets', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(244, 23, 'Kaju Katli Premium Box', 'Diamond-shaped traditional Indian sweet made with rich cashew nut paste and silver vark.', 260.00, 1, 'Sweets', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(245, 23, 'Motichoor Laddu Box', 'Fine gram flour pearls fried in ghee and soaked in cardamom-flavored saffron syrup.', 160.00, 1, 'Sweets', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(246, 23, 'Dahi Puri Chaat Platter', 'Crispy hollow puris filled with potatoes, sweetened curd, tamarind chutney, and crunchy sev.', 120.00, 1, 'Chaats', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(247, 23, 'Pani Puri Street Platter (8 pcs)', 'Crispy puris served with spicy mint pani, sweet tamarind chutney, and potato chickpea filling.', 90.00, 1, 'Chaats', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(248, 23, 'Pav Bhaji Special Double Pav', 'Spicy mashed vegetable gravy topped with butter, served with two toasted soft pavs.', 140.00, 1, 'Chaats', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(249, 23, 'Ghee Podi Masala Dosa', 'Crispy dosa smeared with spiced gunpowder and desi ghee, stuffed with potato masala.', 150.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(250, 23, 'Mini Ghee Idlis in Sambar (14 pcs)', 'Button idlis floating in hot piping spiced sambar topped with pure ghee.', 110.00, 1, 'South Indian', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(251, 23, 'Crispy Onion Pakoda', 'Golden deep-fried fritters made with sliced onions, curry leaves, and gram flour.', 80.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(252, 23, 'Kara Boondi Mixture Pouch', 'Spicy, crunchy fried gram flour pearls seasoned with curry leaves and peanuts.', 70.00, 1, 'Snacks', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(253, 23, 'Madras Special Filter Coffee', 'Strong authentic filter coffee brewed fresh with rich frothy milk.', 40.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 24: California Burrito (IDs: 254 - 264)
-- =============================================================================
(254, 24, 'Grilled Chicken Burrito Bowl', 'Warm bowl layered with grilled chicken, Mexican rice, pinto beans, salsa, and melted Monterey Jack cheese.', 290.00, 1, 'Mexican', NOW(), NOW(), 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
(255, 24, 'BBQ Paneer Burrito Bowl', 'Seasoned grilled paneer, black beans, fajita veggies, cilantro rice, and creamy chipotle mayo.', 260.00, 1, 'Mexican', NOW(), NOW(), 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
(256, 24, 'Peri Peri Chicken Rolled Burrito', 'Large flour tortilla rolled with fiery grilled chicken, seasoned rice, cheese, and pico de gallo.', 280.00, 1, 'Mexican', NOW(), NOW(), 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
(257, 24, 'Cheesy Beans & Salsa Burrito', 'Soft tortilla wrapped with refried beans, cheddar, jalapenos, and sour cream.', 240.00, 1, 'Mexican', NOW(), NOW(), 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
(258, 24, 'Crispy Hard Shell Tacos (3 pcs)', 'Crispy corn shells filled with seasoned fillings, shredded lettuce, salsa, and cheese.', 220.00, 1, 'Mexican', NOW(), NOW(), 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
(259, 24, 'Cheesy Chicken Quesadilla', 'Grilled flour tortilla stuffed with spiced chicken, melted cheeses, and served with salsa.', 260.00, 1, 'Mexican', NOW(), NOW(), 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
(260, 24, 'Crispy Nachos with Guacamole Dip', 'Freshly fried golden corn chips served with freshly mashed Hass avocado guacamole.', 160.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=600&auto=format&fit=crop&q=80'),
(261, 24, 'Loaded Fiesta Nachos Grande', 'Warm tortilla chips piled high with black beans, warm queso, salsa fresca, and jalapenos.', 230.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=600&auto=format&fit=crop&q=80'),
(262, 24, 'Mexican Sweet Corn Salad (Elote)', 'Grilled sweet corn tossed with lime juice, cotija cheese, chili powder, and cilantro.', 140.00, 1, 'Sides', NOW(), NOW(), 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80'),
(263, 24, 'Cinnamon Churros with Dulce de Leche', 'Crispy fried Mexican pastry tossed in cinnamon sugar, served with warm caramel dip.', 160.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(264, 24, 'Fresh Lemon Mint Cooler', 'Fresh lime juice infused with fresh mint leaves and chilled sparkling soda.', 90.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 25: Dindigul Thalappakatti (IDs: 265 - 275)
-- =============================================================================
(265, 25, 'Thalappakatti Mutton Biryani', 'Original Dindigul recipe using aromatic Seeraga Samba rice and tender farm-fresh mutton pieces.', 410.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(266, 25, 'Thalappakatti Chicken Biryani', 'Authentic Seeraga samba biryani cooked with tender chicken and signature home-blended spices.', 320.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(267, 25, 'Thalappakatti Egg Biryani', 'Fragrant Seeraga samba rice cooked with boiled eggs and aromatic Dindigul masala.', 240.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(268, 25, 'Chettinad Pepper Chicken Dry', 'Boneless chicken cubes sautéed with coarse black pepper, shallots, and fragrant curry leaves.', 280.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(269, 25, 'Mutton Kola Urundai (4 pcs)', 'Crispy spiced minced mutton meatballs seasoned with traditional Tamil Nadu spices.', 320.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(270, 25, 'Nattu Kozhi Chicken Roast', 'Country chicken pieces cooked semi-dry with small onions, crushed garlic, and curry leaves.', 340.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(271, 25, 'Thalappakatti Fish Fry', 'Seer fish slice marinated with spicy red masala paste and tawa roasted with curry leaves.', 330.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(272, 25, 'Chettinad Mutton Chops Gravy', 'Tender mutton chops simmered in thick spicy roasted Chettinad masala gravy.', 390.00, 1, 'Curries', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(273, 25, 'Chicken Kothu Parotta', 'Shredded flaky parotta stir-fried on hot iron griddle with chicken curry, egg, and onions.', 260.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(274, 25, 'Veechu Parotta (2 pcs)', 'Thin stretched layered South Indian flatbread cooked crisp with oil on tawa.', 80.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(275, 25, 'Karupatti Halwa (Palm Jaggery Halwa)', 'Traditional Tirunelveli sweet prepared with pure palm jaggery, wheat milk, and ghee.', 120.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 26: Keventers Milkshakes & Desserts (IDs: 276 - 286)
-- =============================================================================
(276, 26, 'Chocolate Hazelnut Thick Shake', 'Classic thick cold shake blended with rich roasted hazelnut cocoa paste in iconic glass bottle.', 190.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(277, 26, 'Alphonso Mango Sundae', 'Creamy mango ice cream scoops layered with real Alphonso mango pulp and white chocolate drops.', 170.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(278, 26, 'Classic Strawberry Milkshake', 'Thick creamy milkshake infused with natural strawberry fruit reduction.', 160.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(279, 26, 'Butterscotch Crunch Milkshake', 'Rich butterscotch ice cream shake blended with crunchy caramelized praline bits.', 170.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(280, 26, 'Lotus Biscoff Freakshake', 'Over-the-top thick milkshake with Biscoff cookie spread, crushed biscuits, and whipped cream.', 220.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(281, 26, 'Cold Coffee with Vanilla Gelato', 'Rich blended espresso cold coffee served with a floating scoop of vanilla gelato.', 170.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(282, 26, 'KitKat Choco Crunch Shake', 'Thick chocolate milkshake packed with crunchy crushed KitKat fingers.', 190.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80'),
(283, 26, 'Dark Hot Chocolate Cup', 'Steaming mug of rich melted dark Belgian chocolate finished with marshmallows.', 140.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),
(284, 26, 'Nutella Waffle Bites', 'Crispy bite-sized waffle pieces drizzled with warm Nutella and powdered sugar.', 150.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(285, 26, 'Berry Blast Ice Cream Sundae', 'Mixed berry ice cream scoops topped with raspberry syrup and white choco curls.', 180.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),
(286, 26, 'Choco Brownie Sundae with Fudge', 'Warm brownie chunks layered with dark chocolate ice cream and hot chocolate fudge.', 190.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 27: Smoke House Deli (IDs: 287 - 297)
-- =============================================================================
(287, 27, 'Wild Mushroom & Truffle Risotto', 'Creamy Arborio rice cooked with porcini and button mushrooms, finished with parmesan and truffle oil.', 480.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(288, 27, 'Smoked Chicken & Brie Bagel', 'Toasted artisan sesame bagel stuffed with smoked chicken breast, French brie cheese, and rocket leaves.', 320.00, 1, 'Sandwiches', NOW(), NOW(), 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80'),
(289, 27, 'Classic Eggs Benedict', 'Poached farm eggs served on toasted English muffins with smoked ham and creamy hollandaise.', 290.00, 1, 'Breakfast', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(290, 27, 'Fluffy Buttermilk Pancakes', 'Stack of three golden buttermilk pancakes served with pure Canadian maple syrup and whipped butter.', 260.00, 1, 'Breakfast', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(291, 27, 'Grilled Tenderloin Steak', 'Prime grilled tenderloin steak served with red wine jus, roast garlic mash, and asparagus.', 540.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80'),
(292, 27, 'Smoked Salmon Bruschetta', 'Artisan sourdough crostini topped with Norwegian smoked salmon, capers, and dill cream cheese.', 390.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?w=600&auto=format&fit=crop&q=80'),
(293, 27, 'Peri Peri Roast Chicken', 'Half roast chicken marinated in bird eye chili rub, served with seasonal vegetables.', 460.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(294, 27, 'Aglio Olio Peperoncino Spaghetti', 'Spaghetti tossed with golden sliced garlic, extra virgin olive oil, chili flakes, and parsley.', 360.00, 1, 'Pasta', NOW(), NOW(), 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&auto=format&fit=crop&q=80'),
(295, 27, 'Deli Caesar Salad with Shaved Parmesan', 'Crisp romaine lettuce hearts, herb croutons, creamy Caesar dressing, and shaved parmesan.', 310.00, 1, 'Salads', NOW(), NOW(), 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop&q=80'),
(296, 27, 'Flourless Chocolate Fudge Cake', 'Dense gluten-free rich dark chocolate fudge cake served with vanilla bean cream.', 240.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),
(297, 27, 'Fresh Berry Kombucha', 'Naturally fermented sparkling probiotic tea infused with wild raspberries and blueberries.', 180.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 28: Anjappar Chettinad Restaurant (IDs: 298 - 308)
-- =============================================================================
(298, 28, 'Chettinad Chicken Masala Curry', 'Spicy aromatic country chicken curry cooked with dry roasted spices and coconut paste.', 310.00, 1, 'Curries', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(299, 28, 'Anjappar Special Mutton Sukka', 'Tender boneless mutton pieces roasted dry with small shallots, garlic, and cracked pepper.', 380.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(300, 28, 'Ceylon Flaky Parotta (2 pcs)', 'Multi-layered flaky South Indian flatbread grilled crisp on tawa.', 80.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(301, 28, 'Chettinad Chicken Dum Biryani', 'Spicy Tamil Nadu style dum biryani packed with tender chicken and aromatic herbs.', 320.00, 1, 'Biryani', NOW(), NOW(), 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80'),
(302, 28, 'Nethili Fish Fry (Anchovies)', 'Crispy fried small anchovies marinated in spicy Chettinad masala.', 280.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(303, 28, 'Chettinad Crab Masala', 'Whole fresh crab cooked in fiery black pepper and roasted coconut gravy.', 420.00, 1, 'Seafood', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(304, 28, 'Chicken Lollipop Chettinad (5 pcs)', 'Crispy spiced chicken wingettes served with hot and spicy dipping sauce.', 270.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80'),
(305, 28, 'Prawn Thokku Masala', 'Juicy fresh prawns cooked in spicy onion-tomato masala with curry leaves.', 390.00, 1, 'Seafood', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(306, 28, 'Ennai Kathirikai (Baby Brinjal Curry)', 'Small eggplants stuffed with Chettinad spices cooked in tangy sesame oil gravy.', 220.00, 1, 'Curries', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(307, 28, 'Chicken Kothu Parotta', 'Shredded parotta minced with chicken, eggs, onions, and spicy salna on a hot griddle.', 250.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(308, 28, 'Elaneer Payasam', 'Chilled dessert made with tender coconut pulp, coconut milk, and cardamom.', 130.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 29: Belgian Waffle Co. (IDs: 309 - 319)
-- =============================================================================
(309, 29, 'Triple Chocolate Waffle', 'Crispy dark chocolate waffle filled with melted milk and white chocolate sauce.', 160.00, 1, 'Waffles', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(310, 29, 'Red Velvet Cream Cheese Waffle', 'Vibrant red velvet waffle layered with sweet vanilla cream cheese spread.', 170.00, 1, 'Waffles', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(311, 29, 'Nutella Loaded Waffle', 'Warm golden crispy waffle smothered in thick hazelnut Nutella spread.', 180.00, 1, 'Waffles', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(312, 29, 'Belgian Dark Chocolate Waffle', 'Rich dark cocoa waffle filled with melted premium 70% dark Belgian chocolate.', 150.00, 1, 'Waffles', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(313, 29, 'Almond Butter & Honey Waffle', 'Golden waffle topped with roasted almond butter, crushed nuts, and pure wild honey.', 160.00, 1, 'Waffles', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(314, 29, 'Kiki & Cream (Oreo) Waffle', 'Crisp waffle stuffed with crushed Oreo cookies and vanilla cream frosting.', 160.00, 1, 'Waffles', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(315, 29, 'Maple Butter Mini Pancakes (8 pcs)', 'Bite-sized fluffy Dutch mini pancakes drizzled with maple syrup and butter.', 140.00, 1, 'Pancakes', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(316, 29, 'Dutch Choco Mini Pancakes (8 pcs)', 'Warm mini pancakes drenched in molten milk chocolate and cocoa pearls.', 160.00, 1, 'Pancakes', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(317, 29, 'Ice Cream Waffle Sandwich', 'Crispy waffle sandwich stuffed with a generous slab of vanilla bean ice cream.', 190.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(318, 29, 'Warm Brownie Waffle', 'Dark waffle infused with crushed brownie pieces and hot fudge drizzle.', 170.00, 1, 'Waffles', NOW(), NOW(), 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=600&auto=format&fit=crop&q=80'),
(319, 29, 'Iced Cafe Mocha', 'Chilled blend of espresso, dark chocolate sauce, and cold milk.', 130.00, 1, 'Beverages', NOW(), NOW(), 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=600&auto=format&fit=crop&q=80'),

-- =============================================================================
-- Restaurant 30: Karavalli Coastal Kitchen (IDs: 320 - 330)
-- =============================================================================
(320, 30, 'Mangalore Anjal (King Fish) Fry', 'Fresh king fish steak marinated in spicy Kundapur chili paste and rava tawa fried.', 490.00, 1, 'Seafood', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(321, 30, 'Kori Rotti with Chicken Curry', 'Crispy dry rice wafers served with authentic Mangalorean coconut chicken curry.', 380.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=600&auto=format&fit=crop&q=80'),
(322, 30, 'Mangalorean Prawn Ghee Roast', 'Juicy tiger prawns roasted in pure ghee with fiery Byadgi chili and spice paste.', 460.00, 1, 'Seafood', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(323, 30, 'Crab Butter Garlic Masala', 'Fresh mud crab cooked in aromatic garlic butter sauce and coastal spices.', 520.00, 1, 'Seafood', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(324, 30, 'Alleppey Fish Curry with Raw Mango', 'Fresh sea bass simmered in coconut milk with tangy raw mango slices and green chillies.', 420.00, 1, 'Curries', NOW(), NOW(), 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80'),
(325, 30, 'Kundapur Chicken Sukka', 'Country chicken tossed with dry roasted grated coconut and aromatic coastal masala.', 340.00, 1, 'Starters', NOW(), NOW(), 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=600&auto=format&fit=crop&q=80'),
(326, 30, 'Neer Dosa (4 pcs)', 'Delicate, soft and lacy rice crepes served with coconut chutney and sagu.', 100.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=600&auto=format&fit=crop&q=80'),
(327, 30, 'Appam with Vegetable Stew', 'Bowl-shaped fermented rice pancakes with soft center, served with coconut vegetable stew.', 140.00, 1, 'Mains', NOW(), NOW(), 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=600&auto=format&fit=crop&q=80'),
(328, 30, 'Malabar Flaky Parotta (2 pcs)', 'Layered Kerala style crisp flatbread toasted on tawa.', 80.00, 1, 'Breads', NOW(), NOW(), 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600&auto=format&fit=crop&q=80'),
(329, 30, 'Steamed Red Rice with Fish Curry', 'Traditional Kerala matta red rice served with spicy coconut fish curry.', 220.00, 1, 'Meals', NOW(), NOW(), 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&auto=format&fit=crop&q=80'),
(330, 30, 'Tender Coconut Souffle', 'Delicate chilled dessert prepared with fresh tender coconut water, malai, and cream.', 190.00, 1, 'Desserts', NOW(), NOW(), 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80');

-- -----------------------------------------------------------------------------
-- PHASE 4: INSERT 20 SAMPLE ORDERS (Delivered, In-Progress, and Tracking tests)
-- -----------------------------------------------------------------------------
INSERT INTO `orders` (OrderID, UserID, RestaurantID, OrderDate, TotalAmount, Status, PaymentMethod, Payment_Status) VALUES
(1, 11, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), 770.00, 'DELIVERED', 'UPI', 'PAID'),
(2, 12, 2, DATE_SUB(NOW(), INTERVAL 4 DAY), 510.00, 'DELIVERED', 'CARD', 'PAID'),
(3, 13, 4, DATE_SUB(NOW(), INTERVAL 3 DAY), 450.00, 'DELIVERED', 'UPI', 'PAID'),
(4, 14, 3, DATE_SUB(NOW(), INTERVAL 2 DAY), 390.00, 'DELIVERED', 'COD', 'PAID'),
(5, 15, 7, DATE_SUB(NOW(), INTERVAL 2 DAY), 470.00, 'DELIVERED', 'UPI', 'PAID'),
(6, 16, 9, DATE_SUB(NOW(), INTERVAL 1 DAY), 420.00, 'DELIVERED', 'UPI', 'PAID'),
(7, 17, 10, DATE_SUB(NOW(), INTERVAL 1 DAY), 630.00, 'DELIVERED', 'CARD', 'PAID'),
(8, 18, 6, DATE_SUB(NOW(), INTERVAL 18 HOUR), 420.00, 'DELIVERED', 'UPI', 'PAID'),
(9, 19, 11, DATE_SUB(NOW(), INTERVAL 12 HOUR), 230.00, 'DELIVERED', 'UPI', 'PAID'),
(10, 20, 14, DATE_SUB(NOW(), INTERVAL 8 HOUR), 700.00, 'DELIVERED', 'CARD', 'PAID'),
(11, 11, 5, DATE_SUB(NOW(), INTERVAL 25 MINUTE), 520.00, 'OUT_FOR_DELIVERY', 'UPI', 'PAID'),
(12, 12, 12, DATE_SUB(NOW(), INTERVAL 15 MINUTE), 405.00, 'PREPARING', 'UPI', 'PAID'),
(13, 15, 1, DATE_SUB(NOW(), INTERVAL 10 MINUTE), 590.00, 'CONFIRMED', 'UPI', 'PAID'),
(14, 21, 21, DATE_SUB(NOW(), INTERVAL 5 MINUTE), 470.00, 'PLACED', 'COD', 'PENDING'),
(15, 22, 17, DATE_SUB(NOW(), INTERVAL 2 DAY), 750.00, 'CANCELLED', 'CARD', 'REFUNDED'),
(16, 23, 15, DATE_SUB(NOW(), INTERVAL 1 DAY), 470.00, 'DELIVERED', 'UPI', 'PAID'),
(17, 24, 16, DATE_SUB(NOW(), INTERVAL 3 DAY), 600.00, 'DELIVERED', 'UPI', 'PAID'),
(18, 25, 20, DATE_SUB(NOW(), INTERVAL 4 DAY), 510.00, 'DELIVERED', 'UPI', 'PAID'),
(19, 26, 29, DATE_SUB(NOW(), INTERVAL 2 DAY), 330.00, 'DELIVERED', 'UPI', 'PAID'),
(20, 27, 30, DATE_SUB(NOW(), INTERVAL 1 DAY), 870.00, 'DELIVERED', 'CARD', 'PAID');

-- -----------------------------------------------------------------------------
-- PHASE 5: INSERT ORDER ITEMS (Line Items for all 20 Orders)
-- -----------------------------------------------------------------------------
INSERT INTO `orderitem` (OrderItemID, OrderID, MenuID, Quantity, ItemTotal) VALUES
-- Order 1 (Restaurant 1, Total: 770)
(1, 1, 1, 1, 420.00),
(2, 1, 2, 1, 350.00),

-- Order 2 (Restaurant 2, Total: 510)
(3, 2, 12, 1, 320.00),
(4, 2, 16, 1, 190.00),

-- Order 3 (Restaurant 4, Total: 450)
(5, 3, 34, 1, 290.00),
(6, 3, 39, 1, 160.00),

-- Order 4 (Restaurant 3, Total: 390)
(7, 4, 23, 2, 280.00),
(8, 4, 27, 1, 110.00),

-- Order 5 (Restaurant 7, Total: 470)
(9, 5, 67, 1, 280.00),
(10, 5, 75, 1, 190.00),

-- Order 6 (Restaurant 9, Total: 420)
(11, 6, 89, 1, 240.00),
(12, 6, 90, 1, 180.00),

-- Order 7 (Restaurant 10, Total: 630)
(13, 7, 100, 1, 360.00),
(14, 7, 104, 1, 270.00),

-- Order 8 (Restaurant 6, Total: 420)
(15, 8, 59, 1, 260.00),
(16, 8, 63, 2, 160.00),

-- Order 9 (Restaurant 11, Total: 230)
(17, 9, 111, 2, 190.00),
(18, 9, 120, 1, 40.00),

-- Order 10 (Restaurant 14, Total: 700)
(19, 10, 144, 1, 440.00),
(20, 10, 147, 1, 260.00),

-- Order 11 (Restaurant 5, Total: 520) - Live Out for Delivery
(21, 11, 48, 1, 230.00),
(22, 11, 50, 1, 290.00),

-- Order 12 (Restaurant 12, Total: 405) - Live Preparing
(23, 12, 122, 1, 85.00),
(24, 12, 124, 1, 320.00),

-- Order 13 (Restaurant 1, Total: 590) - Live Confirmed
(25, 13, 5, 1, 310.00),
(26, 13, 7, 1, 280.00),

-- Order 14 (Restaurant 21, Total: 470) - Live Placed
(27, 14, 221, 1, 240.00),
(28, 14, 225, 1, 230.00),

-- Order 15 (Restaurant 17, Total: 750) - Cancelled
(29, 15, 177, 1, 490.00),
(30, 15, 180, 1, 260.00),

-- Order 16 (Restaurant 15, Total: 470)
(31, 16, 155, 1, 180.00),
(32, 16, 156, 1, 290.00),

-- Order 17 (Restaurant 16, Total: 600)
(33, 17, 166, 1, 260.00),
(34, 17, 167, 1, 340.00),

-- Order 18 (Restaurant 20, Total: 510)
(35, 18, 212, 1, 240.00),
(36, 18, 214, 1, 270.00),

-- Order 19 (Restaurant 29, Total: 330)
(37, 19, 309, 1, 160.00),
(38, 19, 310, 1, 170.00),

-- Order 20 (Restaurant 30, Total: 870)
(39, 20, 320, 1, 490.00),
(40, 20, 321, 1, 380.00);
