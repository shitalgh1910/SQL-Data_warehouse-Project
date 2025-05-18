


--- 1. we can check the unwanted spaces======================
SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num!=TRIM(sls_ord_num);
-- we dont have any unwanted spaces

-- the next two column are the one with which we are going to join other table
-- so we have to make sure that the format in these two table are same
SELECT sls_prd_key
FROM bronze.crm_sales_details
order by sls_prd_key;
SELECT prd_key
FROM silver.crm_prd_info
order by prd_key;
-- as we are connecting the sales table with customer table on cst_id and with product table
-- with prd_id is is very important to check if all the ids in sales table exists in those
-- two tables or not
SELECT sls_ord_num, 
UPPER(TRIM(sls_prd_key)) AS sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
--WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);
-- date cant be zero or negative
-- so lets check if we have any zeros
SELECT sls_order_dt
 FROM bronze.crm_sales_details
 WHERE sls_order_dt<=0;

 -- the date is in 8 integer right so we have to check if we have anything that is more than 8 or 
 -- less than 8
 SELECT LEN(sls_order_dt), sls_order_dt
FROM bronze.crm_sales_details
WHERE LEN(sls_order_dt)!=8
GROUP BY sls_order_dt
;

-- checking for sls_ship_date
 SELECT LEN(sls_ship_dt)
FROM bronze.crm_sales_details
WHERE LEN(sls_ship_dt)!=8
GROUP BY sls_ship_dt
;

-- checking for sls_due_dt
 SELECT LEN(sls_due_dt)
FROM bronze.crm_sales_details
WHERE LEN(sls_due_dt)!=8
GROUP BY sls_due_dt
;


-- lets check if we have any delivered that is order_dt
SELECT * FROM bronze.crm_sales_details
WHERE sls_order_dt>sls_ship_dt OR sls_order_dt>sls_due_dt;
-- so we are all good, we dont have any delivered date that is earlier than order date

-- do you have any negative number in sales
SELECT DISTINCT sls_sales,sls_quantity, sls_price,sls_quantity*sls_price  from bronze.crm_sales_details
WHERE sls_sales!=sls_quantity*sls_price OR sls_sales <=0 OR sls_sales IS NULL 
OR sls_quantity<=0 OR sls_quantity IS NULL OR sls_price<=0 OR sls_price IS NULL 
ORDER BY sls_sales,sls_quantity,sls_price;
-- we can see we have values in negative and zero, negative, and which does not follow the business rules
-- the quality ot sales and price data look bad compared to quantity 
-- looks like the calculation in the source is not working properly.

SELECT DISTINCT sls_sales AS old_sales,sls_quantity, sls_price as old_price,
CASE
WHEN sls_sales<=0 or sls_sales IS NULL OR sls_sales!=sls_quantity*ABS(sls_price) 
    THEN sls_quantity*ABS(sls_price)
    ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE 
WHEN sls_price<=0 OR sls_price IS NULL THEN sls_sales/NULLIF(sls_quantity,0)
ELSE sls_price
END AS sls_price
 from bronze.crm_sales_details
WHERE sls_sales!=sls_quantity*sls_price OR sls_sales <=0 OR sls_sales IS NULL 
OR sls_quantity<=0 OR sls_quantity IS NULL OR sls_price<=0 OR sls_price IS NULL;



----=================now i am inserted the cleaned data into silver layer,
-- ============checking if the right data has been inserted




--- 1. we can check the unwanted spaces======================
SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num!=TRIM(sls_ord_num);
-- we dont have any unwanted spaces

-- the next two column are the one with which we are going to join other table
-- so we have to make sure that the format in these two table are same
SELECT sls_prd_key
FROM silver.crm_sales_details
order by sls_prd_key;
SELECT prd_key
FROM silver.crm_prd_info
order by prd_key;
-- as we are connecting the sales table with customer table on cst_id and with product table
-- with prd_id is is very important to check if all the ids in sales table exists in those
-- two tables or not
SELECT sls_ord_num, 
UPPER(TRIM(sls_prd_key)) AS sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
--WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);
-- date cant be zero or negative
-- so lets check if we have any zeros
SELECT sls_order_dt
 FROM silver.crm_sales_details
 WHERE sls_order_dt<=0;

 -- the date is in 8 integer right so we have to check if we have anything that is more than 8 or 
 -- less than 8
 SELECT LEN(sls_order_dt), sls_order_dt
FROM silver.crm_sales_details
WHERE LEN(sls_order_dt)!=8
GROUP BY sls_order_dt
;

-- checking for sls_ship_date
 SELECT LEN(sls_ship_dt)
FROM silver.crm_sales_details
WHERE LEN(sls_ship_dt)!=8
GROUP BY sls_ship_dt
;

-- checking for sls_due_dt
 SELECT LEN(sls_due_dt)
FROM silver.crm_sales_details
WHERE LEN(sls_due_dt)!=8
GROUP BY sls_due_dt
;


-- lets check if we have any delivered that is order_dt
SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt>sls_ship_dt OR sls_order_dt>sls_due_dt;
-- so we are all good, we dont have any delivered date that is earlier than order date

-- do you have any negative number in sales
SELECT DISTINCT sls_sales,sls_quantity, sls_price,sls_quantity*sls_price  from silver.crm_sales_details
WHERE sls_sales!=sls_quantity*sls_price OR sls_sales <=0 OR sls_sales IS NULL 
OR sls_quantity<=0 OR sls_quantity IS NULL OR sls_price<=0 OR sls_price IS NULL 
ORDER BY sls_sales,sls_quantity,sls_price;
-- we can see we have values in negative and zero, negative, and which does not follow the business rules
-- the quality ot sales and price data look bad compared to quantity 
-- looks like the calculation in the source is not working properly.

SELECT DISTINCT sls_sales AS old_sales,sls_quantity, sls_price as old_price,
CASE
WHEN sls_sales<=0 or sls_sales IS NULL OR sls_sales!=sls_quantity*ABS(sls_price) 
    THEN sls_quantity*ABS(sls_price)
    ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE 
WHEN sls_price<=0 OR sls_price IS NULL THEN sls_sales/NULLIF(sls_quantity,0)
ELSE sls_price
END AS sls_price
 from silver.crm_sales_details
WHERE sls_sales!=sls_quantity*sls_price OR sls_sales <=0 OR sls_sales IS NULL 
OR sls_quantity<=0 OR sls_quantity IS NULL OR sls_price<=0 OR sls_price IS NULL;



---======= SO IT LOOKS LIKE EVERYTHING IN CLEAN NOW-----------------------
SELECT * FROM silver.crm_sales_details;