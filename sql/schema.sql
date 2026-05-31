-- ============================================================
-- BIKE STORE DATA WAREHOUSE - DATABASE SCHEMA
-- Author: Taufiq Akbar Wardiana
-- ============================================================


-- ------------------------------------------------------------
-- BRONZE LAYER - RAW TABLES
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS bronze_brands (
    brand_id    VARCHAR,
    brand_name  VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze_categories (
    category_id   VARCHAR,
    category_name VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze_customers (
    customer_id VARCHAR,
    first_name  VARCHAR,
    last_name   VARCHAR,
    phone       VARCHAR,
    email       VARCHAR,
    street      VARCHAR,
    city        VARCHAR,
    state       VARCHAR,
    zip_code    INTEGER
);

CREATE TABLE IF NOT EXISTS bronze_products (
    product_id   VARCHAR,
    product_name VARCHAR,
    brand_id     VARCHAR,
    category_id  VARCHAR,
    model_year   INTEGER,
    list_price   NUMERIC
);

CREATE TABLE IF NOT EXISTS bronze_orders (
    order_id      VARCHAR,
    customer_id   VARCHAR,
    order_status  INTEGER,
    order_date    VARCHAR,
    required_date VARCHAR,
    shipped_date  VARCHAR,
    store_id      VARCHAR,
    staff_id      VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze_order_items (
    order_item_id VARCHAR,
    order_id      VARCHAR,
    item_id       VARCHAR,
    product_id    VARCHAR,
    quantity      INTEGER,
    list_price    NUMERIC,
    discount      NUMERIC
);

CREATE TABLE IF NOT EXISTS bronze_staffs (
    staff_id   VARCHAR,
    first_name VARCHAR,
    last_name  VARCHAR,
    email      VARCHAR,
    phone      VARCHAR,
    active     INTEGER,
    store_id   VARCHAR,
    manager_id VARCHAR
);

CREATE TABLE IF NOT EXISTS bronze_stocks (
    stock_id   VARCHAR,
    store_id   VARCHAR,
    product_id VARCHAR,
    quantity   INTEGER
);

CREATE TABLE IF NOT EXISTS bronze_stores (
    store_id   VARCHAR,
    store_name VARCHAR,
    phone      VARCHAR,
    email      VARCHAR,
    street     VARCHAR,
    city       VARCHAR,
    state      VARCHAR,
    zip_code   INTEGER
);


-- ------------------------------------------------------------
-- SILVER LAYER - CLEANED TABLES
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS silver_brands (
    brand_id    VARCHAR,
    brand_name  VARCHAR
);

CREATE TABLE IF NOT EXISTS silver_categories (
    category_id   VARCHAR,
    category_name VARCHAR
);

CREATE TABLE IF NOT EXISTS silver_customers (
    customer_id VARCHAR,
    first_name  VARCHAR,
    last_name   VARCHAR,
    phone       VARCHAR,
    email       VARCHAR,
    street      VARCHAR,
    city        VARCHAR,
    state       VARCHAR,
    zip_code    INTEGER
);

CREATE TABLE IF NOT EXISTS silver_products (
    product_id   VARCHAR,
    product_name VARCHAR,
    brand_id     VARCHAR,
    category_id  VARCHAR,
    model_year   INTEGER,
    list_price   NUMERIC
);

CREATE TABLE IF NOT EXISTS silver_orders (
    order_id           VARCHAR,
    customer_id        VARCHAR,
    order_status       INTEGER,
    order_status_label VARCHAR,
    order_date         TIMESTAMP,
    required_date      TIMESTAMP,
    shipped_date       TIMESTAMP,
    store_id           VARCHAR,
    staff_id           VARCHAR
);

CREATE TABLE IF NOT EXISTS silver_order_items (
    order_item_id VARCHAR,
    order_id      VARCHAR,
    item_id       VARCHAR,
    product_id    VARCHAR,
    quantity      INTEGER,
    list_price    NUMERIC,
    discount      NUMERIC
);

CREATE TABLE IF NOT EXISTS silver_staffs (
    staff_id   VARCHAR,
    first_name VARCHAR,
    last_name  VARCHAR,
    email      VARCHAR,
    phone      VARCHAR,
    active     BOOLEAN,
    store_id   VARCHAR,
    manager_id VARCHAR
);

CREATE TABLE IF NOT EXISTS silver_stocks (
    stock_id   VARCHAR,
    store_id   VARCHAR,
    product_id VARCHAR,
    quantity   INTEGER
);

CREATE TABLE IF NOT EXISTS silver_stores (
    store_id   VARCHAR,
    store_name VARCHAR,
    phone      VARCHAR,
    email      VARCHAR,
    street     VARCHAR,
    city       VARCHAR,
    state      VARCHAR,
    zip_code   INTEGER
);


-- ------------------------------------------------------------
-- GOLD LAYER - ANALYTICAL TABLES
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS gold_sales_summary (
    order_id           VARCHAR,
    order_item_id      VARCHAR,
    order_date         TIMESTAMP,
    order_status       INTEGER,
    order_status_label VARCHAR,
    customer_id        VARCHAR,
    store_name         VARCHAR,
    state              VARCHAR,
    product_name       VARCHAR,
    brand_name         VARCHAR,
    category_name      VARCHAR,
    model_year         INTEGER,
    quantity           INTEGER,
    list_price         NUMERIC,
    discount           NUMERIC,
    revenue            NUMERIC,
    staff_first_name   VARCHAR,
    staff_last_name    VARCHAR
);

CREATE TABLE IF NOT EXISTS gold_stock_summary (
    stock_id     VARCHAR,
    store_name   VARCHAR,
    product_name VARCHAR,
    brand_name   VARCHAR,
    quantity     INTEGER
);
