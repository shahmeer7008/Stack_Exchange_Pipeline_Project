"""Deployment manifest — import the pipelines and notebooks you want to deploy and list them in __all__."""

import sys
from pathlib import Path
from stack_exchange_dlt_pipeline import run_stack_exchange_pipeline

# from notebook import my_notebook

__all__: list[str] = [run_stack_exchange_pipeline]
