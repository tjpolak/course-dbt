WITH base_orders AS (
  SELECT
    *
  FROM
    {{ source('greenery_postgres', 'orders') }}
),

renamed_orders AS (
  SELECT 
    order_id as order_guid,
    user_id as user_guid,
    promo_id as promo_id,
    address_id as shipped_address_guid,
    created_at as created_at_utc,
    order_cost,
    shipping_cost,
    order_total,
    tracking_id as tracking_guid,
    shipping_service,
    estimated_delivery_at as estimated_delivery_at_utc,
    delivered_at as delivered_at_utc,
    status as order_status
  FROM base_orders
)

SELECT
  *
FROM
  renamed_orders
