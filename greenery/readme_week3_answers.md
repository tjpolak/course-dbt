# DBT Week 2 Questions and Answers

### Question 1a: What is our overall conversion rate?

- Answer: 62.46%

```
WITH session_count AS (
  SELECT
    SUM(CASE WHEN checkout_count > 0 THEN 1 ELSE 0 END) AS purchase_sessions,
    COUNT(*) AS total_sessions
  FROM
    dbt_tj_p.fact_user_sessions
)

SELECT
  ROUND((CAST(purchase_sessions AS NUMERIC) / CAST(total_sessions AS NUMERIC)) * 100, 2) AS conversion_rate
FROM
  session_count
```

### Question 1b: What is our conversion rate by product?

- Answer:

| product_name      | conversion_rate |
| ----------- | ----------- |
| String of pearls	 | 60.94 |
| Arrow Head	 | 55.56 |
| Cactus	 | 54.55 |
| ZZ Plant	 | 53.97 |
| Bamboo	 | 53.73 |
| Rubber Plant	 | 51.85 |
| Monstera	 | 51.02 |
| Calathea Makoyana	 | 50.94 |
| Fiddle Leaf Fig	 | 50 |
| Majesty Palm	 | 49.25 |
| Aloe Vera	 | 49.23 |
| Devil's Ivy	 | 48.89 |
| Philodendron	 | 48.39 |
| Jade Plant	 | 47.83 |
| Spider Plant	 | 47.46 |
| Pilea Peperomioides	 | 47.46 |
| Dragon Tree	 | 46.77 |
| Money Tree	 | 46.43 |
| Orchid	 | 45.33 |
| Bird of Paradise	 | 45 |
| Ficus	 | 42.65 |
| Birds Nest Fern	 | 42.31 |
| Pink Anthurium	 | 41.89 |
| Boston Fern	 | 41.27 |
| Alocasia Polly	 | 41.18 |
| Peace Lily	 | 40.91 |
| Ponytail Palm	 | 40 |
| Snake Plant	 | 39.73 |
| Angel Wings Begonia	 | 39.34 |
| Pothos	 | 34.43 |

```
WITH product_session_count AS (
  SELECT
    fact_user_product_sessions.product_guid,
    fact_user_product_sessions.product_name,
    SUM(CASE WHEN checkout_count > 0 THEN 1 ELSE 0 END) AS purchase_sessions,
    SUM(CASE WHEN page_view_count > 0 THEN 1 ELSE 0 END) AS page_view_sessions
  FROM
    dbt_tj_p.fact_user_product_sessions
  GROUP BY 1, 2
)

SELECT
  product_guid,
  product_name,
  ROUND((CAST(purchase_sessions AS NUMERIC) / CAST(page_view_sessions AS NUMERIC)) * 100, 2) AS conversion_rate
FROM
  product_session_count
ORDER BY 3 DESC
```

### Question 3: On average, how long does an order take from being placed to being delivered?

- Answer: 3 days 21:24:11.803279

```
select
  avg(delivered_orders.delivery_wait_time) AS avg_delivery_wait_time
from
(
  select
    created_at,
    delivered_at,
    age(delivered_at, created_at) as delivery_wait_time,
    status
  from
    dbt_tj_p.stg_orders
  where
    status = 'delivered'
) delivered_orders
```


### Question 4: How many users have only made one purchase? Two purchases? Three+ purchases?

| orders      | count |
| ----------- | ----------- |
| 1           | 25          |
| 2           | 28          |
| 3+          | 71         |

```
select
  sum(case when order_counts.order_count = 1 then 1 else 0 end) as count_one_purchase,
  sum(case when order_counts.order_count = 2 then 1 else 0 end) as count_two_purchase,
  sum(case when order_counts.order_count >= 3 then 1 else 0 end) as count_three_plus_purchase
from
(
  select
    user_id,
    count(*) as order_count
  from
    dbt_tj_p.stg_orders
  group by
    1
  ) order_counts
```


### Question 5: On average, how many unique sessions do we have per hour?

- Answer: 16.33

```
select
  round(avg(session_count.num_of_sessions), 2) AS avg_session
from
(
  select
    date_trunc('day',created_at) as session_date,
    date_trunc('hour', created_at) as hour_of_day,
    count(distinct session_id) AS num_of_sessions
  from
    dbt_tj_p.stg_events
  group by 1, 2
) session_count
```