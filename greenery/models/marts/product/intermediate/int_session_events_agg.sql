WITH fact_events AS (
    SELECT
        *
    FROM
        {{ ref('fact_events') }}
)

{% set event_type_query %}
SELECT DISTINCT(event_type) FROM {{ ref('fact_events') }}
order by 1
{% endset %}

{% set results = run_query(event_type_query) %}

{% if execute %}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}



SELECT
    session_guid,
    user_guid,
    {% for event_type in results_list %}
    SUM(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END) AS {{event_type}}_count
        {% if not loop.last %}
        ,
        {% endif %}
    {% endfor %}
FROM
    fact_events
{{ dbt_utils.group_by(n=2) }}