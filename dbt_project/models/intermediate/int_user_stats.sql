-- Intermediate: user-level aggregates (answers, accepted rate, badges)
{{ config(materialized='view') }}

with answers as (
  select owner_user_id, count(*) as answers_count, 
  sum(case when is_accepted_flag then 1 else 0 end) as accepted_count
  from {{ ref('stg_answers') }}
  group by owner_user_id
), badges as (
  select user_id, count(distinct badge_id) 
  as badges_count from {{ ref('stg_badges') }} group by user_id
)

select
  u.user_id,
  u.user_display_name,
  u.reputation,
  coalesce(b.badges_count, 0) as badges_count,
  coalesce(a.answers_count, 0) as answers_count,
  coalesce(a.accepted_count, 0) as accepted_count,
  case when coalesce(a.answers_count,0)=0 
  then 0 
  else round(coalesce(a.accepted_count,0)::numeric / a.answers_count, 3) 
  end as accepted_answer_rate
from {{ ref('stg_users') }} as u
left join answers as a on u.user_id = a.owner_user_id
left join badges as b on u.user_id = b.user_id
