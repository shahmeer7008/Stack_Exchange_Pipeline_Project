Marts and mapping to business questions

This folder contains intermediate models and marts that implement answers to the project's business questions.

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
- Intermediate models perform focused aggregations/joins and are intentionally small and composable.
- Tag-question joins use a name-match (`tags_raw ILIKE '%tag_name%'`) for portability across adapters; for large datasets, replace with a normalized tag-question mapping (explode tags) for performance.

Running:

```bash
cd Stack_Exchange_Mini_Project
dbt run --models +marts
```

If you'd like, I can add a more efficient tag-explode intermediate model using adapter-specific functions.