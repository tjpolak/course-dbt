WITH base_products AS (
  SELECT
    *
  FROM
    {{ source('greenery_postgres', 'products') }}
),

renamed_products AS (
  SELECT 
    product_id as product_guid,
    name as product_name,
    price as product_price,
    inventory as product_inventory_level
  FROM base_products
)

SELECT
  *
FROM
  renamed_products