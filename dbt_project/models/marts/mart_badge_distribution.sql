-- Mart: daily badge distribution by class (Q6)
{{ config(materialized='table') }}

select
  badge_name as badge,
  award_count,
  badgeclass
from {{ ref('stg_badges') }}

