--***********************
-- Name: Zelalem Setegn
-- ID: 131846206
-- Date: June 25, 2021
-- Purpose: Lab 05 DBS311
--***********************

SET SERVEROUTPUT ON
-- Q1.	Write a store procedure that get an integer number and prints The number is even.
--         If a number is divisible by 2. Otherwise, it prints The number is odd.

CREATE OR REPLACE PROCEDURE findEvenODD(x IN number) IS
BEGIN


IF MOD(x, 2) = 0 THEN
dbms_output.put_line( ' The number is Even ');
ELSE
dbms_output.put_line('The number is Odd ');
END IF;
END;   




-- Q2.	Create a stored procedure named find_employee. This procedure gets an employee number and prints the following 
--   employee information: First name Last name Email Phone Hire date Job title


CREATE OR REPLACE PROCEDURE find_employee(p_employee_id IN number) AS
v_count NUMBER;
v_first_name Employees.first_name%TYPE;
v_last_name Employees.last_name%TYPE;
v_email Employees.email%TYPE;
v_phone Employees.phone%TYPE;
v_hire_date Employees.hire_date%TYPE;
v_job_title Employees.job_title%TYPE;
BEGIN


select count(employee_id) into v_count from EMPLOYEES where employee_id = p_employee_id;
IF v_count = 0 THEN
dbms_output.put_line( ' The EMPLOYEE_ID is not present in EMPLOYEES ');
ELSE
select FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE, JOB_TITLE
   into   v_first_name, v_last_name, v_email, v_phone, v_hire_date, v_job_title
from EMPLOYEES where EMPLOYEE_ID = p_employee_id;
  
   DBMS_OUTPUT.PUT_LINE('FIRST_NAME : ' || v_first_name);
   DBMS_OUTPUT.PUT_LINE('LAST_NAMENAME: ' || v_last_name);
   DBMS_OUTPUT.PUT_LINE('EMAIL: ' || v_email);
   DBMS_OUTPUT.PUT_LINE('PHONE: ' || v_phone);
   DBMS_OUTPUT.PUT_LINE('HIRE_DATE: ' || v_hire_date);
   DBMS_OUTPUT.PUT_LINE('JOB_TITLE: ' || v_job_title);
END IF;

EXCEPTION
  
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Employee not found.');
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE('Employee has too many records .');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Stored PROCEDURE has errors. Please take a look');     
END;   

---------------------
begin
find_employee(107);
end;

-- Q3. Every year, the company increases the price of all products in one category. For example, the company wants to increase the price (list_price) of products in category 1 by $5. Write a
procedure named update_price_by_cat to update the price of all products in a given category and the given amount to be added to the current price if the price is greater than 0. The
procedure shows the number of updated rows if the update is successful.
The procedure gets two parameters:
• category_id IN NUMBER
• amount NUMBER(9,2)
To define the type of variables that store values of a table’ column, you can also write:
vriable_name table_name.column_name%type;
The above statement defines a variable of the same type as the type of the table’ column.
category_id products.category_id%type;
Or you need to see the table definition to find the type of the category_id column. Make sure
the type of your variable is compatible with the value that is stored in your variable.
To show the number of affected rows the update query, declare a variable named
rows_updated of type NUMBER and use the SQL variable sql%rowcount to set your
variable. Then, print its value in your stored procedure.
Rows_updated := sql%rowcount;
create or replace PROCEDURE update_price_by_cat(p_category_id in products.category_id%TYPE, p_amount in products.list_price%TYPE) AS
v_count number;
begin

select count(category_id) into v_count from products where category_id = p_category_id;

if (p_amount > 0 and v_count > 0) THEN
       update products set LIST_PRICE = LIST_PRICE + p_amount where category_id = p_category_id;
       DBMS_OUTPUT.PUT_LINE('Rows Updated =' || SQL%ROWCOUNT);  
     
   ELSE
DBMS_OUTPUT.PUT_LINE('Either there are no CATEGORY matching or the input price is lesser than zero');  
   end if;


EXCEPTION
  
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('PRODUCTS not found.');   
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Stored PROCEDURE has errors. Please take a look');     
end;


----------
declare
p_category_id number := 1;
p_amount number(9,2) := 5;
begin
update_price_by_cat(p_category_id , p_amount );
end;

-- Q4.Every year, the company increase the price of products whose price is less than the average price of all products by 1%. (list_price * 1.01). Write a stored procedure named
update_price_under_avg. This procedure do not have any parameters. You need to find the average price of all products and store it into a variable of the same type. If the average price
is less than or equal to $1000, update products’ price by 2% if the price of the product is less than the calculated average. If the average price is greater than $1000, update products’ price
by 1% if the price of the product is less than the calculated average. The query displays an error message if any error occurs. Otherwise, it displays the number of updated rows.

create or replace PROCEDURE update_price_under_avg AS
v_avg products.list_price%TYPE;
v_rate number;
begin

select avg(LIST_PRICE) into v_avg from products ;

   if v_avg >= 1000 THEN
       v_rate := 1.02;         
   ELSE
v_rate :=1.01;
   end if;
  
  
   update products set LIST_PRICE = LIST_PRICE * v_rate where LIST_PRICE <= v_avg;
   DBMS_OUTPUT.PUT_LINE('Rows Updated =' || SQL%ROWCOUNT);  


EXCEPTION
  
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('PRODUCTS not found.');   
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Stored PROCEDURE has errors. Please take a look');     
end;
--------------

begin
   update_price_under_avg;
end;

-- Q5. Write a procedure named product_price_report to show the number of products in each price category

CREATE OR REPLACE PROCEDURE product_price_report AS
avg_price NUMBER;
min_price NUMBER;
max_price NUMBER;
cheap_count NUMBER;
fair_count NUMBER;
exp_count NUMBER;

BEGIN

SELECT AVG(list_price), MAX(list_price), MIN(list_price) INTO avg_price, max_price, min_price
FROM products;

SELECT COUNT(list_price) INTO cheap_count
FROM products
WHERE list_price < (avg_price - min_price) / 2;

SELECT COUNT(list_price) INTO exp_count
FROM products
WHERE list_price > (max_price - avg_price) / 2;

SELECT COUNT(list_price) INTO fair_count
FROM products
WHERE list_price >= (avg_price - min_price) / 2 AND list_price <= (max_price - avg_price) / 2;

dbms_output.put_line('Cheap: ' ||cheap_count);
dbms_output.put_line('Fair: ' ||fair_count);
dbms_output.put_line('Expensive: ' ||exp_count);
END;

BEGIN
product_price_report();
END;


















