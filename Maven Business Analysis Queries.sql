/* BUSINESS PROBLEM: Find the three largest sources of revenue loss across the market to purchase funnel. 
Also, find how much revenue that loss amounts to and what it is as a percentage of potential revenue. Finally, find possible
improvements and choose the improvement that would produce the 
greatest impact. */

-- Use Maven database
USE maven_db;

/* Deeper Analysis and Answering the three business questions of the business problem */
/* Find the three largest sources of revenue loss in the market-to-purchase funnel (home, products, cart, shipping, and billing) */

-- Create table of customer sessions that DID NOT result in a purchase.
CREATE TABLE online_activity_no_purchase AS (
SELECT 
	wpv.website_pageview_id,
	ws.created_at AS session_created,
	ws.website_session_id AS session_id,
	wpv.pageview_url AS pageview_url,
	wpv.created_at AS pageview_created
FROM website_pageviews_cleaned wpv 
JOIN website_sessions_cleaned ws 
ON wpv.website_session_id = ws.website_session_id
LEFT JOIN orders_cleaned o 
ON ws.website_session_id = o.website_session_id
WHERE o.order_id IS NULL
);


-- Calculate how many sessions were used per year to view website material as well as total session conversion rate.
WITH total_session_activity AS (
SELECT
YEAR(session_created) AS session_year, 
COUNT(session_id) AS total_sessions
FROM online_activity_no_purchase
GROUP BY YEAR(session_created)
), previous_sessions  AS (
	SELECT
    *,
    LAG(total_sessions) OVER() previous_year_sessions
    FROM total_session_activity
), session_conversion AS (
	SELECT
    *,
    CONCAT((total_sessions - previous_year_sessions) / previous_year_sessions * 100, '%') AS session_conversion_rate
    FROM previous_sessions
)

SELECT
*
FROM session_conversion;


/* Investigate the data and customer activity between 2014 and 2015 (since those years resulted in the largest session drop). 
This can be used to produce recommendations to answer the business problem.*/

-- Total revenue per year
SELECT 
YEAR(created_at) AS session_year,
SUM(items_purchased * price_usd) AS total_revenue
FROM orders_cleaned
GROUP BY YEAR(created_at);


-- Total refunds per year
SELECT 
YEAR(created_at) AS refund_year,
COUNT(DISTINCT order_item_refund_id) AS total_refunds,
SUM(refund_amount_usd) AS total_refund_amount
FROM  order_item_refunds_cleaned
GROUP BY YEAR(created_at);

-- Find the total refund amount for each product
SELECT
p.product_name,
SUM(refund_amount_usd) AS total_refund_amount
FROM order_item_refunds_cleaned oir
JOIN order_items_cleaned oic 
ON oir.order_item_id = oic.order_item_id
JOIN orders_cleaned oc
ON oir.order_id = oc.order_id
JOIN products p 
ON oic.product_id = p.product_id
GROUP BY product_name;

-- What is the product popularity per year?
SELECT
YEAR(created_at) AS year_viewed,
pageview_url, COUNT(*) AS total_views
FROM website_pageviews_cleaned
WHERE pageview_url IN (
'/the-original-mr-fuzzy',
'/the-forever-love-bear',
'/the-birthday-sugar-panda',
'/the-hudson-river-mini-bear'
)
GROUP BY YEAR(created_at), pageview_url
ORDER BY year_viewed, total_views DESC;

SELECT
*
FROM website_sessions_cleaned;


-- Calculate how much each viewed product, including the highest selling product (the original mr fuzzy), contributed to overall sales each year. 
SELECT 
t.pageview_url,
COUNT(*) AS total_views,
SUM(t.items_purchased * price_usd) AS total_revenue
FROM (
SELECT
ws.website_session_id AS session_id,
wp.pageview_url AS pageview_url,
ws.created_at AS session_created,
wp.created_at AS pageview_created,
oc.order_id AS order_id,
oc.items_purchased AS items_purchased,
oic.order_item_id AS order_item_id,
oic.price_usd,
p.product_name AS product_name,
ROW_NUMBER()OVER(PARTITION BY ws.website_session_id ORDER BY wp.created_at) AS r_n
FROM website_sessions_cleaned ws 
JOIN website_pageviews_cleaned wp
ON ws.website_session_id = wp.website_session_id
JOIN orders_cleaned oc
ON ws.website_session_id = oc.website_session_id
JOIN order_items_cleaned oic 
ON oc.order_id = oic.order_id
JOIN products p 
ON oic.product_id = p.product_id
WHERE pageview_url IN (
'/the-original-mr-fuzzy',
'/the-forever-love-bear',
'/the-birthday-sugar-panda',
'/the-hudson-river-mini-bear'
)
) t
GROUP BY t.pageview_url;


-- Calculate the conversion rate for customers who viewed the home url of the maven website.
WITH home_only_activity AS (
	SELECT 
    YEAR(session_created) AS session_year, 
    COUNT(*) AS total_viewers
    FROM online_activity_no_purchase
    WHERE pageview_url = '/home'
    GROUP BY YEAR(session_created)
), previous_home_views AS (
	SELECT
    *,
    LAG(total_viewers) OVER() AS previous_year_viewers
    FROM home_only_activity
), home_conversion AS (
	SELECT
    *,
    CONCAT(((total_viewers - previous_year_viewers) / previous_year_viewers) * 100, '%') AS conversion_rate
    FROM previous_home_views
)

SELECT * 
FROM home_conversion;


-- Calculate the conversion rate for customers who viewed the products url of the maven website.
WITH product_only_activity AS (
	SELECT 
    YEAR(session_created) AS session_year, 
    COUNT(*) AS total_viewers
    FROM online_activity_no_purchase
    WHERE pageview_url = '/products'
    GROUP BY YEAR(session_created)
), previous_product_views AS (
	SELECT
    *,
    LAG(total_viewers) OVER() AS previous_year_viewers
    FROM product_only_activity
), product_transition AS (
	SELECT
    *,
    CONCAT(((total_viewers - previous_year_viewers) / previous_year_viewers) * 100, '%') AS conversion_rate
    FROM previous_product_views
)

SELECT
*
FROM product_transition;

-- Calculate the conversion rate for customers who viewed the cart url of the maven website.
WITH cart_only_activity AS (
	SELECT 
    YEAR(session_created) AS session_year, 
    COUNT(*) AS total_viewers
    FROM online_activity_no_purchase
    WHERE pageview_url = '/cart'
    GROUP BY YEAR(session_created)
), previous_cart_views AS (
	SELECT
    *,
    LAG(total_viewers) OVER() AS previous_year_viewers
    FROM cart_only_activity
), cart_conversion AS (
	SELECT
    *,
    CONCAT(((total_viewers - previous_year_viewers) / previous_year_viewers) * 100, '%') AS conversion_rate
    FROM previous_cart_views
)

SELECT * 
FROM cart_conversion;


-- Calculate the conversion rate for customers who viewed the shipping url of the maven website.
WITH shipping_only_activity AS (
	SELECT 
    YEAR(session_created) AS session_year, 
    COUNT(*) AS total_viewers
    FROM online_activity_no_purchase
    WHERE pageview_url = '/shipping'
    GROUP BY YEAR(session_created)
), previous_shipping_views AS (
	SELECT
    *,
    LAG(total_viewers) OVER() AS previous_year_viewers
    FROM shipping_only_activity
), shipping_conversion AS (
	SELECT
    *,
    CONCAT(((total_viewers - previous_year_viewers) / previous_year_viewers) * 100, '%') AS conversion_rate
    FROM previous_shipping_views
)

SELECT * 
FROM shipping_conversion;



-- Calculate the conversion rate for customers who viewed the billing url of the maven website.
WITH billing_only_activity AS (
	SELECT 
    YEAR(session_created) AS session_year, 
    COUNT(*) AS total_viewers
    FROM online_activity_no_purchase
    WHERE pageview_url = '/billing'
    GROUP BY YEAR(session_created)
), previous_billing_views AS (
	SELECT
    *,
    LAG(total_viewers) OVER() AS previous_year_viewers
    FROM billing_only_activity
), billing_conversion AS (
	SELECT
    *,
    CONCAT(((total_viewers - previous_year_viewers) / previous_year_viewers) * 100, '%') AS conversion_rate
    FROM previous_billing_views
)

SELECT * 
FROM billing_conversion;

-- Calculate the conversion rate for customers who viewed the billing-2 (second billing page) url of the maven website.
WITH billing_two_only_activity AS (
	SELECT 
    YEAR(session_created) AS session_year, 
    COUNT(*) AS total_viewers
    FROM online_activity_no_purchase
    WHERE pageview_url = '/billing-2'
    GROUP BY YEAR(session_created)
), previous_billing_two_views AS (
	SELECT
    *,
    LAG(total_viewers) OVER() AS previous_year_viewers
    FROM billing_two_only_activity
), billing_two_conversion AS (
	SELECT
    *,
    CONCAT(((total_viewers - previous_year_viewers) / previous_year_viewers) * 100, '%') AS conversion_rate
    FROM previous_billing_two_views
)

SELECT * 
FROM billing_two_conversion;

-- Inter-url and page view count and conversion rate amongst customers who did not make a purchase 
-- Funnel: (home, products, cart, shipping, billing, and billing-2)
CREATE TABLE url_conversion_rates AS
WITH url_conversion AS (
	SELECT 
	pageview_url,
	COUNT(pageview_url) AS total_pageviews
	FROM online_activity_no_purchase
	WHERE pageview_url 
	IN
	('/home', '/products', '/cart', '/shipping', '/billing', '/billing-2')
	GROUP BY pageview_url
), calculate_previous AS (
	SELECT
	pageview_url,
	CASE
		WHEN pageview_url = '/home' THEN 1
        WHEN pageview_url = '/products' THEN 2
		WHEN pageview_url = '/cart' THEN 3
		WHEN pageview_url = '/shipping' THEN 4    
		WHEN pageview_url = '/billing' THEN 5
		WHEN pageview_url = '/billing-2' THEN 6
    END AS url_order,
    total_pageviews,
	LAG(total_pageviews) OVER() AS previous_pageviews
	FROM url_conversion
), view_conversion_rate AS (
	SELECT
    *,
    (total_pageviews - previous_pageviews) / previous_pageviews AS conversion_rate
    FROM calculate_previous
)

SELECT
pageview_url,
url_order,
total_pageviews,
conversion_rate
FROM view_conversion_rate
ORDER BY url_order;




-- Return results for the total views where the view was a product url per year.
CREATE TABLE yearly_product_views AS
SELECT
YEAR(created_at) AS view_year, 
COUNT(*) AS total_product_views
FROM website_pageviews_cleaned
WHERE pageview_url IN (
'/the-original-mr-fuzzy',
'/the-forever-love-bear',
'/the-birthday-sugar-panda',
'/the-hudson-river-mini-bear'
)
GROUP BY view_year
ORDER BY view_year;

-- Return results for the total views where the view was the home url per year.
CREATE TABLE yearly_home_views AS
SELECT
YEAR(created_at) AS view_year, 
COUNT(*) AS total_home_views
FROM website_pageviews_cleaned
WHERE pageview_url IN (
'/home'
)
GROUP BY view_year
ORDER BY view_year;

-- Return results for the total views where the view was the cart url per year.
CREATE TABLE yearly_cart_views AS
SELECT
YEAR(created_at) AS view_year, 
COUNT(*) AS total_cart_views
FROM website_pageviews_cleaned
WHERE pageview_url IN (
'/cart'
)
GROUP BY view_year
ORDER BY view_year;

-- Count total sessions per year 
CREATE TABLE sessions_per_year AS
SELECT 
YEAR(created_at) AS session_year, 
COUNT(DISTINCT website_session_id) AS total_sessions
FROM website_sessions_cleaned
GROUP BY session_year
ORDER BY session_year;


-- Count total views per year
CREATE TABLE views_per_year AS
WITH yearly_views AS (
	SELECT 
	YEAR(created_at) AS pageview_year, 
	COUNT(DISTINCT website_pageview_id) AS total_pageviews
	FROM website_pageviews_cleaned
	GROUP BY pageview_year
	ORDER BY pageview_year
), calculate_previous AS (
	SELECT
    pageview_year,
    total_pageviews,
    LAG(total_pageviews) OVER() AS previous_pageviews
    FROM yearly_views
), pageview_conversion_rate AS (
	SELECT
    pageview_year,
    total_pageviews,
    (total_pageviews - previous_pageviews) / previous_pageviews AS conversion_rate
    FROM calculate_previous
)

SELECT
pageview_year,
total_pageviews,
conversion_rate
FROM pageview_conversion_rate;

