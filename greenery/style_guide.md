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
