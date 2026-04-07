SELECT * FROM sales
-- EDA -----------------------------------------------------------------------------------------------------------------------------
--Total Transactions 
SELECT COUNT(*) FROM sales

-- Types of Payment Methods
SELECT payment_method ,COUNT(*) 
FROM sales 
GROUP BY payment_method

--ALL Walmart Branch IDs
SELECT DISTINCT branch 
FROM sales

-- Maximum Qty ordered 
SELECT MAX(quantity) FROM sales

-- Answering Business Problems -----------------------------------------------------------------------------------------------------

-- Q1 What are the different payment methods and how many transactions & items were sold with each method?

-- Q2 Which Category recevied the Highest average rating in branch

-- Q3 Which are the Busiest days of the week for each branch based on transactions volumne ?

-- Q4 How many items were sold though each payment method ?

-- Q5 What are the minimum , average & maximum rating form each category?

-- Q6 What is the Total Profit for each category

-- Q7 What is the most frequently used payment method in each branch ?

-- Q8 How many transaction occurs in each shift(Morning , Afternoon ,Evenong) across Branches?

-- Q9 Which branches experienced the largest decrease in revenue compared to thier previous year?







