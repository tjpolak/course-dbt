```
├── dbt_project.yml
└── models
    └── stage
        └── shopify
            ├── intermediate
            |   ├── shopify_intermediate.yml
            |   ├── int_shopify_customer_metrics.sql
            ├── stage
            |   ├── base_shopify_order_types.sql
            |   ├── shopify_stage.yml
            |   ├── stg_shopify_customers.sql
            |   ├── stg_shopify_orders.sql
            ├── shopify_raw.yml
    ├── mart
    |   └── core
    |       ├── intermediate
    |       |   ├── core_intermediate.yml
    |       |   ├── int_order_adjustments.sql
    |       |   ├── int_customers_unioned.sql
    |       └── mart_core.yml
    |       └── dim_customer.sql
    |       └── fact_orders.sql
    |   └── finance
    |   └── marketing
    |       └── mart_marketing.yml
    |       └── fact_user_orders.sql
    |   └── product
```

```
WITH shopify_customers AS (

    SELECT * FROM {{ ref('stg_shopify_customers') }}

),

shopify_orders AS (

    SELECT * FROM {{ ref('stg_shopify_orders') }}

),

customer_orders as (

    SELECT
        customer_key,
        MIN(order_date) as first_order_date,
        MAX(order_date) as most_recent_order_date,
        COUNT(order_id) as number_of_orders,
        SUM(amount) as lifetime_value

    FROM shopify_orders

    GROUP BY 1

),

final AS (

    SELECT
        shopify_customers.customer_key,
        shopify_customers.first_name,
        shopify_customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        COALESCE(customer_orders.number_of_orders, 0) as number_of_orders,
        COALESCE(customer_orders.lifetime_value, 0) as lifetime_value

    FROM shopify_customers

    LEFT OUTER JOIN 
        customer_orders 
    ON 
        shopify_customers.customer_key = customer_orders.customer_key

)

SELECT * FROM final
```
