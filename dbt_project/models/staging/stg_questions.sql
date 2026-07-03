-- Staging model for raw questions
{{ config(materialized='view') }}

select
	question_id,
	title as question_title,
	null as question_body,
	to_varchar(tags) as tags_raw,
	cast(score as integer) as score,
	cast(view_count as integer) as view_count,
	cast(answer_count as integer) as answer_count,
	case when creation_date is null then null else to_timestamp(creation_date) end as creation_date,
	case when last_activity_date is null then null else to_timestamp(last_activity_date) end as last_activity_date,
	try_cast(to_varchar(owner:"user_id") as bigint) as owner_user_id
from {{ source('raw_stack_exchange_data', 'questions') }}

