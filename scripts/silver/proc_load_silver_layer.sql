/* This is the masters file for stored procedure, i have broken down codes of each tables, with quality check and transformation, but we need to make this 
in order to make a stored procedure as a whole so that we can load the data from bronze and upload it to our silver layer for further analysis*/

CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
    SET @batch_start_time=GETDATE();
    SET @start_time=GETDATE();
    --================================crm_cust_info_************************************************
    PRINT('--================================crm_cust_info************************************************');
    PRINT'================================================'
    PRINT'>> TRUNCATING TABLE silver.crm_cust_info'
    TRUNCATE TABLE silver.crm_cust_info;
    PRINT'================================================'
    PRINT'>>>> Inserting data into silver.crm_cust_info'
    -- HERE WE WILL WRITE QUERY TO CLEAN AND TRANSFORM THE DATA
    INSERT INTO silver.crm_cust_info(cst_id, 
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status, 
    cst_gndr,
    cst_create_date)
    SELECT 
    cst_id, 
    cst_key,
    TRIM(cst_firstname) AS cst_firstname
    ,TRIM(cst_lastname) AS cst_lastname,
    CASE
        WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married' -- This is called data normalisation or data standardisation
        WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
        ELSE 'unknown'
    END AS cst_marital_status-- Normalise maritial status values to readable format
    ,CASE 
        WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'-- USING UPPER JUST TO MAKE SURE IF IN FUTURE SOMEONE ENTERS LOWER CASE VALUE
        WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'-- USING TRIM INCASE WE GET GENDER DATA WITH SPACE
        ELSE 'unknown' 
    END AS cst_gndr,-- Normalised gender status values to readable format
    cst_create_date
    FROM (
    SELECT *,
    ROW_NUMBER()OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_list 
    FROM bronze.crm_cust_info)
    t
    WHERE flag_list=1;
    SET @end_time=GETDATE();
        Print('-----------------------------------');
        PRINT'>>>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'Seconds';
        Print('-----------------------------------');

    -- HERE WE HAVE THE DETAILS OF THE CUSTOMER 3 TIME WHERE ONLY ONCE ALL THE DETAILS ARE AVAILABLE
    -- AND IF WE CHECK THE DATE CREATED THE LATEST ONE IS THE MOST ACCURATE AS IN IT HAS ALL THE DETAILS
    -- HERE WE CAN USE RANK FUNCTION TO PICK THE LATEST VALUE
    SET @start_time=GETDATE();
    --================================CRM_PRD_INFO_************************************************
    PRINT('--================================CRM_PRD_INFO_************************************************');
    PRINT'================================================'
    PRINT'>> TRUNCATING TABLE silver.crm_prd_info'
    TRUNCATE TABLE silver.crm_prd_info;
    PRINT'================================================'
    PRINT'>>>> Inserting data into silver.crm_prd_info'
    INSERT INTO silver.crm_prd_info(
        pr_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT pr_id,
    REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,-- extracting category id/splitting the columns
    SUBSTRING(prd_key, 7,LEN(prd_key)) AS prd_key, -- extracting pr_key spliiting the columns
    prd_nm,
    ISNULL (prd_cost,0) AS prd_cost, -- handing missing value
    CASE UPPER(TRIM(prd_line))-- normalising the date, instead of code value we have user friendly value
    WHEN  'M'THEN 'mountain'
    WHEN 'R'THEN 'road'
    WHEN 'S'THEN 'other sales'
    WHEN 'T'THEN 'Touring'
    ELSE 'N/A'-- handdle missing value
    END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt, -- data type casting 
    CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt 
    FROM bronze.crm_prd_info;
     SET @end_time=GETDATE();
        Print('-----------------------------------');
        PRINT'>>>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'Seconds';
        Print('-----------------------------------');
    --WHERE REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') NOT IN 
    --(SELECT id FROM bronze.erp_px_cat_g1v2);
    -- NOW WHEN YOU CAN AND CHECK YOUR SILVER DDL YOU DONT HAVE FEW COLUMNS THAT YOU CREATED 
    -- HERE SO YOU GO BACK AND ADD THESE COLUMNS OKAY GUYS
    -- LETS DO THAT
  
    --================================crm_sales_details************************************************'
    SET @start_time=GETDATE();
    PRINT('--================================crm_sales_details************************************************');
    PRINT'================================================'
    PRINT'>> TRUNCATING TABLE silver.crm_sales_details'
    TRUNCATE TABLE silver.crm_sales_details;
    PRINT'================================================'
    PRINT'>>>> Inserting data into silver.crm_sales_details'
    INSERT INTO silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
    )
    SELECT sls_ord_num, 
    sls_prd_key,
    sls_cust_id,
    CASE
        WHEN sls_order_dt=0 OR LEN(sls_order_dt)!=8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
    END AS sls_order_dt,
    -- we you can write case condition just for sls_order_dt but just incase in future
    -- if someone enters a random date then you cant have it in your table
    -- so write the logic for all the dates
    CASE
        WHEN sls_ship_dt=0 OR LEN(sls_ship_dt)!=8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
    END AS sls_ship_dt,
    CASE
        WHEN sls_due_dt=0 OR LEN(sls_due_dt)!=8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
    END AS sls_due_dt,
    -- one more check, the order date must always be earlier than the shipping date or due date
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
    FROM bronze.crm_sales_details;
     SET @end_time=GETDATE();
        Print('-----------------------------------');
        PRINT'>>>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'Seconds';
        Print('-----------------------------------');

    --================================erp_cust_az12s************************************************'
    PRINT('--================================erp_cust_az12************************************************');
    SET @start_time=GETDATE();
    PRINT'================================================'
    PRINT'>> TRUNCATING TABLE silver.erp_cust_az12'
    TRUNCATE TABLE silver.erp_cust_az12;
    PRINT'================================================'
    PRINT'>>>> Inserting data into silver.erp_cust_az12'
    INSERT INTO silver.erp_cust_az12(
        cid,
        bdate,
        gen
    )
    SELECT 
    CASE 
        WHEN cid LIKE 'NAS% ' 
        THEN SUBSTRING(cid,4,len(cid)) -- removed NAS prefix if present
    ELSE cid
    END cid,
    CASE WHEN bdate>GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,-- set future birthdates to NUll
    CASE 
        WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'Unknown'
    END AS gen-- normalising gender values and handle unknown cases
    FROM bronze.erp_cust_az12;
     SET @end_time=GETDATE();
        Print('-----------------------------------');
        PRINT'>>>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'Seconds';
        Print('-----------------------------------');
    -- we are going to join cust_info with cst_id from cust_info and cid from cust_az12 
    -- so it is important to go and check they are in same format 
    --================================erp_loc_a101************************************************'
    SET @start_time=GETDATE();
    PRINT('--================================erp_loc_a101************************************************');
    PRINT'================================================'
    PRINT'>> TRUNCATING TABLE silver.erp_loc_a101'
    TRUNCATE TABLE silver.erp_loc_a101;
    PRINT'================================================'
    PRINT'>>>> Inserting data into silver.erp_loc_a101'
    INSERT INTO silver.erp_loc_a101(
    cid,
    cntry
    )
    SELECT 
    REPLACE(cid,'-','') AS cid ,--handled invalid value
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
     SET @end_time=GETDATE();
        Print('-----------------------------------');
        PRINT'>>>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'Seconds';
        Print('-----------------------------------');
    --================================px_cat_g1v2************************************************'
    SET @start_time=GETDATE();
    PRINT('--================================px_cat_g1v2************************************************');
    PRINT'================================================'
    PRINT'>> TRUNCATING TABLE silver.erp_px_cat_g1v2'
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    PRINT'================================================'
    PRINT'>>>> Inserting data into silver.erp_px_cat_g1v2'
    INSERT INTO silver.erp_px_cat_g1v2(
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT id,
    cat,
    subcat,
    CASE
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(maintenance), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN ('YES','Y') THEN 'Yes'
    WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(maintenance), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ' ', '')) IN ('NO','N') THEN 'No'
    ELSE maintenance
    END AS maintenance
    FROM bronze.erp_px_cat_g1v2;
     SET @end_time=GETDATE();
        Print('-----------------------------------');
        PRINT'>>>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'Seconds';
        Print('-----------------------------------');
    SET @batch_end_time=GETDATE();
    PRINT'TOTAL LOAD DURATION:' +CAST(DATEDIFF(SECOND, @batch_start_time,@batch_end_time) AS NVARCHAR) +'Seconds';
    END TRY
    BEGIN CATCH -- WE HAVE TO SPECIFY WHAT SHOULD SQL DO INCASE OF ERROR
        PRINT'============'
        PRINT'ERRO OCCURED DURING LOADING BRONZE LAYER';-- WE CAN PRINT THE ERROR MESSAGE
        PRINT'ERROR MESSAGE' + ERROR_MESSAGE(); --  SAME
        PRINT'ERROR MESSAGE'+CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT'ERROR MESSAGE'+CAST(ERROR_STATE() AS NVARCHAR);
    END CATCH
END

EXEC silver.load_silver
