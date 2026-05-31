-- ============================================================
-- BIKE STORE DATA WAREHOUSE - ANALYTICAL QUERIES
-- Author: Taufiq Akbar Wardiana
-- ============================================================


-- ------------------------------------------------------------
-- 1. TOTAL REVENUE KESELURUHAN
-- ------------------------------------------------------------
SELECT 
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary;


-- ------------------------------------------------------------
-- 2. REVENUE PER STORE
-- ------------------------------------------------------------
SELECT 
    store_name,
    COUNT(DISTINCT order_id)        AS total_orders,
    SUM(quantity)                   AS total_qty,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
GROUP BY store_name
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 3. REVENUE PER TAHUN PER STORE
-- ------------------------------------------------------------
SELECT
    store_name,
    EXTRACT(YEAR FROM order_date)   AS tahun,
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
WHERE order_status = 4
GROUP BY store_name, tahun
ORDER BY store_name, tahun;


-- ------------------------------------------------------------
-- 4. REVENUE PER KATEGORI
-- ------------------------------------------------------------
SELECT
    category_name,
    SUM(quantity)                   AS total_qty,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
GROUP BY category_name
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 5. TOP 10 PRODUK BY REVENUE
-- ------------------------------------------------------------
SELECT 
    product_name,
    brand_name,
    category_name,
    SUM(quantity)                   AS total_qty,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
GROUP BY product_name, brand_name, category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 6. PERFORMA STAFF BY REVENUE
-- ------------------------------------------------------------
SELECT
    staff_first_name || ' ' || staff_last_name AS staff_name,
    store_name,
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
WHERE order_status = 4
GROUP BY staff_name, store_name
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 7. STOCK STATUS PER STORE
-- ------------------------------------------------------------
SELECT
    store_name,
    brand_name,
    SUM(quantity) AS total_stock
FROM gold_stock_summary
GROUP BY store_name, brand_name
ORDER BY store_name, total_stock DESC;


-- ------------------------------------------------------------
-- 8. PRODUK DENGAN STOK MENIPIS (< 10)
-- ------------------------------------------------------------
SELECT
    store_name,
    product_name,
    brand_name,
    quantity AS current_stock
FROM gold_stock_summary
WHERE quantity < 10
ORDER BY quantity ASC;


-- ------------------------------------------------------------
-- 9. REVENUE PER BRAND
-- -----------------
