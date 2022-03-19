WITH stg_order_items AS (
    SELECT
        *
    FROM
        {{ ref('stg_order_items') }}
)

SELECT
    order_guid,
    product_guid,
    order_item_quantity
FROM
    stg_order_items