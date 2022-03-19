WITH base_addresses as (
  SELECT 
    *
  FROM {{ source('greenery_postgres', 'addresses') }}
),

renamed_addresses as (
  SELECT 
    address_id as address_guid,
    address as address_street_name,
    zipcode as address_zipcode,
    state as address_state,
    country as address_country
  FROM base_addresses
)

SELECT 
  * 
FROM renamed_addresses