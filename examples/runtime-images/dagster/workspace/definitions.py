"""Minimal Dagster definitions — replace with client ingestion/orchestration code."""

from dagster import Definitions, asset, job, op


@asset
def ingestion_staging_check() -> str:
    return "ingestion volume ready"


@op
def snowflake_load_placeholder() -> str:
    return "snowflake load — wire client dbt/Snowflake assets"


@job
def ingestion_to_snowflake_job():
    snowflake_load_placeholder()


defs = Definitions(assets=[ingestion_staging_check], jobs=[ingestion_to_snowflake_job])
