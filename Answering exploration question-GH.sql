-- 1. How many orders are there in the dataset? The orders table contains a row for each order, so this should be easy to find out!

SELECT * FROM orders; 
select count(order_id) as orders_count
from orders; 

-- Answer: 99441

-- 2. Are orders actually delivered? Look at the columns in the orders table: one of them is called order_status. Most orders seem to be delivered, but some aren’t.
--  Find out how many orders are delivered and how many are cancelled, unavailable, or in any other status by grouping and aggregating this column.

select count(order_id) as orders_count,
        order_status
from orders
Group By order_status; 

-- 3. Is Magist having user growth? A platform losing users left and right isn’t going to be very useful to us. 
-- It would be a good idea to check for the number of orders grouped by year and month. Tip: you can use the functions YEAR() and MONTH() to separate the year and the month of the order_purchase_timestamp.
SELECT * FROM orders; 
-- by year: 
SELECT year(order_purchase_timestamp) AS year,
       count(order_id) AS number_of_orders
FROM orders
Group BY year; 

-- by months: 
SELECT year (order_purchase_timestamp) as years,
	 month(order_purchase_timestamp) AS months,
       count(order_id) AS number_of_orders
FROM orders
Group BY years, months
Order BY years asc, months asc; 

-- Answer: YoY - growing, but MoM - 2018 - almost no orders in 9, 10 months - weird


-- 4. How many products are there on the products table? (Make sure that there are no duplicate products.)

select count(distinct (product_id)) as unique_products_count,
        count(product_id) as all_count
         
from products; 

-- 5. Which are the categories with the most products? Since this is an external database and has been partially anonymized, we do not have the names of the products. 
-- But we do know which categories products belong to. This is the closest we can get to knowing what sellers are offering in the Magist marketplace. 
-- By counting the rows in the products table and grouping them by categories, we will know how many products are offered in each category. 
-- This is not the same as how many products are actually sold by category. To acquire this insight we will have to combine multiple tables together: 
-- we’ll do this in the next lesson.

-- proucts by category

SELECT product_category_name, 
	   count(distinct product_id)
FROM products
Group By product_category_name; 

-- How many of those products were present in actual transactions? 
-- The products table is a “reference” of all the available products. 
-- Have all these products been involved in orders? Check out the order_items table to find out!

SELECT * FROM orders;
SELECT * FROM products; 
SELECT * FROM order_payments;
SELECT * FROM order_items;

SELECT p.product_category_name, 
	   count(distinct p.product_id),
        count( o.product_id)  as sold_products_sum
FROM products as p
Left JOIN order_items as o on p.product_id = o.product_id
Group By product_category_name;


SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;
-- 7. What’s the price for the most expensive and cheapest products? 
-- Sometimes, having a broad range of prices is informative. Looking for the maximum and minimum values is also a good way to detect extreme outliers.

SELECT MAX(price), 
		Min(price)
FROM order_items;
    
-- What are the highest and lowest payment values? 
-- Some orders contain multiple products. What’s the highest someone has paid for an order? 
-- Look at the order_payments table and try to find it out.

SELECT * FROM order_payments;
SELECT MAX(payment_value), 
		Min(payment_value)
FROM order_payments;


SELECT *
FROM order_payments;

SELECT
    SUM(payment_value) as highest_order
FROM order_payments
GROUP BY order_id
ORDER BY highest_order desc
LIMIT 1;
