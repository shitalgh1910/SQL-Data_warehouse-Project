Gold Layer Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.
1. gold.dim_customers
* Purpose: Stores customer details enriched with demographic and geographic data.
| Column Name       | Data Type      | Description                                                               |
| ----------------- | -------------- | ------------------------------------------------------------------------- |
| `customer_key`    | `INT`          | Surrogate key uniquely identifying each customer record in the dimension. |
| `customer_id`     | `INT`          | Unique numerical identifier assigned to each customer.                    |
| `customer_number` | `NVARCHAR(50)` | Alphanumeric identifier representing the customer for tracking/reference. |
| `first_name`      | `NVARCHAR(50)` | The customer's first name.                                                |
| `last_name`       | `NVARCHAR(50)` | The customer's last or family name.                                       |
| `country`         | `NVARCHAR(50)` | Country of residence (e.g., 'Australia').                                 |
| `marital_status`  | `NVARCHAR(50)` | Marital status (e.g., 'Married', 'Single').                               |
| `gender`          | `NVARCHAR(50)` | Gender of the customer (e.g., 'Male', 'Female', 'n/a').                   |
| `birthdate`       | `DATE`         | Date of birth (YYYY-MM-DD).                                               |
| `create_date`     | `DATE`         | Date the customer record was created.                                     |

2. gold.dim_products
* Purpose: Provides information about the products and their attributes.
| Column Name            | Data Type      | Description                                               |
| ---------------------- | -------------- | --------------------------------------------------------- |
| `product_key`          | `INT`          | Surrogate key uniquely identifying each product record.   |
| `product_id`           | `INT`          | Unique identifier for the product.                        |
| `product_number`       | `NVARCHAR(50)` | Alphanumeric product code.                                |
| `product_name`         | `NVARCHAR(50)` | Descriptive product name.                                 |
| `category_id`          | `NVARCHAR(50)` | Identifier for the product's category.                    |
| `category`             | `NVARCHAR(50)` | Broad classification (e.g., Bikes, Components).           |
| `subcategory`          | `NVARCHAR(50)` | More detailed classification within category.             |
| `maintenance_required` | `NVARCHAR(50)` | Indicates if maintenance is required (e.g., 'Yes', 'No'). |
| `cost`                 | `INT`          | Base price of the product.                                |
| `product_line`         | `NVARCHAR(50)` | Product line or series (e.g., Road, Mountain).            |
| `start_date`           | `DATE`         | Product availability start date.                          |
3. gold.fact_sales
* Purpose: Stores transactional sales data for analytical purposes.
| Column Name     | Data Type      | Description                                          |
| --------------- | -------------- | ---------------------------------------------------- |
| `order_number`  | `NVARCHAR(50)` | Unique alphanumeric identifier for each sales order. |
| `product_key`   | `INT`          | Foreign key linking to `dim_products`.               |
| `customer_key`  | `INT`          | Foreign key linking to `dim_customers`.              |
| `order_date`    | `DATE`         | Date when the order was placed.                      |
| `shipping_date` | `DATE`         | Date the order was shipped.                          |
| `due_date`      | `DATE`         | Payment due date for the order.                      |
| `sales_amount`  | `INT`          | Total sale amount for the line item.                 |
| `quantity`      | `INT`          | Number of product units ordered.                     |
| `price`         | `INT`          | Price per unit of the product.                       |

