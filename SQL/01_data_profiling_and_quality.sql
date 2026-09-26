SELECT
    COUNT(*) AS total_rows,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    COUNT(DISTINCT invoice_and_item_number) AS distinct_invoice_items,
    COUNT(DISTINCT store_number) AS distinct_stores,
    COUNT(DISTINCT item_number) AS distinct_products,
    COUNT(DISTINCT category) AS distinct_categories,
    COUNT(DISTINCT vendor_number) AS distinct_vendors,
    COUNT(DISTINCT county) AS distinct_counties
FROM `bigquery-public-data.iowa_liquor_sales.sales`;

-- =========================================================


/*
Project: Iowa Retail Sales & Market Opportunity Analysis
Query: 02 - Annual Data Coverage
Purpose: Evaluate yearly record volume, store coverage,
         product coverage, sales value and bottles sold
Source: bigquery-public-data.iowa_liquor_sales.sales
*/

SELECT
    EXTRACT(YEAR FROM date) AS sales_year,
    COUNT(*) AS row_count,
    COUNT(DISTINCT store_number) AS active_stores,
    COUNT(DISTINCT item_number) AS active_products,
    ROUND(SUM(sale_dollars), 2) AS total_sales_dollars,
    SUM(bottles_sold) AS total_bottles_sold
FROM `bigquery-public-data.iowa_liquor_sales.sales`
GROUP BY sales_year
ORDER BY sales_year;


-- =========================================================


/*
Project: Iowa Retail Sales & Market Opportunity Analysis
Query: 04 - Schema Inventory
Purpose: Document column names, data types, nullability
         and source-column order
Source: BigQuery INFORMATION_SCHEMA
*/

SELECT
    ordinal_position,
    column_name,
    data_type,
    is_nullable
FROM `bigquery-public-data.iowa_liquor_sales.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'sales'
ORDER BY ordinal_position;


-- =========================================================


/*
Project: Iowa Retail Sales & Market Opportunity Analysis
Query: 05 - Critical Fields Completeness
Purpose: Check missing values in the fields required for analysis
*/

SELECT
    COUNT(*) AS total_rows,

    COUNTIF(
        invoice_and_item_number IS NULL
        OR TRIM(invoice_and_item_number) = ''
    ) AS missing_invoice_items,

    COUNTIF(
        store_number IS NULL
        OR TRIM(store_number) = ''
    ) AS missing_store_numbers,

    COUNTIF(
        item_number IS NULL
        OR TRIM(item_number) = ''
    ) AS missing_item_numbers,

    COUNTIF(
        category IS NULL
        OR TRIM(category) = ''
    ) AS missing_categories,

    COUNTIF(
        vendor_number IS NULL
        OR TRIM(vendor_number) = ''
    ) AS missing_vendor_numbers,

    COUNTIF(bottles_sold IS NULL)
        AS missing_bottles_sold,

    COUNTIF(sale_dollars IS NULL)
        AS missing_sale_dollars

FROM `bigquery-public-data.iowa_liquor_sales.sales`

WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31';


-- =========================================================


/*
Query: 06 - Missing Vendor Records
Purpose: Inspect records with missing vendor numbers
*/

SELECT
    date,
    invoice_and_item_number,
    item_number,
    item_description,
    vendor_number,
    vendor_name
FROM `bigquery-public-data.iowa_liquor_sales.sales`
WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31'
  AND (
      vendor_number IS NULL
      OR TRIM(vendor_number) = ''
  )
ORDER BY
    date,
    invoice_and_item_number;


-- =========================================================


/*
Query: 07 - Zero and Negative Values
Purpose: Identify potentially invalid sales and quantity values
*/

SELECT
    COUNT(*) AS total_rows,

    COUNTIF(bottles_sold = 0)
        AS zero_bottles_sold,

    COUNTIF(bottles_sold < 0)
        AS negative_bottles_sold,

    COUNTIF(sale_dollars = 0)
        AS zero_sales_dollars,

    COUNTIF(sale_dollars < 0)
        AS negative_sales_dollars

FROM `bigquery-public-data.iowa_liquor_sales.sales`

WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31';


-- =========================================================



/*
Query: 08 - Negative Value Consistency
Purpose: Confirm whether negative quantities and
         negative sales occur together
*/

SELECT
    COUNTIF(
        bottles_sold < 0
        AND sale_dollars < 0
    ) AS both_values_negative,

    COUNTIF(
        bottles_sold < 0
        AND sale_dollars >= 0
    ) AS only_bottles_negative,

    COUNTIF(
        bottles_sold >= 0
        AND sale_dollars < 0
    ) AS only_sales_negative

FROM `bigquery-public-data.iowa_liquor_sales.sales`

WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31';


-- =========================================================


/*
Query: 09 - Descriptive Fields Completeness
Purpose: Check missing values in important descriptive
         and location fields
*/

SELECT
    COUNT(*) AS total_rows,

    COUNTIF(store_name IS NULL)
        AS missing_store_names,

    COUNTIF(address IS NULL)
        AS missing_addresses,

    COUNTIF(city IS NULL)
        AS missing_cities,

    COUNTIF(zip_code IS NULL)
        AS missing_zip_codes,

    COUNTIF(county IS NULL)
        AS missing_counties,

    COUNTIF(category_name IS NULL)
        AS missing_category_names,

    COUNTIF(vendor_name IS NULL)
        AS missing_vendor_names,

    COUNTIF(item_description IS NULL)
        AS missing_item_descriptions,

    COUNTIF(store_location IS NULL)
        AS missing_store_locations

FROM `bigquery-public-data.iowa_liquor_sales.sales`

WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31';


-- =========================================================


/*
Query: 10 - Numeric Fields Completeness
Purpose: Check missing values in pricing,
         packaging and volume fields
*/

SELECT
    COUNT(*) AS total_rows,

    COUNTIF(pack IS NULL)
        AS missing_pack,

    COUNTIF(bottle_volume_ml IS NULL)
        AS missing_bottle_volume,

    COUNTIF(state_bottle_cost IS NULL)
        AS missing_bottle_cost,

    COUNTIF(state_bottle_retail IS NULL)
        AS missing_bottle_retail,

    COUNTIF(volume_sold_liters IS NULL)
        AS missing_volume_liters,

    COUNTIF(volume_sold_gallons IS NULL)
        AS missing_volume_gallons

FROM `bigquery-public-data.iowa_liquor_sales.sales`

WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31';


-- =========================================================


/*
Query: 11 - Pricing and Packaging Validity
Purpose: Check for invalid zero or negative values
         in packaging and pricing fields
*/

SELECT
    COUNT(*) AS total_rows,

    COUNTIF(pack <= 0)
        AS invalid_pack_values,

    COUNTIF(bottle_volume_ml <= 0)
        AS invalid_bottle_volume,

    COUNTIF(state_bottle_cost <= 0)
        AS invalid_bottle_cost,

    COUNTIF(state_bottle_retail <= 0)
        AS invalid_bottle_retail

FROM `bigquery-public-data.iowa_liquor_sales.sales`

WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31';


-- =========================================================


/*
Query: 12 - Invalid Retail Price Breakdown
Purpose: Separate zero retail prices from negative retail prices
*/

SELECT
    COUNTIF(state_bottle_retail = 0)
        AS zero_retail_prices,

    COUNTIF(state_bottle_retail < 0)
        AS negative_retail_prices

FROM `bigquery-public-data.iowa_liquor_sales.sales`

WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31';


-- =========================================================