# DBT Week 4 Questions and Answers

### Part 1: Snapshot Creattion

- Answer: I was able to create a model called orders_snapshot.  I initialized the snapshot by executing the 'dbt snapshot' command, ran the sql, and then executed the 'dbt snapshot' again. I was able to see the rows were updated and created a new row with the correct start and end dates.

```
% snapshot orders_snapshot %}

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
```

### Part 2a: Product Funnel

- Answer: I didn't create another model, but used a query at the BI/Reporting layer using the fact_user_sessions table that we created in prior weeks.  It seems that there was a larger drop off at the bottom of the funnel from the add to cart / checkout -> checkout step.

| step      | step_count | lag_step_count | step_drop_off |
| ----------- | ----------- | ----------- | ----------- |
| top_funnel	 | 578 | NULL | NULL
| middle_funnel	 | 467 | 578 | 0.19 |
| bottom_funnel	 | 361 | 467 | 0.23 |

```
WITH top_funnel AS (
  select
    distinct
    session_guid
  from
    dbt_tj_p.fact_user_sessions
  where
    page_view_count > 0 or add_to_cart_count > 0 or checkout_count > 0
),

middle_funnel as (
  select
    distinct
    session_guid
  from
    dbt_tj_p.fact_user_sessions
  where
    add_to_cart_count > 0 or checkout_count > 0
),

bottom_funnel as (
  select
    distinct
    session_guid
  from
    dbt_tj_p.fact_user_sessions
  where
    checkout_count > 0
),

steps as (
  select 'top_funnel' as step, count(*) as step_count from top_funnel
  union all
  select 'middle_funnel' as step, count(*) as step_count from middle_funnel
  union all
  select 'bottom_funnel' as step, count(*) as step_count from bottom_funnel
)

select
  step,
  step_count,
  lag(step_count, 1) over () as lag_step_count,
  round((1.0 - step_count::numeric/lag(step_count, 1) over ()),2) as step_drop_off
from
  steps
```

### Part 2b: Exposures

- Answers: I was able to create an exposure.xml in the models folder that documented the Product Funnel Dashboard.  I also ran the dbt doc command and generated a new DAG that will be attached to the submission.

### Part 3b: Setting up for production / scheduled dbt run of your project

- In a perfect world, we would be using Airflow to schedule the dbt executions.  We are using Fivetran and Python for our 'EL' steps, and we would have Airflow check to ensure the source data was loaded before our model started.  After all of our source data was loaded, we would execute the 'dbt build' command.  We would have any alerts and errors integrated with our slack channel so we would be notified of any issues.  After the dbt models were successful, we would send an email out to all of the users that the previous days data was available for consumption.