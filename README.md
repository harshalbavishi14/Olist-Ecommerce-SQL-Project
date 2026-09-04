# 🛒 Olist E-Commerce SQL Analysis Project

An end-to-end SQL project built using the **Olist Brazilian E-Commerce Dataset**, focused on database design, data import, data validation, relational integrity, and business analysis using **SQL Server (T-SQL)**.

The project demonstrates how SQL can be used to transform raw e-commerce transaction data into meaningful business insights.

---

## 📊 Project Overview

This project analyzes approximately 100K e-commerce orders from the Brazilian Olist marketplace.

The analysis covers:

- Customer behavior
- Order performance
- Product performance
- Seller performance
- Revenue analysis
- Payment methods
- Delivery performance
- Customer reviews
- Product categories
- Geographic analysis

The project follows a structured SQL workflow:

**Raw Data → Database Setup → Data Validation → Relational Integrity → Business Analysis**

---

## 🎯 Project Objectives

- Design a relational e-commerce database
- Import raw CSV datasets into SQL Server
- Validate data quality and consistency
- Identify duplicate and NULL records
- Establish primary and foreign key relationships
- Analyze sales and revenue performance
- Analyze customer and seller behavior
- Evaluate delivery performance
- Analyze payment methods and customer reviews
- Generate business-focused insights using SQL

---

## 🛠️ Tools & Technologies

- **Database:** Microsoft SQL Server
- **SQL Environment:** SQL Server Management Studio (SSMS)
- **Language:** T-SQL
- **Dataset:** Olist Brazilian E-Commerce Public Dataset
- **Version Control:** Git
- **Repository:** GitHub

---

## 📁 Project Structure

```text
Olist-Ecommerce-SQL-Project/
│
├── README.md
│
├── SQL/
│   ├── 01_Database_Setup_and_Data_Import.sql
│   ├── 02_Constraints_and_Relationships.sql
│   ├── 03_Data_Validation_and_Cleaning.sql
│   └── 04_SQL_Business_Analysis.sql
│
└── Dataset/
    └── Raw_Data/
        ├── olist_customers_dataset.csv
        ├── olist_orders_dataset.csv
        ├── olist_order_items_dataset.csv
        ├── olist_order_payments_dataset.csv
        ├── olist_order_reviews_dataset.csv
        ├── olist_products_dataset.csv
        ├── olist_sellers_dataset.csv
        ├── olist_geolocation_dataset.csv
        └── product_category_name_translation.csv
```

---

## 📌 Dataset

This project uses the **Olist Brazilian E-Commerce Public Dataset**.

The dataset contains approximately 100K orders from 2016 to 2018 and includes information about customers, orders, products, sellers, payments, reviews, geolocation, and product categories.

**Dataset Source:**
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## 🗄️ Database

Database name:

```text
EcommerceDB
```

### Core Tables

| Table | Description |
|---|---|
| `customers` | Customer information and location |
| `orders` | Order status and timestamps |
| `order_items` | Products and sellers associated with orders |
| `order_payments` | Payment method, value, and installments |
| `order_reviews` | Customer review scores and comments |
| `products` | Product details and categories |
| `sellers` | Seller information and location |
| `product_category_translation` | Portuguese-to-English category mapping |

---

## 🔗 Database Relationships

The database uses primary keys and foreign keys to maintain relational integrity.

```text
customers
    │
    └── orders
          │
          ├── order_items ─── products
          │        │
          │        └── sellers
          │
          ├── order_payments
          │
          └── order_reviews

products
    │
    └── product_category_translation
```

### Foreign Key Relationships

- `orders.customer_id` → `customers.customer_id`
- `order_items.order_id` → `orders.order_id`
- `order_items.product_id` → `products.product_id`
- `order_items.seller_id` → `sellers.seller_id`
- `order_payments.order_id` → `orders.order_id`
- `order_reviews.order_id` → `orders.order_id`
- `products.product_category_name` → `product_category_translation.product_category_name`

---

## 🧹 Data Preparation & Validation

Before performing business analysis, the dataset was validated for common data-quality issues.

### Validation Checks

- Row count validation
- Duplicate record detection
- NULL value analysis
- Primary key validation
- Foreign key validation
- Orphan record detection
- Invalid payment values
- Invalid product prices
- Invalid freight values
- Invalid review scores
- Delivery date consistency
- Product category validation

These checks help ensure that the database is reliable and suitable for business analysis.

---

## 📜 SQL Script Breakdown

| File | Description |
|---|---|
| `01_Database_Setup_and_Data_Import.sql` | Creates the database and tables, imports CSV data, and performs initial checks. |
| `02_Constraints_and_Relationships.sql` | Creates primary keys and foreign key relationships to establish relational integrity. |
| `03_Data_Validation_and_Cleaning.sql` | Performs data-quality validation, duplicate checks, NULL checks, orphan checks, and consistency checks. |
| `04_SQL_Business_Analysis.sql` | Contains business-focused SQL analysis covering revenue, customers, products, sellers, payments, delivery, and reviews. |

---

## 🧮 SQL Concepts Covered

### Basic SQL
- SELECT
- WHERE
- DISTINCT
- ORDER BY
- TOP

### Aggregation
- COUNT
- SUM
- AVG
- MIN
- MAX
- GROUP BY
- HAVING

### Joins
- INNER JOIN
- LEFT JOIN
- Multi-table JOINs

### Conditional Logic
- CASE WHEN

### String Functions
- UPPER
- LOWER
- LEN
- LEFT
- RIGHT
- REPLACE
- CHARINDEX

### Date & Time Functions
- CAST
- CONVERT
- DATEPART
- DATEDIFF

### Advanced SQL
- Subqueries
- EXISTS
- NOT EXISTS
- CTEs
- Window Functions
- LAG
- Running Totals
- Moving Averages
- Ranking
- Percentage Calculations

### Database Concepts
- Primary Keys
- Foreign Keys
- Constraints
- Views
- Stored Procedures
- Indexes
- Data Validation
- Data Cleaning

---

## 📈 Business Analysis

### 💰 Revenue Analysis
- Total revenue
- Monthly revenue trends
- Revenue by state
- Revenue by product category
- Revenue by seller
- Revenue contribution
- Cumulative revenue analysis

### 👤 Customer Analysis
- Total customers
- Customers by state
- Customer spending
- Repeat customers
- Customer lifetime value
- Top customers

### 📦 Product Analysis
- Top products by revenue
- Products never sold
- Category performance
- Product pricing analysis
- Product weight analysis

### 🏪 Seller Analysis
- Top sellers by revenue
- Top sellers by order volume
- Seller delivery performance
- Seller review performance
- Seller revenue contribution

### 🚚 Delivery Analysis
- Average delivery time
- Late deliveries
- Delivery success rate
- Delivery performance by state
- Seller delivery performance

### 💳 Payment Analysis
- Payment method usage
- Revenue by payment method
- Average payment value
- Installment analysis

### ⭐ Review Analysis
- Average review score
- Review score distribution
- Category ratings
- Seller ratings
- Delivery performance vs. customer reviews

---

## ❓ Key Business Questions

The SQL analysis answers practical business questions such as:

- What is the total revenue generated?
- Which month generated the highest revenue?
- Which product categories generate the most revenue?
- Who are the highest-value customers?
- Which sellers generate the highest revenue?
- Which payment method is used most frequently?
- Which states have the highest customer demand?
- Which products have never been sold?
- What is the average delivery time?
- Which sellers have the highest delivery delays?
- How does delivery performance affect customer reviews?

---

## 🚀 How to Run the Project

### Step 1 — Create the Database

Open SQL Server Management Studio and create the database:

```sql
CREATE DATABASE EcommerceDB;
GO
```

### Step 2 — Run Database Setup

Execute:

```text
01_Database_Setup_and_Data_Import.sql
```

This creates the required tables and imports the CSV data.

### Step 3 — Create Relationships

Execute:

```text
02_Constraints_and_Relationships.sql
```

This creates the primary keys and foreign keys.

### Step 4 — Validate the Data

Execute:

```text
03_Data_Validation_and_Cleaning.sql
```

This performs data-quality and relational-integrity checks.

### Step 5 — Run Business Analysis

Execute:

```text
04_SQL_Business_Analysis.sql
```

This contains the final business analysis queries.

---

## 💼 Real-World Business Value

This project demonstrates how a Data Analyst can use SQL to support business decision-making.

The analysis can help stakeholders understand:

- Sales performance
- Customer behavior
- Product demand
- Seller performance
- Delivery efficiency
- Payment preferences
- Customer satisfaction

The project focuses on converting raw transactional data into **actionable business insights**.

---

## 🏁 Project Outcome

Through this project, the following skills are demonstrated:

- SQL Server database development
- Relational database design
- CSV data import
- Data validation
- Data cleaning
- Primary and foreign key implementation
- Complex SQL querying
- Business analysis
- Advanced SQL techniques
- GitHub project organization

---

## 🎯 Project Focus

```text
Raw E-Commerce Data
        ↓
Database Setup
        ↓
Data Validation & Cleaning
        ↓
Relational Integrity
        ↓
SQL Business Analysis
        ↓
Actionable Business Insights
```

---

## 👨‍💻 Author

**Harshal Bavishi**

Aspiring Data Analyst
Data Analytics | Power BI | SQL | Excel | Data Visualization

---

⭐ If you found this project useful, consider giving the repository a **star**!
