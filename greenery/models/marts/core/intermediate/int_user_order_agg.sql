WITH stg_users AS (
    SELECT
        *
    FROM
        {{ ref('stg_users') }}
),

stg_orders AS (
    SELECT
        *
    FROM
        {{ ref('stg_orders') }}
)

select
  stg_users.user_guid,
  MIN(stg_orders.created_at_utc) AS first_order_timestamp_utc,
  MAX(stg_orders.created_at_utc) AS most_recent_order_timestamp_utc,
  ROUND(CAST(AVG(stg_orders.order_cost) AS NUMERIC), 2) AS average_order_value,
  SUM(stg_orders.order_cost) AS lifetime_total_spent,
  COUNT(DISTINCT stg_orders.order_guid) AS lifetime_order_count
from
  stg_users
left outer join
  stg_orders
on
  stg_users.user_guid = stg_orders.user_guid
group by
  stg_users.user_guid
