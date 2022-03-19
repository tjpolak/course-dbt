WITH base_promos AS (
  SELECT
    *
  FROM
    {{ source('greenery_postgres', 'promos') }}
),

renamed_promos AS (
  SELECT 
    promo_id,
    discount as promo_discount,
    status as promo_status
FROM base_promos
)

SELECT
  *
FROM
  renamed_promos
