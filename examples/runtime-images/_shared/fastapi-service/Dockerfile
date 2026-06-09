# syntax=docker/dockerfile:1
# Shared FastAPI reference pattern — copy per service with SERVICE_* build args.

ARG PYTHON_VERSION=3.12-slim-bookworm
FROM python:${PYTHON_VERSION} AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:${PYTHON_VERSION} AS runtime

ARG SERVICE_TITLE=platform-service
ARG SERVICE_DESCRIPTION=Reference data platform microservice
ARG SERVICE_PORT=8000

LABEL org.opencontainers.image.title="${SERVICE_TITLE}" \
      org.opencontainers.image.description="${SERVICE_DESCRIPTION}" \
      org.opencontainers.image.vendor="client-platform" \
      org.opencontainers.image.licenses="Proprietary"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_PORT=${SERVICE_PORT}

RUN groupadd --gid 10001 app && \
    useradd --uid 10001 --gid app --create-home --shell /sbin/nologin app

WORKDIR /app
COPY --from=builder /root/.local /home/app/.local
COPY app/ ./app/

RUN chown -R app:app /app
USER 10001
ENV PATH=/home/app/.local/bin:$PATH

EXPOSE ${SERVICE_PORT}

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request,os; urllib.request.urlopen(f'http://127.0.0.1:{os.environ[\"APP_PORT\"]}/health')" || exit 1

CMD uvicorn app.main:app --host 0.0.0.0 --port ${APP_PORT} --workers 2
