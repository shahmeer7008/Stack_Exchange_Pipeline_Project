-- Staging model for raw badges
{{ config(materialized='view') }}
select badge_id,
       name as badge_name,
       badge_type,
       cast(null as timestamp) as award_date
from {{ source('raw_stack_exchange_data', 'badges') }}