--***********************
-- Name: Zelalem Setegn
-- ID: 131846206
-- Date: JUN 04,2021
-- Purpose: Lab 2 DBS311
--***********************
--1. For each job title display the number of employees. Sort the result according to the number of employees.
SELECT
   job_title,
   count(*) AS "EMPLOYEES" 
FROM
   employees 
GROUP BY
   job_title 
ORDER BY
   count(*);
--2.Display the highest, lowest, and average customer credit limits. Name these results high, low, and average. Add a column that shows the difference between the highest and the lowest credit limits named “High and Low Difference”. Round the average to 2 decimal places.
SELECT
   MAX(credit_limit) aS "high",
   MIN (credit_limit) aS "low",
   Round(AVG(credit_limit), 2) aS "average",
   MAX(credit_limit) - MIN (credit_limit) As "High Low Difference" 
FROM
   customers;
--3. Display the order id, the total number of products, and the total order amount for orders with the total amount over $1,000,000. Sort the result based on total amount from the high to low values.
SELECT
   o.order_id,
   SUM(i.quantity) AS "TOTAL_ITEMS",
   SUM(i.quantity * i.unit_price) AS "TOTAL_AMOUNT" 
FROM
   orders o 
   LEFT JOIN
      order_items i 
      ON o.order_id = i.order_id 
GROUP BY
   o.order_id 
order by
   "TOTAL_AMOUNT" DESC;
--4 Display the warehouse id, warehouse name, and the total number of products for each warehouse. Sort the result according to the warehouse ID.
SELECT
   inventories.warehouse_id,
   warehouses.warehouse_name,
   SUM(Quantity) AS "TOTAL_PRODUCTS" 
FROM
   inventories,
   warehouses 
WHERE
   inventories.warehouse_id = warehouses.warehouse_id 
GROUP BY
   inventories.warehouse_id,
   warehouses.warehouse_name 
order by
   inventories.warehouse_id;
--5. For each customer display customer number, customer full name, and the total number of orders issued by the customer. 
--? If the customer does not have any orders, the result shows 0.
--Display only customers whose customer name starts with ‘O’ and contains ‘e’.
--? Include also customers whose customer name ends with ‘t’.
--? Show the customers with highest number of orders first.
SELECT
  customers.customer_id,
   CUSTOMERS.name,
   COUNT(  customers.customer_id) AS "TOTAL_NUMBER OF PRODUCTS" 
FROM
   customers 
   LEFT JOIN
      orders 
      ON orders.customer_id = customers.customer_id
WHERE
   customers.name LIKE 'O%' 
   AND customers.name LIKE '%e%' 
   OR customers.name LIKE '%t' 
GROUP BY
 customers.customer_id,
   customers.name
order by
   "TOTAL_NUMBER OF PRODUCTS" desc ;
--6. Write a SQL query to show the total and the average sale amount for each category. Round the average to 2 decimal places.
SELECT
   Product_categories.category_id,
   SUM(quantity*Unit_price)AS "TOTAL_AMOUNT",
   ROUND( AVG(quantity*Unit_price), 2) AS "AVERAGE_AMOUNT"
FROM
   PRODUCT_CATEGORIES,
   PRODUCTS,
   ORDER_ITEMS 
WHERE
   Product_categories.category_id = Products.category_id
   AND Order_items.Product_id = Products.Product_id 
GROUP BY
   Product_categories.category_id;
