SELECT * FROM bronze.erp_px_cat_g1v2;
/*SELECT COUNT(*),id
FROM bronze.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*)>1 OR id IS NULL;
-- we dont have any duplicate or null*/

-- checking if it matches the 
select pr_id,prd_key,prd_line
FROM silver.crm_prd_info;