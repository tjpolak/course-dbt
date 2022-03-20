WITH fact_events AS (
    SELECT
        *
    FROM
        {{ ref('fact_events') }}
)

SELECT
    fact_events.event_guid,
    fact_events.session_guid,
    fact_events.user_guid,
    fact_events.order_guid,
    fact_events.product_guid,
    dim_user.user_first_name,
    dim_user.user_last_name,
    dim_user.user_email,
    fact_events.page_url,
    fact_events.event_type,
    fact_events.created_at_utc
FROM
    fact_events
LEFT OUTER JOIN
    {{ ref('dim_user') }}
ON
    fact_events.user_guid = dim_user.user_guid
WHERE
    fact_events.event_type = 'page_view'