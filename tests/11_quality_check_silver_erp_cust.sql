SELECT * from bronze.erp_cust_az12;
SELECT cst_id FROM silver.crm_cust_info;
---===================1. checking null and duplicates--------===================
SELECT COUNT(*),cid FROM bronze.erp_cust_az12
GROUP BY cid
HAVING COUNT(*)>1 OR cid IS NULL;
-- so we dont have any null or duplicates
--- =====================2. Checking if i have any unwanted spaces============
SELECT TRIM(cid)
FROM bronze.erp_cust_az12
WHERE cid!=TRIM(cid);

-- we dont have any spaces
--===========================checking the join table format-==============
SELECT 
cid,
bdate,
gen
FROM bronze.erp_cust_az12;
-- we are going to join cust_info with cst_id from cust_info and cid from cust_az12 
-- so it is important to go and check they are in same format 
SELECT cst_id
from silver.crm_cust_info;
-- we can see the format are not same we have to get substring
SELECT 
cid,
SUBSTRING(cid,9,len(cid)) as cst_id,
bdate,
gen
FROM bronze.erp_cust_az12;

-- ===================checking birthdate if it has any null
SELECT COUNT(*),bdate
FROM bronze.erp_cust_az12
GROUP BY bdate
HAVING bdate IS NULL

-- another thing we can check with dates is in future
SELECT COUNT(*),bdate
FROM bronze.erp_cust_az12
GROUP BY bdate
HAVING bdate<'1925-05-19' OR bdate>'2025-05-19';

-- so we have data which is older than 100 years and in future as well so we need to clean this

--=====================checking if the gen column have any spaces or other value
SELECT DISTINCT 
  gen,
  CASE 
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN ('M', 'MALE') THEN 'Male'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN ('F', 'FEMALE') THEN 'Female'
    ELSE 'Unknown'
  END AS GEN2
FROM bronze.erp_cust_az12;

--=======================VALIDATING SILVER LAYER AFTER CLEANING DATA-===========
--********************************************************************************

SELECT * from silver.erp_cust_az12;
SELECT cst_id FROM silver.crm_cust_info;
---===================1. checking null and duplicates--------===================
SELECT COUNT(*),cid FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*)>1 OR cid IS NULL;
-- so we dont have any null or duplicates
--- =====================2. Checking if i have any unwanted spaces============
SELECT TRIM(cid)
FROM silver.erp_cust_az12
WHERE cid!=TRIM(cid);

-- we dont have any spaces
--===========================checking the join table format-==============
SELECT 
cid,
bdate,
gen
FROM silver.erp_cust_az12;
-- we are going to join cust_info with cst_id from cust_info and cid from cust_az12 
-- so it is important to go and check they are in same format 
SELECT cst_id
from silver.crm_cust_info;
-- we can see the format are not same we have to get substring
SELECT 
cid,
SUBSTRING(cid,9,len(cid)) as cst_id,
bdate,
gen
FROM silver.erp_cust_az12;

-- ===================checking birthdate if it has any null
SELECT COUNT(*),bdate
FROM silver.erp_cust_az12
GROUP BY bdate
HAVING bdate IS NULL

-- another thing we can check with dates is in future
SELECT COUNT(*),bdate
FROM silver.erp_cust_az12
GROUP BY bdate
HAVING bdate<'1925-05-19' OR bdate>'2025-05-19';

-- so we have data which is older than 100 years and in future as well so we need to clean this

--=====================checking if the gen column have any spaces or other value
SELECT DISTINCT 
  gen,
  CASE 
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN ('M', 'MALE') THEN 'Male'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN ('F', 'FEMALE') THEN 'Female'
    ELSE 'Unknown'
  END AS GEN2
FROM silver.erp_cust_az12;
