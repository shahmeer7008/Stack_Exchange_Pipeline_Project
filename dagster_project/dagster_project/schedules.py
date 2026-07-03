from dagster import ScheduleDefinition

from .jobs import stackexchange_job

stackexchange_daily_schedule = ScheduleDefinition(
    name="stackexchange_daily_6_30pm_pkt",
    job=stackexchange_job,
    cron_schedule="30 18 * * *",
    execution_timezone="Asia/Karachi",
)
