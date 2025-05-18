# SQL-Data_warehouse-Project

### Story Behind the Project
I come from an agricultural engineering background and moved into data science in 2022. I studied at the University of Canberra, where I took subjects like database systems, exploratory data analysis, statistics, data preparation, and business intelligence. While studying, I often wondered how all these topics worked together in real life.

I wanted to build something that connected everything I had learned and made it all make sense. In 2025 May, I had surgery and had to stay at home for three weeks. I used that time to start this project.

This is the biggest project I’ve worked on so far. It’s different from others I’ve done because it includes creating an ETL process(what I used to wonder what it is), building data models, and more. It helped me understand how everything fits together and gave me a clear picture of how a data warehouse system works.
In this project, I have built a modern data warehouse with SQL server, including ETL processes, data modeling and analytics.
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.
## Data Architecture
The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:
![Data Warehousing](https://github.com/user-attachments/assets/02567ae2-1fa6-41ff-945c-6dc96d00dfb4)
* Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
* Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
*Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.
I am using Mysql Workbench to create this Warehouse.
## Project Overview
This project involves:

#### Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
#### ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
#### Data Modeling: Developing fact and dimension tables optimized for analytical queries.
#### Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

## Resources
I have uploaded the dataset, Notion Project management file for tracking the project progress, and all other files I have created and used in this repository. 

## Project Requirement
### Building the Data Warehouse (Data Engineering)
Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

Specifications
Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.
Data Quality: Cleanse and resolve data quality issues prior to analysis.
Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.
Scope: Focus on the latest dataset only; historization of data is not required.
Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.
### BI: Analytics & Reporting (Data Analysis)
Objective
Develop SQL-based analytics to deliver detailed insights into:
Customer Behavior
Product Performance
Sales Trends
These insights empower stakeholders with key business metrics, enabling strategic decision-making.
