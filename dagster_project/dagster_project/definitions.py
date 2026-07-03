from dagster import Definitions

from .dlt_assets import load_stackexchange
from .jobs import stackexchange_job
from .schedules import stackexchange_daily_schedule 

defs = Definitions(
    assets=[load_stackexchange],
    jobs=[stackexchange_job],
    schedules=[stackexchange_daily_schedule ],
)