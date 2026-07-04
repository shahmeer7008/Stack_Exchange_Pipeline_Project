-- Intermediate: compute time-to-first-answer per question and tag
{{ config(materialized='view') }}

with first_answers as (
  select question_id, min(creation_date) 
  as first_answer_date 
  from {{ ref('stg_answers') }} 
  group by question_id
)

select
  q.question_id,
  q.creation_date as question_date,
  fa.first_answer_date,
  t.tag_name,
  case when fa.first_answer_date is null 
  then null 
  else datediff('second', q.creation_date, fa.first_answer_date) 
  end as seconds_to_first_answer

from {{ ref('stg_questions') }} as q

left join first_answers as fa 
on q.question_id = fa.question_id

left join {{ ref('stg_tags') }} as t 
on q.tags_raw ilike concat('%', t.tag_name, '%')
