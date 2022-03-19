WITH base_order_items AS (
  SELECT 
    *
  FROM {{ source('greenery_postgres', 'order_items') }}
),

renamed_order_items AS (
  SELECT 
    order_id as order_guid,
    product_id as product_guid,
    quantity as order_item_quantity
  FROM base_order_items
)

SELECT
  *
FROM 
  renamed_order_items