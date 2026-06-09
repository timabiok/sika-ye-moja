"""FastAPI APIs reference — replace with client microservices."""

import logging
import os
from datetime import datetime, timezone

from fastapi import FastAPI

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger("fastapi-apis")

app = FastAPI(title="Data Platform APIs", version="0.1.0", docs_url=None, redoc_url=None)


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "fastapi-apis"}


@app.get("/ready")
def ready() -> dict:
    return {
        "status": "ready",
        "service": "fastapi-apis",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "environment": os.getenv("APP_ENV", "unknown"),
    }


@app.get("/v1/status")
def status() -> dict:
    logger.info("platform status requested")
    return {"status": "operational", "runtime": "podman", "stack": "data-platform"}
