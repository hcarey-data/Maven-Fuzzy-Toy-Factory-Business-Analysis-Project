-- Create project database.
CREATE DATABASE maven_db;
-- Use database.
USE maven_db;

-- Create dataset tables to store data.
CREATE TABLE orders (
	order_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    user_id INT,
    primary_product_id INT,
    items_purchased INT,
    price_usd DECIMAL(10, 2),
    cogs_usd DECIMAL(10, 2)
);

SELECT * FROM orders;

CREATE TABLE order_items (
	order_item_id INT PRIMARY KEY,
    created_at DATETIME,
    order_id INT,
    product_id INT,
    is_primary_item BOOLEAN,
    price_usd DECIMAL(10, 2),
    cogs_usd DECIMAL(10, 2)
);

SELECT * FROM order_items;

CREATE TABLE order_item_refunds(
	order_item_refund_id INT PRIMARY KEY,
    created_at DATETIME,
    order_item_id INT,
    order_id INT,
    refund_amount_usd DECIMAL(10, 2)
);

SELECT * FROM order_item_refunds;

CREATE TABLE products (
	product_id INT PRIMARY KEY,
    created_at DATETIME,
    product_name VARCHAR(50)
);

SELECT * FROM products;

CREATE TABLE website_sessions (
	website_session_id INT PRIMARY KEY,
    created_at DATETIME,
    user_id INT,
    is_repeat_session BOOLEAN,
    utm_source VARCHAR(50),
    utm_campaign VARCHAR(50),
    utm_content VARCHAR(50),
    device_type VARCHAR(50),
    http_referer VARCHAR(100)
);

SELECT * FROM website_sessions;

CREATE TABLE website_pageviews (
	website_pageview_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    pageview_url VARCHAR(255)
);

SELECT * FROM website_pageviews;

-- Load data into SQL tables.
LOAD DATA LOCAL INFILE 'C:/Users/18328/Downloads/Maven+Fuzzy+Factory/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/18328/Downloads/Maven+Fuzzy+Factory/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/18328/Downloads/Maven+Fuzzy+Factory/order_item_refunds.csv'
INTO TABLE order_item_refunds
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/18328/Downloads/Maven+Fuzzy+Factory/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/18328/Downloads/Maven+Fuzzy+Factory/website_sessions.csv'
INTO TABLE website_sessions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/18328/Downloads/Maven+Fuzzy+Factory/website_pageviews.csv'
INTO TABLE website_pageviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/* DATA CLEANING  */

-- Orders Table

-- Check datatypes.
DESCRIBE orders;

-- Count duplicate rows. (There are no duplicates.)
SELECT 
	order_id, 
    created_at, 
    website_session_id, 
    user_id, 
    primary_product_id, 
    items_purchased, 
    price_usd, 
    cogs_usd, 
    COUNT(*) 
FROM orders
GROUP BY order_id, created_at, website_session_id, user_id, primary_product_id, items_purchased, price_usd, cogs_usd
HAVING COUNT(*) > 1;

-- Check for nulls and blanks. (There are no nulls or blanks.)
SELECT 
	SUM(CASE WHEN order_id IS NULL OR LENGTH(TRIM(order_id)) = 0 THEN 1 ELSE 0 END) AS order_id_nulls_blanks,
    SUM(CASE WHEN created_at IS NULL OR LENGTH(TRIM(created_at)) = 0 THEN 1 ELSE 0 END) AS created_at_nulls_blanks,
    SUM(CASE WHEN website_session_id IS NULL OR LENGTH(TRIM(website_session_id)) = 0 THEN 1 ELSE 0 END) AS website_session_id_nulls_blanks,
	SUM(CASE WHEN user_id IS NULL OR LENGTH(TRIM(user_id)) = 0 THEN 1 ELSE 0 END) AS user_id_nulls_blanks,
    SUM(CASE WHEN primary_product_id IS NULL OR LENGTH(TRIM(primary_product_id)) = 0 THEN 1 ELSE 0 END) AS primary_product_id_nulls_blanks,
    SUM(CASE WHEN items_purchased IS NULL OR LENGTH(TRIM(items_purchased)) = 0 THEN 1 ELSE 0 END) AS items_purchased_nulls_blanks,
	SUM(CASE WHEN price_usd IS NULL OR LENGTH(TRIM(price_usd)) = 0 THEN 1 ELSE 0 END) AS price_usd_nulls_blanks,
    SUM(CASE WHEN cogs_usd IS NULL OR LENGTH(TRIM(cogs_usd)) = 0 THEN 1 ELSE 0 END) AS cogs_usd_nulls_blanks
FROM orders;

-- Minimum and Maximum values
SELECT
	MIN(created_at) AS earliest_date,
    MAX(created_at) AS latest_date,
    MIN(items_purchased) AS min_purchased_items,
    MAX(items_purchased) AS max_items_purchased,
    MIN(price_usd) AS min_price,
    MAX(price_usd) AS max_price,
    MIN(cogs_usd) AS min_cogs_usd,
    MAX(cogs_usd) AS max_cogs_usd
FROM orders;

-- After running test queries, created cleaned table.
CREATE TABLE orders_cleaned AS 
SELECT 
	order_id, 
    created_at, 
    website_session_id, 
    user_id, 
    primary_product_id, 
    items_purchased, 
    price_usd, 
    cogs_usd
FROM orders;


-- Orders Items Table

-- Check datatypes.
DESCRIBE order_items;

-- Count duplicate rows. (There are no duplicates.)
SELECT 
	order_item_id, 
    created_at, 
    order_id, 
    product_id, 
    is_primary_item, 
    price_usd, 
    cogs_usd, 
    COUNT(*) 
FROM order_items
GROUP BY order_item_id, created_at, order_id, product_id, is_primary_item, price_usd, cogs_usd
HAVING COUNT(*) > 1;

-- Check for nulls and blanks. (There are no nulls or blanks.)
SELECT 
	SUM(CASE WHEN order_item_id IS NULL OR LENGTH(TRIM(order_item_id)) = 0 THEN 1 ELSE 0 END) AS order_item_id_nulls_blanks,
    SUM(CASE WHEN created_at IS NULL OR LENGTH(TRIM(created_at)) = 0 THEN 1 ELSE 0 END) AS created_at_nulls_blanks,
    SUM(CASE WHEN order_id IS NULL OR LENGTH(TRIM(order_id)) = 0 THEN 1 ELSE 0 END) AS order_id_nulls_blanks,
	SUM(CASE WHEN product_id IS NULL OR LENGTH(TRIM(product_id)) = 0 THEN 1 ELSE 0 END) AS product_id_nulls_blanks,
    SUM(CASE WHEN is_primary_item IS NULL OR LENGTH(TRIM(is_primary_item)) = 0 THEN 1 ELSE 0 END) AS is_primary_item_nulls_blanks,
	SUM(CASE WHEN price_usd IS NULL OR LENGTH(TRIM(price_usd)) = 0 THEN 1 ELSE 0 END) AS price_usd_nulls_blanks,
    SUM(CASE WHEN cogs_usd IS NULL OR LENGTH(TRIM(cogs_usd)) = 0 THEN 1 ELSE 0 END) AS cogs_usd_nulls_blanks
FROM order_items;

-- Minimum and Maximum values
SELECT
	MIN(created_at) AS earliest_date,
    MAX(created_at) AS latest_date,
    MIN(price_usd) AS min_price,
    MAX(price_usd) AS max_price,
    MIN(cogs_usd) AS min_cogs_usd,
    MAX(cogs_usd) AS max_cogs_usd
FROM order_items;

-- After running test queries, created cleaned table.
CREATE TABLE order_items_cleaned AS 
SELECT 
	order_item_id, 
    created_at, 
    order_id, 
    product_id, 
    is_primary_item, 
    price_usd, 
    cogs_usd
FROM order_items;



-- Orders Item Refunds Table

-- Check datatypes.
DESCRIBE order_item_refunds;

-- Count duplicate rows. (There are no duplicates.)
SELECT 
	order_item_refund_id, 
    created_at, 
    order_item_id,
    order_id,
    refund_amount_usd,
    COUNT(*) 
FROM order_item_refunds
GROUP BY order_item_refund_id, created_at, order_item_id, order_id, refund_amount_usd
HAVING COUNT(*) > 1;

-- Check for nulls and blanks. (There are no nulls or blanks.)
SELECT 
	SUM(CASE WHEN order_item_refund_id IS NULL OR LENGTH(TRIM(order_item_refund_id)) = 0 THEN 1 ELSE 0 END) AS order_item_refund_id_nulls_blanks,
    SUM(CASE WHEN created_at IS NULL OR LENGTH(TRIM(created_at)) = 0 THEN 1 ELSE 0 END) AS created_at_nulls_blanks,
    SUM(CASE WHEN order_item_id IS NULL OR LENGTH(TRIM(order_item_id)) = 0 THEN 1 ELSE 0 END) AS order_item_id_nulls_blanks,
	SUM(CASE WHEN order_id IS NULL OR LENGTH(TRIM(order_id )) = 0 THEN 1 ELSE 0 END) AS order_id_nulls_blanks,
    SUM(CASE WHEN refund_amount_usd IS NULL OR LENGTH(TRIM(refund_amount_usd)) = 0 THEN 1 ELSE 0 END) AS refund_amount_usd_nulls_blanks
FROM order_item_refunds;


-- Minimum and Maximum values
SELECT
	MIN(created_at) AS earliest_date,
    MAX(created_at) AS latest_date,
    MIN(refund_amount_usd) AS min_refund_amount_usd,
    MAX(refund_amount_usd) AS max_refund_amount_usd
FROM order_item_refunds;

-- After running test queries, created cleaned table.
CREATE TABLE order_item_refunds_cleaned AS 
SELECT 
	order_item_refund_id, 
    created_at, 
    order_item_id,
    order_id,
    refund_amount_usd
FROM order_item_refunds;



-- Products Table

-- Check datatypes.
DESCRIBE products;

-- Count duplicate rows. (There are no duplicates.)
SELECT 
	product_id, 
    created_at, 
    product_name,
    COUNT(*) 
FROM products
GROUP BY product_id, created_at, product_name
HAVING COUNT(*) > 1;

-- Check for nulls and blanks. (There are no nulls or blanks.)
SELECT 
	SUM(CASE WHEN product_id IS NULL OR LENGTH(TRIM(product_id)) = 0 THEN 1 ELSE 0 END) AS product_id_nulls_blanks,
    SUM(CASE WHEN created_at IS NULL OR LENGTH(TRIM(created_at)) = 0 THEN 1 ELSE 0 END) AS created_at_nulls_blanks,
    SUM(CASE WHEN product_name IS NULL OR LENGTH(TRIM(product_name)) = 0 THEN 1 ELSE 0 END) AS product_name_nulls_blanks
FROM products;


-- Minimum and Maximum values
SELECT
	MIN(created_at) AS earliest_date,
    MAX(created_at) AS latest_date
FROM products;

-- After running test queries, created cleaned table.
CREATE TABLE products_cleaned AS 
SELECT 
	product_id, 
    created_at, 
    product_name
FROM products;


-- Website Sessions Table

-- Check datatypes.
DESCRIBE website_sessions;

-- Count duplicate rows. (There are no duplicates.)
SELECT 
	website_session_id,
    created_at,
    user_id,
    is_repeat_session,
    utm_source,
    utm_campaign,
    utm_content,
    device_type,
    http_referer,
    COUNT(*) 
FROM website_sessions
GROUP BY website_session_id, created_at, user_id, is_repeat_session, utm_source, utm_campaign, utm_content, device_type, http_referer
HAVING COUNT(*) > 1;

-- Check for nulls and blanks. There were nulls found in utm_source, utm_campaign, and utm_content columns.
SELECT 
	SUM(CASE WHEN website_session_id IS NULL OR LENGTH(TRIM(website_session_id)) = 0 THEN 1 ELSE 0 END) AS website_session_id_nulls_blanks,
    SUM(CASE WHEN created_at IS NULL OR LENGTH(TRIM(created_at)) = 0 THEN 1 ELSE 0 END) AS created_at_nulls_blanks,
    SUM(CASE WHEN user_id IS NULL OR LENGTH(TRIM(user_id)) = 0 THEN 1 ELSE 0 END) AS user_id_nulls_blanks,
    SUM(CASE WHEN is_repeat_session IS NULL OR LENGTH(TRIM(is_repeat_session)) = 0 THEN 1 ELSE 0 END) AS is_repeat_session_nulls_blanks,
    SUM(CASE WHEN utm_source IS NULL OR LENGTH(TRIM(utm_source)) = 0 THEN 1 ELSE 0 END) AS utm_source_nulls_blanks,
    SUM(CASE WHEN utm_campaign IS NULL OR LENGTH(TRIM(utm_campaign)) = 0 THEN 1 ELSE 0 END) AS utm_campaign_nulls_blanks,
    SUM(CASE WHEN utm_content IS NULL OR LENGTH(TRIM(utm_content)) = 0 THEN 1 ELSE 0 END) AS utm_content_nulls_blanks,
    SUM(CASE WHEN device_type IS NULL OR LENGTH(TRIM(device_type)) = 0 THEN 1 ELSE 0 END) AS device_type_nulls_blanks,
    SUM(CASE WHEN http_referer IS NULL OR LENGTH(TRIM(http_referer)) = 0 THEN 1 ELSE 0 END) AS http_referer_nulls_blanks
FROM website_sessions;


-- Minimum and Maximum values
SELECT
	MIN(created_at) AS earliest_date,
    MAX(created_at) AS latest_date
FROM website_sessions;

SELECT COUNT(*) FROM website_sessions;

SELECT * FROM website_sessions_cleaned
WHERE utm_source IS NULL 
OR utm_campaign IS NULL
OR utm_content IS NULL;

-- After running test queries, created cleaned table.
CREATE TABLE website_sessions_cleaned AS 
SELECT
    website_session_id,
    created_at,
    user_id,
    is_repeat_session,
    COALESCE(utm_source, 'not_specified') AS utm_source,
    COALESCE(utm_campaign, 'not_specified') AS utm_campaign,
    COALESCE(utm_content, 'not_specified') AS utm_content,
    device_type,
    http_referer
FROM website_sessions;


-- Products Table

-- Check datatypes.
DESCRIBE website_pageviews;

-- Count duplicate rows. (There are no duplicates.)
SELECT 
	website_pageview_id,
    created_at,
    website_session_id,
    COUNT(*) 
FROM website_pageviews
GROUP BY website_pageview_id, created_at, website_session_id
HAVING COUNT(*) > 1;

-- Check for nulls and blanks. (There are no nulls or blanks.)
SELECT 
	SUM(CASE WHEN website_pageview_id IS NULL OR LENGTH(TRIM(website_pageview_id)) = 0 THEN 1 ELSE 0 END) AS website_pageview_id_nulls_blanks,
    SUM(CASE WHEN created_at IS NULL OR LENGTH(TRIM(created_at)) = 0 THEN 1 ELSE 0 END) AS created_at_nulls_blanks,
    SUM(CASE WHEN website_session_id IS NULL OR LENGTH(TRIM(website_session_id)) = 0 THEN 1 ELSE 0 END) AS website_session_id_nulls_blanks
FROM website_pageviews;


-- Minimum and Maximum values
SELECT
	MIN(created_at) AS earliest_date,
    MAX(created_at) AS latest_date
FROM website_pageviews;

-- After running test queries, created cleaned table.
CREATE TABLE website_pageviews_cleaned AS 
SELECT 
	website_pageview_id,
    created_at,
    website_session_id
FROM website_pageviews;


/* EXPLORATORY DATA ANALYSIS (EDA) */
SELECT * FROM orders_cleaned;
SELECT * FROM order_items_cleaned;
SELECT * FROM order_item_refunds_cleaned;
SELECT * FROM products_cleaned;
SELECT * FROM website_sessions;
SELECT * FROM website_pageviews;


/* GENERAL KPIs */

-- Total Revenue (Defined as price_usd * items_purchased)
SELECT 
	SUM(price_usd * items_purchased) AS total_revenue
FROM orders_cleaned;

-- Total Cost of Goods sold (COGS)
SELECT
	SUM(cogs_usd) AS total_cost_of_goods_sold
FROM orders_cleaned;

-- Total Gross Profit 
SELECT
	SUM(price_usd * items_purchased) - SUM(cogs_usd)
FROM orders_cleaned;

-- Total Gross Profit Margin 
SELECT
	CONCAT(ROUND(((SUM(price_usd * items_purchased) - SUM(cogs_usd)) / SUM(price_usd * items_purchased)) * 100, 2), '%') AS total_gross_profit_margin
FROM orders_cleaned;

-- Total Orders
SELECT 
	COUNT(DISTINCT order_id) AS total_orders
FROM orders_cleaned;

-- Average Order Value (AOV)
SELECT 
	ROUND(SUM(price_usd * items_purchased) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM orders_cleaned;

-- Total Refunds
SELECT
	COUNT(DISTINCT order_item_refund_id) AS total_refund_count,
    SUM(refund_amount_usd) AS total_refund_total_usd,
	ROUND(SUM(refund_amount_usd) / (SELECT COUNT(DISTINCT order_item_refund_id) FROM order_item_refunds_cleaned), 2) AS average_refund_amount
FROM order_item_refunds_cleaned;

-- Total Online Sessions
SELECT
COUNT(DISTINCT website_session_id) AS total_sessions
FROM website_sessions_cleaned;

-- Count the number of repeated and non-repeated sessions along with their ratio to the total sessions
WITH session_count AS (
	SELECT
	is_repeat_session,
	COUNT(*) AS total_sessions
	FROM website_sessions_cleaned
	GROUP BY is_repeat_session
), case_name AS (
	SELECT
    (CASE WHEN is_repeat_session = 0 THEN 'Yes' ELSE 'No' END) AS is_repeat_session,
    total_sessions,
    total_sessions / (SELECT COUNT(*) FROM website_sessions_cleaned) AS session_ratio
    FROM session_count
)

SELECT
	is_repeat_session,
	total_sessions,
    session_ratio
FROM case_name;

-- Session Device Types and their ratio to total sessions
SELECT
	device_type,
    COUNT(*) AS number_of_devices,
    COUNT(*) / (SELECT COUNT(*) FROM website_sessions_cleaned) AS device_ratio
FROM website_sessions_cleaned
GROUP BY device_type;

-- Total Page Views
SELECT 
	COUNT(DISTINCT website_pageview_id) AS total_pageviews
FROM website_pageviews_cleaned;
	






