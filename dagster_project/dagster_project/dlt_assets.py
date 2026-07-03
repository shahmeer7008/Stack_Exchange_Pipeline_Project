import sys
from pathlib import Path

# Go up two directories
project_root = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(project_root))

from dagster import asset

from dlt_pipeline.stack_exchange_dlt_pipeline import run_stack_exchange_pipeline


@asset
def load_stackexchange():
    load_info = run_stack_exchange_pipeline()
    return str(load_info)