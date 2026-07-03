-- Mart: average time-to-first-answer per tag and monthly trend (Q3)
{{ config(materialized='table') }}

select
  tag_name,
  date_trunc('month', question_date) as month,
  avg(seconds_to_first_answer) as avg_seconds_to_first_answer,
  avg_seconds_to_first_answer/3600.0 as avg_hours_to_first_answer
from {{ ref('int_time_to_first_answer') }}
group by 1,2
order by 1,2
