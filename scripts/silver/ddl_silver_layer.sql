/* This script creating tables to insert the data from bronze layer to silver layer*/

/* As we will not be doing any data modeling in our silver layer it will be very easy to create DDL for this layer 
copy the code from bronze layer and change the name from bronze to silver*/
/*-- Later you might have to come and change the datatypes if you do some data cleaning.
  I have changed few datatype as i cleaned the data before inserting 
  and it has to match the datatype of the table in order to work.*/

-- lets check if it exists already or not
-- we can build a t-sql logic to do this

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- CREATING AN EXTRATABLE FOR MORE INFORMATION 
);
GO
-- Now go and check prd_info and create table for that one
IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
    pr_id INT,
    cat_id NVARCHAR(50),
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE ,
    prd_end_dt DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- CREATING AN EXTRATABLE FOR MORE INFORMATION 

);

-- CREATING DDL FOR SALES_DETAILS FILE
GO
IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- CREATING AN EXTRATABLE FOR MORE INFORMATION 

);

-- Now go to erp file and create tables for those files
-- remember to use exactly the sale name
GO
IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12(
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(20),
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- CREATING AN EXTRATABLE FOR MORE INFORMATION 

);
GO
IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101(
    cid NVARCHAR(50),
    cntry NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- CREATING AN EXTRATABLE FOR MORE INFORMATION 

);
GO
IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR (50),
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- CREATING AN EXTRATABLE FOR MORE INFORMATION 

);
