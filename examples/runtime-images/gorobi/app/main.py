"""Gorobi reference service — replace with client trading/Gorobi integration."""

import logging
import os
from datetime import datetime, timezone

from fastapi import FastAPI

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger("gorobi")

app = FastAPI(title="Gorobi API", version="0.1.0", docs_url=None, redoc_url=None)


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "gorobi"}


@app.get("/ready")
def ready() -> dict:
    return {
        "status": "ready",
        "service": "gorobi",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "environment": os.getenv("APP_ENV", "unknown"),
    }


@app.get("/v1/positions")
def positions() -> dict:
    logger.info("positions requested")
    return {"service": "gorobi", "message": "reference endpoint — wire Charles River APIs"}
