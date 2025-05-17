/* IN THIS I HAVE CREATED THE DATABASE NAMED DATAWAREHOUSE AFTER CHECKING IF IT ALREADY EXISTS. 
IF IT EXISTS, THEN IT IS DROPPED, AND RECREATED. ADDITIONALLY I AM SETTING UP THREE SCHEMAS WITHIN THE DATABASE
*/
USE master;
GO
-- DROPING AND CREATING A DATABASE
IF EXISTS(SELECT 1 FROM sys.databases WHERE name='DataWarehouse')
BEGIN 
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO
-- Now creating
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO
/* The first step after creating the database is creating a schema
*/
CREATE SCHEMA bronze;
Go -- This is a seperator this tells mysql that go to another only after executing this command.
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;

