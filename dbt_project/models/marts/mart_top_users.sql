-- Mart: Top contributing users answering Q2
{{ config(materialized='table') }}

select
  user_id,
  user_display_name,
  reputation,
  badges_count,
  answers_count,
  accepted_count,
  accepted_answer_rate
from {{ ref('int_user_stats') }}
order by reputation desc, badges_count desc
