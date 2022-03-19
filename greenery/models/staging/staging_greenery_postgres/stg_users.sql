WITH base_users AS (
  SELECT
    *
  FROM
    {{ source('greenery_postgres', 'users') }}
),

renamed_users AS (
  SELECT 
    user_id as user_guid,
    first_name as user_first_name,
    last_name as user_last_name,
    email as user_email,
    phone_number as user_phone_number,
    created_at as created_at_utc,
    updated_at as updated_at_utc,
    address_id as address_guid
FROM base_users
)

SELECT
  *
FROM
  renamed_users
