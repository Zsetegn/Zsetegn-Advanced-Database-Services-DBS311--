--***********************
-- Name: Zelalem Setegn
-- ID: 131846206
-- Date: 05/28/2021
-- Purpose: Lab 1 DBS311
--***********************
--1.Write a query to display the tomorrow’s date in the following format: January 10th of year 2019 the result will depend on the day when you RUN/EXECUTE this query. Label the column “Tomorrow”.
SELECT
  TO_CHAR( SYSDATE+1, 'FMMonth DD"th of year" YYYY' ) As Tomorrow
FROM
  dual;
  --2. Define an SQL variable called “tomorrow”, assign it a value of tomorrow’s date and use it in an SQL statement. Here the question is asking you to use a Substitution variable. Instead ofusing the constant values in your queries, you can use variables to store and reuse the values.
 define Today
 SELECT
  TO_CHAR( &Today +1, 'FMMonth DD"th of year" YYYY' ) As Tomorrow
FROM
  dual;
  --3. Define an SQL variable called “tomorrow”, assign it a value of tomorrow’s date and use it in an SQL statement. Here the question is asking you to use a Substitution variable. Instead ofusing the constant values in your queries, you can use variables to store and reuse the values.
SELECT product_id, product_name, list_price, round(list_price*1.2) "New price", round(list_price*1.2)
-list_price "Price Difference"
FROM products
WHERE category_id IN(2,3,5);

--4. For employees whose manager ID is 2, write a query that displays the employee’s Full Name and Job Title in the following format: Summer, Payne is Public Accountant.
SELECT first_name||', '||last_name||' is  '||job_Title As EmployeeInfo
FROM employees
WHERE manager_id = 2;
--5. For each employee hired before October 2016, display the employee’s last name, hire date and calculate the number of YEARS between TODAY and the date the employee was hired
SELECT last_name, hire_date, round((sysdate - hire_date) / 365)  "Years Worked"
FROM employees
WHERE hire_date < to_date('01-OCT-16',  'DD-Mon-YY')
ORDER BY round(((sysdate - hire_date) / 365), 1);
--6. Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of service, but only for those hired after January 1, 2016.
SELECT last_name, hire_date,
TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), 'Tuesday'),'fmDAY, Month " the " Ddspth " of year" YYYY') as "REVIEW DAY"
FROM employees
WHERE hire_date > '01-JAN-16'
ORDER BY "REVIEW DAY";
--7. For all warehouses, display warehouse id, warehouse name, city, and state. For warehouses with the null value for the state column, display “unknown”. Sort the result basedon the warehouse ID.
SELECT w.warehouse_id, w.warehouse_name, L.city, nvl(state, 'Unknown') As state
FROM warehouses w, locations L
where w.warehouse_id =L.location_id
ORDER BY w.warehouse_id;