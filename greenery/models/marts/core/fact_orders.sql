WITH stg_orders AS (
    SELECT
        *
    FROM
        {{ ref('stg_orders') }}
)

SELECT
    stg_orders.order_guid,
    user_guid,
    COALESCE(promo_id, 'No Promo') AS promo_id,
    shipped_address_guid,
    created_at_utc,
    int_order_items_agg.total_order_line_quantity as order_quantity,
    order_cost,
    shipping_cost,
    order_total,
    tracking_guid,
    shipping_service,
    estimated_delivery_at_utc,
    delivered_at_utc,
    order_status
FROM
    stg_orders
LEFT OUTER JOIN
    {{ ref('int_order_items_agg') }}
ON
    stg_orders.order_guid = int_order_items_agg.order_guid
    