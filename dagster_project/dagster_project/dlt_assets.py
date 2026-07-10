# import sys
# from pathlib import Path

# project_root = Path(__file__).resolve().parents[2]
# sys.path.insert(0, str(project_root))

# from dagster import asset,RetryPolicy, DailyPartitionsDefinition,FreshnessPolicy
# from dagster_dbt import DbtCliResource, dbt_assets
# from dagster import AssetDep
# from dlt_pipeline.stack_exchange_dlt_pipeline import run_stack_exchange_pipeline



# @asset( 
#     retry_policy=RetryPolicy(
#     max_retries=3,
#     delay=30),

   
# )
# def load_stackexchange():
#     load_info = run_stack_exchange_pipeline()
#     return str(load_info)       
# DBT_PROJECT_DIR = project_root / "dbt_project"

# dbt = DbtCliResource(project_dir=DBT_PROJECT_DIR)


# @dbt_assets(
#     manifest=DBT_PROJECT_DIR / "target" / "manifest.json",
#      deps=[AssetDep("load_stackexchange")]
# )
# def stackexchange_dbt_assets(context, dbt: DbtCliResource):
#     yield from dbt.cli(["build"], context=context).stream()




import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(project_root))

from dagster import AssetExecutionContext, AssetKey
from dagster_dbt import DbtCliResource, dbt_assets
from dagster_dlt import DagsterDltResource, DagsterDltTranslator, dlt_assets
from dagster_dlt.translator import DltResourceTranslatorData

from dlt_pipeline.stack_exchange_dlt_source import stack_exchange_source
from dlt_pipeline.stack_exchange_dlt_pipeline import pipeline


class StackExchangeDltTranslator(DagsterDltTranslator):
    def get_asset_spec(self, data: DltResourceTranslatorData):
        default_spec = super().get_asset_spec(data)
        return default_spec.replace_attributes(
            key=AssetKey(["stack_exchange", data.resource.name]),
            group_name="stack_exchange",
        )


@dlt_assets(
    dlt_source=stack_exchange_source(),
    dlt_pipeline=pipeline,
    name="stack_exchange",
    dagster_dlt_translator=StackExchangeDltTranslator(),
    op_tags={
        "dagster/max_retries": 3,
        "dagster/retry_delay": 30,
    },
)
def stack_exchange_dlt_assets(context: AssetExecutionContext, dlt: DagsterDltResource):
    yield from dlt.run(context=context)


DBT_PROJECT_DIR = project_root / "dbt_project"
dbt = DbtCliResource(project_dir=DBT_PROJECT_DIR)

STACK_EXCHANGE_RESOURCES = ["users", "questions", "answers", "comments", "badges", "tags"]


@dbt_assets(
    manifest=DBT_PROJECT_DIR / "target" / "manifest.json"
)
def stackexchange_dbt_assets(context, dbt: DbtCliResource):
    yield from dbt.cli(["run"], context=context).stream()