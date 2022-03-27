# DBT Week 3 Questions and Answers

### Part 1a: What is our overall conversion rate?

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

### Part 1b: What is our conversion rate by product?

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

### Part 1c: Why might certain products be converting at higher/lower rates than others? Note: we don't actually have data to properly dig into this, but we can make some hypotheses

- Answer: I would like to see the campaign and ad data from social media and the email platform.  My guess would be that there may have been some marketing campaigns that were geared towards some of the products recently that would cause more attention than others.  In addition, some of the products may be placed at the front of the website during these campaigns which would cause more attention as well.

### Part 2: Create a macro to simplify part of a model(s).

- Answer: I created a macro in the int_session_events_agg.sql file that looped through the event type columns.  I also created a macro in the macros folder called grant_usage_on_schemas.sql that I used to call in the post hooks to grant acess to reporting.

### Part 3: Add a post hook to your project to apply grants to the role “reporting”.

- Answer: I created a macro called grant_usage_on_schemas and use this in a post-hook call to grant usage and select to all tables in the schema to reporting

### Part 4: Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project.

- Answer: I installed both packages in my dbt project.  For the dbt-utilis, I used the group by functionbality in my int_models where I was aggregated the data
and needed a group by n.  

### Part 5: Show (using dbt docs and the model DAGs) how you have simplified or improved a DAG using macros and/or dbt packages.

- Answer: The DAG is attached to the project submission in slack.