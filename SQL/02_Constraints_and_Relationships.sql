/*==============================================================
 PROJECT: Olist E-Commerce Data Analysis
 DATABASE: EcommerceDB
 SECTION: 02 - Primary Keys and Foreign Key Relationships
==============================================================*/

USE EcommerceDB;
GO


/*==============================================================
 STEP 1: ADD PRIMARY KEY - CUSTOMERS
==============================================================*/

ALTER TABLE customers
ADD CONSTRAINT PK_customers
PRIMARY KEY (customer_id);
GO


/*==============================================================
 STEP 2: ADD PRIMARY KEY - ORDERS
==============================================================*/

ALTER TABLE orders
ADD CONSTRAINT PK_orders
PRIMARY KEY (order_id);
GO


/*==============================================================
 STEP 3: ADD PRIMARY KEY - PRODUCTS
==============================================================*/

ALTER TABLE products
ADD CONSTRAINT PK_products
PRIMARY KEY (product_id);
GO


/*==============================================================
 STEP 4: ADD PRIMARY KEY - SELLERS
==============================================================*/

ALTER TABLE sellers
ADD CONSTRAINT PK_sellers
PRIMARY KEY (seller_id);
GO


/*==============================================================
 STEP 5: ADD PRIMARY KEY - ORDER ITEMS

 order_id alone cannot be a primary key because one order can
 contain multiple products. Therefore, a composite primary key
 is used.
==============================================================*/

ALTER TABLE order_items
ADD CONSTRAINT PK_order_items
PRIMARY KEY (order_id, order_item_id);
GO


/*==============================================================
 STEP 6: ADD PRIMARY KEY - ORDER PAYMENTS

 One order can have multiple payment records.
 Therefore, a composite primary key is used.
==============================================================*/

ALTER TABLE order_payments
ADD CONSTRAINT PK_order_payments
PRIMARY KEY (order_id, payment_sequential);
GO


/*==============================================================
 STEP 7: ADD PRIMARY KEY - PRODUCT CATEGORY TRANSLATION
==============================================================*/

ALTER TABLE product_category_translation
ADD CONSTRAINT PK_product_category_translation
PRIMARY KEY (product_category_name);
GO


/*==============================================================
 STEP 8: ADD PRIMARY KEY - ORDER REVIEWS

 review_id is used as the primary key.
==============================================================*/

ALTER TABLE order_reviews
ADD CONSTRAINT PK_order_reviews
PRIMARY KEY (review_id);
GO


/*==============================================================
 STEP 9: CHECK DATA TYPE OF CUSTOMER_ID

 This was used when the foreign key relationship produced the
 error that both columns had different lengths.
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
 STEP 10: FIX CUSTOMER_ID DATA TYPE MISMATCH

 The customers.customer_id and orders.customer_id columns must
 have exactly the same data type and length before creating
 a foreign key.

 Example:
 customers.customer_id -> NCHAR(50)
 orders.customer_id    -> NCHAR(50)
==============================================================*/

-- If required, first remove the dependent primary key.

ALTER TABLE customers
DROP CONSTRAINT PK_customers;
GO

ALTER TABLE customers
ALTER COLUMN customer_id NCHAR(50) NOT NULL;
GO

ALTER TABLE customers
ADD CONSTRAINT PK_customers
PRIMARY KEY (customer_id);
GO


/*==============================================================
 STEP 11: CREATE FOREIGN KEY
 ORDERS -> CUSTOMERS
==============================================================*/

ALTER TABLE orders
ADD CONSTRAINT FK_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);
GO


/*==============================================================
 STEP 12: CREATE FOREIGN KEY
 ORDER ITEMS -> ORDERS
==============================================================*/

ALTER TABLE order_items
ADD CONSTRAINT FK_orderitems_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);
GO


/*==============================================================
 STEP 13: CREATE FOREIGN KEY
 ORDER ITEMS -> SELLERS
==============================================================*/

ALTER TABLE order_items
ADD CONSTRAINT FK_orderitems_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);
GO


/*==============================================================
 STEP 14: CREATE FOREIGN KEY
 ORDER ITEMS -> PRODUCTS
==============================================================*/

ALTER TABLE order_items
ADD CONSTRAINT FK_orderitems_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);
GO


/*==============================================================
 STEP 15: CREATE FOREIGN KEY
 ORDER PAYMENTS -> ORDERS
==============================================================*/

ALTER TABLE order_payments
ADD CONSTRAINT FK_orderpayments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);
GO


/*==============================================================
 STEP 16: CREATE FOREIGN KEY
 ORDER REVIEWS -> ORDERS
==============================================================*/

ALTER TABLE order_reviews
ADD CONSTRAINT FK_orderreviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);
GO


/*==============================================================
 STEP 17: CREATE FOREIGN KEY
 PRODUCTS -> PRODUCT CATEGORY TRANSLATION
==============================================================*/

ALTER TABLE products
ADD CONSTRAINT FK_products_category
FOREIGN KEY (product_category_name)
REFERENCES product_category_translation(product_category_name);
GO


/*==============================================================
 STEP 18: VERIFY ALL FOREIGN KEY RELATIONSHIPS
==============================================================*/

SELECT
    fk.name AS Foreign_Key_Name,
    OBJECT_NAME(fk.parent_object_id) AS Child_Table,
    OBJECT_NAME(fk.referenced_object_id) AS Parent_Table
FROM sys.foreign_keys fk
ORDER BY Child_Table, Foreign_Key_Name;
GO