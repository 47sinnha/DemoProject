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


-- Basic Sql Queries-- 
SELECT COUNT(*) AS total_orders
FROM retail_sales;

SELECT SUM(Sales) AS total_sales
FROM retail_sales;

SELECT SUM(Profit) AS total_profit
FROM retail_sales;

SELECT AVG(Sales)
FROM retail_sales;


-- Customer Analysis --
SELECT Customer_Name,
       SUM(Sales) AS revenue
FROM retail_sales
GROUP BY Customer_Name
ORDER BY revenue DESC
LIMIT 10;


SELECT Customer_Name,
       SUM(Profit) AS profit
FROM retail_sales
GROUP BY Customer_Name
ORDER BY profit DESC
LIMIT 10;


SELECT Category,
       SUM(Sales) AS sales
FROM retail_sales
GROUP BY Category
ORDER BY sales DESC;

SELECT Category,
       SUM(Profit) AS profit
FROM retail_sales
GROUP BY Category
ORDER BY profit DESC;

SELECT Sub_Category,
       SUM(Profit) AS profit
FROM retail_sales
GROUP BY Sub_Category
ORDER BY profit DESC;

-- Region Analysis --
SELECT Region,
       SUM(Sales) AS sales
FROM retail_sales
GROUP BY Region
ORDER BY sales DESC;


SELECT Region,
       SUM(Profit) AS profit
FROM retail_sales
GROUP BY Region
ORDER BY profit DESC;

-- 6: Discount Analysis
SELECT AVG(Discount)
FROM retail_sales;

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


-- 7: Time Series Analysis
SELECT
YEAR(Order_Date) AS Year,
MONTH(Order_Date) AS Month,
SUM(Sales) AS Revenue

FROM retail_sales

GROUP BY Year, Month
ORDER BY Year, Month;



SELECT
YEAR(Order_Date),
MONTH(Order_Date),
SUM(Profit)

FROM retail_sales

GROUP BY YEAR(Order_Date),
MONTH(Order_Date);

-- Shipping Analysis-- 
SELECT
AVG(DATEDIFF(Ship_Date, Order_Date))
AS Avg_Shipping_Days
FROM retail_sales;


SELECT
Region,
AVG(DATEDIFF(Ship_Date, Order_Date))
AS Avg_Delivery_Days

FROM retail_sales

GROUP BY Region;


-- Window function-- 
SELECT
Customer_Name,
SUM(Sales) AS Revenue,

RANK() OVER(
ORDER BY SUM(Sales) DESC
) AS Ranking

FROM retail_sales

GROUP BY Customer_Name;

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

-- Advance Business Queries-- 
SELECT
City,
SUM(Sales) AS Revenue

FROM retail_sales

GROUP BY City

ORDER BY Revenue DESC

LIMIT 5;
-----------------------------
SELECT
Product_Name,
SUM(Quantity) AS Units_Sold

FROM retail_sales

GROUP BY Product_Name

ORDER BY Units_Sold DESC

LIMIT 10;
-------------------------------

