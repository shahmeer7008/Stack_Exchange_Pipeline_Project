-- Intermediate: user-level aggregates (answers, accepted rate, badges)
{{ config(materialized='view') }}

with answers as (
  select owner_user_id,accept_rate
  from {{ ref('stg_answers') }}
) 


select
  u.user_id,
  u.user_display_name,
  u.reputation,
  u.badge_counts_raw,
  try_cast(to_varchar(a.accept_rate) as bigint) as accept_rate
from {{ ref('stg_users') }} as u

left join answers as a 
on u.user_id = a.owner_user_id

