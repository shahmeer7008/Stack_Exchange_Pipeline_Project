-- Mart: high-view unanswered or low answer-to-view ratio
{{ config(materialized='table') }}

with answer_counts as (
  select
    question_id,
    count(*) as answer_count
  from {{ ref('stg_answers') }}
  group by question_id
),
q as (
  select
    q.question_id,
    q.question_title,
    q.view_count,
    coalesce(a.answer_count, 0) as answer_count
  from {{ ref('stg_questions') }} as q
  left join answer_counts as a 
  on q.question_id = a.question_id
)

select *
from q
where (answer_count = 0 and coalesce(view_count,0) >= 1000)
or (coalesce(answer_count,0) / nullif(coalesce(view_count,0),0) < 0.01)
order by view_count desc
