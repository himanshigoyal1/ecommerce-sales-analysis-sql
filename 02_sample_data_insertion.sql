-- Sample Data for E-commerce Sales Analysis
-- This data represents a realistic e-commerce scenario

-- Insert Categories
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Clothing', 'Fashion and apparel items'),
(3, 'Books', 'Books and educational materials'),
(4, 'Home & Garden', 'Home improvement and garden supplies'),
(5, 'Sports', 'Sports equipment and accessories');

-- Insert Products
INSERT INTO products (product_id, product_name, category_id, price, cost, created_date) VALUES
(1, 'Wireless Headphones', 1, 79.99, 45.00, '2024-01-15'),
(2, 'Smartphone Case', 1, 24.99, 12.00, '2024-01-20'),
(3, 'Bluetooth Speaker', 1, 149.99, 85.00, '2024-02-01'),
(4, 'Men\'s T-Shirt', 2, 29.99, 15.00, '2024-01-10'),
(5, 'Women\'s Jeans', 2, 89.99, 45.00, '2024-01-25'),
(6, 'Running Shoes', 2, 129.99, 70.00, '2024-02-05'),
(7, 'Data Science Book', 3, 49.99, 25.00, '2024-01-30'),
(8, 'Programming Guide', 3, 39.99, 20.00, '2024-02-10'),
(9, 'Coffee Maker', 4, 199.99, 120.00, '2024-01-18'),
(10, 'Garden Tools Set', 4, 89.99, 50.00, '2024-02-15'),
(11, 'Yoga Mat', 5, 34.99, 18.00, '2024-01-22'),
(12, 'Tennis Racket', 5, 159.99, 90.00, '2024-02-08');

-- Insert Customers
INSERT INTO customers (customer_id, first_name, last_name, email, phone, city, state, country, registration_date, age, gender) VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '555-0101', 'New York', 'NY', 'USA', '2024-01-05', 32, 'Male'),
(2, 'Sarah', 'Johnson', 'sarah.j@email.com', '555-0102', 'Los Angeles', 'CA', 'USA', '2024-01-12', 28, 'Female'),
(3, 'Michael', 'Brown', 'michael.b@email.com', '555-0103', 'Chicago', 'IL', 'USA', '2024-01-18', 35, 'Male'),
(4, 'Emily', 'Davis', 'emily.d@email.com', '555-0104', 'Houston', 'TX', 'USA', '2024-01-25', 29, 'Female'),
(5, 'David', 'Wilson', 'david.w@email.com', '555-0105', 'Phoenix', 'AZ', 'USA', '2024-02-02', 41, 'Male'),
(6, 'Jessica', 'Miller', 'jessica.m@email.com', '555-0106', 'Philadelphia', 'PA', 'USA', '2024-02-08', 26, 'Female'),
(7, 'Robert', 'Garcia', 'robert.g@email.com', '555-0107', 'San Antonio', 'TX', 'USA', '2024-02-15', 38, 'Male'),
(8, 'Lisa', 'Martinez', 'lisa.m@email.com', '555-0108', 'San Diego', 'CA', 'USA', '2024-02-22', 33, 'Female'),
(9, 'James', 'Anderson', 'james.a@email.com', '555-0109', 'Dallas', 'TX', 'USA', '2024-03-01', 30, 'Male'),
(10, 'Mary', 'Taylor', 'mary.t@email.com', '555-0110', 'San Jose', 'CA', 'USA', '2024-03-08', 27, 'Female');

-- Insert Orders
INSERT INTO orders (order_id, customer_id, order_date, order_status, total_amount, shipping_cost) VALUES
(1, 1, '2024-01-15', 'completed', 104.98, 9.99),
(2, 2, '2024-01-20', 'completed', 179.98, 12.99),
(3, 3, '2024-01-25', 'completed', 89.99, 7.99),
(4, 4, '2024-02-01', 'completed', 249.98, 15.99),
(5, 5, '2024-02-05', 'completed', 129.99, 9.99),
(6, 6, '2024-02-10', 'completed', 89.98, 8.99),
(7, 7, '2024-02-15', 'completed', 199.99, 12.99),
(8, 8, '2024-02-20', 'completed', 164.98, 11.99),
(9, 9, '2024-02-25', 'completed', 79.99, 7.99),
(10, 10, '2024-03-01', 'completed', 219.98, 14.99),
(11, 1, '2024-03-05', 'completed', 149.99, 9.99),
(12, 2, '2024-03-10', 'processing', 69.98, 6.99),
(13, 3, '2024-03-15', 'shipped', 159.99, 10.99),
(14, 4, '2024-03-20', 'completed', 89.99, 7.99),
(15, 5, '2024-03-25', 'completed', 174.98, 12.99);

-- Insert Order Items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1, 79.99),
(2, 1, 2, 1, 24.99),
(3, 2, 3, 1, 149.99),
(4, 2, 4, 1, 29.99),
(5, 3, 5, 1, 89.99),
(6, 4, 6, 1, 129.99),
(7, 4, 7, 1, 49.99),
(8, 4, 8, 1, 39.99),
(9, 5, 6, 1, 129.99),
(10, 6, 7, 1, 49.99),
(11, 6, 8, 1, 39.99),
(12, 7, 9, 1, 199.99),
(13, 8, 10, 1, 89.99),
(14, 8, 11, 2, 34.99),
(15, 9, 1, 1, 79.99),
(16, 10, 3, 1, 149.99),
(17, 10, 11, 2, 34.99),
(18, 11, 3, 1, 149.99),
(19, 12, 4, 1, 29.99),
(20, 12, 8, 1, 39.99),
(21, 13, 12, 1, 159.99),
(22, 14, 10, 1, 89.99),
(23, 15, 6, 1, 129.99),
(24, 15, 2, 1, 24.99),
(25, 15, 2, 1, 24.99);