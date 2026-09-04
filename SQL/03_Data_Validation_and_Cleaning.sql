/*==============================================================
 PROJECT: Olist E-Commerce Data Analysis
 DATABASE: EcommerceDB
 SECTION: 03 - Data Validation and Data Quality Checks
==============================================================*/

USE EcommerceDB;
GO


/*==============================================================
 STEP 1: VERIFY ALL TABLES
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
 STEP 2: CHECK ROW COUNT OF ALL TABLES
==============================================================*/

SELECT 'customers' AS Table_Name, COUNT(*) AS Total_Rows FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;
GO


/*==============================================================
 STEP 3: CHECK DUPLICATE CUSTOMERS
==============================================================*/

SELECT
    customer_id,
    COUNT(*) AS Duplicate_Count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
GO


/*==============================================================
 STEP 4: CHECK DUPLICATE ORDERS
==============================================================*/

SELECT
    order_id,
    COUNT(*) AS Duplicate_Count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
GO


/*==============================================================
 STEP 5: CHECK DUPLICATE PRODUCTS
==============================================================*/

SELECT
    product_id,
    COUNT(*) AS Duplicate_Count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
GO


/*==============================================================
 STEP 6: CHECK DUPLICATE SELLERS
==============================================================*/

SELECT
    seller_id,
    COUNT(*) AS Duplicate_Count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;
GO


/*==============================================================
 STEP 7: CHECK DUPLICATE CATEGORY TRANSLATIONS
==============================================================*/

SELECT
    product_category_name,
    COUNT(*) AS Duplicate_Count
FROM product_category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;
GO


/*==============================================================
 STEP 8: CHECK NULL VALUES - CUSTOMERS
==============================================================*/

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS Null_Unique_Customer_ID,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS Null_State
FROM customers;
GO


/*==============================================================
 STEP 9: CHECK NULL VALUES - ORDERS
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
 STEP 10: CHECK NULL VALUES - ORDER ITEMS
==============================================================*/

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS Null_Seller_ID,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS Null_Price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS Null_Freight_Value
FROM order_items;
GO


/*==============================================================
 STEP 11: CHECK NULL VALUES - ORDER PAYMENTS
==============================================================*/

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS Null_Payment_Type,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS Null_Payment_Value
FROM order_payments;
GO


/*==============================================================
 STEP 12: CHECK NULL VALUES - PRODUCTS
==============================================================*/

SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS Null_Product_Category
FROM products;
GO


/*==============================================================
 STEP 13: CHECK NULL VALUES - SELLERS
==============================================================*/

SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS Null_Seller_ID,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS Null_State
FROM sellers;
GO


/*==============================================================
 STEP 14: CHECK ORPHAN ORDERS
 Orders with no matching customer
==============================================================*/

SELECT o.*
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
GO


/*==============================================================
 STEP 15: CHECK ORPHAN ORDER ITEMS
 Order items with no matching order
==============================================================*/

SELECT oi.*
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
GO


/*==============================================================
 STEP 16: CHECK ORPHAN ORDER ITEMS - PRODUCTS
==============================================================*/

SELECT oi.*
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
GO


/*==============================================================
 STEP 17: CHECK ORPHAN ORDER ITEMS - SELLERS
==============================================================*/

SELECT oi.*
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
GO


/*==============================================================
 STEP 18: CHECK ORPHAN PAYMENTS
==============================================================*/

SELECT op.*
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;
GO


/*==============================================================
 STEP 19: CHECK ORPHAN REVIEWS
==============================================================*/

SELECT r.*
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;
GO


/*==============================================================
 STEP 20: CHECK PRODUCTS WITH NO CATEGORY TRANSLATION
==============================================================*/

SELECT DISTINCT
    p.product_category_name
FROM products p
LEFT JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND pct.product_category_name IS NULL;
GO


/*==============================================================
 STEP 21: CHECK NEGATIVE OR INVALID PAYMENT VALUES
==============================================================*/

SELECT *
FROM order_payments
WHERE payment_value <= 0;
GO


/*==============================================================
 STEP 22: CHECK NEGATIVE OR INVALID PRODUCT PRICES
==============================================================*/

SELECT *
FROM order_items
WHERE price <= 0
   OR freight_value < 0;
GO


/*==============================================================
 STEP 23: CHECK INVALID REVIEW SCORES
 Valid scores should be between 1 and 5.
==============================================================*/

SELECT *
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;
GO


/*==============================================================
 STEP 24: CHECK INVALID DELIVERY DATES
 Delivered date should not be earlier than purchase date.
==============================================================*/

SELECT *
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;
GO


/*==============================================================
 STEP 25: FINAL FOREIGN KEY VERIFICATION
==============================================================*/

SELECT
    fk.name AS Foreign_Key_Name,
    OBJECT_NAME(fk.parent_object_id) AS Child_Table,
    OBJECT_NAME(fk.referenced_object_id) AS Parent_Table
FROM sys.foreign_keys fk
ORDER BY Child_Table, Foreign_Key_Name;
GO