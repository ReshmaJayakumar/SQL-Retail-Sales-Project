-- Retail Data Analysis Portfolio Project
CREATE DATABASE retail_sales_analysis;

-- Creating Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
    category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales;

-- Imported Data using Table Data Import Wizard

-- Selecting first 10 rows of imported data
SELECT * FROM retail_sales LIMIT 10;

-- Counting the total number of rows in the table
SELECT COUNT(*) FROM retail_sales;

-- Checking if there are any fields with null values - Data Cleaning
SELECT * FROM retail_sales WHERE 
sale_date IS NULL 
OR
sale_time IS NULL 
OR
customer_id IS NULL 
OR
gender IS NULL 
OR
age IS NULL 
OR
category IS NULL 
OR
quantity IS NULL 
OR 
price_per_unit IS NULL 
OR
cogs IS NULL 
OR
total_sale IS NULL;

-- 0 rows returned

-- Data Exploration
-- How many sales we have?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_unique_customers FROM retail_sales;

-- How many unique categories do we have?
SELECT COUNT(DISTINCT category) AS total_unique_categories FROM retail_sales;

-- Which are the unique categories?
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems and Answers
SELECT * FROM retail_sales;

-- 1. Retrieve all columns for sales made on 2022-11-05
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- 2. Retrieve all transactions where the category is 'Clothing' and the sold is equal to or more than 4 in the month of Nov-2022
 SELECT transactions_id, category, quantity AS TotalQuantitySold FROM retail_sales 
 WHERE category = 'Clothing' AND quantity >= 4 AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
 
 -- 3. Calculate the total sales for each category
 SELECT category,SUM(total_sale) AS TotalSales FROM retail_sales
 GROUP BY category;

-- 4. Find the average age of customers who purchased items from the 'Beauty' category
SELECT category, ROUND(AVG(age),2) AS AverageAgeOfCustomers FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- 5. Find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales WHERE total_sale > 1000;

-- 6. Find the total number of transactions made by each gender in each category
SELECT category,gender,COUNT(transactions_id) AS TotalTransactions FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- 7. Calculate the average sale for each month. Find out best selling month in each year.
WITH RANKING AS (
SELECT ROUND(AVG(total_sale),2) AS AverageSales, DATE_FORMAT(sale_date,'%m') AS Month, DATE_FORMAT(sale_date,'%Y') AS Year,
RANK() OVER (PARTITION BY DATE_FORMAT(sale_date,'%Y') ORDER BY ROUND(AVG(total_sale),2) DESC) AS RankValue
FROM retail_sales
GROUP BY Month, Year)
SELECT Year, Month, AverageSales FROM RANKING WHERE RankValue = 1;

-- 8. Find the top 5 customers based on the highest total sales.
SELECT customer_id,sum(total_sale) AS TotalSales FROM retail_sales
GROUP BY customer_id
ORDER BY TotalSales DESC
LIMIT 5;

-- 9. Find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS UniqueCustomerCount FROM retail_sales
GROUP BY category;

-- 10. Create each shift and number of orders (Example Morning < 12, Afternoon between 12 & 17, Evening > 17)
WITH hourly_sales AS
(
SELECT *,HOUR(sale_time) AS HourTime,
CASE
	WHEN HOUR(sale_time) < 12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END AS Shift
 FROM retail_sales
)
SELECT Shift,COUNT(transactions_id) AS TotalOrders FROM hourly_sales
GROUP BY shift;

-- End of RetailSales Portfolio Project
