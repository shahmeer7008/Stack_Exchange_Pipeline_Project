-- Intermediate: tag-level activity metrics (join tags to questions via name match)
{{ config(materialized='view') }}

with question_answers as (
  select question_id, count(*) as answers_count 
  from {{ ref('stg_answers') }} 
  group by question_id
), 

question_comments as (
  select post_id, count(*) as comments_count 
  from {{ ref('stg_comments') }} 
  group by post_id
)

select
  t.tag_name,
  count(distinct q.question_id) as question_count,
  sum(coalesce(q.view_count,0)) as total_views,
  avg(coalesce(q.view_count,0)) as avg_views_per_question,
  sum(coalesce(qa.answers_count,0)) as total_answers,
  avg(coalesce(qa.answers_count,0)) as avg_answers_per_question,
  sum(coalesce(qc.comments_count,0)) as total_comments,
  avg(coalesce(qc.comments_count,0)) as avg_comments_per_question
  
from {{ ref('stg_tags') }} as t
left join {{ ref('stg_questions') }} as q 
on q.tags_raw ilike concat('%', t.tag_name, '%')

left join question_answers as qa 
on q.question_id = qa.question_id

left join question_comments as qc 
on q.question_id = qc.post_id

group by t.tag_name
