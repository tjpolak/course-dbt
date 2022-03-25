WITH fact_events AS (
    SELECT
        *
    FROM
        {{ ref('fact_events') }}
),

fact_order_line_items AS (
    SELECT
        *
    FROM
        {{ ref('fact_order_line_items') }}
)

SELECT
    fact_events.session_guid,
    fact_events.user_guid,
    COALESCE(fact_events.product_guid, fact_order_line_items.product_guid) AS product_guid,
    SUM(CASE WHEN fact_events.event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_count,
    SUM(CASE WHEN fact_events.event_type = 'checkout' THEN 1 ELSE 0 END) AS checkout_count,
    SUM(CASE WHEN fact_events.event_type = 'package_shipped' THEN 1 ELSE 0 END) AS package_shipped_count,
    SUM(CASE WHEN fact_events.event_type = 'page_view' THEN 1 ELSE 0 END) AS page_view_count
FROM
    fact_events
LEFT OUTER JOIN
    fact_order_line_items
ON
    fact_events.order_guid = fact_order_line_items.order_guid
    AND COALESCE(fact_events.product_guid, fact_order_line_items.product_guid) = fact_order_line_items.product_guid
GROUP BY
    1, 2, 3