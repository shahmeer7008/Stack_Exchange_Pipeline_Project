-- Intermediate: daily activity counts (questions/answers/comments/badges)
{{ config(materialized='view') }}

with q as (
    select
        date_trunc('day', creation_date) as day,
        count(*) as new_questions
    from {{ ref('stg_questions') }}
    group by 1
),

a as (
    select
        date_trunc('day', creation_date) as day,
        count(*) as new_answers
    from {{ ref('stg_answers') }}
    group by 1
),

c as (
    select
        date_trunc('day', creation_date) as day,
        count(*) as new_comments
    from {{ ref('stg_comments') }}
    group by 1
),

b as (
    select
        date_trunc('day', award_date) as day,
        count(*) as new_badges
    from {{ ref('stg_badges') }}
    group by 1
),

activity as (

    select day, new_questions, 0 as new_answers, 0 as new_comments, 0 as new_badges
    from q

    union all

    select day, 0, new_answers, 0, 0
    from a

    union all

    select day, 0, 0, new_comments, 0
    from c

    union all

    select day, 0, 0, 0, new_badges
    from b

)

select
    day,
    sum(new_questions) as new_questions,
    sum(new_answers) as new_answers,
    sum(new_comments) as new_comments,
    sum(new_badges) as new_badges
from activity
group by day
order by day