CREATE DATABASE retaildataset;
use retaildataset;
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Ship_Date DATE,
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Age INT,
    Gender VARCHAR(20),
    Region VARCHAR(50),
    City VARCHAR(100),
    Category VARCHAR(50),
    Sub_Category VARCHAR(100),
    Product_Name VARCHAR(100),
    Sales DOUBLE,
    Quantity INT,
    Discount DOUBLE,
    Profit DOUBLE
);


-- Basic KPIs
CREATE VIEW vw_total_orders AS
SELECT COUNT(*) AS total_orders
FROM retail_sales;

CREATE VIEW vw_total_sales AS
SELECT SUM(Sales) AS total_sales
FROM retail_sales;

CREATE VIEW vw_total_profit AS
SELECT SUM(Profit) AS total_profit
FROM retail_sales;

CREATE VIEW vw_avg_sales AS
SELECT AVG(Sales) AS avg_sales
FROM retail_sales;

-- --customer analysis-- 
CREATE VIEW vw_top_customers_sales AS
SELECT Customer_Name,
       SUM(Sales) AS revenue
FROM retail_sales
GROUP BY Customer_Name
ORDER BY revenue DESC
LIMIT 10;

CREATE VIEW vw_top_customers_profit AS
SELECT Customer_Name,
       SUM(Profit) AS profit
FROM retail_sales
GROUP BY Customer_Name
ORDER BY profit DESC
LIMIT 10;

-- category analysis
CREATE VIEW vw_category_sales AS
SELECT Category,
       SUM(Sales) AS sales
FROM retail_sales
GROUP BY Category
ORDER BY sales DESC;

CREATE VIEW vw_category_profit AS
SELECT Category,
       SUM(Profit) AS profit
FROM retail_sales
GROUP BY Category
ORDER BY profit DESC;

CREATE VIEW vw_subcategory_profit AS
SELECT Sub_Category,
       SUM(Profit) AS profit
FROM retail_sales
GROUP BY Sub_Category
ORDER BY profit DESC;


-- Regional analysis
CREATE VIEW vw_region_sales AS
SELECT Region,
       SUM(Sales) AS sales
FROM retail_sales
GROUP BY Region
ORDER BY sales DESC;

CREATE VIEW vw_region_profit AS
SELECT Region,
       SUM(Profit) AS profit
FROM retail_sales
GROUP BY Region
ORDER BY profit DESC;

-- Discount analysis-- 
CREATE VIEW vw_avg_discount AS
SELECT AVG(Discount) AS avg_discount
FROM retail_sales;

CREATE VIEW vw_discount_profit_analysis AS
SELECT
CASE
WHEN Discount = 0 THEN 'No Discount'
WHEN Discount <= 0.2 THEN 'Low'
WHEN Discount <= 0.5 THEN 'Medium'
ELSE 'High'
END AS Discount_Level,

SUM(Profit) AS Profit

FROM retail_sales

GROUP BY Discount_Level;

-- Time Series Analysis
CREATE VIEW vw_monthly_sales AS
SELECT
YEAR(Order_Date) AS Year,
MONTH(Order_Date) AS Month,
SUM(Sales) AS Revenue
FROM retail_sales
GROUP BY Year, Month
ORDER BY Year, Month;

CREATE VIEW vw_monthly_profit AS
SELECT
YEAR(Order_Date) AS Year,
MONTH(Order_Date) AS Month,
SUM(Profit) AS Profit
FROM retail_sales
GROUP BY Year, Month;

-- Shipping analysis
CREATE VIEW vw_avg_shipping_days AS
SELECT
AVG(DATEDIFF(Ship_Date, Order_Date))
AS Avg_Shipping_Days
FROM retail_sales;

CREATE VIEW vw_region_delivery_days AS
SELECT
Region,
AVG(DATEDIFF(Ship_Date, Order_Date))
AS Avg_Delivery_Days
FROM retail_sales
GROUP BY Region;

-- Windown functions
CREATE VIEW vw_customer_ranking AS
SELECT
Customer_Name,
SUM(Sales) AS Revenue,

RANK() OVER(
ORDER BY SUM(Sales) DESC
) AS Ranking

FROM retail_sales
GROUP BY Customer_Name;


CREATE VIEW vw_top_product_each_category AS
SELECT *
FROM
(
SELECT
Category,
Product_Name,
SUM(Sales) AS Revenue,

ROW_NUMBER() OVER(
PARTITION BY Category
ORDER BY SUM(Sales) DESC
) AS rn

FROM retail_sales
GROUP BY Category, Product_Name
) x
WHERE rn = 1;


CREATE VIEW vw_top5_cities_sales AS
SELECT
City,
SUM(Sales) AS Revenue
FROM retail_sales
GROUP BY City
ORDER BY Revenue DESC
LIMIT 5;

CREATE VIEW vw_top10_products_quantity AS
SELECT
Product_Name,
SUM(Quantity) AS Units_Sold
FROM retail_sales
GROUP BY Product_Name
ORDER BY Units_Sold DESC
LIMIT 10;

