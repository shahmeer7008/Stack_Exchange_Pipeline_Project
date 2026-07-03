-- Mart: daily badge distribution by class (Q6)
{{ config(materialized='table') }}

select
  badge_type as badge_class,
  date_trunc('day', award_date) as day,
  count(*) as badges_awarded
from {{ ref('stg_badges') }}
group by 1, 2
order by 2 desc, 1 asc
