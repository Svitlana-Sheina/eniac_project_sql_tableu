-- Answering business quesions: 
-- 2.1. What categories of tech products does Magist have?
-- How many products of these tech categories have been sold (within the time window of the database snapshot)? 
-- What percentage does that represent from the overall number of products sold?

SELECT p.product_category_name, 
pc.product_category_name_english,
	   count(distinct p.product_id) as number_of_products_in_category,
	   count( o.product_id)  as number_of_sold_products,
      concat(ROUND(100.0 * COUNT(o.product_id) / (SELECT COUNT(o2.product_id) FROM order_items o2), 2), '%') AS percentage_of_sold
FROM products as p
Left Join product_category_name_translation as pc on p.product_category_name = pc.product_category_name
Left JOIN order_items as o on p.product_id = o.product_id
GROUP BY p.product_category_name, pc.product_category_name_english;

-- What’s the average price of the products being sold?

SELECT ROUND(AVG(price),2) as average_price 
FROM order_items;

-- Are expensive tech products popular? * --No

SELECT p.product_category_name, 
pc.product_category_name_english,
	   count(distinct p.product_id) as number_of_products_in_category,
	   count( o.product_id)  as number_of_sold_products,
       CASE 
           WHEN product_category_name_english in('pc_gamer','telephony', 'fixed_telephony', 'tablets_printing_image', 'computers','air_conditioning','consoles_games','electronics') then ('Tech category')
           else 'non-tech products'
           End AS Tech_products,
           
      concat(ROUND(100.0 * COUNT(o.product_id) / (SELECT COUNT(o2.product_id) FROM order_items o2), 2), '%') AS percentage_of_sold,
      round(avg(o.price),2) as average_price
FROM products as p
Left Join product_category_name_translation as pc on p.product_category_name = pc.product_category_name
Left JOIN order_items as o on p.product_id = o.product_id
GROUP BY p.product_category_name, pc.product_category_name_english;