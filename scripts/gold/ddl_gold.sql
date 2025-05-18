/*DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.*/
CREATE VIEW gold.dim_customers AS 
    SELECT 
    ROW_NUMBER() OVER(ORDER BY  cst_id ) AS customer_key,
    ci.cst_id AS customer_id, 
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    lo.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr!='unknown' THEN ci.cst_gndr -- as crm is the master for gender
    ELSE COALESCE(ca.gen,'unknown')
    END AS gender,
    ci.cst_create_date AS create_date,
    ca.bdate
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key=ca.cid
    LEFT JOIN silver.erp_loc_a101 lo
    ON ci.cst_key=lo.cid
-- it is important to check that there are no duplicates after you joining the table
-- YOU CAN CHECK AS FOLLOW
/*Select count(*),
cst_id 
from (
    SELECT 
    ci.cst_id, 
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    ci.cst_marital_status,
    ci.cst_gndr,
    ci.cst_create_date,
    ca.bdate,
    ca.gen,
    lo.cntry
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key=ca.cid
    LEFT JOIN silver.erp_loc_a101 lo
    ON ci.cst_key=lo.cid ) T
    GROUP BY cst_id
    HAVING count(*)>1;*/
-- NOW WE CAN SEE THAT THERE ARE TWO COLUMNS FOR GENDER
-- YOU GO AND REMOVE ALL AND GET DISTICS AND CHECK AGAIN

    /*SELECT  DIStinct
    ci.cst_id,
    ci.cst_gndr,
    ca.gen,
    CASE WHEN ci.cst_gndr!='unknown' THEN ci.cst_gndr -- as crm is the master for gender
    ELSE COALESCE(ca.gen,'unknown')
    END AS new_gen
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key=ca.cid
    LEFT JOIN silver.erp_loc_a101 lo
    ON ci.cst_key=lo.cid
    WHERE cst_gndr!=gen;
    -- HERE WE ARE CHECKING IF THE BOTH THE TABLE ARE GIVING SAME VALUE

    select distinct gender FROM gold.dim_customers;*/


=======================================================================================
CREATE VIEW gold.dim_products AS 
SELECT 
ROW_NUMBER() OVER(ORDER BY pr.prd_start_dt,pr.prd_key) AS product_key,
pr.pr_id AS product_id,
pr.prd_key AS product_number,
 pr.prd_nm AS product_name,
pr.prd_line AS product_line,
pr.cat_id AS category_id,
ca.cat AS category,
ca.subcat AS subcategory,
ca.maintenance,
pr.prd_cost AS product_cost,
pr.prd_start_dt AS product_start_date,
pr.prd_end_dt AS product_end_date
 
FROM 
silver.crm_prd_info as pr
LEFT JOIN silver.erp_px_cat_g1v2 ca
ON pr.cat_id=ca.id
WHERE prd_end_dt IS NULL;
-- checking duplicates

--select * from gold.dim_products;-- you can execute 
============================================================================
CREATE VIEW gold.dim_products AS 
SELECT 
ROW_NUMBER() OVER(ORDER BY pr.prd_start_dt,pr.prd_key) AS product_key,
pr.pr_id AS product_id,
pr.prd_key AS product_number,
 pr.prd_nm AS product_name,
pr.prd_line AS product_line,
pr.cat_id AS category_id,
ca.cat AS category,
ca.subcat AS subcategory,
ca.maintenance,
pr.prd_cost AS product_cost,
pr.prd_start_dt AS product_start_date,
pr.prd_end_dt AS product_end_date
 
FROM 
silver.crm_prd_info as pr
LEFT JOIN silver.erp_px_cat_g1v2 ca
ON pr.cat_id=ca.id
WHERE prd_end_dt IS NULL;
-- checking duplicates

--select * from gold.dim_products;-- you can execute 
