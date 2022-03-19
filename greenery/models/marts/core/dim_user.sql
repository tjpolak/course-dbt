WITH stg_users AS (
    SELECT
        *
    FROM
        {{ ref('stg_users') }}
),

stg_addresses AS (
    SELECT
        *
    FROM
        {{ ref('stg_addresses') }}
)

SELECT
    -- user attributes
    stg_users.user_guid,
    stg_users.user_first_name,
    stg_users.user_last_name,
    stg_users.user_first_name || ' ' || stg_users.user_last_name as user_full_name,
    stg_users.user_email,
    stg_users.user_phone_number,
    stg_users.created_at_utc,
    stg_users.updated_at_utc,
    -- user address attributes
    stg_addresses.address_guid,
    stg_addresses.address_street_name,
    stg_addresses.address_zipcode,
    stg_addresses.address_state,
    stg_addresses.address_country,
    -- user order agg attributes
    int_user_order_agg.first_order_timestamp_utc  AS first_order_timestamp_utc,
    int_user_order_agg.most_recent_order_timestamp_utc AS most_recent_order_timestamp_utc,
    COALESCE(int_user_order_agg.average_order_value, 0) AS average_order_value,
    COALESCE(int_user_order_agg.lifetime_total_spent, 0) AS lifetime_total_spent,
    COALESCE(int_user_order_agg.lifetime_order_count, 0) AS lifetime_order_count
FROM
    stg_users
LEFT OUTER JOIN
    stg_addresses
ON
    stg_users.address_guid = stg_addresses.address_guid
LEFT OUTER JOIN
    {{ ref('int_user_order_agg') }}
ON
    stg_users.user_guid = int_user_order_agg.user_guid