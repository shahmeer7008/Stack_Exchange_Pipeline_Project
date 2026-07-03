-- Intermediate: enrich questions with computed metrics (answers/comments)
{{ config(materialized='view') }}

with answers as (
  select question_id, count(*) as answers_count 
  from {{ ref('stg_answers') }} 
  group by question_id
), 

comments as (
  select post_id, count(*) as comments_count 
  from {{ ref('stg_comments') }} 
  group by post_id
)

select
  q.question_id,
  q.question_title,
  q.tags_raw,
  q.score,
  q.view_count,
  q.answer_count,
  q.creation_date,
  q.last_activity_date,
  q.owner_user_id,
  q.question_body,
  coalesce(a.answers_count, 0) as answers_count,
  coalesce(c.comments_count, 0) as comments_count
from {{ ref('stg_questions') }} as q
left join answers as a 
on q.question_id = a.question_id
left join comments as c 
on q.question_id = c.post_id
