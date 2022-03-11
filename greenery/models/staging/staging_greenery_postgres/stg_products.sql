{{
  config(
    materialized='table'
  )
}}

SELECT 
    product_id,
    name,
    price,
    inventory
FROM {{ source('greenery_postgres', 'products') }}