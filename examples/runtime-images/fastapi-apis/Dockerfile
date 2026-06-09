# syntax=docker/dockerfile:1
# FastAPI APIs — general microservices gateway reference.

FROM python:3.12-slim-bookworm AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-slim-bookworm AS runtime

LABEL org.opencontainers.image.title="fastapi-apis" \
      org.opencontainers.image.description="FastAPI microservices reference for data platform APIs" \
      org.opencontainers.image.vendor="client-platform"

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 APP_PORT=8000 SERVICE_NAME=fastapi-apis

RUN groupadd --gid 10001 app && useradd --uid 10001 --gid app --create-home --shell /sbin/nologin app
WORKDIR /app
COPY --from=builder /root/.local /home/app/.local
COPY app/ ./app/
RUN chown -R app:app /app
USER 10001
ENV PATH=/home/app/.local/bin:$PATH
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health')" || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]
