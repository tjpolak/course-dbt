WITH stg_order_items AS (
    SELECT
        *
    FROM
        {{ ref('stg_order_items') }}
)

SELECT
    order_guid,
    SUM(order_item_quantity) as total_order_line_quantity
FROM
    stg_order_items
{{ dbt_utils.group_by(n=1) }}