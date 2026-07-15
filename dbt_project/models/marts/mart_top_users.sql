-- Mart: Top contributing users answering Q2
{{ config(materialized='table') }}

select
  user_id,
  user_display_name,
  reputation,
  accept_rate
from {{ ref('int_user_stats') }}
order by reputation desc, award_count desc
