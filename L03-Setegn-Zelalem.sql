--***********************
-- Name: Zelalem Setegn
-- ID: 131846206
-- Date: June 11, 2021
-- Purpose: Lab 3 DBS311
--***********************
--1 Write a SQL query to display the last name and hire date of all employees who were hired before the employee with ID 107 got hired but after March 2016. Sort the result by the hire date and then employee ID.
SELECT last_name,
       hire_date
FROM   employees
WHERE  ( hire_date < (SELECT hire_date
                      FROM   employees
                      WHERE  employee_id = 107)
         AND hire_date > '31-MAR-16' )
ORDER  BY hire_date ASC;

--2 Write a SQL query to display customer name and credit limit for customers with lowest credit limit. Sort the result by customer ID.
SELECT NAME,
       credit_limit
FROM   customers
WHERE  credit_limit = (SELECT Min(credit_limit)
                       FROM   customers);

--3. Write a SQL query to display the product ID, product name, and list price of the highest paid product(s) in each category. Sort by category ID and the product ID.
SELECT category_id,
       product_id,
       product_name,
       list_price
FROM   products
WHERE  list_price IN (SELECT Max(list_price)
                      FROM   products
                      GROUP  BY category_id)
ORDER  BY category_id,
          product_id;

--4 Write a SQL query to display the category ID and the category name of the most expensive (highest list price) product(s).
SELECT products.category_id,
       category_name
FROM   products,
       product_categories
WHERE  list_price = (SELECT Max(list_price)
                     FROM   products)
       AND products.category_id = product_categories. category_id;

--5 Write a SQL query to display product name and list price for products in category 1 which have the list price less than the lowest list price in ANY category. Sort the output by top list prices first and then by the product ID.
SELECT product_name,
       list_price
FROM   products
WHERE  category_id = 1
       AND list_price <= ANY (SELECT Min(list_price)
                              FROM   products
                              GROUP  BY category_id)
ORDER  BY list_price DESC,
          product_id;

--6 Display the maximum price (list price) of the category(s) that has the lowest price product.
SELECT Max(list_price)
FROM   products
WHERE  list_price IN (SELECT Max(list_price)
                      FROM   products
                      GROUP  BY category_id); 