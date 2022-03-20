# DBT Week 1 Questions and Answers

### Question 1: What is our user repeat rate?

- Answer: 78.84%

```
WITH user_order_count AS (
  SELECT
    SUM(CASE WHEN lifetime_order_count >= 2 THEN 1 ELSE 0 END) AS purchased_two_plus,
    COUNT(*) AS total_users_ordered
  FROM
    dbt_tj_p.dim_user
  WHERE 
    lifetime_order_count > 0
)
```

### Question 2: What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

- Indicators that a user will order again: There total lifetime order count and amount spent, positive reviews left (site reviews or NPS value), how often were orders on-time vs. late, amount of days/months between orders, event data on the site (have they returned or been active lately)
- Indicators that a user will NOT order again: If orders were consistently late or damaged, negative reviews, number of times called customer service, time between orders, event data on the site (have they returned or been active lately)
- If you had more data, what features would you want to look into to answer this question: I would want to bring in customer service data, any reviews/NPS data, and order return data

### Question 3: Explain the marts models you added. Why did you organize the models in the way you did?

- I addeded the following models:
  - Core:
    - int_order_items_agg: aggregated order item quantity for each distinct order_guid
    - int_user_order_agg: aggregated data for the lifetime purchase information of a user such as average order value, order count, etc.
    - dim_product: dimension that is used to describe the various products and attributes
    - dim_user: dimension that is used to describe the users of the site and their demographic information
    - fact_events: fact table used to store event data for the website as well as order tracking
    - fact_order_line_items: fact table used to store order information down to the product line item grain
    - fact_orders: fact table used to store order information aggregated at the distinct order header grain
  - Marketing:
    - fact_user_orders: fact table used to track orders and user information associated to each order (includes if a order is from a first time customer)
  - Product:
    - int_session_events_agg: used to aggregate each event that happened during a session by event type
    - fact_page_views: fact table used to track the page_view events and user information associated with each page view
    - fact_user_sessions: fact table used to track the event sessions and user information associated with the events

### Question 4: What assumptions are you making about each model? (i.e. why are you adding each test?)

### Question 5: Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

### Question 6: Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

