/*==============================================================
 PROJECT: Olist E-Commerce Data Analysis
 DATABASE: EcommerceDB
 SECTION: 01 - Database Setup and Data Import
==============================================================*/


/*==============================================================
 STEP 1: CREATE DATABASE
==============================================================*/

CREATE DATABASE EcommerceDB;
GO


/*==============================================================
 STEP 2: USE DATABASE
==============================================================*/

USE EcommerceDB;
GO


/*==============================================================
 STEP 3: CHECK DATABASE
==============================================================*/

SELECT DB_NAME() AS Current_Database;
GO


/*==============================================================
 STEP 4: CHECK EXISTING TABLES
==============================================================*/

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO


/*==============================================================
 STEP 5: IMPORT DATA
 CSV files were imported into the following tables:
==============================================================*/

-- customers
-- orders
-- order_items
-- order_payments
-- order_reviews
-- products
-- sellers
-- product_category_translation


/*==============================================================
 STEP 6: CHECK IMPORTED DATA
==============================================================*/

SELECT TOP 10 * FROM customers;
SELECT TOP 10 * FROM orders;
SELECT TOP 10 * FROM order_items;
SELECT TOP 10 * FROM order_payments;
SELECT TOP 10 * FROM order_reviews;
SELECT TOP 10 * FROM products;
SELECT TOP 10 * FROM sellers;
SELECT TOP 10 * FROM product_category_translation;
GO


/*==============================================================
 STEP 7: CHECK ROW COUNT OF ALL TABLES
==============================================================*/

SELECT 'customers' AS Table_Name, COUNT(*) AS Total_Rows
FROM customers

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'order_payments', COUNT(*)
FROM order_payments

UNION ALL

SELECT 'order_reviews', COUNT(*)
FROM order_reviews

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers

UNION ALL

SELECT 'product_category_translation', COUNT(*)
FROM product_category_translation;
GO


/*==============================================================
 STEP 8: CHECK DATA TYPES OF ALL COLUMNS
==============================================================*/

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO


/*==============================================================
 STEP 9: CHECK SPECIFIC COLUMN DATA TYPES

 This query was used to identify data type/length mismatches,
 such as customer_id.
==============================================================*/

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'customer_id';
GO


/*==============================================================
 STEP 10: CHECK NULL VALUES - CUSTOMERS
==============================================================*/

SELECT *
FROM customers
WHERE customer_id IS NULL
   OR customer_unique_id IS NULL
   OR customer_zip_code_prefix IS NULL
   OR customer_city IS NULL
   OR customer_state IS NULL;
GO


/*==============================================================
 STEP 11: CHECK NULL VALUES - ORDERS
==============================================================*/

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS Null_Order_Status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS Null_Purchase_Date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS Null_Delivery_Date,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS Null_Estimated_Delivery_Date
FROM orders;
GO


/*==============================================================
 STEP 12: CHECK NULL VALUES - OTHER TABLES
==============================================================*/

-- order_items
SELECT *
FROM order_items
WHERE order_id IS NULL
   OR product_id IS NULL
   OR seller_id IS NULL;

-- order_payments
SELECT *
FROM order_payments
WHERE order_id IS NULL
   OR payment_type IS NULL
   OR payment_value IS NULL;

-- order_reviews
SELECT *
FROM order_reviews
WHERE review_id IS NULL
   OR order_id IS NULL
   OR review_score IS NULL;

-- products
SELECT *
FROM products
WHERE product_id IS NULL;

-- sellers
SELECT *
FROM sellers
WHERE seller_id IS NULL;

-- product_category_translation
SELECT *
FROM product_category_translation
WHERE product_category_name IS NULL
   OR product_category_name_english IS NULL;
GO


/*==============================================================
 STEP 13: CHECK DUPLICATE PRIMARY IDENTIFIERS
==============================================================*/

-- Customers
SELECT
    customer_id,
    COUNT(*) AS Duplicate_Count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Orders
SELECT
    order_id,
    COUNT(*) AS Duplicate_Count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Products
SELECT
    product_id,
    COUNT(*) AS Duplicate_Count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Sellers
SELECT
    seller_id,
    COUNT(*) AS Duplicate_Count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;
GO


/*==============================================================
 STEP 14: CHECK DUPLICATES IN PRODUCT CATEGORY TRANSLATION
==============================================================*/

SELECT
    product_category_name,
    COUNT(*) AS Duplicate_Count
FROM product_category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;
GO


/*==============================================================
 STEP 15: CHECK TOTAL UNIQUE CUSTOMERS
 customer_unique_id represents the actual unique customer.
==============================================================*/

SELECT
    COUNT(DISTINCT customer_unique_id) AS Unique_Customers
FROM customers;
GO


/*==============================================================
 STEP 16: BULK INSERT
 Product Category Translation CSV
==============================================================*/

-- IMPORTANT:
-- Run this only if the table exists and data needs to be imported.
-- Clear existing data first only when required.

-- DELETE FROM product_category_translation;

BULK INSERT product_category_translation
FROM 'E:\DA\SQL_PowerBI_Ecommerce_Project\Dataset\Raw_Data\product_category_name_translation.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO


/*==============================================================
 STEP 17: VERIFY BULK INSERT
==============================================================*/

SELECT COUNT(*) AS Total_Category_Translations
FROM product_category_translation;

SELECT TOP 10 *
FROM product_category_translation;
GO


/*==============================================================
 STEP 18: FINAL DATA VALIDATION
==============================================================*/

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN
(
    'customers',
    'orders',
    'order_items',
    'order_payments',
    'order_reviews',
    'products',
    'sellers',
    'product_category_translation'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO