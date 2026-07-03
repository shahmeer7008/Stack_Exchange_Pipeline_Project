from dagster_dbt import DbtCliResource

from .dbt_project_assets import dbt_project

dbt_resource = DbtCliResource(project_dir=dbt_project)
