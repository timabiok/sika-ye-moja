# syntax=docker/dockerfile:1
# Gorobi — trading/API integration route (APIM token validation upstream).

FROM python:3.12-slim-bookworm AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-slim-bookworm AS runtime

LABEL org.opencontainers.image.title="gorobi" \
      org.opencontainers.image.description="Gorobi API route — Charles River / trading integration reference" \
      org.opencontainers.image.vendor="client-platform"

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 APP_PORT=8010 SERVICE_NAME=gorobi

RUN groupadd --gid 10001 app && useradd --uid 10001 --gid app --create-home --shell /sbin/nologin app
WORKDIR /app
COPY --from=builder /root/.local /home/app/.local
COPY app/ ./app/
RUN chown -R app:app /app
USER 10001
ENV PATH=/home/app/.local/bin:$PATH
EXPOSE 8010

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8010/health')" || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8010", "--workers", "2"]
