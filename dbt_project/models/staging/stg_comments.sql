-- Staging model for raw comments
{{ config(materialized='view') }}
select comment_id,
       post_id,
       cast(score as integer) as score,
       null as post_type,
       null as comment_text,
       try_cast(to_varchar(owner:"user_id") as bigint) as user_id,
       case
           when creation_date is null then null
           else to_timestamp(creation_date)
       end as creation_date
from {{ source('raw_stack_exchange_data', 'comments') }}