"""Ingestion reference — staging files on mounted volume before Dagster/Snowflake load."""

import logging
import os
from datetime import datetime, timezone
from pathlib import Path

from fastapi import FastAPI

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger("ingestion")

DATA_PATH = Path(os.getenv("INGESTION_DATA_PATH", "/data/ingestion"))

app = FastAPI(title="Ingestion Service", version="0.1.0", docs_url=None, redoc_url=None)


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "ingestion"}


@app.get("/ready")
def ready() -> dict:
    DATA_PATH.mkdir(parents=True, exist_ok=True)
    writable = os.access(DATA_PATH, os.W_OK)
    return {
        "status": "ready" if writable else "degraded",
        "service": "ingestion",
        "data_path": str(DATA_PATH),
        "writable": writable,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


@app.get("/v1/staging/status")
def staging_status() -> dict:
    DATA_PATH.mkdir(parents=True, exist_ok=True)
    files = list(DATA_PATH.iterdir()) if DATA_PATH.exists() else []
    logger.info("staging status — %d files", len(files))
    return {
        "service": "ingestion",
        "data_path": str(DATA_PATH),
        "file_count": len(files),
        "note": "Mount host path or Azure Files at INGESTION_DATA_PATH",
    }
