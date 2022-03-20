WITH session_length AS (
    SELECT
        session_guid,
        MIN(created_at_utc) as first_event_datetime_utc,
        MAX(created_at_utc) as last_event_datetime_utc
    FROM
        {{ ref('fact_events') }}
    GROUP BY
        1
)

SELECT
    int_session_events_agg.session_guid,
    int_session_events_agg.user_guid,
    dim_user.user_first_name,
    dim_user.user_last_name,
    dim_user.user_email,
    int_session_events_agg.add_to_cart_count,
    int_session_events_agg.checkout_count,
    int_session_events_agg.package_shipped_count,
    int_session_events_agg.page_view_count,
    (DATE_PART('day', session_length.last_event_datetime_utc::timestamp - session_length.first_event_datetime_utc::timestamp) * 24 * 60) + 
        (DATE_PART('hour', session_length.last_event_datetime_utc::timestamp - session_length.first_event_datetime_utc::timestamp) * 60) +
        (DATE_PART('minute', session_length.last_event_datetime_utc::timestamp - session_length.first_event_datetime_utc::timestamp)) AS session_length_minutes
FROM
    {{ ref('int_session_events_agg') }}
LEFT OUTER JOIN
    {{ ref('dim_user') }}
ON
    int_session_events_agg.user_guid = dim_user.user_guid
LEFT OUTER JOIN
    session_length
ON
    int_session_events_agg.session_guid = session_length.session_guid