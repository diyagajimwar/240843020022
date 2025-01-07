USE `tiffinwala`;


-- Populating the `role` table
INSERT INTO `role` (`role_name`) VALUES
('admin'),
('customer'),
('vendor');

-- Populating the `user` table with admins
INSERT INTO `user` (`Uid`, `fname`, `lname`, `email`, `Rid`, `area`, `city`, `pincode`, `state`, `password`, `contact`) VALUES
(NULL, 'Amit', 'Sharma', 'amit.sharma@example.com', 1, 'Shivaji Nagar', 'Pune', '411005', 'Maharashtra', 'admin123', '9876543210'),
(NULL, 'Diya', 'Patel', 'diya.patel@example.com', 1, 'Viman Nagar', 'Pune', '411014', 'Maharashtra', 'admin123', '8765432109'),
(NULL, 'Mayur', 'Joshi', 'mayur.joshi@example.com', 1, 'Baner', 'Pune', '411045', 'Maharashtra', 'admin123', '7654321098');

-- Populating the `user` table with vendors
INSERT INTO `user` (`Uid`, `fname`, `lname`, `email`, `Rid`, `area`, `city`, `pincode`, `state`, `password`, `contact`) VALUES
(NULL, 'Ramesh', 'Kumar', 'ramesh.kumar@example.com', 3, 'Kothrud', 'Pune', '411038', 'Maharashtra', 'vendor123', '7543210987'),
(NULL, 'Sneha', 'Desai', 'sneha.desai@example.com', 3, 'Aundh', 'Pune', '411007', 'Maharashtra', 'vendor123', '6543210987');

-- Populating the `user` table with customers
INSERT INTO `user` (`Uid`, `fname`, `lname`, `email`, `Rid`, `area`, `city`, `pincode`, `state`, `password`, `contact`) VALUES
(NULL, 'Raj', 'Verma', 'raj.verma@example.com', 2, 'Wakad', 'Pune', '411057', 'Maharashtra', 'cust123', '9876543211'),
(NULL, 'Pooja', 'Singh', 'pooja.singh@example.com', 2, 'Hadapsar', 'Pune', '411028', 'Maharashtra', 'cust123', '8765432110'),
(NULL, 'Kunal', 'Rathore', 'kunal.rathore@example.com', 2, 'Kharadi', 'Pune', '411014', 'Maharashtra', 'cust123', '7654321109');

-- Populating the `vendor` table
INSERT INTO `vendor` (`Vendor_id`, `Uid`, `GSTIN`, `Adhar_number`, `Is_verified`) VALUES
(NULL, 'V001', '27ABCDE1234F1Z5', '123456789012', 1),
(NULL, 'V002', '27FGHIJ5678K2Z6', '234567890123', 0);

-- Populating the `vendor_subscription_plan` table
INSERT INTO `vendor_subscription_plan` (`Plan_id`, `Vendor_id`, `Name`, `Price`, `Description`, `Image`, `is_available`, `Rating`) VALUES
(NULL, 1, 'Basic Tiffin Plan', 100, 'Simple homemade meals', 'basic.jpg', 1, 5),
(NULL, 1, 'Premium Tiffin Plan', 150, 'Premium meals with desserts', 'premium.jpg', 1, 4),
(NULL, 2, 'Vegetarian Plan', 120, 'Pure vegetarian meals', 'veg.jpg', 1, 5);

-- Populating the `tiffin` table
INSERT INTO `tiffin` (`Tiffin_id`, `V_Subscription_id`, `Tiffin_name`, `price`, `day`, `Time`, `description`, `food_type`, `Rating`) VALUES
(NULL, 1, 'Monday Special', 100, 'Monday', 'Lunch', 'Dal, Rice, Sabzi', 'Veg', 4),
(NULL, 1, 'Tuesday Delight', 100, 'Tuesday', 'Lunch', 'Paneer Curry, Chapati', 'Veg', 5),
(NULL, 2, 'Premium Feast', 150, 'Wednesday', 'Dinner', 'Butter Chicken, Naan', 'Non-Veg', 5),
(NULL, 3, 'Pure Veg Platter', 120, 'Thursday', 'Lunch', 'Mix Veg, Roti, Rice', 'Veg', 5);

-- Populating the `customer_order_log` table
INSERT INTO `customer_order_log` (`Order_id`, `Uid`, `Order_date`) VALUES
(NULL, 'C001', '2024-01-01'),
(NULL, 'C002', '2024-01-02'),
(NULL, 'C003', '2024-01-03');

-- Populating the `customer_subscribed_plans` table
INSERT INTO `customer_subscribed_plans` (`Customer_plan_id`, `Uid`, `v_subscription_id`) VALUES
(NULL, 'C001', 1),
(NULL, 'C002', 2),
(NULL, 'C003', 3);

-- Populating the `customer_subscriptions_junction` table
INSERT INTO `customer_subscriptions_junction` (`Customer_plan_id`, `Uid`, `Plan_id`) VALUES
(1, 'C001', 1),
(2, 'C002', 2),
(3, 'C003', 3);

-- Populating the `feedback` table
INSERT INTO `feedback` (`feedback_id`, `customer_plan_id`, `Uid`, `v_subscription_id`, `feedback_text`, `Rating`) VALUES
(NULL, 1, 'C001', 1, 'Great service!', 5),
(NULL, 2, 'C002', 2, 'Food was delicious.', 4),
(NULL, 3, 'C003', 3, 'Could be better.', 3);

-- Populating the `payment` table
INSERT INTO `payment` (`Pid`, `Order_id`, `RazorPay_id`, `Payment_date`, `Amount`) VALUES
(NULL, 1, 'RZP0001', '2024-01-01', 100.00),
(NULL, 2, 'RZP0002', '2024-01-02', 150.00),
(NULL, 3, 'RZP0003', '2024-01-03', 120.00);
