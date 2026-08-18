-- ============================================================================
-- Orderly - reverse-engineered MySQL 8 schema
--
-- This file was NOT derived from any existing .sql/migration file (none exist
-- in the repo). It was reconstructed purely by reading every raw, string-
-- concatenated SQL query in app/models/*.js, app/controllers/*.js,
-- app/services/firebase-config.js and app/middleware/auth.js, and inferring
-- column names/types from SELECT lists, WHERE/JOIN clauses and the object
-- literals passed to `sql.query('INSERT INTO x SET ?', obj)`.
--
-- No FOREIGN KEY constraints are declared (legacy data is messy / not
-- guaranteed referentially clean) - relationships are documented in comments
-- instead. Run with:  mysql -u root orderly < schema.sql
-- ============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Lookup / independent tables
-- ----------------------------------------------------------------------------

-- Derived from: cart.model.js, order.model.js, producer.model.js, product.model.js
-- (joined as `currency_tb` everywhere: pl.currency_id/order_tb.currency_id -> currency_tb.cur_id)
CREATE TABLE IF NOT EXISTS `currency_tb` (
  `cur_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `currency` VARCHAR(10) NOT NULL DEFAULT '',
  `currency_type` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`cur_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: cart.model.js, inventory.model.js, product.model.js
-- (joined as `unit_tb` everywhere: pl.unit_id -> unit_tb.unit_tb -- yes, the PK column
--  is literally referenced as `utb.unit_tb` in the raw SQL)
CREATE TABLE IF NOT EXISTS `unit_tb` (
  `unit_tb` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `unit` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`unit_tb`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: cart.model.js, order.model.js, producer.model.js ("select * from conveyance_tb")
CREATE TABLE IF NOT EXISTS `conveyance_tb` (
  `conv_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `conveyance` DECIMAL(10,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`conv_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: order.model.js (Order.urgent_charges / Order.place_order)
CREATE TABLE IF NOT EXISTS `delivery_charge_tb` (
  `dc_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `delivery_name` VARCHAR(255) NOT NULL DEFAULT '',
  `amount` DECIMAL(10,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`dc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: order.model.js (Order.return_order_reasons)
CREATE TABLE IF NOT EXISTS `order_return_reason_tb` (
  `reason_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `reason` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`reason_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: profile.model.js (Profile.faq_list)
CREATE TABLE IF NOT EXISTS `faq_tb` (
  `faq_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `question` VARCHAR(500) NOT NULL DEFAULT '',
  `answer` TEXT,
  PRIMARY KEY (`faq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: inventory.model.js (Inventory.sku_gallery)
CREATE TABLE IF NOT EXISTS `product_gallery_mains` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `image_path` VARCHAR(255) NOT NULL DEFAULT '',
  `title` VARCHAR(255) NOT NULL DEFAULT '',
  `description` TEXT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: app/services/firebase-config.js (senPushNotification), profile.model.js (Profile.notifications)
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL DEFAULT '',
  `description` TEXT,
  `banner` VARCHAR(255) DEFAULT '',
  `send_to_all` TINYINT(1) NOT NULL DEFAULT 0,
  `api_url` VARCHAR(255) DEFAULT '',
  `api_data` TEXT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: cart.model.js, inventory.model.js, order.model.js, producer.model.js
-- (producer_list.producer_id is also treated as == the producer's users_tb.user_id
--  in a couple of distance queries in cart.model.js / order.model.js)
CREATE TABLE IF NOT EXISTS `producer_list` (
  `producer_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `producer_name` VARCHAR(255) NOT NULL DEFAULT '',
  `producer_image_url` VARCHAR(255) DEFAULT '',
  `producer_icon_url` VARCHAR(255) DEFAULT '',
  `prod_desc` TEXT,
  PRIMARY KEY (`producer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Users
-- ----------------------------------------------------------------------------

-- Derived from: login.model.js, register.model.js, profile.model.js, producer.model.js,
-- order.model.js, cart.model.js, app/middleware/auth.js, admin.model.js
-- user_type: 0 = customer, 1 = store manager (producer), 2 = delivery agent, 3 = platform manager
-- status: 0 = active, 1 = removed (Profile.remove_account)
-- password: bcrypt hash, only set for platform manager (user_type = 3) accounts - every other
-- persona authenticates via Firebase (fb_id), not a password
CREATE TABLE IF NOT EXISTS `users_tb` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fb_id` VARCHAR(255) DEFAULT '',
  `first_name` VARCHAR(255) DEFAULT '',
  `last_name` VARCHAR(255) DEFAULT '',
  `email_id` VARCHAR(255) DEFAULT '',
  `gender` VARCHAR(20) DEFAULT '',
  `mobile` VARCHAR(20) DEFAULT '',
  `device` VARCHAR(255) DEFAULT '',
  `device_id` VARCHAR(255) DEFAULT '',
  `fcm_id` VARCHAR(500) DEFAULT '',
  `version` VARCHAR(50) DEFAULT '',
  `signup_type` VARCHAR(50) DEFAULT '',
  `user_type` TINYINT NOT NULL DEFAULT 0,
  `address` VARCHAR(500) DEFAULT '',
  `zip_code` VARCHAR(20) DEFAULT '',
  `latitude` DOUBLE DEFAULT 0,
  `longitude` DOUBLE DEFAULT 0,
  `distance` DOUBLE DEFAULT 0,
  `status` TINYINT NOT NULL DEFAULT 0,
  `profile_pic` VARCHAR(255) DEFAULT '',
  `producerid` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> producer_list.producer_id (store manager users only)',
  `password` VARCHAR(255) DEFAULT NULL COMMENT 'bcrypt hash, platform manager users only',
  `remove_account_reason` VARCHAR(500) DEFAULT '',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  KEY `idx_users_fb_id` (`fb_id`),
  KEY `idx_users_mobile` (`mobile`),
  KEY `idx_users_producerid` (`producerid`),
  KEY `idx_users_email_id` (`email_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dev seed: one platform manager account for local login testing. email_id has no unique
-- constraint (guest customers can share a blank one), so this isn't upsert-safe - only run
-- it once per database, same as the rest of this file.
-- Password below is 'ChangeMe123!' - change it before this ever goes near production.
INSERT INTO users_tb (first_name, last_name, email_id, user_type, status, password, signup_type)
VALUES ('Platform', 'Manager', 'admin@orderly.local', 3, 0, '$2b$10$AunYOGgzkHA2V4o4ci3kBeWfuZa1ke0zb1pUCdeKWenfe6cHnxClG', 'Password');

-- ----------------------------------------------------------------------------
-- Catalog
-- ----------------------------------------------------------------------------

-- Derived from: cart.model.js, inventory.model.js, product.model.js, order.model.js
-- display_status: 0 = active/visible, 1 = removed (Inventory.remove_inventory)
CREATE TABLE IF NOT EXISTS `product_list` (
  `product_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `producerid` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> producer_list.producer_id',
  `product_name` VARCHAR(255) DEFAULT '',
  `product_desc` TEXT,
  `rate_per_hour` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `product_qty` INT NOT NULL DEFAULT 0,
  `truck_name` VARCHAR(255) DEFAULT '',
  `truck_number` VARCHAR(100) DEFAULT '',
  `display_status` TINYINT NOT NULL DEFAULT 0,
  `currency_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> currency_tb.cur_id',
  `unit_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> unit_tb.unit_tb',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `idx_product_producerid` (`producerid`),
  KEY `idx_product_display_status` (`display_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: cart.model.js, inventory.model.js, order.model.js, product.model.js
CREATE TABLE IF NOT EXISTS `product_img_tb` (
  `img_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL COMMENT 'FK -> product_list.product_id',
  `img_path` VARCHAR(255) DEFAULT '',
  `img_name` VARCHAR(255) DEFAULT '',
  PRIMARY KEY (`img_id`),
  KEY `idx_product_img_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Cart
-- ----------------------------------------------------------------------------

-- Derived from: cart.model.js, login.model.js (cart merge on login), order.model.js (place_order)
CREATE TABLE IF NOT EXISTS `cart_tb` (
  `cart_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL COMMENT 'FK -> users_tb.user_id',
  `producer_id` INT UNSIGNED DEFAULT 0 COMMENT 'FK -> producer_list.producer_id',
  `product_id` INT UNSIGNED NOT NULL COMMENT 'FK -> product_list.product_id',
  `rate_per_hour` DECIMAL(10,2) DEFAULT 0,
  `qty` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`cart_id`),
  KEY `idx_cart_user_id` (`user_id`),
  KEY `idx_cart_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Addresses
-- ----------------------------------------------------------------------------

-- Derived from: order.model.js (add_address/view_address/update_address/delete_address),
-- register.model.js (initial address insert on signup)
CREATE TABLE IF NOT EXISTS `user_address` (
  `ua_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `userid` INT UNSIGNED NOT NULL COMMENT 'FK -> users_tb.user_id',
  `user_name` VARCHAR(255) DEFAULT '',
  `mobile` VARCHAR(20) DEFAULT '',
  `email_id` VARCHAR(255) DEFAULT '',
  `street_no` VARCHAR(100) DEFAULT '',
  `flat_no` VARCHAR(100) DEFAULT '',
  `address` VARCHAR(500) DEFAULT '',
  `zipcode` VARCHAR(20) DEFAULT '',
  `city` VARCHAR(100) DEFAULT '',
  `state` VARCHAR(100) DEFAULT '',
  `country` VARCHAR(100) DEFAULT '',
  `add_latitude` DOUBLE DEFAULT 0,
  `add_longitude` DOUBLE DEFAULT 0,
  `address_type` VARCHAR(20) DEFAULT 'Home',
  `is_default` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ua_id`),
  KEY `idx_user_address_userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Trucks (fleet)
-- ----------------------------------------------------------------------------

-- Derived from: order.model.js (Order.fetch_truck_listing)
CREATE TABLE IF NOT EXISTS `truck_tb` (
  `truck_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `producerid` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> producer_list.producer_id',
  `truck_name` VARCHAR(255) DEFAULT '',
  `truck_number` VARCHAR(100) DEFAULT '',
  `device_id` VARCHAR(255) DEFAULT '',
  `is_available` TINYINT(1) NOT NULL DEFAULT 0,
  `truck_status` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`truck_id`),
  KEY `idx_truck_producerid` (`producerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Orders
-- ----------------------------------------------------------------------------

-- Derived from: order.model.js (Order.place_order, Order.my_order, Order.my_order_collapse, ...)
CREATE TABLE IF NOT EXISTS `order_tb` (
  `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL COMMENT 'FK -> users_tb.user_id',
  `delivery_option` TINYINT DEFAULT 0,
  `delivery_date` DATE DEFAULT NULL,
  `delivery_slot` VARCHAR(100) DEFAULT '',
  `delivery_charge` DECIMAL(10,2) DEFAULT 0,
  `sub_total` DECIMAL(10,2) DEFAULT 0,
  `convinience_fee` DECIMAL(10,2) DEFAULT 0,
  `grant_total` DECIMAL(10,2) DEFAULT 0,
  `discount` DECIMAL(10,2) DEFAULT 0,
  `dest_address` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> user_address.ua_id',
  `payment_transaction_id` VARCHAR(255) DEFAULT '',
  `payment_mode` VARCHAR(50) DEFAULT '',
  `full_dest_address` TEXT COMMENT 'JSON snapshot of user_address row at order time',
  `currency_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> currency_tb.cur_id',
  `order_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `idx_order_user_id` (`user_id`),
  KEY `idx_order_dest_address` (`dest_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: order.model.js (line items for an order - named `order_details_id` in the
-- codebase itself, e.g. "from order_details_id odi"), claims.model.js
-- current_status codes (see app/utils/constants.js ORDER_STATUS + code usage):
-- 0/1/2 placed/ready/shipped, 3 delivered, 4/5 return/replace requested,
-- 6 cancelled, 7/8/9/10 return flow, 11/12/13/14 replace flow
CREATE TABLE IF NOT EXISTS `order_details_id` (
  `order_details_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL COMMENT 'FK -> order_tb.order_id',
  `order_number` VARCHAR(50) DEFAULT '',
  `producer_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> producer_list.producer_id',
  `product_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> product_list.product_id',
  `rate_per_hour` DECIMAL(10,2) DEFAULT 0,
  `qty` INT DEFAULT 0,
  `product_name` VARCHAR(255) DEFAULT '',
  `product_desc` TEXT,
  `img_paths` VARCHAR(255) DEFAULT '',
  `total` DECIMAL(10,2) DEFAULT 0,
  `address` INT UNSIGNED DEFAULT 0 COMMENT 'FK -> user_address.ua_id (source/pickup address)',
  `dest_address` INT UNSIGNED DEFAULT 0 COMMENT 'FK -> user_address.ua_id (delivery address)',
  `full_src_address` TEXT COMMENT 'JSON snapshot of source user_address row',
  `current_status` TINYINT NOT NULL DEFAULT 0,
  `reject_reason` VARCHAR(500) DEFAULT '',
  `pay_status` TINYINT DEFAULT 0,
  `delivery_agent` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> users_tb.user_id (user_type = 2)',
  `date_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_details_id`),
  KEY `idx_odi_order_id` (`order_id`),
  KEY `idx_odi_producer_id` (`producer_id`),
  KEY `idx_odi_product_id` (`product_id`),
  KEY `idx_odi_delivery_agent` (`delivery_agent`),
  KEY `idx_odi_current_status` (`current_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: order.model.js (Order.update_order_status, Order.track_order, Order.place_order)
CREATE TABLE IF NOT EXISTS `order_history` (
  `order_history_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_detail_id` INT UNSIGNED NOT NULL COMMENT 'FK -> order_details_id.order_details_id',
  `order_num` VARCHAR(50) DEFAULT '',
  `oh_status` TINYINT DEFAULT 0,
  `oh_date_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_history_id`),
  KEY `idx_order_history_detail_id` (`order_detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: order.model.js (Order.product_return, Order.producer_order_return, Order.track_order)
CREATE TABLE IF NOT EXISTS `product_return` (
  `return_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_details_id` INT UNSIGNED NOT NULL COMMENT 'FK -> order_details_id.order_details_id',
  `order_number` VARCHAR(50) DEFAULT '',
  `return_type` TINYINT DEFAULT 0,
  `return_title` VARCHAR(255) DEFAULT '',
  `review` TEXT,
  `product_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> product_list.product_id',
  `user_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> users_tb.user_id',
  `prod_status` TINYINT DEFAULT 0,
  `is_return_replace` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`return_id`),
  KEY `idx_product_return_odi` (`order_details_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: order.model.js (Order.product_review) - note: controller maps the
-- submitted `order_details_id` value into a field literally named `order_number`
CREATE TABLE IF NOT EXISTS `product_review` (
  `review_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_number` VARCHAR(50) DEFAULT '',
  `product_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> product_list.product_id',
  `app_exp` TINYINT DEFAULT 0,
  `vehicle_qty` TINYINT DEFAULT 0,
  `drive_exp` TINYINT DEFAULT 0,
  `payment_exp` TINYINT DEFAULT 0,
  `overall` TINYINT DEFAULT 0,
  `user_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> users_tb.user_id',
  `comment` TEXT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Temperature / location tracking (cold-chain trucks)
-- ----------------------------------------------------------------------------

-- Derived from: temperature.model.js (Temperature.add_temperature), order.model.js (Order.update_temp_loacation)
CREATE TABLE IF NOT EXISTS `temp_location` (
  `temp_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `device_id` VARCHAR(255) DEFAULT '',
  `latitude` DOUBLE DEFAULT 0,
  `longitude` DOUBLE DEFAULT 0,
  `temperature` DECIMAL(6,2) DEFAULT 0,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`temp_id`),
  KEY `idx_temp_location_device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Derived from: order.model.js (Order.fetch_temprature) - only read in the code we found;
-- no INSERT was located in app/models or app/controllers, so this is presumably populated
-- by an external/cron process. Columns inferred purely from the SELECT/WHERE clauses.
CREATE TABLE IF NOT EXISTS `temp_location_history` (
  `temp_his_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `device_id` VARCHAR(255) DEFAULT '',
  `orders_detail_id` INT UNSIGNED DEFAULT NULL COMMENT 'FK -> order_details_id.order_details_id',
  `latitude` DOUBLE DEFAULT 0,
  `longitude` DOUBLE DEFAULT 0,
  `temperature` DECIMAL(6,2) DEFAULT 0,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`temp_his_id`),
  KEY `idx_temp_history_device_id` (`device_id`),
  KEY `idx_temp_history_odi` (`orders_detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Notifications (join table)
-- ----------------------------------------------------------------------------

-- Derived from: app/services/firebase-config.js (senPushNotification),
-- profile.model.js (Profile.notifications / Profile.notification_destroy)
CREATE TABLE IF NOT EXISTS `notifications_users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `notification_id` INT UNSIGNED NOT NULL COMMENT 'FK -> notifications.id',
  `user_id` INT UNSIGNED NOT NULL COMMENT 'FK -> users_tb.user_id',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_users_notification_id` (`notification_id`),
  KEY `idx_notifications_users_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
