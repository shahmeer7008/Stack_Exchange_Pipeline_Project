import logging
import dlt
from pathlib import Path
from .stack_exchange_dlt_source import stack_exchange_source

pipeline_dir = Path(__file__).parent / ".dlt"

logging.basicConfig(level=logging.DEBUG)
# def run_stack_exchange_pipeline():
pipeline = dlt.pipeline(
    pipeline_name="stack_exchange_pipeline",
    destination="snowflake",
    dataset_name="raw_stack_exchange_data",
    dev_mode=False,
    pipelines_dir=str(pipeline_dir)
    )


#I  was facing issue to debug failure in pipeline so I have added this logging
# to log errors and pipeline run status
    # try:
    #     print("Running pipeline...")
    #     load_info = pipeline.run(stack_exchange_source())
    #     print("Pipeline load_info:\n", load_info)
    #     print("\nLoad info details:")
    #     print(f"  loads_ids: {load_info.loads_ids}")
    #     print(f"  started_at: {load_info.started_at}")
    #     print(f"  finished_at: {load_info.finished_at}")
    #     if hasattr(load_info, 'loads'):
    #         for load in load_info.loads:
    #             print(f"\n  Load {load.load_id}:")
    #             if hasattr(load, 'load_packages'):
    #                 for pkg in load.load_packages:
    #                     print(f"    Package state: {pkg.state}")
    #                     for job in pkg.jobs:
    #                         print(f"      Job: {job.file_name}, state: {job.state}")
    # except Exception as e:
    #     print("Pipeline run raised an exception:", e)
    #     import traceback
    #     traceback.print_exc()
    #     raise

    # return load_info