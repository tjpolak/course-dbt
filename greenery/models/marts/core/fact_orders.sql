WITH stg_orders AS (
    SELECT
        *
    FROM
        {{ ref('stg_orders') }}
),

stg_promos AS (
    SELECT
        *
    FROM
        {{ ref('stg_promos') }}
)

SELECT
    stg_orders.order_guid,
    stg_orders.user_guid,
    COALESCE(stg_orders.promo_id, 'No Promo') AS promo_id,
    stg_orders.shipped_address_guid,
    stg_orders.created_at_utc,
    int_order_items_agg.total_order_line_quantity as order_quantity,
    stg_orders.order_cost,
    stg_orders.shipping_cost,
    stg_promos.promo_discount as order_discount,
    stg_orders.order_total,
    stg_orders.tracking_guid,
    stg_orders.shipping_service,
    stg_orders.estimated_delivery_at_utc,
    stg_orders.delivered_at_utc,
    stg_orders.order_status
FROM
    stg_orders
LEFT OUTER JOIN
    {{ ref('int_order_items_agg') }}
ON
    stg_orders.order_guid = int_order_items_agg.order_guid
LEFT OUTER JOIN
    stg_promos
ON
    stg_orders.promo_id = stg_promos.promo_id

    