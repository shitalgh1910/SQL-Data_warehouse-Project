--========checking for bronze layer data=========
--==========checking null or duplicate values
SELECT count(*),cid
FROM bronze.erp_loc_a101
GROUP BY cid
HAVING count(*)>1 OR cid IS NULL;

SELECT * FROM 
bronze.erp_loc_a101;
SELECT cst_id,cst_key
FROM silver.crm_cust_info;
-- NOW WE CAN SEE THAT WE ARE FOING TO JOINING TWO TABLES ON CST_ID
SELECT REPLACE(cid,'-','') cid FROM bronze.erp_loc_a101;
select cst_key from silver.crm_cust_info;

-- DATA CONSISTENCY AND STANDARDISATION
SELECT DISTINCT cntry,
CASE 
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('USA', 'US','UNITEDSTATES') THEN 'United States'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
         ('UNITEDKINGDOM') THEN 'United Kingdom'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('FRANCE') THEN 'France'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('DE', 'GERMANY') THEN 'Germany'
     WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('AUSTRALIA') THEN 'Australia'
     WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('CANADA') THEN 'Canada'
    ELSE 'Other'
END AS cntry
FROM bronze.erp_loc_a101;
select * from 
bronze.erp_loc_a101
where TRIM(cntry)!=cntry;

---=========***************************check in silver table

--==========checking null or duplicate values
SELECT count(*),cid
FROM silver.erp_loc_a101
GROUP BY cid
HAVING count(*)>1 OR cid IS NULL;

SELECT * FROM 
silver.erp_loc_a101;
SELECT cst_id,cst_key
FROM silver.crm_cust_info;
-- NOW WE CAN SEE THAT WE ARE FOING TO JOINING TWO TABLES ON CST_ID
SELECT REPLACE(cid,'-','') cid FROM silver.erp_loc_a101;
select cst_key from silver.crm_cust_info;

-- DATA CONSISTENCY AND STANDARDISATION
SELECT DISTINCT cntry,
CASE 
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('USA', 'US','UNITEDSTATES') THEN 'United States'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
         ('UNITEDKINGDOM') THEN 'United Kingdom'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('FRANCE') THEN 'France'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('DE', 'GERMANY') THEN 'Germany'
     WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('AUSTRALIA') THEN 'Australia'
     WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN 
        ('CANADA') THEN 'Canada'
    ELSE 'Other'
END AS cntry
FROM silver.erp_loc_a101;
select * from 
silver.erp_loc_a101;

