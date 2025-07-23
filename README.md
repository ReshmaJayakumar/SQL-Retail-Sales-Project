# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_sales_analysis`

This project is a hands-on exploration of retail sales data using SQL. I worked with a dataset that mimics real retail transactions — including dates, times, customer info, categories, and sales amounts. The goal was to practice and demonstrate how SQL can be used to answer real business questions. From simple counts and customer insights to identifying peak sales months and analyzing purchase behavior by category — each query reflects a practical scenario.

I used MySQL to:
            Set up and structure the data
            Clean and explore it
            Answer real-world business questions with SQL

## Project Structure

### 1. Database Setup

- **Database Creation**: I created a database called retail_sales_analysis.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql

CREATE DATABASE retail_sales_analysis;

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

```

### 2. Data Cleaning
- **Null Value Check**: Ran a quick check for any null values and verified that no rows were missing critical info like date, customer ID, or price

```sql

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

```

### 3. Data Exploration and Analysis

- **Sales Count**: Determine the total number of sales in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.

```sql

-- Total number of sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS total_unique_customers FROM retail_sales;

-- Unique categories
SELECT COUNT(DISTINCT category) AS total_unique_categories FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

```

### 4. Data Analysis & Findings

1. **Sales made on '2022-11-05**:

```sql

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

```

2. **Transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

```sql

 SELECT transactions_id, category, quantity AS TotalQuantitySold FROM retail_sales 
 WHERE category = 'Clothing' AND quantity >= 4 AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

```

3. **Total sales for each category.**:

```sql

 SELECT category,SUM(total_sale) AS TotalSales FROM retail_sales
 GROUP BY category;

```

4. **Average age of customers who purchased items from the 'Beauty' category.**:

```sql

SELECT category, ROUND(AVG(age),2) AS AverageAgeOfCustomers FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

```

5. **Transactions where the total_sale is greater than 1000.**:

```sql

SELECT * FROM retail_sales WHERE total_sale > 1000;

```

6. **Total number of transactions (transaction_id) made by each gender in each category.**:

```sql

SELECT category,gender,COUNT(transactions_id) AS TotalTransactions FROM retail_sales
GROUP BY category, gender
ORDER BY category;

```

7. **Average sale for each month. Find out best selling month in each year**:

```sql

WITH RANKING AS (
SELECT ROUND(AVG(total_sale),2) AS AverageSales, DATE_FORMAT(sale_date,'%m') AS Month, DATE_FORMAT(sale_date,'%Y') AS Year,
RANK() OVER (PARTITION BY DATE_FORMAT(sale_date,'%Y') ORDER BY ROUND(AVG(total_sale),2) DESC) AS RankValue
FROM retail_sales
GROUP BY Month, Year)
SELECT Year, Month, AverageSales FROM RANKING WHERE RankValue = 1;

```

8. **Top 5 customers based on the highest total sales**:
   
```sql

SELECT customer_id,sum(total_sale) AS TotalSales FROM retail_sales
GROUP BY customer_id
ORDER BY TotalSales DESC
LIMIT 5;

```

9. **Number of unique customers who purchased items from each category.**:
    
```sql

SELECT category, COUNT(DISTINCT customer_id) AS UniqueCustomerCount FROM retail_sales
GROUP BY category;

```

10. **Create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

```sql

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

```

## Insights and Takeaways

- Clothing and Beauty were common categories.
- Some customers had sales above 1000 — valuable for targeted marketing.
- Afternoon was the busiest time overall.
- Monthly ranking helped reveal seasonal patterns in sales.
- Customer segmentation by gender and category gave a clearer view of buying behavior.

## Files in this Repo

- **retail_sales.sql**: Database setup + all analysis queries
- **SQL - Retail Sales Analysis_utf.csv**: Dataset
- **README.md**: Project Overview and Code Explanations

## Conclusion

This retail sales analysis project provided actionable insights into customer behavior, sales trends, and product category performance. These insights can support data-driven decisions in inventory planning, customer segmentation, and targeted marketing.

## Author
**Reshma Jayakumar**
[LinkedIn](https://www.linkedin.com/in/reshjayakumar)
[Email me](mailto:reshjkumar.jkumar@gmail.com)
