-- =========================================================
-- Query 14: Validate Analysis View
-- =========================================================


/*
Query: 13 - Create Analysis View
Purpose: Create a reusable view containing the selected
         period and required analytical columns
*/

CREATE OR REPLACE VIEW
`portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`
AS

SELECT
    invoice_and_item_number,
    date,
    store_number,
    store_name,
    city,
    zip_code,
    county_number,
    county,
    category,
    category_name,
    vendor_number,
    vendor_name,
    item_number,
    item_description,
    pack,
    bottle_volume_ml,
    state_bottle_cost,
    state_bottle_retail,
    bottles_sold,
    sale_dollars,
    volume_sold_liters

FROM `bigquery-public-data.iowa_liquor_sales.sales`

WHERE date BETWEEN DATE '2021-01-01' AND DATE '2025-12-31';


-- =========================================================
-- Query 14: Validate Analysis View
-- =========================================================

/*
Query: 14 - Validate Analysis View
Purpose: Confirm that the view contains the expected
         number of rows and correct date range
*/

SELECT
    COUNT(*) AS total_rows,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date

FROM
`portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`;