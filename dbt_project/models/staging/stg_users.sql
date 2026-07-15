-- Staging model for raw users
{{ config(materialized='view',persist_docs={"relation": true, "columns": true}) }}
select user_id as user_id,
       display_name as user_display_name,
       profile_image as profile_img,
       website_url as web_url,
       location as user_location,
       account_id,
       is_employee as is_employee_flag,
       badge_counts__bronze as badge_count_bronze,
       badge_counts__silver as badge_count_silver,
       badge_counts__gold as badge_count_gold,
       badge_counts as badge_counts_raw,
       cast(reputation as bigint) as reputation,
       case
            when creation_date is null then null
            else to_timestamp(creation_date)
            end as creation_date,
        case
            when last_access_date is null then null
                else to_timestamp(last_access_date)
                end as last_access_date,
        case
            when last_modified_date is null then null
            else to_timestamp(last_modified_date)
            end as last_modified_date
from {{ source('raw_stack_exchange_data', 'users') }}