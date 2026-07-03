-- Intermediate: answers aggregated per question
{{ config(materialized='view') }}

with answers as (
  select
    answer_id,
    question_id,
    is_accepted_flag,
    creation_date
  from {{ ref('stg_answers') }}
),
per_question as (
  select
    question_id,
    count(*) as answer_count,
    min(creation_date) as first_answer_date
  from answers
  group by question_id
)

select * from per_question
