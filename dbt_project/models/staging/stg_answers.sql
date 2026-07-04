-- Staging model for raw answers
{{ config(materialized='view') }}

select answer_id,
       question_id,
       null as answer_body,
       cast(score as integer) as score,
       is_accepted as is_accepted_flag,
       case
           when creation_date is null then null
           else to_timestamp(creation_date)
       end as creation_date,
       try_cast(to_varchar(owner:"user_id") as bigint) as owner_user_id
from {{ source('raw_stack_exchange_data', 'answers') }}