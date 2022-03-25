SELECT
    int_session_product_events_agg.session_guid,
    int_session_product_events_agg.user_guid,
    int_session_product_events_agg.product_guid,
    dim_user.user_first_name,
    dim_user.user_last_name,
    dim_user.user_email,
    dim_product.product_name,
    int_session_product_events_agg.add_to_cart_count,
    int_session_product_events_agg.checkout_count,
    int_session_product_events_agg.package_shipped_count,
    int_session_product_events_agg.page_view_count
FROM
    {{ ref('int_session_product_events_agg') }}
LEFT OUTER JOIN
    {{ ref('dim_user') }}
ON
    int_session_product_events_agg.user_guid = dim_user.user_guid
LEFT OUTER JOIN
    {{ ref('dim_product') }}
ON
     int_session_product_events_agg.product_guid = dim_product.product_guid