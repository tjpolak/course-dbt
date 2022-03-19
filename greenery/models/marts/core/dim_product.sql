WITH stg_products AS (
    SELECT
        *
    FROM
        {{ ref('stg_products') }}
)

SELECT
    product_guid,
    product_name,
    product_price,
    product_inventory_level
FROM
    stg_products