-- Mart: daily & weekly volume metrics (Q4)
{{ config(materialized='table') }}

select day, new_questions, new_answers, new_comments, new_badges
from {{ ref('int_daily_activity') }}

union all

select date_trunc('week', day) as day,
  sum(new_questions) as new_questions,
  sum(new_answers) as new_answers,
  sum(new_comments) as new_comments,
  sum(new_badges) as new_badges
from {{ ref('int_daily_activity') }}
group by 1
order by 1
