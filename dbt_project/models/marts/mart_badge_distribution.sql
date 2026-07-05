-- Mart: daily badge distribution by class (Q6)
{{ config(materialized='table') }}

select
  badge_name as badge,
  count(*) as badges_awarded

from {{ ref('stg_badges') }}

group by 1
order by  1 asc
