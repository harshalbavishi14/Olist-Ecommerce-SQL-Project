/*==============================================================
 PROJECT: Olist E-Commerce Data Analysis
 DATABASE: EcommerceDB
 SECTION: 04 - Dashboard Analysis Queries
 QUESTIONS: Q101 - Q150
==============================================================*/

USE EcommerceDB;
GO


/*==============================================================
 Q101. Calculate Total Revenue
==============================================================*/

SELECT
    SUM(payment_value) AS Total_Revenue
FROM order_payments;
GO


/*==============================================================
 Q102. Calculate Total Number of Orders
==============================================================*/

SELECT
    COUNT(DISTINCT order_id) AS Total_Orders
FROM orders;
GO


/*==============================================================
 Q103. Calculate Total Unique Customers
==============================================================*/

SELECT
    COUNT(DISTINCT customer_unique_id) AS Total_Customers
FROM customers;
GO


/*==============================================================
 Q104. Calculate Total Number of Sellers
==============================================================*/

SELECT
    COUNT(DISTINCT seller_id) AS Total_Sellers
FROM sellers;
GO


/*==============================================================
 Q105. Calculate Average Order Value (AOV)

 Total Revenue / Total Distinct Orders
==============================================================*/

SELECT
    SUM(payment_value) * 1.0 /
    COUNT(DISTINCT order_id) AS Average_Order_Value
FROM order_payments;
GO


/*==============================================================
 Q106. Calculate Average Customer Review Score
==============================================================*/

SELECT
    AVG(CAST(review_score AS DECIMAL(10,2))) AS Average_Review_Score
FROM order_reviews;
GO


/*==============================================================
 Q107. Calculate Average Delivery Time in Days

 Delivery Time = Delivered Date - Purchase Date
==============================================================*/

SELECT
    AVG(
        DATEDIFF(
            DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )
    ) AS Average_Delivery_Days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
GO


/*==============================================================
 Q108. Calculate Cancellation Rate

 Cancelled Orders / Total Orders * 100
==============================================================*/

SELECT
    SUM(
        CASE
            WHEN order_status = 'canceled' THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS Cancellation_Rate_Percentage
FROM orders;
GO


/*==============================================================
 Q109. Calculate Delivery Success Rate

 Delivered Orders / Total Orders * 100
==============================================================*/

SELECT
    SUM(
        CASE
            WHEN order_status = 'delivered' THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS Delivery_Success_Rate_Percentage
FROM orders;
GO


/*==============================================================
 Q110. Calculate Total Number of Products
==============================================================*/

SELECT
    COUNT(DISTINCT product_id) AS Total_Products
FROM products;
GO

/*==============================================================
 Q111. Analyze Monthly Revenue Trend Over Time
==============================================================*/

SELECT
    YEAR(o.order_purchase_timestamp) AS Order_Year,
    MONTH(o.order_purchase_timestamp) AS Order_Month,
    SUM(op.payment_value) AS Monthly_Revenue
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    Order_Year,
    Order_Month;
GO


/*==============================================================
 Q112. Analyze Monthly Order Volume Over Time
==============================================================*/

SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    MONTH(order_purchase_timestamp) AS Order_Month,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    Order_Year,
    Order_Month;
GO


/*==============================================================
 Q113. Identify the Month with the Highest Revenue
==============================================================*/

SELECT TOP 1
    YEAR(o.order_purchase_timestamp) AS Order_Year,
    MONTH(o.order_purchase_timestamp) AS Order_Month,
    SUM(op.payment_value) AS Total_Revenue
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    Total_Revenue DESC;
GO


/*==============================================================
 Q114. Calculate Month-over-Month Revenue Growth
==============================================================*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS Order_Year,
        MONTH(o.order_purchase_timestamp) AS Order_Month,
        SUM(op.payment_value) AS Revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)
SELECT
    Order_Year,
    Order_Month,
    Revenue,
    LAG(Revenue) OVER
    (
        ORDER BY Order_Year, Order_Month
    ) AS Previous_Month_Revenue,
    Revenue
        - LAG(Revenue) OVER
        (
            ORDER BY Order_Year, Order_Month
        ) AS Revenue_Difference
FROM MonthlyRevenue
ORDER BY Order_Year, Order_Month;
GO


/*==============================================================
 Q115. Identify the Day of the Week with the Highest Orders
==============================================================*/

SELECT
    DATENAME(WEEKDAY, order_purchase_timestamp) AS Week_Day,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM orders
GROUP BY
    DATENAME(WEEKDAY, order_purchase_timestamp)
ORDER BY
    Total_Orders DESC;
GO


/*==============================================================
 Q116. Identify States Generating the Highest Revenue
==============================================================*/

SELECT
    c.customer_state,
    SUM(op.payment_value) AS Total_Revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    c.customer_state
ORDER BY
    Total_Revenue DESC;
GO


/*==============================================================
 Q117. Identify Cities with the Highest Number of Customers
==============================================================*/

SELECT
    customer_city,
    COUNT(DISTINCT customer_unique_id) AS Total_Customers
FROM customers
GROUP BY
    customer_city
ORDER BY
    Total_Customers DESC;
GO


/*==============================================================
 Q118. Calculate Average Order Value by State
==============================================================*/

SELECT
    c.customer_state,
    SUM(op.payment_value) * 1.0
        / COUNT(DISTINCT o.order_id) AS Average_Order_Value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    c.customer_state
ORDER BY
    Average_Order_Value DESC;
GO


/*==============================================================
 Q119. Identify Product Categories Generating the Highest Revenue
==============================================================*/

SELECT
    p.product_category_name,
    SUM(oi.price) AS Total_Revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_category_name
ORDER BY
    Total_Revenue DESC;
GO


/*==============================================================
 Q120. Identify Product Categories with the Highest Number of Orders
==============================================================*/

SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS Total_Orders
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_category_name
ORDER BY
    Total_Orders DESC;
GO

/*==============================================================
 Q121. Identify Products Generating the Highest Revenue
==============================================================*/

SELECT TOP 10
    p.product_id,
    SUM(oi.price) AS Total_Revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id
ORDER BY
    Total_Revenue DESC;
GO


/*==============================================================
 Q122. Identify Product Categories with the Highest
       Average Customer Ratings
==============================================================*/

SELECT
    p.product_category_name,
    AVG(CAST(r.review_score AS DECIMAL(10,2))) AS Average_Rating
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_reviews r
    ON oi.order_id = r.order_id
GROUP BY
    p.product_category_name
ORDER BY
    Average_Rating DESC;
GO


/*==============================================================
 Q123. Identify Products That Were Never Sold
==============================================================*/

SELECT
    p.product_id,
    p.product_category_name
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
GO


/*==============================================================
 Q124. Identify the Top 10 Customers Based on Total Spending
==============================================================*/

SELECT TOP 10
    c.customer_unique_id,
    SUM(op.payment_value) AS Total_Spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    c.customer_unique_id
ORDER BY
    Total_Spending DESC;
GO


/*==============================================================
 Q125. Identify Repeat Customers
==============================================================*/

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY
    Total_Orders DESC;
GO


/*==============================================================
 Q126. Calculate Customer Lifetime Value (CLV)
==============================================================*/

SELECT
    c.customer_unique_id,
    SUM(op.payment_value) AS Customer_Lifetime_Value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY
    c.customer_unique_id
ORDER BY
    Customer_Lifetime_Value DESC;
GO


/*==============================================================
 Q127. Analyze Customer Distribution by State
==============================================================*/

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS Total_Customers
FROM customers
GROUP BY
    customer_state
ORDER BY
    Total_Customers DESC;
GO


/*==============================================================
 Q128. Calculate Customer Percentage by State
==============================================================*/

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS Total_Customers,
    COUNT(DISTINCT customer_unique_id) * 100.0 /
    (
        SELECT COUNT(DISTINCT customer_unique_id)
        FROM customers
    ) AS Customer_Percentage
FROM customers
GROUP BY
    customer_state
ORDER BY
    Customer_Percentage DESC;
GO


/*==============================================================
 Q129. Identify Orders That Were Delivered Late
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
 Q130. Calculate Average Delivery Time by Customer State
==============================================================*/

SELECT
    c.customer_state,
    AVG(
        CAST(
            DATEDIFF(
                DAY,
                o.order_purchase_timestamp,
                o.order_delivered_customer_date
            ) AS DECIMAL(10,2)
        )
    ) AS Average_Delivery_Days
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY
    c.customer_state
ORDER BY
    Average_Delivery_Days ASC;
GO

/*==============================================================
 Q131. Identify Sellers with the Fastest Average Delivery Time
==============================================================*/

SELECT
    s.seller_id,
    AVG(
        CAST(
            DATEDIFF(
                DAY,
                o.order_purchase_timestamp,
                o.order_delivered_customer_date
            ) AS DECIMAL(10,2)
        )
    ) AS Avg_Delivery_Days
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY
    s.seller_id
ORDER BY
    Avg_Delivery_Days ASC;
GO


/*==============================================================
 Q132. Identify Sellers with the Highest Delayed Delivery Rate
==============================================================*/

SELECT
    s.seller_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    COUNT(
        DISTINCT CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN o.order_id
        END
    ) AS Delayed_Orders,
    COUNT(
        DISTINCT CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN o.order_id
        END
    ) * 100.0 / COUNT(DISTINCT o.order_id) AS Delay_Rate_Percentage
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY
    s.seller_id
ORDER BY
    Delay_Rate_Percentage DESC;
GO


/*==============================================================
 Q133. Analyze the Impact of Delivery Delay on Customer Reviews
==============================================================*/

SELECT
    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 'Late Delivery'
        ELSE 'On Time Delivery'
    END AS Delivery_Status,
    AVG(CAST(r.review_score AS DECIMAL(10,2))) AS Average_Review_Score,
    COUNT(*) AS Total_Reviews
FROM orders o
JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY
    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 'Late Delivery'
        ELSE 'On Time Delivery'
    END;
GO


/*==============================================================
 Q134. Analyze the Distribution of Customer Review Scores
==============================================================*/

SELECT
    review_score,
    COUNT(*) AS Total_Reviews
FROM order_reviews
GROUP BY
    review_score
ORDER BY
    review_score;
GO


/*==============================================================
 Q135. Identify Product Categories with the Highest Ratings
==============================================================*/

SELECT
    p.product_category_name,
    AVG(CAST(r.review_score AS DECIMAL(10,2))) AS Average_Rating,
    COUNT(r.review_id) AS Total_Reviews
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_reviews r
    ON oi.order_id = r.order_id
GROUP BY
    p.product_category_name
ORDER BY
    Average_Rating DESC;
GO


/*==============================================================
 Q136. Identify Product Categories with the Lowest Ratings
==============================================================*/

SELECT
    p.product_category_name,
    AVG(CAST(r.review_score AS DECIMAL(10,2))) AS Average_Rating,
    COUNT(r.review_id) AS Total_Reviews
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_reviews r
    ON oi.order_id = r.order_id
GROUP BY
    p.product_category_name
ORDER BY
    Average_Rating ASC;
GO


/*==============================================================
 Q137. Classify Customer Reviews into Satisfaction Categories

 5 = Excellent
 4 = Good
 3 = Average
 1-2 = Poor
==============================================================*/

SELECT
    CASE
        WHEN review_score = 5 THEN 'Excellent'
        WHEN review_score = 4 THEN 'Good'
        WHEN review_score = 3 THEN 'Average'
        ELSE 'Poor'
    END AS Review_Category,
    COUNT(*) AS Total_Reviews
FROM order_reviews
GROUP BY
    CASE
        WHEN review_score = 5 THEN 'Excellent'
        WHEN review_score = 4 THEN 'Good'
        WHEN review_score = 3 THEN 'Average'
        ELSE 'Poor'
    END
ORDER BY
    Total_Reviews DESC;
GO


/*==============================================================
 Q138. Identify the Payment Method Generating the Highest Revenue
==============================================================*/

SELECT
    payment_type,
    SUM(payment_value) AS Total_Revenue
FROM order_payments
GROUP BY
    payment_type
ORDER BY
    Total_Revenue DESC;
GO


/*==============================================================
 Q139. Identify the Most Frequently Used Payment Method
==============================================================*/

SELECT
    payment_type,
    COUNT(*) AS Total_Transactions
FROM order_payments
GROUP BY
    payment_type
ORDER BY
    Total_Transactions DESC;
GO


/*==============================================================
 Q140. Calculate the Average Installment Count by Payment Type
==============================================================*/

SELECT
    payment_type,
    AVG(
        CAST(payment_installments AS DECIMAL(10,2))
    ) AS Average_Installments
FROM order_payments
GROUP BY
    payment_type
ORDER BY
    Average_Installments DESC;
GO

/*==============================================================
 Q141. Identify the Payment Method with the Highest
       Average Order Value
==============================================================*/

SELECT
    payment_type,
    AVG(payment_value) AS Average_Order_Value
FROM order_payments
GROUP BY
    payment_type
ORDER BY
    Average_Order_Value DESC;
GO


/*==============================================================
 Q142. Identify the Top 10 Sellers Generating the Highest Revenue
==============================================================*/

SELECT TOP 10
    s.seller_id,
    SUM(oi.price) AS Total_Revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id
ORDER BY
    Total_Revenue DESC;
GO


/*==============================================================
 Q143. Identify Sellers with the Highest Average Customer Ratings
==============================================================*/

SELECT
    s.seller_id,
    AVG(CAST(r.review_score AS DECIMAL(10,2))) AS Average_Rating
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN order_reviews r
    ON oi.order_id = r.order_id
GROUP BY
    s.seller_id
ORDER BY
    Average_Rating DESC;
GO


/*==============================================================
 Q144. Identify the Top 10 Sellers Processing the Highest
       Number of Orders
==============================================================*/

SELECT TOP 10
    seller_id,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM order_items
GROUP BY
    seller_id
ORDER BY
    Total_Orders DESC;
GO


/*==============================================================
 Q145. Calculate Each Seller's Percentage Contribution
       to Total Revenue
==============================================================*/

SELECT
    oi.seller_id,
    SUM(oi.price) AS Seller_Revenue,
    SUM(oi.price) * 100.0 /
    (
        SELECT SUM(price)
        FROM order_items
    ) AS Revenue_Percentage
FROM order_items oi
GROUP BY
    oi.seller_id
ORDER BY
    Revenue_Percentage DESC;
GO


/*==============================================================
 Q146. Perform Pareto Analysis Using the 80/20 Rule

 Calculate cumulative revenue percentage for products.
==============================================================*/

WITH ProductRevenue AS
(
    SELECT
        p.product_id,
        SUM(oi.price) AS Revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id
)
SELECT
    product_id,
    Revenue,

    SUM(Revenue) OVER
    (
        ORDER BY Revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Revenue,

    SUM(Revenue) OVER () AS Total_Revenue,

    SUM(Revenue) OVER
    (
        ORDER BY Revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) * 100.0 /
    SUM(Revenue) OVER () AS Cumulative_Revenue_Percentage

FROM ProductRevenue
ORDER BY
    Revenue DESC;
GO


/*==============================================================
 Q147. Perform ABC Analysis for Products

 A Category = Top 80% of Revenue
 B Category = Next 15% of Revenue
 C Category = Remaining 5% of Revenue
==============================================================*/

WITH ProductRevenue AS
(
    SELECT
        p.product_id,
        SUM(oi.price) AS Revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id
),
RevenueCalculation AS
(
    SELECT
        product_id,
        Revenue,

        SUM(Revenue) OVER
        (
            ORDER BY Revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 /
        SUM(Revenue) OVER () AS Cumulative_Revenue_Percentage

    FROM ProductRevenue
)
SELECT
    product_id,
    Revenue,
    Cumulative_Revenue_Percentage,

    CASE
        WHEN Cumulative_Revenue_Percentage <= 80 THEN 'A'
        WHEN Cumulative_Revenue_Percentage <= 95 THEN 'B'
        ELSE 'C'
    END AS ABC_Category

FROM RevenueCalculation
ORDER BY
    Revenue DESC;
GO


/*==============================================================
 Q148. Calculate Monthly Running Total Revenue
==============================================================*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS Order_Year,
        MONTH(o.order_purchase_timestamp) AS Order_Month,
        SUM(op.payment_value) AS Revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)
SELECT
    Order_Year,
    Order_Month,
    Revenue,

    SUM(Revenue) OVER
    (
        ORDER BY Order_Year, Order_Month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Revenue

FROM MonthlyRevenue
ORDER BY
    Order_Year,
    Order_Month;
GO


/*==============================================================
 Q149. Calculate 3-Month Moving Average Revenue
==============================================================*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS Order_Year,
        MONTH(o.order_purchase_timestamp) AS Order_Month,
        SUM(op.payment_value) AS Revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)
SELECT
    Order_Year,
    Order_Month,
    Revenue,

    AVG(Revenue) OVER
    (
        ORDER BY Order_Year, Order_Month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Three_Month_Moving_Average

FROM MonthlyRevenue
ORDER BY
    Order_Year,
    Order_Month;
GO


/*==============================================================
 Q150. Display Dynamic Top N Products Based on Revenue

 Example below: Top 10 Products
==============================================================*/

SELECT TOP 10
    p.product_id,
    SUM(oi.price) AS Total_Revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id
ORDER BY
    Total_Revenue DESC;
GO