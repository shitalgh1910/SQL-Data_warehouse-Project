-- first you go and check bronze layer data and after transformation and inserting you 
-- go back and validate the transformation and cleaning in silver layer as well.
--====================1 checking duplicates Null value
SELECT COUNT(*), pr_id
FROM bronze.crm_prd_info
GROUP BY pr_id
HAVING COUNT(*)>1 OR pr_id IS NULL;
-- we dont have any duplicated or Null
-- lets move on to next column prd_key
SELECT COUNT(*),prd_key
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*)>1 OR prd_key IS NULL;
-- HERE IN PRODUCT KEY WE HAVE FIRST FOUR LETTER CATEGORY ID SO WE CAN SPLIT THIS INTO TWO COLUMNS

SELECT id FROM bronze.erp_px_cat_g1v2;
-- we can see that there is a underscore in category table whereas we have 
-- minus we have to replace it with underscore otherwise we cant join

-- Lets check for unwanted spaces------
-- Expectations: NO result
SELECT TRIM(prd_nm)
from bronze.crm_prd_info
WHERE TRIM(prd_nm)!=prd_nm;

-- check for Nulls or Negative Number in prd_cost
-- Expectations: No result
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost<0 OR prd_cost IS NULL;
-- we have two nulls
-- next we prd_line
-- here we have abbrevations so we go and check try to make it full name for user friendly
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

-- lets check for Invalid date orders

SELECT * FROM bronze.crm_prd_info
WHERE prd_end_dt<prd_start_dt;

-- LETS BUILD FOR ONE TO TWO ROWS AND WE CAN INTEGRATE THE SOLUTION TO WHOLE LOT
SELECT pr_id, prd_key, prd_nm, prd_start_dt,prd_end_dt,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R','AC-HE-HL-U509');


select * from silver.crm_prd_info;
-- =====================+RUNNING QUALITY CHECKS FOR SILVER IF THE DATA HAS TRANSFORMED AND LOADED CORRECTLY

--====================1 checking duplicates Null value
SELECT COUNT(*), pr_id
FROM silver.crm_prd_info
GROUP BY pr_id
HAVING COUNT(*)>1 OR pr_id IS NULL;
-- we dont have any duplicated or Null
-- lets move on to next column prd_key
SELECT COUNT(*),prd_key
FROM silver.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*)>1 OR prd_key IS NULL;
-- HERE IN PRODUCT KEY WE HAVE FIRST FOUR LETTER CATEGORY ID SO WE CAN SPLIT THIS INTO TWO COLUMNS

SELECT id FROM bronze.erp_px_cat_g1v2;
-- we can see that there is a underscore in category table whereas we have 
-- minus we have to replace it with underscore otherwise we cant join

-- Lets check for unwanted spaces------
-- Expectations: NO result
SELECT TRIM(prd_nm)
from silver.crm_prd_info
WHERE TRIM(prd_nm)!=prd_nm;

-- check for Nulls or Negative Number in prd_cost
-- Expectations: No result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost<0 OR prd_cost IS NULL;
-- we have two nulls
-- next we prd_line
-- here we have abbrevations so we go and check try to make it full name for user friendly
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- lets check for Invalid date orders

SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt<prd_start_dt;

-- LETS BUILD FOR ONE TO TWO ROWS AND WE CAN INTEGRATE THE SOLUTION TO WHOLE LOT
SELECT pr_id, prd_key, prd_nm, prd_start_dt,prd_end_dt,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R','AC-HE-HL-U509');