--***********************
-- Name: Zelalem Setegn
-- ID: 131846206
-- Date: June 15, 2021
-- Purpose: Lab 4 DBS311
--***********************
--1 Display cities that no warehouse is located in them. (use set operators to answer this question)
SELECT city
FROM locations
MINUS
SELECT city
FROM locations, warehouses
WHERE Warehouses.location_ID = locations.location_id;

--2  Display the category ID, category name, and the number of products in category 1, 2, and 5. In your result, display first the number of products in category 5, then category 1 and then 2.
SELECT product_categories.category_id,
       category_name,
       Count(*)
FROM   product_categories,
       products
WHERE  product_categories.category_id = products.category_id
       AND products.category_id IN ( 1, 2, 5 )
GROUP  BY product_categories.category_id,
          category_name,
          products.category_id
ORDER  BY Count(*) DESC;

--3 Display product ID for products whose quantity in the inventory is less than to 5. (You are not allowed to use JOIN for this question.)
SELECT product_id
FROM   inventories
WHERE  quantity < 5;

--4 We need a single report to display all warehouses and the state that they are located in and all states regardless of whether they have warehouses in them or not. (Use set operators in you answer.)
SELECT
   warehouse_name,
   state 
FROM
   warehouses 
   LEFT JOIN
      locations 
      ON warehouses.location_id = locations.location_id 
   UNION
   SELECT
      warehouse_name,
      state 
   FROM
      warehouses 
      RIGHT JOIN
         locations 
         ON warehouses.location_id = locations.location_id;

