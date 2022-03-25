WITH fact_events AS (
    SELECT
        *
    FROM
        {{ ref('fact_events') }}
)



SELECT
    session_guid,
    user_guid,
    SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_count,
    SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS checkout_count,
    SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) AS package_shipped_count,
    SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS page_view_count
FROM
    fact_events
{{ dbt_utils.group_by(n=2) }}