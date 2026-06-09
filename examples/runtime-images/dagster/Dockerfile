# syntax=docker/dockerfile:1
# Dagster — reference webserver workspace (add dagster-daemon separately in production).

FROM python:3.12-slim-bookworm AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-slim-bookworm AS runtime

LABEL org.opencontainers.image.title="dagster" \
      org.opencontainers.image.description="Dagster webserver reference — orchestration UI and definitions" \
      org.opencontainers.image.vendor="client-platform"

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 \
    DAGSTER_HOME=/opt/dagster SERVICE_NAME=dagster

RUN groupadd --gid 10002 dagster && useradd --uid 10002 --gid dagster --create-home --shell /sbin/nologin dagster
RUN mkdir -p /opt/dagster && chown dagster:dagster /opt/dagster

WORKDIR /opt/dagster
COPY --from=builder /root/.local /home/dagster/.local
COPY workspace/ ./

RUN chown -R dagster:dagster /opt/dagster
USER 10002
ENV PATH=/home/dagster/.local/bin:$PATH
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:3000/server_info')" || exit 1

CMD ["dagster-webserver", "-h", "0.0.0.0", "-p", "3000", "-w", "workspace.yaml"]
