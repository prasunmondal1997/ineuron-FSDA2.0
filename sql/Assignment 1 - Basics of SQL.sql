use database DEMO_DATABASE;
use schema public;

-- ***************************  Question 1 ************************************
-- ----------------------------------------------------------------------------
-- Create 'PM SALES Table'
CREATE or replace table PM_SALES
(    
    order_id VARCHAR2(100),
    order_date STRING PRIMARY KEY,
    ship_date STRING,
    ship_mode VARCHAR2(100),
    customer_name VARCHAR2(100),
    segment VARCHAR2(100),
    state VARCHAR2(100),
    country VARCHAR2(100),
    market VARCHAR(100),
    region VARCHAR(100),
    product_id VARCHAR2(100),
    category VARCHAR2(100),
    sub_category VARCHAR2(100),
    product_name String,
    sales NUMBER(12,2),
    quantity NUMBER(12,2),
    discount NUMBER(12,2),
    profit NUMBER(12,3),
    shipping_cost NUMBER(12,3),
    order_priority VARCHAR(50),
    year NUMBER(10,2)
);

-- Loading table
-- The sales_data_final.csv (input file) has a column 'product_name', which already contains a ',' in its string. This command is been replaced with '-' in excel as a data cleaning process

-- View table
Select * From PM_SALES;

-- Describe the table column properties
Describe Table PM_SALES;


-- ***************************  Question 2 ************************************
-- ----------------------------------------------------------------------------

-- Change the primary key to ORDER_ID column
Alter Table PM_SALES DROP PRIMARY KEY;
Alter Table PM_SALES ADD PRIMARY KEY(ORDER_ID);


-- ***************************  Question 3 ************************************
-- ----------------------------------------------------------------------------
/*
To load the table into Snowflake the 'ORDER_DATE' and 'SHIP_DATE' columns are defined as strings.
The default data types is VARCHAR(16777216) for these two columns.
But to run any date operation the data type shall be changed to DATE.
Using TO_DATE function, creating two additonal columns named ORDER_DATE_FORMATTED and SHIP_DATE_FORMATTED in a new table called 'PM_SALES_FORMATTED'.
*/

Create or Replace table PM_SALES_FORMATTED As
Select *,
    TO_DATE(REPLACE(ORDER_DATE,'-','/'), 'MM/dd/yyyy') as ORDER_DATE_FORMATTED,
    TO_DATE(REPLACE(SHIP_DATE,'-','/'), 'MM/dd/yyyy') as SHIP_DATE_FORMATTED
From PM_SALES;

Select * From PM_SALES_FORMATTED;


-- ***************************  Question 4 ************************************
-- ----------------------------------------------------------------------------

-- A new column called ORDER_EXTRACT is been created from ORDER ID column by extracting the number after last '-'
Create or Replace table PM_SALES_FORMATTED As
Select *,
    Substring(ORDER_ID, 9) as ORDER_EXTRACT
From PM_SALES_FORMATTED;

Select * From PM_SALES_FORMATTED;
Describe Table PM_SALES_FORMATTED;


-- ***************************  Question 5 ************************************
-- ----------------------------------------------------------------------------

-- Column DISCOUNT_FLAG is created based on DISCOUNT COLUMN
Create or Replace table PM_SALES_FORMATTED As
Select *,
    Case
        When DISCOUNT > 0 Then 'Yes'
        Else 'No'
    End As DISCOUNT_FLAG
From PM_SALES_FORMATTED;

Select * From PM_SALES_FORMATTED;


-- ***************************  Question 6 ************************************
-- ----------------------------------------------------------------------------

-- Column PROCESS_DAYS is created by substracting order date from ship date
Create or Replace table PM_SALES_FORMATTED As
Select *,
    Datediff('Days', ORDER_DATE_FORMATTED, SHIP_DATE_FORMATTED) As PROCESS_DAYS
From PM_SALES_FORMATTED;

Select * From PM_SALES_FORMATTED;


-- ***************************  Question 7 ************************************
-- ----------------------------------------------------------------------------

-- RATING column is produced based on PROCESS_DAYS data
Create or Replace table PM_SALES_FORMATTED As
Select *,
        Case
            When PROCESS_DAYS <=3 Then '5'
            When PROCESS_DAYS >3 AND PROCESS_DAYS <=6 Then '4'
            When PROCESS_DAYS >6 AND PROCESS_DAYS <=10 Then '3'
            When PROCESS_DAYS >10 Then '2'
        End As RATING
From PM_SALES_FORMATTED;

Select * From PM_SALES_FORMATTED;

-- ************************* - End of Assignment 1 - **************************










