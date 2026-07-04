-- Mart: Tag engagement metrics answering Q1
{{ config(materialized='table') }}

select
  tag_name,
  question_count,
  total_views,
  avg_views_per_question,
  total_answers,
  avg_answers_per_question,
  total_comments,
  avg_comments_per_question,
  (coalesce(total_views,0) + 
  coalesce(total_answers,0)*10 + 
  coalesce(total_comments,0)*3) as engagement_score
from {{ ref('int_tag_activity') }}
order by engagement_score desc
