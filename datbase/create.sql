CREATE DATABASE IF NOT EXISTS `tiffinwala` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
USE `tiffinwala`;

-- Table structure for `role`
CREATE TABLE `role` (
  `Role_Id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`Role_Id`),
  UNIQUE KEY `Role_Name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for `user`
CREATE TABLE `user` (
  `Uid` VARCHAR(10) NOT NULL,
  `fname` varchar(50) NOT NULL,
  `lname` varchar(50) NOT NULL,
  `email` varchar(70) NOT NULL,
  `Rid` int NOT NULL,
  `area` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `pincode` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `password` varchar(30) NOT NULL,
  `contact` varchar(20) NOT NULL,
  PRIMARY KEY (`Uid`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`Rid`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`Rid`) REFERENCES `role` (`Role_Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Trigger for automated Uid naming convention
DELIMITER $$

CREATE TRIGGER `before_user_insert`
BEFORE INSERT ON `user`
FOR EACH ROW
BEGIN
  DECLARE role_prefix CHAR(1);
  SET role_prefix = CASE 
                      WHEN NEW.Rid = (SELECT `Role_Id` FROM `role` WHERE `role_name` = 'admin') THEN 'A'
                      WHEN NEW.Rid = (SELECT `Role_Id` FROM `role` WHERE `role_name` = 'customer') THEN 'C'
                      WHEN NEW.Rid = (SELECT `Role_Id` FROM `role` WHERE `role_name` = 'vendor') THEN 'V'
                    END;
  SET NEW.Uid = CONCAT(role_prefix, LPAD(COALESCE((SELECT COUNT(*) + 1 FROM `user` WHERE LEFT(`Uid`, 1) = role_prefix), 1), 3, '0'));
END$$

DELIMITER ;

CREATE TABLE `vendor` (
  `Vendor_id` int NOT NULL AUTO_INCREMENT,
  `Is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `Uid` VARCHAR(10) NOT NULL,
  `GSTIN` VARCHAR(17) DEFAULT NULL, -- GSTIN field added (15 characters max for India)
  `Adhar_number` VARCHAR(15) DEFAULT NULL, -- Aadhaar number field added (12 digits for India)
  PRIMARY KEY (`Vendor_id`),
  KEY `Uid` (`Uid`),
  CONSTRAINT `vendor_ibfk_1` FOREIGN KEY (`Uid`) REFERENCES `user` (`Uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for `vendor_subscription_plan`
CREATE TABLE `vendor_subscription_plan` (
  `Plan_id` int NOT NULL AUTO_INCREMENT,
  `Vendor_id` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Price` int NOT NULL,
  `Description` varchar(255) NOT NULL,
  `Image` varchar(255) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  `Rating` int DEFAULT NULL,
  PRIMARY KEY (`Plan_id`),
  KEY `Vendor_id` (`Vendor_id`),
  CONSTRAINT `vendor_subscription_plan_ibfk_1` FOREIGN KEY (`Vendor_id`) REFERENCES `vendor` (`Vendor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for `customer_order_log`
CREATE TABLE `customer_order_log` (
  `Order_id` int NOT NULL AUTO_INCREMENT,
  `Uid` VARCHAR(10) NOT NULL,
  `Order_date` date NOT NULL,
  PRIMARY KEY (`Order_id`),
  KEY `Uid` (`Uid`),
  CONSTRAINT `customer_order_log_ibfk_1` FOREIGN KEY (`Uid`) REFERENCES `user` (`Uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for `customer_subscribed_plans`
CREATE TABLE `customer_subscribed_plans` (
  `Customer_plan_id` int NOT NULL AUTO_INCREMENT,
  `Uid` VARCHAR(10) NOT NULL,
  `v_subscription_id` int NOT NULL,
  PRIMARY KEY (`Customer_plan_id`),
  KEY `Uid` (`Uid`),
  KEY `v_subscription_id` (`v_subscription_id`),
  CONSTRAINT `customer_subscribed_plans_ibfk_1` FOREIGN KEY (`Uid`) REFERENCES `user` (`Uid`),
  CONSTRAINT `customer_subscribed_plans_ibfk_2` FOREIGN KEY (`v_subscription_id`) REFERENCES `vendor_subscription_plan` (`Plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for `customer_subscriptions_junction`
CREATE TABLE `customer_subscriptions_junction` (
  `Customer_plan_id` int NOT NULL,
  `Uid` VARCHAR(10) NOT NULL,
  `Plan_id` int NOT NULL,
  PRIMARY KEY (`Customer_plan_id`, `Uid`, `Plan_id`),
  KEY `Uid` (`Uid`),
  KEY `Plan_id` (`Plan_id`),
  CONSTRAINT `customer_subscriptions_junction_ibfk_1` FOREIGN KEY (`Customer_plan_id`) REFERENCES `customer_subscribed_plans` (`Customer_plan_id`),
  CONSTRAINT `customer_subscriptions_junction_ibfk_2` FOREIGN KEY (`Uid`) REFERENCES `user` (`Uid`),
  CONSTRAINT `customer_subscriptions_junction_ibfk_3` FOREIGN KEY (`Plan_id`) REFERENCES `vendor_subscription_plan` (`Plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for `feedback`
CREATE TABLE `feedback` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `customer_plan_id` int NOT NULL,
  `Uid` VARCHAR(10) NOT NULL,
  `v_subscription_id` int NOT NULL,
  `feedback_text` varchar(500) NOT NULL,
  `Rating` int DEFAULT NULL CHECK (`Rating` BETWEEN 1 AND 5),
  PRIMARY KEY (`feedback_id`),
  KEY `customer_plan_id` (`customer_plan_id`),
  KEY `Uid` (`Uid`),
  KEY `v_subscription_id` (`v_subscription_id`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`customer_plan_id`) REFERENCES `customer_subscribed_plans` (`Customer_plan_id`),
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`Uid`) REFERENCES `user` (`Uid`),
  CONSTRAINT `feedback_ibfk_3` FOREIGN KEY (`v_subscription_id`) REFERENCES `vendor_subscription_plan` (`Plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for `payment`
CREATE TABLE `payment` (
  `Pid` int NOT NULL AUTO_INCREMENT,
  `Order_id` int NOT NULL,
  `RazorPay_id` varchar(255) NOT NULL,
  `Payment_date` date NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`Pid`),
  UNIQUE KEY `RazorPay_id` (`RazorPay_id`),
  KEY `Order_id` (`Order_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`Order_id`) REFERENCES `customer_order_log` (`Order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for `tiffin`
CREATE TABLE `tiffin` (
  `Tiffin_id` int NOT NULL AUTO_INCREMENT,
  `V_Subscription_id` int NOT NULL,
  `Tiffin_name` varchar(255) NOT NULL,
  `price` int NOT NULL,
  `day` varchar(255) NOT NULL,
  `Time` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `food_type` varchar(255) NOT NULL,
  `Rating` int NOT NULL,
  PRIMARY KEY (`Tiffin_id`),
  KEY `V_Subscription_id` (`V_Subscription_id`),
  CONSTRAINT `tiffin_ibfk_1` FOREIGN KEY (`V_Subscription_id`) REFERENCES `vendor_subscription_plan` (`Plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
