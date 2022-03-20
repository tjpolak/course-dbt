WITH stg_events AS (
    SELECT
        *
    FROM
        {{ ref('stg_events') }}
)

SELECT 
    event_guid,
    session_guid,
    user_guid,
    product_guid,
    order_guid,
    page_url,
    event_type,
    created_at_utc 
FROM stg_events