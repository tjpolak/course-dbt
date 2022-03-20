WITH fact_orders AS (
    SELECT
        *
    FROM
        {{ ref('fact_orders') }}
)

SELECT
    fact_orders.order_guid,
    fact_orders.user_guid,
    fact_orders.promo_id,
    fact_orders.shipped_address_guid,
    dim_user.user_first_name,
    dim_user.user_last_name,
    dim_user.user_email,
    fact_orders.order_quantity,
    fact_orders.order_cost,
    fact_orders.shipping_cost,
    fact_orders.order_total,
    fact_orders.order_status,
    CASE WHEN dim_user.lifetime_order_count = 1 THEN true ELSE false END AS is_new_customer,
    fact_orders.tracking_guid,
    fact_orders.shipping_service,
    fact_orders.estimated_delivery_at_utc,
    fact_orders.delivered_at_utc,
    fact_orders.created_at_utc
FROM
    fact_orders
LEFT OUTER JOIN
    {{ ref('dim_user') }}
ON
    fact_orders.user_guid = dim_user.user_guid