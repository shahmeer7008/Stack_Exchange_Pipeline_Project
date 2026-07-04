-- Mart: Top contributing users answering Q2
{{ config(materialized='table') }}

select
  user_id,
  user_display_name,
  reputation,
  badge_counts_raw,
  answers_count,
  accepted_count,
  accepted_answer_rate
from {{ ref('int_user_stats') }}
order by reputation desc, badge_counts_raw desc
