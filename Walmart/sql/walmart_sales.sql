SELECT * FROM sales
-- EDA ----------------------------------------------------------------------------------------------------------------------------------------------------
--Total Transactions 
SELECT COUNT(*) FROM sales

-- Types of Payment Methods
SELECT payment_method ,COUNT(*) FROM sales GROUP BY payment_method

-- Maximum Quantity Order 
SELECT MAX(quantity) FROM sales



-- Business Questions ---------------------------------------------------------------------------------------------------------------------------------------
-- 1. What are the different payment methods and how many transactions and items were sold with each method?
SELECT payment_method ,
	COUNT(*) AS no_of_Trasactions,
	SUM(quantity) AS no_of_qty
FROM sales 
GROUP BY payment_method;

-- 2.Which category received the highest average rating in each branch?
SELECT *
FROM (
    SELECT 
        branch,
        category,
        ROUND(AVG(rating)::numeric, 2) AS avg_ratings,
        RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
    FROM sales
    GROUP BY 1, 2
) t
WHERE rank = 1;

-- 3.What is the busiest day of the week for each branch based on the transaction volume?
SELECT * 
FROM
	(SELECT 
		branch,
		TO_CHAR(TO_DATE(date,'DD/MM/YY'),'Day') as day_name,
		COUNT(*) as no_of_transactions,
		RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC )AS rank
	FROM sales
	GROUP BY 1,2)t
WHERE rank = 1

-- 4.What are the average, minimum, and maximum ratings for each category in each city?
SELECT 
	city,
	category ,
	MAX(rating) as max_ratings,
	MIN(rating) as min_ratings,
	AVG(rating) as avg_ratings
FROM sales 
GROUP by 1,2

-- 5.What is the total profit for each category, ranked from highest to lowest?
SELECT * From sales
SELECT 
	category ,
	ROUND(SUM(total_price)::numeric,2) as total_revenue ,
	ROUND(SUM(total_price * profit_margin)::numeric,2) as total_profit  
FROM sales
GROUP BY 1

-- 6.What is the most frequent used payment method in each branch?
WITH cte AS  	
	(SELECT 
		branch,
		payment_method,
		COUNT(*) as no_of_trans,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*)DESC) as rank
	FROM sales
	GROUP BY 1,2 )
SELECT * FROM cte 
WHERE rank = 1 

-- 7.How many transactions occur in each shift (morning, afternoon, evening) across branches?
SELECT
	branch,
	CASE 
		WHEN EXTRACT (HOUR FROM (time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM (time::time)) BETWEEN  12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift,
	COUNT(*)
FROM sales
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- 8.which branches experienced the largest decrease in revenue compared to their previous years.

-- Changes in revenue FORMULA used =( (last_yr revenue - current_yr revenue) / last_yr revenue )*100

-----2022-------
WITH rev_2022 
AS (
	SELECT 
		branch ,
		SUM(total_price) as revenue
	FROM sales
	WHERE EXTRACT(YEAR FROM TO_DATE(date,'DD/MM/YY')) = 2022
	GROUP BY 1
) ,
------2023------
rev_2023
AS 
(
SELECT 
		branch ,
		SUM(total_price) as revenue
	FROM sales
	WHERE EXTRACT(YEAR FROM TO_DATE(date,'DD/MM/YY')) = 2023
	GROUP BY 1
)

SELECT 
	ls.branch,
	ls.revenue as last_yr_revenue,
	cs.revenue as current_yr_revenue,
	ROUND(
	(ls.revenue - cs.revenue)::numeric/ ls.revenue::numeric *100 
	,2) AS percent_decrease_revenue
FROM rev_2022 as ls 
JOIN rev_2023 as cs 
ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5;







