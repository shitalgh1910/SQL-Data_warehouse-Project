USE DataWarehouse;
-- The first step in cleaning your dataset is checking if you have duplicate primary key
-- and any null values in primary key
-- ============1. Checking NULL and Duplicate primary key================================
SELECT COUNT(*) AS count_of_primary_key, cst_id
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;
-- =============2. Checking Unwanted Spaces================================================
-- If we check our data there are alot of unwanted spaces in our data. 
-- lets try to clean the spaces
-- expecation is NO RESULT.
SELECT cst_firstname FROM silver.crm_cust_info
WHERE cst_firstname!=TRIM(cst_firstname);
-- we can see spaces but looking one by one and trying to figure out is not possible
-- speacially when it is at the end, we dont know right? lets use the filter

-- we can see there are 15 name that has spaces in them.
-- we will use TRIM() to get the name as non spaced 

--=============3.CHECKING CONSISTENCY IN LOW CARDINALITY COLUMNS: DATA STANDARDIZATION AND CONSISTENCY============
SELECT DISTINCT cst_gndr, COUNT(*)
FROM 
silver.crm_cust_info
GROUP BY cst_gndr;-- CHECKING THE COUNT AND GROUPING BY cst_gndr
-- we can see we either have F or M or NULL BUT WE DON'T KNOW HOW MANY ARE NULL SO WE NEED TO CHECK THE COUNT AS WELL

-- 
SELECT * FROM silver.crm_cust_info;
-- we can see the data in silver layer is all good. 

