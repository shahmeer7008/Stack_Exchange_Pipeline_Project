I established a dlt  pipeline and scheduled it on dagster.For setting Karachi Timezone ,I did :

stackexchange_daily_schedule = ScheduleDefinition(
    name="stackexchange_daily_6_30pm_pkt",
    job=stackexchange_job,
    cron_schedule="30 18 * * *",
    execution_timezone="Asia/Karachi",
)

On first load, pipeline histroically loaded data and then incremntal is implemented with proper pagination.

Mapping of marts to business questions:

1. Q1 (Which tags generate the highest engagement?):
   - Mart: `mart_tag_engagement` — computes totals and averages for views, answers, comments per tag and an engagement_score.

2. Q2 (Top contributing users):
   - Mart: `mart_top_users` — ranks users by reputation, badges, answers, and accepted-answer rate. Uses `int_user_stats`.

3. Q3 (Average time-to-first-answer per tag):
   - Mart: `mart_time_to_first_answer` — aggregates `int_time_to_first_answer` by tag and month to show trends.

4. Q4 (Daily/weekly volume):
   - Mart: `mart_activity_volume` — exposes daily counts and weekly rollups from `int_daily_activity`.

5. Q5 (High-view unanswered or low answer-to-view ratio):
   - Mart: `mart_unanswered_high_view` — flags questions with high views but zero or unusually low answers.

6. Q6 (Badge distribution per day):
   - Mart: `mart_badge_distribution` — daily counts of badges by class (gold/silver/bronze).

Design choices:
- One staging model per raw source was maintained (already implemented in `models/staging`).
- Separate Intermediate and Marts models for each business question.Intermediate Models perform focused aggregations/joins and are intentionally small and composable and Marts models provide final results
- 

Running:

```bash
cd Stack_Exchange_Mini_Project
dbt run --models +marts
```
