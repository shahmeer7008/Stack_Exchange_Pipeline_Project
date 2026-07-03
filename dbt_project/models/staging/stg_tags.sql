-- Staging model for raw tags
{{ config(materialized='view') }}

select
	name as tag_name,
	cast(count as integer) as tag_count,
	null as excerpt_post_id,
	null as wiki_post_id
from {{ source('raw_stack_exchange_data', 'tags') }}

