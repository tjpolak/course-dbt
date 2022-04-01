{% snapshot orders_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='order_id',

      strategy='timestamp',
      updated_at='estimated_delivery_at',
    )
  }}

  SELECT
    *
  FROM
    {{ source('greenery_postgres', 'orders') }}

{% endsnapshot %}