-- 2.2. In relation to the sellers:
-- How many months of data are included in the magist database? - 25

SELECT
  MAX(order_purchase_timestamp) AS max_day,
  MIN(order_purchase_timestamp) AS min_day,
  TIMESTAMPDIFF(month, MIN(order_purchase_timestamp),MAX(order_purchase_timestamp)) AS dif_months_in_the_dataset
FROM orders;

-- How many sellers are there? -- 3095

SELECT count(*) as total_count,
		count(distinct (seller_id)) as unique_ids_check
FROM sellers;

--  How many Tech sellers are there? 

SELECT *
FROM sellers;

SELECT *
FROM order_items;



 
SELECT 
        p.product_category_name,
        count(distinct s.seller_id)

FROM sellers as s
left join order_items as o on o.seller_id = s.seller_id
left join products as p on p.product_id = o.product_id
Group By p.product_category_name
;

-- What percentage of overall sellers are Tech sellers? -- c.a 11,3%

      -- PART 1:     
SELECT 
        p.product_category_name,
        product_category_name_english,
        count(distinct s.seller_id),
         CASE 
           WHEN product_category_name_english in('pc_gamer','telephony', 'fixed_telephony', 'tablets_printing_image', 'computers','air_conditioning','consoles_games','electronics') then ('Tech category')
           else 'non-tech products'
           End AS Tech_products
FROM sellers as s
left join order_items as o on o.seller_id = s.seller_id
left join products as p on p.product_id = o.product_id
left join product_category_name_translation as pc on pc.product_category_name = p.product_category_name
Group By p.product_category_name
;

-- Part 2 
SELECT
  COUNT(DISTINCT CASE WHEN t.Tech_products = 'Tech category' THEN t.seller_id END) AS tech_sellers_count,
  COUNT(DISTINCT t.seller_id) AS total_sellers_count,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN t.Tech_products = 'Tech category' THEN t.seller_id END)
    / NULLIF(COUNT(DISTINCT t.seller_id), 0),2) AS pct_tech_sellers
FROM (
  SELECT DISTINCT
    o.seller_id,
    CASE 
      WHEN pc.product_category_name_english IN ('pc_gamer','telephony','fixed_telephony','tablets_printing_image','computers','air_conditioning','consoles_games','electronics') THEN 'Tech category'
      ELSE 'non-tech products'
    END AS Tech_products
  FROM sellers AS s
  LEFT JOIN order_items AS o ON o.seller_id = s.seller_id
  LEFT JOIN products AS p ON p.product_id = o.product_id
  LEFT JOIN product_category_name_translation AS pc 
    ON pc.product_category_name = p.product_category_name
  WHERE o.seller_id IS NOT NULL  -- active sellers only
) AS t
;

-- What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers

select 
ROUND(SUM(o2.price), 2) AS total_amount_all_sellers,
  ROUND(SUM(CASE WHEN t.Tech_products = 'Tech category' THEN o2.price ELSE 0 END), 2) AS total_amount_tech_sellers
  
FROM (
  SELECT DISTINCT
    o.seller_id,
    CASE 
      WHEN pc.product_category_name_english IN ('pc_gamer','telephony','fixed_telephony','tablets_printing_image','computers','air_conditioning','consoles_games','electronics') THEN 'Tech category'
      ELSE 'non-tech products'
    END AS Tech_products
  FROM sellers AS s
  LEFT JOIN order_items AS o ON o.seller_id = s.seller_id
  LEFT JOIN products AS p ON p.product_id = o.product_id
  LEFT JOIN product_category_name_translation AS pc 
    ON pc.product_category_name = p.product_category_name
  WHERE o.seller_id IS NOT NULL  -- active sellers only
) AS t
JOIN order_items AS o2
  ON o2.seller_id = t.seller_id
;


-- Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?

-- All sellers: 

Select 16602514.1/3095/30 ; -- 178,8

-- All Tech sellers: 

Select 3378813.4/349/30 ; -- 322,7



