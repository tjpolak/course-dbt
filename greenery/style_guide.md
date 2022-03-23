```
├── dbt_project.yml
└── models
    └── clean
            └── shopify
                ├── base
                |   ├── base_shopify_order_types.sql
                ├── raw_shopify.yml
                ├── clean_shopify.yml
                ├── stg_shopify_customers.sql
                └── stg_shopify_orders.sql
    ├── curated
    |   └── core
    |       ├── intermediate
    |       |   ├── core_intermediate.yml
    |       |   ├── int_order_adjustments.sql
    |       |   ├── int_customers_unioned.sql
    |       └── curated_core.yml
    |       └── dim_customer.sql
    |       └── fact_orders.sql
    |   └── finance
    |   └── marketing
    |       └── curated_marketing.yml
    |       └── fact_user_orders.sql
    |   └── product
```