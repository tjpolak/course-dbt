# DBT Week 1 Questions and Answers

### Question 1: How many users do we have?

- Answer: 130

```
Select
  count(distinct user_id) as num_users
from
  dbt_tj_p.stg_users
```

### Question 2: On average, how many orders do we receive per hour?

- Answer: 7.52

```
select
  round(avg(order_count.num_of_orders), 2) AS avg_orders
from
(
  select
    date_trunc('day',created_at) as order_date,
    date_trunc('hour', created_at) as hour_of_day,
    count(distinct order_id) AS num_of_orders
  from
    dbt_tj_p.stg_orders
  group by 1, 2
) order_count
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
elect
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