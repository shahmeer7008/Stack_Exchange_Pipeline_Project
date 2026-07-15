-- Mart: daily & weekly volume metrics (Q4)
{{ config(materialized='table') }}

select day, new_questions, new_answers, new_comments, new_badges
from {{ ref('int_daily_activity') }}


