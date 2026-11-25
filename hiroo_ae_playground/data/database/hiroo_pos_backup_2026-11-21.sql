/*
SQLyog Community v12.4.0 (64 bit)
MySQL - 10.4.17-MariaDB : Database - tongkrongan_hiroo_pos
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`tongkrongan_hiroo_pos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `tongkrongan_hiroo_pos`;

/*Table structure for table `menus` */

DROP TABLE IF EXISTS `menus`;

CREATE TABLE `menus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` enum('Kopi','Non-Kopi','Makanan','Cemilan') COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(12,2) NOT NULL CHECK (`price` > 0),
  `serving_label` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `menus` */

insert  into `menus`(`id`,`code`,`name`,`category`,`price`,`serving_label`,`image_url`,`is_available`,`is_active`,`created_at`,`updated_at`) values 
(1,'KOP-01','Es Kopi Susu Hiroo','Kopi',18000.00,'Gelas 250 ml · Gula Aren',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(2,'KOP-02','Americano Dingin','Kopi',15000.00,'Gelas 12 oz · Double Shot',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(3,'KOP-03','Cafe Latte Hangat','Kopi',20000.00,'Cangkir 8 oz · Susu Segar',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(4,'KOP-04','Kopi Tubruk Gula Aren','Kopi',12000.00,'Cangkir Klasik · Robusta',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(5,'NON-01','Matcha Latte Hijau','Non-Kopi',22000.00,'Gelas 12 oz · Matcha Susu',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(6,'NON-02','Es Lemon Tea Segar','Non-Kopi',12000.00,'Gelas 12 oz · Irisan Lemon',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(7,'NON-03','Es Teh Manis','Non-Kopi',8000.00,'Gelas 12 oz · Teh Melati',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(8,'NON-04','Air Mineral 600ml','Non-Kopi',5000.00,'Botol Dingin / Biasa',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(9,'CEM-01','Pisang Goreng Aren','Cemilan',15000.00,'Isi 4 Pcs · Wijen & Aren',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(10,'CEM-02','Kentang Goreng','Cemilan',16000.00,'Porsi Sharing · Saus Sambal',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(11,'CEM-03','Roti Bakar Cokelat Keju','Cemilan',18000.00,'2 Tangkup · Cokelat & Keju',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(12,'MAK-01','Mie Goreng Spesial Hiroo','Makanan',22000.00,'Porsi Pas · Telur Mata Sapi',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03'),
(13,'MAK-02','Nasi Ayam Katsu Sambal','Makanan',25000.00,'Nasi Hangat · Sambal Matah',NULL,1,1,'2026-11-21 02:01:03','2026-11-21 02:01:03');

/*Table structure for table `order_items` */

DROP TABLE IF EXISTS `order_items`;

CREATE TABLE `order_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `menu_id` int(10) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL CHECK (`quantity` > 0),
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_order_items_order` (`order_id`),
  KEY `fk_order_items_menu` (`menu_id`),
  CONSTRAINT `fk_order_items_menu` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`),
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `order_items` */

/*Table structure for table `orders` */

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_number` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idempotency_key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shift_id` int(10) unsigned NOT NULL,
  `business_date` date NOT NULL,
  `cashier_id` int(10) unsigned NOT NULL,
  `customer_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending_payment','processing','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending_payment',
  `cancel_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cancelled_by` int(10) unsigned DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  UNIQUE KEY `idempotency_key` (`idempotency_key`),
  KEY `idx_orders_business_date` (`business_date`),
  KEY `idx_orders_status` (`status`),
  KEY `fk_orders_shift` (`shift_id`),
  KEY `fk_orders_cashier` (`cashier_id`),
  KEY `fk_orders_cancelled_by` (`cancelled_by`),
  CONSTRAINT `fk_orders_cancelled_by` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_orders_cashier` FOREIGN KEY (`cashier_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_orders_shift` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `orders` */

/*Table structure for table `payments` */

DROP TABLE IF EXISTS `payments`;

CREATE TABLE `payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `method` enum('cash','qris') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','paid','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'paid',
  `amount_paid` decimal(12,2) NOT NULL,
  `change_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `qris_account_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qris_account_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paid_at` datetime NOT NULL,
  `sheet_synced_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  CONSTRAINT `fk_payments_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `payments` */

/*Table structure for table `roles` */

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` enum('owner','cashier') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `roles` */

insert  into `roles`(`id`,`name`) values 
(1,'owner'),
(2,'cashier');

/*Table structure for table `shifts` */

DROP TABLE IF EXISTS `shifts`;

CREATE TABLE `shifts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shift_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cashier_id` int(10) unsigned NOT NULL,
  `business_date` date NOT NULL,
  `started_at` datetime NOT NULL,
  `ended_at` datetime DEFAULT NULL,
  `opening_cash` decimal(12,2) NOT NULL DEFAULT 0.00,
  `expected_cash` decimal(12,2) DEFAULT NULL,
  `actual_cash` decimal(12,2) DEFAULT NULL,
  `difference` decimal(12,2) DEFAULT NULL,
  `status` enum('open','closed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `closed_by` int(10) unsigned DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shift_code` (`shift_code`),
  KEY `idx_shifts_status` (`status`),
  KEY `idx_shifts_business_date` (`business_date`),
  KEY `fk_shifts_cashier` (`cashier_id`),
  KEY `fk_shifts_closed_by` (`closed_by`),
  CONSTRAINT `fk_shifts_cashier` FOREIGN KEY (`cashier_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_shifts_closed_by` FOREIGN KEY (`closed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `shifts` */

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_users_role` (`role_id`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `users` */

insert  into `users`(`id`,`role_id`,`name`,`username`,`password_hash`,`is_active`,`created_at`) values 
(1,1,'Faiz Alfianto','faiz','$2b$10$k0k5eInexE17rbhbDo7Dc.vKZvbN6qboDR6AQj.Uz.ld6uwsOiIAK',1,'2026-11-21 02:01:03'),
(2,1,'Nadia Putri','nadia','$2b$10$E4sIFPrNialz8hsobW4xfuZi7vICP/Q3.cN.CKBMg3BUmkzEIF2Fy',1,'2026-11-21 02:01:03'),
(3,2,'Siti Rahma','siti','$2b$10$MqgvAxJ6/BAq2e4syM7kG.XKNAfbYZHF5fZAQ.u./ppjLWfWmw77W',1,'2026-11-21 02:01:03'),
(4,2,'Budi Santoso','budi','$2b$10$h9M7PhEW/2AsqPgzQ6ub1.cyl4lfVg39387vSDjrZ9/5Y8f2BQV4S',1,'2026-11-21 02:01:03');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
