-- ========================================================
-- GANAAN BURGER & FAST FOOD RESTAURANT MANAGEMENT SYSTEM
-- Database Schema & Sample Data for MySQL / MariaDB
-- Magaca Database-ka: ganaan_burger_db
-- ========================================================

CREATE DATABASE IF NOT EXISTS `ganaan_burger_db` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `ganaan_burger_db`;

-- --------------------------------------------------------
-- 1. Table: categories (Qeybaha Cuntada)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `product_addons`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `customers`;
DROP TABLE IF EXISTS `restaurant_settings`;

CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `name_so` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(100) NOT NULL UNIQUE,
    `icon` VARCHAR(50) DEFAULT 'utensils',
    `description` TEXT,
    `is_active` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 2. Table: products (Cuntooyinka iyo Cabitaannada)
-- --------------------------------------------------------
CREATE TABLE `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `name` VARCHAR(150) NOT NULL,
    `name_so` VARCHAR(150) NOT NULL,
    `description` TEXT,
    `description_so` TEXT,
    `price` DECIMAL(10,2) NOT NULL,
    `image_url` VARCHAR(500) NOT NULL,
    `is_available` TINYINT(1) DEFAULT 1,
    `is_featured` TINYINT(1) DEFAULT 0,
    `preparation_time_mins` INT DEFAULT 10,
    `calories` INT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 3. Table: product_addons (Waxyaabaha dheeraadka ah sida Cheese, Sauce)
-- --------------------------------------------------------
CREATE TABLE `product_addons` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT DEFAULT NULL,
    `name` VARCHAR(100) NOT NULL,
    `name_so` VARCHAR(100) NOT NULL,
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT `fk_addons_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 4. Table: customers (Macaamiisha)
-- --------------------------------------------------------
CREATE TABLE `customers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(150) NOT NULL,
    `phone` VARCHAR(50) NOT NULL,
    `address` TEXT,
    `city` VARCHAR(100) DEFAULT 'Mogadishu',
    `total_orders` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 5. Table: orders (Dalabyada / Orders)
-- --------------------------------------------------------
CREATE TABLE `orders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_number` VARCHAR(30) NOT NULL UNIQUE,
    `customer_name` VARCHAR(150) NOT NULL,
    `customer_phone` VARCHAR(50) NOT NULL,
    `order_type` ENUM('dine_in', 'takeaway', 'delivery') NOT NULL DEFAULT 'dine_in',
    `table_number` VARCHAR(20) DEFAULT NULL,
    `delivery_address` TEXT DEFAULT NULL,
    `subtotal` DECIMAL(10,2) NOT NULL,
    `tax` DECIMAL(10,2) DEFAULT 0.00,
    `delivery_fee` DECIMAL(10,2) DEFAULT 0.00,
    `total_amount` DECIMAL(10,2) NOT NULL,
    `payment_method` ENUM('EVC_PLUS', 'ZAAD', 'SAHAL', 'CASH', 'CREDIT_CARD') NOT NULL DEFAULT 'EVC_PLUS',
    `payment_status` ENUM('pending', 'paid', 'refunded') NOT NULL DEFAULT 'pending',
    `order_status` ENUM('pending', 'cooking', 'ready', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    `notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 6. Table: order_items (Cuntooyinka ku jira dalab kasta)
-- --------------------------------------------------------
CREATE TABLE `order_items` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `product_name` VARCHAR(150) NOT NULL,
    `price` DECIMAL(10,2) NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `addons_detail` TEXT,
    `subtotal` DECIMAL(10,2) NOT NULL,
    CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 7. Table: restaurant_settings (Settings-ka Muqayadda)
-- --------------------------------------------------------
CREATE TABLE `restaurant_settings` (
    `setting_key` VARCHAR(100) PRIMARY KEY,
    `setting_value` TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- GELINTA MACLUUMAADKA BILOWGA AH (SAMPLE DATA)
-- --------------------------------------------------------

-- Qeybaha Cuntada (Categories)
INSERT INTO `categories` (`id`, `name`, `name_so`, `slug`, `icon`, `description`) VALUES
(1, 'Burgers', 'Noocyada Burger-ka', 'burgers', 'sandwich', 'Hilib lo\'ad & digaag diyaarsan oo la dubay oo leh jiis macaan'),
(2, 'Shawarma', 'Shuwarmo & Duub', 'shawarma', 'utensils-alt', 'Shuwarmo Carabi caraf badan leh oo hilib ama digaag ah'),
(3, 'Drinks & Fresh Juice', 'Cabitaanno & Casiirro', 'drinks', 'coffee', 'Casiirro dabiici ah, Shaah caddiis, Milkshake & Qabow'),
(4, 'Sides & Combos', 'Cuntooyin Raacis ah', 'sides', 'sparkles', 'Faraas qallalan, Onion rings, iyo jiis shiilan');

-- Cuntooyinka (Products)
INSERT INTO `products` (`id`, `category_id`, `name`, `name_so`, `description`, `description_so`, `price`, `image_url`, `is_available`, `is_featured`, `preparation_time_mins`, `calories`) VALUES
-- 1. Burgers
(1, 1, 'Ganaan Signature Beef Burger', 'Ganaan Burger Khaas ah', 'Juicy Angus beef patty with cheddar cheese, fresh lettuce, tomato, caramelized onions and Ganaan secret sauce.', 'Hilib dibi oo jilicsan, jiis cheddar dhalaalaya, basal macaan oo guduudan iyo suugo qarsoodi ah oo Ganaan.', 4.50, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80', 1, 1, 12, 650),
(2, 1, 'Crispy Zinger Chicken Burger', 'Burger Digaag Qallalan', 'Extra crispy seasoned chicken breast, spicy coleslaw, jalapeños, and creamy garlic mayonnaise on a toasted brioche.', 'Digaag subag ku qallalan oo basbaas leh, coleslaw jilicsan iyo suugo toom ku jirto brioche jilicsan.', 5.00, 'https://images.unsplash.com/photo-1625813506062-0aeb1d7a094b?auto=format&fit=crop&w=800&q=80', 1, 1, 15, 680),
(3, 1, 'Double Smash Cheeseburger', 'Labalaab Jiis Burger', 'Two thin smashed beef patties, double melted American cheese, crisp pickles, mustard & grilled diced onions.', 'Labo cad oo hilib duban ah, labo lakab oo jiis ah, khajaar qajaar dhanaan ah iyo suugo macaan.', 6.50, 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=800&q=80', 1, 1, 12, 850),
(4, 1, 'Smoky BBQ Bacon Burger', 'Burger BBQ & Hilib Doofaar La\'aan ah', 'Halal smoky strips, beef patty, crispy onion rings, sharp cheese, and rich Kansas BBQ sauce.', 'Hilib duban oo leh maraq BBQ qiiq caraf leh, halxidhaale basaleed qallalan iyo jiis macaan.', 5.50, 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?auto=format&fit=crop&w=800&q=80', 1, 0, 14, 720),
(5, 1, 'Mushroom Swiss Truffle Burger', 'Burger likaha & Jiiska Swiss-ka', 'Gourmet beef patty loaded with butter sautéed mushrooms, Swiss cheese, and fragrant truffle aioli.', 'Hilib jilicsan oo lagu kor daray likaha lagu shiilay subag iyo jiis Swiss heer sare ah.', 5.80, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80', 1, 0, 15, 690),

-- 2. Shawarma (Shuwarmo)
(6, 2, 'Ganaan Signature Chicken Shawarma', 'Shuwarmo Digaag Ganaan', 'Spiced slow-roasted chicken, rich garlic toum sauce, french fries, and pickled cucumbers rolled in toasted saj bread.', 'Digaag si qunyar ah loo dubay oo xawaash caraf leh ku jira, toom lagu daray khajaar iyo baradho la duubay.', 3.50, 'https://images.unsplash.com/photo-1561651823-34feb02250e4?auto=format&fit=crop&w=800&q=80', 1, 1, 8, 520),
(7, 2, 'Premium Beef Shawarma Roll', 'Shuwarmo Hilib Dibi Roll', 'Tender sliced marinated beef with sesame tahini, sumac red onions, fresh parsley, and diced tomatoes.', 'Hilib lo\'ad oo jilicsan oo lagu qooyay tahini, basal guduudan oo sumac leh, iyo yaanyo cusub.', 4.20, 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=800&q=80', 1, 1, 10, 580),
(8, 2, 'Super Mixed Shawarma Plate', 'Saxan Shuwarmo Isku Dhafan', 'Generous platter of both chicken & beef shawarma, fragrant yellow spiced rice, garlic dip, hummus, pickles & pita.', 'Saxan weyn oo ay ku wada jiraan digaag iyo hilib, bariis caraf leh, suugo toom, xumus iyo rooti pita.', 7.00, 'https://images.unsplash.com/photo-1633321702518-7feccafb94d5?auto=format&fit=crop&w=800&q=80', 1, 1, 15, 820),
(9, 2, 'Spicy Mexican Shawarma Wrap', 'Shuwarmo Basbaas & Jalapeño', 'Chicken shawarma wrap with Mexican jalapeños, melted cheddar cheese, and spicy chipotle sauce.', 'Shuwarmo digaag oo basbaas ah, jalapeño, jiis cheddar iyo suugo basbaas macaan leh.', 4.00, 'https://images.unsplash.com/photo-1648838779953-f7efd18833fd?auto=format&fit=crop&w=800&q=80', 1, 0, 10, 550),

-- 3. Drinks & Juices (Cabitaanno)
(10, 3, 'Fresh Somali Sweet Mango Juice', 'Casiir Cambe Dabiici ah', '100% freshly pressed natural mango pulp served icy cold. Thick, sweet, and tropical.', 'Casiir cambe oo dabiici ah oo aad u qabow, macaan oo nafaqo badan.', 2.00, 'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=800&q=80', 1, 1, 3, 160),
(11, 3, 'Vimto Ice Slush & Mint', 'Vimto Baraf & Naacnaac', 'Classic ice-crushed Vimto with fresh mint sprigs, lemon slice, and cooling chill.', 'Vimto baraf la jajabiyay lagu daray caleenta naacnaaca iyo liin dhanaanta.', 1.50, 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=800&q=80', 1, 1, 3, 140),
(12, 3, 'Traditional Somali Spiced Tea (Shaah Caddiis)', 'Shaah Caddiis Carfaya', 'Authentic Somali milk tea brewed with crushed green cardamom, cinnamon quills, cloves and sweet condensed milk.', 'Shaah caddiis macaan oo lagu kariyay hayl, qorfe, dhego yare iyo caano jilicsan.', 1.00, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?auto=format&fit=crop&w=800&q=80', 1, 0, 4, 120),
(13, 3, 'Creamy Oreo Milkshake', 'Oreo Milkshake Macaan', 'Rich vanilla ice cream blended with real Oreo cookies, topped with whipped cream and chocolate drizzle.', 'Caano iyo jalaato la shiiday oo Oreo lagu daray, korkana kareem iyo shukulaato looga buufiyay.', 3.00, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=800&q=80', 1, 1, 5, 420),
(14, 3, 'Tropical Passion Fruit Mojito', 'Mojito Liin & Passion Fruit', 'Sparkling soda water, fresh passion fruit pulp, crushed lime, mint leaves and cane sugar over ice.', 'Cabitaan dhalaalaya oo qabow oo leh liin, naacnaac iyo midhaha macaan ee passion fruit.', 2.50, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=800&q=80', 1, 0, 4, 150),
(15, 3, 'Chilled Coca-Cola / Fanta Can', 'Kooko ama Fanta Qabow', '330ml ice cold canned soda served with a chilled cup and lemon wedge.', 'Kooko ama Fanta aad u qabow oo baraf laguugu shubayo.', 1.00, 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?auto=format&fit=crop&w=800&q=80', 1, 0, 1, 140),

-- 4. Sides & Combos (Raacis)
(16, 4, 'Crispy Golden French Fries', 'Baradho Shiilan (Faraas)', 'Skin-on golden potato fries tossed in seasoned salt. Served with garlic dip and ketchup.', 'Baradho shiilan oo qallalan oo lagu daray suugo toom iyo ketchup.', 1.50, 'https://images.unsplash.com/photo-1576107232684-1279f3908594?auto=format&fit=crop&w=800&q=80', 1, 1, 6, 320),
(17, 4, 'Cheesy Loaded Dynamite Fries', 'Faraas Jiis & Hilib Leh', 'Crispy fries topped with melted warm cheddar cheese, minced beef, jalapeños, and special dynamite sauce.', 'Baradho shiilan oo korka lagaga shubay jiis cheddar dhalaalaya, hilib iyo basbaas dynamite.', 3.50, 'https://images.unsplash.com/photo-1585109649139-366815a0d713?auto=format&fit=crop&w=800&q=80', 1, 1, 8, 540),
(18, 4, 'Mozzarella Cheese Sticks (5 pcs)', 'Jiis Mozzarella Shiilan (5 Xabbo)', 'Stretchy mozzarella cheese coated in herb breadcrumbs, fried crisp. Served with warm marinara dip.', 'Jiis mozzarella jilicsan oo la shiilay oo leh suugo yaanyo Talyaani ah.', 3.00, 'https://images.unsplash.com/photo-1531749668029-2db88e4276c7?auto=format&fit=crop&w=800&q=80', 1, 0, 6, 410);

-- Product Addons (Waxyaabaha Dheeraadka ah)
INSERT INTO `product_addons` (`product_id`, `name`, `name_so`, `price`) VALUES
(1, 'Extra Cheddar Cheese Slice', 'Jiis Dheeraad ah', 0.50),
(1, 'Double Beef Patty', 'Hilib Labalaab ah', 1.80),
(1, 'Caramelized Sweet Onions', 'Basal Macaan oo Duban', 0.40),
(2, 'Extra Spicy Jalapeño Sauce', 'Suugo Basbaas Dheeraad ah', 0.30),
(6, 'Extra Garlic Toum Dip', 'Suugo Toom Dheeraad ah', 0.40),
(6, 'Add Melted Cheese Inside', 'Jiis Gudaha Lagu Daray', 0.60),
(7, 'Extra Beef Portion', 'Hilib Dheeraad ah', 1.20);

-- Settings-ka Muqayadda
INSERT INTO `restaurant_settings` (`setting_key`, `setting_value`) VALUES
('restaurant_name', 'Ganaan Burger & Fast Food'),
('tagline', 'Dhadhanka Dhabta Ah ee Muqayadda Casriga Ah'),
('phone_number', '+252 61 5000000 / +252 61 7000000'),
('location', 'Wadada Maka Al-Mukarama, Muqdisho, Soomaaliya'),
('currency_symbol', '$'),
('exchange_rate_sos', '26000'),
('evc_number', '0615000000'),
('zaad_number', '0634000000'),
('tax_rate_percent', '5');

-- Sample Initial Orders (Dalabyo tusaale ah)
INSERT INTO `orders` (`order_number`, `customer_name`, `customer_phone`, `order_type`, `table_number`, `delivery_address`, `subtotal`, `tax`, `delivery_fee`, `total_amount`, `payment_method`, `payment_status`, `order_status`, `notes`) VALUES
('ORD-1001', 'Axmed Cabdullaahi', '+252 61 2345678', 'dine_in', 'Miiska 04', NULL, 10.00, 0.50, 0.00, 10.50, 'EVC_PLUS', 'paid', 'completed', 'Fadlan basbaas ha ku badinina'),
('ORD-1002', 'Faadumo Cali Xasan', '+252 61 9876543', 'takeaway', NULL, NULL, 6.50, 0.33, 0.00, 6.83, 'ZAAD', 'paid', 'cooking', 'Shuwarmada toom badan ku dara'),
('ORD-1003', 'Khaalid Maxamed Yuusuf', '+252 61 5551234', 'delivery', NULL, 'KM4, Kasoo horjeedka Hoteel Jazeera', 15.00, 0.75, 1.50, 17.25, 'CASH', 'pending', 'pending', 'Wac markaad timaado albaabka');

INSERT INTO `order_items` (`order_id`, `product_id`, `product_name`, `price`, `quantity`, `addons_detail`, `subtotal`) VALUES
(1, 1, 'Ganaan Signature Beef Burger', 4.50, 1, 'Extra Cheddar Cheese Slice', 5.00),
(1, 10, 'Fresh Somali Sweet Mango Juice', 2.00, 2, NULL, 4.00),
(1, 16, 'Crispy Golden French Fries', 1.50, 1, NULL, 1.50),
(2, 6, 'Ganaan Signature Chicken Shawarma', 3.50, 1, 'Extra Garlic Toum Dip', 3.90),
(2, 13, 'Creamy Oreo Milkshake', 3.00, 1, NULL, 3.00),
(3, 3, 'Double Smash Cheeseburger', 6.50, 1, NULL, 6.50),
(3, 8, 'Super Mixed Shawarma Plate', 7.00, 1, NULL, 7.00),
(3, 11, 'Vimto Ice Slush & Mint', 1.50, 1, NULL, 1.50);

-- --------------------------------------------------------
-- Views for Reporting & Analytics (Muuqaallo Maamul)
-- --------------------------------------------------------
CREATE OR REPLACE VIEW `v_daily_sales` AS
SELECT 
    DATE(created_at) AS `order_date`,
    COUNT(id) AS `total_orders`,
    SUM(total_amount) AS `total_revenue`,
    AVG(total_amount) AS `average_ticket_value`
FROM `orders`
WHERE `payment_status` = 'paid'
GROUP BY DATE(created_at);

CREATE OR REPLACE VIEW `v_popular_items` AS
SELECT 
    `product_name`,
    SUM(`quantity`) AS `total_sold`,
    SUM(`subtotal`) AS `total_generated`
FROM `order_items`
GROUP BY `product_name`
ORDER BY `total_sold` DESC;
