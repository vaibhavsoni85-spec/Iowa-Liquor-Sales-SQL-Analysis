-- =========================================================
-- Query 15: Annual Sales Performance
-- Purpose: Summarize annual sales, bottles sold, volume,
--          active stores, and active products from 2021–2025
-- =========================================================


SELECT
    EXTRACT(YEAR FROM date) AS sales_year,

    ROUND(SUM(sale_dollars) / 1000000, 2)
        AS net_sales_millions,

    ROUND(SUM(bottles_sold) / 1000000, 2)
        AS net_bottles_millions,

    ROUND(SUM(volume_sold_liters) / 1000000, 2)
        AS net_volume_million_liters,

    COUNT(DISTINCT store_number)
        AS active_stores,

    COUNT(DISTINCT item_number)
        AS active_products

FROM
`portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`

GROUP BY sales_year

ORDER BY sales_year;


-- =========================================================

-- =========================================================
-- Query 16: Monthly Sales Trend
-- Purpose: Summarize monthly sales from 2021–2025
--          to identify sales patterns over time
-- =========================================================


SELECT
    EXTRACT(YEAR FROM date) AS sales_year,
    EXTRACT(MONTH FROM date) AS sales_month,

    ROUND(SUM(sale_dollars) / 1000000, 2)
        AS net_sales_millions

FROM
    `portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`

GROUP BY
    sales_year,
    sales_month

ORDER BY
    sales_year,
    sales_month;


-- =========================================================
-- Query 17: Top 10 Categories by Sales
-- Purpose: Identify the ten liquor categories generating
--          the highest total sales from 2021–2025
-- =========================================================


SELECT
    category_name,

    ROUND(SUM(sale_dollars) / 1000000, 2)
        AS net_sales_millions,

    ROUND(SUM(bottles_sold) / 1000000, 2)
        AS net_bottles_millions

FROM
    `portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`

GROUP BY
    category_name

ORDER BY
    net_sales_millions DESC

LIMIT 10;


-- =========================================================
-- Query 18: Top 5 Category Sales by Year
-- Purpose: Show the five leading liquor categories in each
--          year and compare their annual sales performance
-- =========================================================


SELECT
    EXTRACT(YEAR FROM date) AS sales_year,
    category_name,

    ROUND(SUM(sale_dollars) / 1000000, 2)
        AS net_sales_millions

FROM
    `portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`

WHERE
    category_name IN (
        'AMERICAN VODKAS',
        'CANADIAN WHISKIES',
        'STRAIGHT BOURBON WHISKIES',
        '100% AGAVE TEQUILA',
        'WHISKEY LIQUEUR'
    )

GROUP BY
    sales_year,
    category_name

ORDER BY
    sales_year,
    net_sales_millions DESC;



-- =========================================================
-- Query 19: Top 10 Products by Sales
-- Purpose: Identify the ten products generating the highest
--          total sales from 2021–2025
-- =========================================================


SELECT
    item_number,
    item_description,
    category_name,

    ROUND(SUM(sale_dollars) / 1000000, 2)
        AS net_sales_millions,

    ROUND(SUM(bottles_sold) / 1000000, 2)
        AS net_bottles_millions

FROM
    `portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`

GROUP BY
    item_number,
    item_description,
    category_name

ORDER BY
    net_sales_millions DESC

LIMIT 10;



-- =========================================================
-- Query 20: Top 10 Counties by Sales
-- Purpose: Identify the ten counties generating the highest
--          sales and compare their store activity
-- =========================================================


SELECT
    county,

    ROUND(SUM(sale_dollars) / 1000000, 2)
        AS net_sales_millions,

    ROUND(SUM(bottles_sold) / 1000000, 2)
        AS net_bottles_millions,

    COUNT(DISTINCT store_number)
        AS active_stores

FROM
    `portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`

WHERE
    county IS NOT NULL

GROUP BY
    county

ORDER BY
    net_sales_millions DESC

LIMIT 10;


-- =========================================================
-- Query 21: Sales Value per Bottle by Category
-- Purpose: Compare the average sales value per bottle
--          across the five leading liquor categories
-- =========================================================


SELECT
    category_name,

    ROUND(
        SUM(sale_dollars) / SUM(bottles_sold),
        2
    ) AS net_sales_per_bottle

FROM
    `portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`

WHERE
    category_name IN (
        'AMERICAN VODKAS',
        'CANADIAN WHISKIES',
        'STRAIGHT BOURBON WHISKIES',
        '100% AGAVE TEQUILA',
        'WHISKEY LIQUEUR'
    )

GROUP BY
    category_name

ORDER BY
    net_sales_per_bottle DESC;



-- =========================================================
-- Query 22: Top 10 Stores by Sales
-- Purpose: Identify the ten stores generating the highest
--          total sales from 2021–2025
-- =========================================================


SELECT
    store_number,
    store_name,
    county,

    ROUND(SUM(sale_dollars) / 1000000, 2)
        AS net_sales_millions,

    ROUND(SUM(bottles_sold) / 1000000, 2)
        AS net_bottles_millions

FROM
    `portfolio-project-508812.iowa_liquor_portfolio.vw_sales_2021_2025`

GROUP BY
    store_number,
    store_name,
    county

ORDER BY
    net_sales_millions DESC

LIMIT 10;



-- =========================================================





