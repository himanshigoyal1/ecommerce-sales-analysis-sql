-- E-commerce Sales Analysis Queries

-- ==============================================
-- 1. SALES PERFORMANCE ANALYSIS
-- ==============================================

-- Monthly Sales Summary
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    COUNT(*) as total_orders,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as avg_order_value,
    SUM(shipping_cost) as total_shipping
FROM orders 
WHERE order_status = 'completed'
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY year, month;

-- Daily Sales Trend (Last 30 Days)
SELECT 
    order_date,
    COUNT(*) as orders_count,
    SUM(total_amount) as daily_revenue
FROM orders 
WHERE order_date >= '2024-02-15' 
    AND order_status = 'completed'
GROUP BY order_date
ORDER BY order_date;

-- ==============================================
-- 2. CUSTOMER ANALYSIS
-- ==============================================

-- Customer Segmentation by Purchase Behavior
SELECT 
    customer_id,
    first_name,
    last_name,
    COUNT(*) as total_orders,
    SUM(total_amount) as total_spent,
    AVG(total_amount) as avg_order_value,
    CASE 
        WHEN SUM(total_amount) > 300 THEN 'High Value'
        WHEN SUM(total_amount) > 150 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_segment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'completed'
GROUP BY c.customer_id, first_name, last_name
ORDER BY total_spent DESC;

-- Customer Demographics Analysis
SELECT 
    gender,
    COUNT(*) as customer_count,
    AVG(age) as avg_age,
    SUM(total_amount) as total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'completed'
GROUP BY gender;

-- Top 10 Customers by Revenue
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.city,
    c.state,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'completed'
GROUP BY c.customer_id, customer_name, c.city, c.state
ORDER BY total_revenue DESC
LIMIT 10;

-- ==============================================
-- 3. PRODUCT PERFORMANCE ANALYSIS
-- ==============================================

-- Best Selling Products
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity) as total_sold,
    SUM(oi.quantity * oi.unit_price) as total_revenue,
    COUNT(DISTINCT oi.order_id) as orders_count
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 'completed'
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_sold DESC;

-- Product Profitability Analysis
SELECT 
    p.product_name,
    c.category_name,
    p.price,
    p.cost,
    (p.price - p.cost) as profit_per_unit,
    SUM(oi.quantity) as units_sold,
    SUM(oi.quantity * (p.price - p.cost)) as total_profit
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 'completed'
GROUP BY p.product_name, c.category_name, p.price, p.cost
ORDER BY total_profit DESC;

-- Category Performance
SELECT 
    c.category_name,
    COUNT(DISTINCT p.product_id) as products_count,
    SUM(oi.quantity) as total_units_sold,
    SUM(oi.quantity * oi.unit_price) as total_revenue,
    AVG(oi.unit_price) as avg_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'completed'
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- ==============================================
-- 4. ORDER ANALYSIS
-- ==============================================

-- Order Status Distribution
SELECT 
    order_status,
    COUNT(*) as order_count,
    SUM(total_amount) as total_value,
    AVG(total_amount) as avg_order_value
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- Average Order Value by Month
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    COUNT(*) as orders_count,
    AVG(total_amount) as avg_order_value,
    MIN(total_amount) as min_order_value,
    MAX(total_amount) as max_order_value
FROM orders
WHERE order_status = 'completed'
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY year, month;

-- ==============================================
-- 5. GEOGRAPHICAL ANALYSIS
-- ==============================================

-- Sales by State
SELECT 
    c.state,
    COUNT(DISTINCT c.customer_id) as unique_customers,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_revenue,
    AVG(o.total_amount) as avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'completed'
GROUP BY c.state
ORDER BY total_revenue DESC;

-- Top Cities by Revenue
SELECT 
    c.city,
    c.state,
    COUNT(DISTINCT c.customer_id) as customers,
    SUM(o.total_amount) as total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'completed'
GROUP BY c.city, c.state
ORDER BY total_revenue DESC
LIMIT 10;

-- ==============================================
-- 6. BUSINESS INSIGHTS QUERIES
-- ==============================================

-- Customer Lifetime Value (Simple Calculation)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.registration_date,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as lifetime_value,
    AVG(o.total_amount) as avg_order_value,
    DATEDIFF(CURDATE(), c.registration_date) as days_since_registration
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'completed'
GROUP BY c.customer_id, customer_name, c.registration_date
ORDER BY lifetime_value DESC;

-- Monthly Growth Rate
SELECT 
    year,
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY year, month) as previous_month_revenue,
    CASE 
        WHEN LAG(monthly_revenue) OVER (ORDER BY year, month) IS NOT NULL 
        THEN ROUND(((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year, month)) / LAG(monthly_revenue) OVER (ORDER BY year, month)) * 100, 2)
        ELSE NULL
    END as growth_rate_percent
FROM (
    SELECT 
        EXTRACT(YEAR FROM order_date) as year,
        EXTRACT(MONTH FROM order_date) as month,
        SUM(total_amount) as monthly_revenue
    FROM orders 
    WHERE order_status = 'completed'
    GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
) monthly_sales
ORDER BY year, month;

-- Product Cross-Selling Analysis
SELECT 
    p1.product_name as product_1,
    p2.product_name as product_2,
    COUNT(*) as times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
JOIN orders o ON oi1.order_id = o.order_id
WHERE o.order_status = 'completed'
GROUP BY p1.product_name, p2.product_name
ORDER BY times_bought_together DESC
LIMIT 10;