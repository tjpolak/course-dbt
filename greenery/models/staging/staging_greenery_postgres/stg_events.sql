WITH base_events AS (
  SELECT
    *
  FROM
    {{ source('greenery_postgres', 'events') }}  
),

renamed_events AS (
  SELECT 
    event_id as event_guid,
    session_id as session_guid,
    user_id as user_guid,
    page_url,
    created_at as created_at_utc,
    event_type,
    order_id as order_guid,
    product_id as product_guid
FROM base_events
)

SELECT 
  *
FROM
  renamed_events