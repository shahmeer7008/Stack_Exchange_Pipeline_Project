from dagster import define_asset_job

stackexchange_job = define_asset_job(
    name="stackexchange_job"
)