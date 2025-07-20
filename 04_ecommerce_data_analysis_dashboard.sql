
-- Customer Acquisition by Month
SELECT 
    EXTRACT(YEAR FROM registration_date) as year,
    EXTRACT(MONTH FROM registration_date) as month,
    COUNT(*) as new_customers,
    SUM(COUNT(*)) OVER (ORDER BY EXTRACT(YEAR FROM registration_date), EXTRACT(MONTH FROM registration_date)) as cumulative_customers
FROM customers
GROUP BY EXTRACT(YEAR FROM registration_date), EXTRACT(MONTH FROM registration_date)
ORDER BY year, month;

-- ==============================================
-- INVENTORY ANALYSIS
-- ==============================================

-- Product Velocity Analysis
SELECT 
    p.product_name,
    c.category_name,
    p.price,
    COALESCE(SUM(oi.quantity), 0) as total_sold,
    CASE 
        WHEN COALESCE(SUM(oi.quantity), 0) >= 3 THEN 'Fast Moving'
        WHEN COALESCE(SUM(oi.quantity), 0) >= 1 THEN 'Moderate Moving'
        ELSE 'Slow Moving'
    END as velocity_category
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.order_status = 'completed'
GROUP BY p.product_id, p.product_name, c.category_name, p.price
ORDER BY total_sold DESC;

-- ==============================================
-- CUSTOMER BEHAVIOR ANALYSIS
-- ==============================================

-- Purchase Frequency Analysis
SELECT 
    customer_frequency,
    COUNT(*) as customer_count,
    AVG(total_spent) as avg_spent_per_customer
FROM (
    SELECT 
        c.customer_id,
        COUNT(o.order_id) as customer_frequency,
        SUM(o.total_amount) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'completed'
    GROUP BY c.customer_id
) frequency_analysis
GROUP BY customer_frequency
ORDER BY customer_frequency;

-- Customer Age Group Analysis
SELECT 
    CASE 
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END as age_group,
    COUNT(DISTINCT c.customer_id) as customers,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_revenue,
    AVG(o.total_amount) as avg_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'completed'
GROUP BY age_group
ORDER BY total_revenue DESC;

-- ==============================================
-- SEASONAL ANALYSIS
-- ==============================================

-- Day of Week Analysis
SELECT 
    DAYNAME(order_date) as day_of_week,
    COUNT(*) as orders_count,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as avg_order_value
FROM orders
WHERE order_status = 'completed'
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY DAYOFWEEK(order_date);

-- ==============================================
-- PRICING ANALYSIS
-- ==============================================

-- Price Point Analysis
SELECT 
    CASE 
        WHEN price < 50 THEN 'Budget ($0-49)'
        WHEN price BETWEEN 50 AND 99 THEN 'Mid-range ($50-99)'
        WHEN price BETWEEN 100 AND 149 THEN 'Premium ($100-149)'
        ELSE 'Luxury ($150+)'
    END as price_range,
    COUNT(DISTINCT p.product_id) as products_count,
    SUM(oi.quantity) as total_units_sold,
    SUM(oi.quantity * oi.unit_price) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.order_status = 'completed'
GROUP BY price_range
ORDER BY total_revenue DESC;

-- ==============================================
-- BUSINESS METRICS DASHBOARD
-- ==============================================

-- Key Performance Indicators (KPIs)
SELECT 
    'Total Customers' as metric,
    COUNT(*) as value,
    NULL as percentage
FROM customers
UNION ALL
SELECT 
    'Total Orders' as metric,
    COUNT(*) as value,
    NULL as percentage
FROM orders
UNION ALL
SELECT 
    'Completed Orders' as metric,
    COUNT(*) as value,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders)), 2) as percentage
FROM orders WHERE order_status = 'completed'
UNION ALL
SELECT 
    'Total Revenue' as metric,
    ROUND(SUM(total_amount), 2) as value,
    NULL as percentage
FROM orders WHERE order_status = 'completed'
UNION ALL
SELECT 
    'Average Order Value' as metric,
    ROUND(AVG(total_amount), 2) as value,
    NULL as percentage
FROM orders WHERE order_status = 'completed';