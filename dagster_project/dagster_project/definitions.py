from dagster import Definitions
from dagster_dlt import DagsterDltResource
from .dlt_assets import stack_exchange_dlt_assets, stackexchange_dbt_assets,dbt
from .jobs import stackexchange_pipeline_job
from .schedules import stackexchange_daily_schedule 
defs = Definitions(
    assets=[stack_exchange_dlt_assets,stackexchange_dbt_assets],
    resources={
        "dlt": DagsterDltResource(),
        "dbt": dbt,
    },
    jobs=[stackexchange_pipeline_job],
    schedules=[stackexchange_daily_schedule ],
)