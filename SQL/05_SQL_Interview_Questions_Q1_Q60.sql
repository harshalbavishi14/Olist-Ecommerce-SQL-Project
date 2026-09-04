USE EcommerceDB;
GO


/*==============================================================
 Q1. Display all records from the customers table.
==============================================================*/

SELECT *
FROM customers;
GO


/*==============================================================
 Q2. Display customer ID, city, and state.
==============================================================*/

SELECT
    customer_id,
    customer_city,
    customer_state
FROM customers;
GO


/*==============================================================
 Q3. Identify the top 10 highest-value payments.
==============================================================*/

SELECT TOP 10
    order_id,
    payment_type,
    payment_value
FROM order_payments
ORDER BY payment_value DESC;
GO


/*==============================================================
 Q4. Find all orders placed after 1 January 2018.
==============================================================*/

SELECT *
FROM orders
WHERE order_purchase_timestamp > '2018-01-01';
GO


/*==============================================================
 Q5. Find all delivered orders.
==============================================================*/

SELECT *
FROM orders
WHERE order_status = 'delivered';
GO


/*==============================================================
 Q6. Find all unique customer states.
==============================================================*/

SELECT DISTINCT
    customer_state
FROM customers
ORDER BY customer_state;
GO


/*==============================================================
 Q7. Find products with a weight greater than 1000 grams.
==============================================================*/

SELECT
    product_id,
    product_category_name,
    product_weight_g
FROM products
WHERE product_weight_g > 1000;
GO


/*==============================================================
 Q8. Find orders that have been cancelled.
==============================================================*/

SELECT *
FROM orders
WHERE order_status = 'canceled';
GO


/*==============================================================
 Q9. Display the first 20 sellers.
==============================================================*/

SELECT TOP 20 *
FROM sellers;
GO


/*==============================================================
 Q10. Find payments made using a credit card.
==============================================================*/

SELECT *
FROM order_payments
WHERE payment_type = 'credit_card';
GO


/*==============================================================
 Q11. Total revenue by payment type.
==============================================================*/

SELECT
    payment_type,
    SUM(payment_value) AS Total_Revenue
FROM order_payments
GROUP BY payment_type
ORDER BY Total_Revenue DESC;
GO


/*==============================================================
 Q12. Total customers by state.
==============================================================*/

SELECT
    customer_state,
    COUNT(*) AS Total_Customers
FROM customers
GROUP BY customer_state
ORDER BY Total_Customers DESC;
GO


/*==============================================================
 Q13. Top 10 cities by customer count.
==============================================================*/

SELECT TOP 10
    customer_city,
    COUNT(*) AS Total_Customers
FROM customers
GROUP BY customer_city
ORDER BY Total_Customers DESC;
GO


/*==============================================================
 Q14. Average payment by payment type.
==============================================================*/

SELECT
    payment_type,
    AVG(payment_value) AS Average_Payment
FROM order_payments
GROUP BY payment_type
ORDER BY Average_Payment DESC;
GO


/*==============================================================
 Q15. Min, Max and Avg freight value.
==============================================================*/

SELECT
    MIN(freight_value) AS Minimum_Freight_Value,
    MAX(freight_value) AS Maximum_Freight_Value,
    AVG(freight_value) AS Average_Freight_Value
FROM order_items;
GO


/*==============================================================
 Q16. Average review score by category.
==============================================================*/

SELECT
    p.product_category_name,
    AVG(CAST(r.review_score AS DECIMAL(10,2))) AS Average_Review_Score
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN order_reviews r
    ON oi.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY Average_Review_Score DESC;
GO


/*==============================================================
 Q17. Total orders by status.
==============================================================*/

SELECT
    order_status,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY order_status
ORDER BY Total_Orders DESC;
GO


/*==============================================================
 Q18. Average product weight by category.
==============================================================*/

SELECT
    product_category_name,
    AVG(CAST(product_weight_g AS DECIMAL(10,2))) AS Average_Product_Weight
FROM products
WHERE product_category_name IS NOT NULL
  AND product_weight_g IS NOT NULL
GROUP BY product_category_name
ORDER BY Average_Product_Weight DESC;
GO


/*==============================================================
 Q19. States with more than 500 customers.
==============================================================*/

SELECT
    customer_state,
    COUNT(*) AS Total_Customers
FROM customers
GROUP BY customer_state
HAVING COUNT(*) > 500
ORDER BY Total_Customers DESC;
GO


/*==============================================================
 Q20. Total revenue by state.
==============================================================*/

SELECT
    c.customer_state,
    SUM(op.payment_value) AS Total_Revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY Total_Revenue DESC;
GO


/*==============================================================
 Q21. Display all orders along with customer information.
==============================================================*/

SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    c.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;
GO


/*==============================================================
 Q22. Display all order items along with product information.
==============================================================*/

SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    p.product_category_name,
    p.product_weight_g
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id;
GO


/*==============================================================
 Q23. Display all order items along with seller information.
==============================================================*/

SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    s.seller_city,
    s.seller_state
FROM order_items oi
INNER JOIN sellers s
    ON oi.seller_id = s.seller_id;
GO


/*==============================================================
 Q24. Display all orders with their payment details.
==============================================================*/

SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    op.payment_type,
    op.payment_installments,
    op.payment_value
FROM orders o
INNER JOIN order_payments op
    ON o.order_id = op.order_id;
GO


/*==============================================================
 Q25. Display all orders with their customer review details.
==============================================================*/

SELECT
    o.order_id,
    o.order_status,
    r.review_id,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date
FROM orders o
INNER JOIN order_reviews r
    ON o.order_id = r.order_id;
GO

/*==============================================================
 Q26. Classify customers by spending.
==============================================================*/

SELECT
    c.customer_unique_id,
    SUM(op.payment_value) AS Total_Spending,
    CASE
        WHEN SUM(op.payment_value) >= 1000 THEN 'High Value'
        WHEN SUM(op.payment_value) >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Category
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    c.customer_unique_id;
GO


/*==============================================================
 Q27. Classify delivery performance.
==============================================================*/

SELECT
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    CASE
        WHEN order_delivered_customer_date IS NULL
            THEN 'Not Delivered'
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Delayed'
    END AS Delivery_Performance
FROM orders;
GO


/*==============================================================
 Q28. Classify products by weight.
==============================================================*/

SELECT
    product_id,
    product_category_name,
    product_weight_g,
    CASE
        WHEN product_weight_g IS NULL THEN 'Unknown'
        WHEN product_weight_g < 1000 THEN 'Light'
        WHEN product_weight_g BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'Heavy'
    END AS Weight_Category
FROM products;
GO


/*==============================================================
 Q29. Classify review scores.
==============================================================*/

SELECT
    review_id,
    order_id,
    review_score,
    CASE
        WHEN review_score = 5 THEN 'Excellent'
        WHEN review_score = 4 THEN 'Good'
        WHEN review_score = 3 THEN 'Average'
        ELSE 'Poor'
    END AS Review_Category
FROM order_reviews;
GO


/*==============================================================
 Q30. Classify payment methods.
==============================================================*/

SELECT
    order_id,
    payment_type,
    payment_value,
    CASE
        WHEN payment_type = 'credit_card' THEN 'Card Payment'
        WHEN payment_type = 'boleto' THEN 'Bank Slip'
        WHEN payment_type = 'voucher' THEN 'Voucher Payment'
        WHEN payment_type = 'debit_card' THEN 'Debit Card Payment'
        ELSE 'Other Payment Method'
    END AS Payment_Category
FROM order_payments;
GO


/*==============================================================
 Q31. Display customer cities in uppercase.
==============================================================*/

SELECT
    customer_city,
    UPPER(customer_city) AS City_Uppercase
FROM customers;
GO


/*==============================================================
 Q32. Display seller cities in lowercase.
==============================================================*/

SELECT
    seller_city,
    LOWER(seller_city) AS City_Lowercase
FROM sellers;
GO

/*==============================================================
 Q33. Find the length of customer city names.
==============================================================*/

SELECT
    customer_city,
    LEN(customer_city) AS City_Name_Length
FROM customers;
GO


/*==============================================================
 Q34. Extract the first 5 characters of product IDs.
==============================================================*/

SELECT
    product_id,
    LEFT(product_id, 5) AS First_5_Characters
FROM products;
GO


/*==============================================================
 Q35. Extract the last 5 characters of seller IDs.
==============================================================*/

SELECT
    seller_id,
    RIGHT(seller_id, 5) AS Last_5_Characters
FROM sellers;
GO


/*==============================================================
 Q36. Replace underscores with spaces in product category names.
==============================================================*/

SELECT
    product_category_name,
    REPLACE(product_category_name, '_', ' ') AS Category_Name
FROM products;
GO


/*==============================================================
 Q37. Find the position of an underscore in product category names.
==============================================================*/

SELECT
    product_category_name,
    CHARINDEX('_', product_category_name) AS Underscore_Position
FROM products
WHERE product_category_name IS NOT NULL;
GO


/*==============================================================
 Q38. Display the first word from product category names.

 Example:
 computers_accessories → computers
==============================================================*/

SELECT
    product_category_name,
    CASE
        WHEN CHARINDEX('_', product_category_name) > 0
            THEN LEFT(
                product_category_name,
                CHARINDEX('_', product_category_name) - 1
            )
        ELSE product_category_name
    END AS First_Word
FROM products
WHERE product_category_name IS NOT NULL;
GO


/*==============================================================
 Q39. Display the date on which each order was purchased.
==============================================================*/

SELECT
    order_id,
    CAST(order_purchase_timestamp AS DATE) AS Purchase_Date
FROM orders;
GO


/*==============================================================
 Q40. Calculate the number of days between order purchase
      and delivery.
==============================================================*/

SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    DATEDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS Delivery_Days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
GO

/*==============================================================
 Q41. Orders by year.
==============================================================*/

SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY Order_Year;
GO


/*==============================================================
 Q42. Monthly sales.
==============================================================*/

SELECT
    YEAR(o.order_purchase_timestamp) AS Sales_Year,
    MONTH(o.order_purchase_timestamp) AS Sales_Month,
    SUM(op.payment_value) AS Monthly_Sales
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    Sales_Year,
    Sales_Month;
GO


/*==============================================================
 Q43. Weekday-wise orders.
==============================================================*/

SELECT
    DATENAME(WEEKDAY, order_purchase_timestamp) AS Weekday_Name,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY DATENAME(WEEKDAY, order_purchase_timestamp)
ORDER BY Total_Orders DESC;
GO


/*==============================================================
 Q44. Weekend orders.
 Saturday and Sunday orders.
==============================================================*/

SELECT *
FROM orders
WHERE DATENAME(WEEKDAY, order_purchase_timestamp)
      IN ('Saturday', 'Sunday');
GO


/*==============================================================
 Q45. Delivery time in days.
==============================================================*/

SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    DATEDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS Delivery_Time_Days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
GO


/*==============================================================
 Q46. Average delivery time.
==============================================================*/

SELECT
    AVG(
        CAST(
            DATEDIFF(
                DAY,
                order_purchase_timestamp,
                order_delivered_customer_date
            ) AS DECIMAL(10,2)
        )
    ) AS Average_Delivery_Days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
GO


/*==============================================================
 Q47. Delayed deliveries.
 Delivered after the estimated delivery date.
==============================================================*/

SELECT
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date,
    order_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;
GO


/*==============================================================
 Q48. Month with highest orders.
==============================================================*/

SELECT TOP 1
    YEAR(order_purchase_timestamp) AS Order_Year,
    MONTH(order_purchase_timestamp) AS Order_Month,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY Total_Orders DESC;
GO


/*==============================================================
 Q49. Quarter-wise revenue.
==============================================================*/

SELECT
    YEAR(o.order_purchase_timestamp) AS Sales_Year,
    DATEPART(QUARTER, o.order_purchase_timestamp) AS Sales_Quarter,
    SUM(op.payment_value) AS Total_Revenue
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    DATEPART(QUARTER, o.order_purchase_timestamp)
ORDER BY
    Sales_Year,
    Sales_Quarter;
GO


/*==============================================================
 Q50. Average approval time.

 Approval Time = Order Approved Date - Order Purchase Date
==============================================================*/

SELECT
    AVG(
        CAST(
            DATEDIFF(
                MINUTE,
                order_purchase_timestamp,
                order_approved_at
            ) AS DECIMAL(10,2)
        ) / 60.0
    ) AS Average_Approval_Time_Hours
FROM orders
WHERE order_approved_at IS NOT NULL;
GO

/*==============================================================
 Q51. Find customers who have placed more than the
      average number of orders.
==============================================================*/

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) >
(
    SELECT AVG(Customer_Order_Count * 1.0)
    FROM
    (
        SELECT
            customer_id,
            COUNT(DISTINCT order_id) AS Customer_Order_Count
        FROM orders
        GROUP BY customer_id
    ) AS CustomerOrders
)
ORDER BY Total_Orders DESC;
GO


/*==============================================================
 Q52. Find products priced above the average product price.
==============================================================*/

SELECT
    product_id,
    AVG(price) AS Average_Product_Price
FROM order_items
GROUP BY product_id
HAVING AVG(price) >
(
    SELECT AVG(price)
    FROM order_items
)
ORDER BY Average_Product_Price DESC;
GO


/*==============================================================
 Q53. Find sellers with revenue above the average seller revenue.
==============================================================*/

SELECT
    seller_id,
    SUM(price) AS Seller_Revenue
FROM order_items
GROUP BY seller_id
HAVING SUM(price) >
(
    SELECT AVG(Seller_Revenue)
    FROM
    (
        SELECT
            seller_id,
            SUM(price) AS Seller_Revenue
        FROM order_items
        GROUP BY seller_id
    ) AS SellerRevenue
)
ORDER BY Seller_Revenue DESC;
GO


/*==============================================================
 Q54. Find orders with payment values above the
      average payment value.
==============================================================*/

SELECT
    order_id,
    payment_value
FROM order_payments
WHERE payment_value >
(
    SELECT AVG(payment_value)
    FROM order_payments
)
ORDER BY payment_value DESC;
GO


/*==============================================================
 Q55. Find states with customer counts above the
      average state customer count.
==============================================================*/

SELECT
    customer_state,
    COUNT(*) AS Total_Customers
FROM customers
GROUP BY customer_state
HAVING COUNT(*) >
(
    SELECT AVG(State_Customer_Count * 1.0)
    FROM
    (
        SELECT
            customer_state,
            COUNT(*) AS State_Customer_Count
        FROM customers
        GROUP BY customer_state
    ) AS StateCustomers
)
ORDER BY Total_Customers DESC;
GO


/*==============================================================
 Q56. Find orders whose total payment is greater than
      the average order payment.
==============================================================*/

SELECT
    order_id,
    SUM(payment_value) AS Total_Order_Payment
FROM order_payments
GROUP BY order_id
HAVING SUM(payment_value) >
(
    SELECT AVG(Order_Payment * 1.0)
    FROM
    (
        SELECT
            order_id,
            SUM(payment_value) AS Order_Payment
        FROM order_payments
        GROUP BY order_id
    ) AS OrderPayments
)
ORDER BY Total_Order_Payment DESC;
GO


/*==============================================================
 Q57. Find customers who have placed at least one order.
==============================================================*/

SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM customers c
WHERE EXISTS
(
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
GO


/*==============================================================
 Q58. Find products that have never been ordered.
==============================================================*/

SELECT
    product_id,
    product_category_name
FROM products p
WHERE NOT EXISTS
(
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
);
GO


/*==============================================================
 Q59. Find sellers who have sold at least one product.
==============================================================*/

SELECT
    seller_id,
    seller_city,
    seller_state
FROM sellers s
WHERE EXISTS
(
    SELECT 1
    FROM order_items oi
    WHERE oi.seller_id = s.seller_id
);
GO


/*==============================================================
 Q60. Find customers whose total spending is greater
      than the overall average customer spending.
==============================================================*/

SELECT
    c.customer_unique_id,
    SUM(op.payment_value) AS Total_Spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    c.customer_unique_id
HAVING SUM(op.payment_value) >
(
    SELECT AVG(Customer_Spending * 1.0)
    FROM
    (
        SELECT
            c2.customer_unique_id,
            SUM(op2.payment_value) AS Customer_Spending
        FROM customers c2
        JOIN orders o2
            ON c2.customer_id = o2.customer_id
        JOIN order_payments op2
            ON o2.order_id = op2.order_id
        GROUP BY c2.customer_unique_id
    ) AS CustomerSpending
)
ORDER BY Total_Spending DESC;
GO