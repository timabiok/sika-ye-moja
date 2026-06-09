#!/usr/bin/env bash
# Layer 3 — pull platform images, retag for Quadlet, start full runtime stack.
#
# Services: gorobi, ingestion, fastapi-apis, dagster + nginx-proxy
#
# Usage:
#   ACR_NAME=myacr IMAGE_TAG=<git-sha> RUNTIME_UAMI_ID=<uami-resource-id> \
#     /opt/compliance/bootstrap/deploy-runtime-stack.sh

set -euo pipefail

: "${ACR_NAME:?Set ACR_NAME}"
: "${IMAGE_TAG:?Set IMAGE_TAG}"
: "${RUNTIME_UAMI_ID:?Set RUNTIME_UAMI_ID}"

REGISTRY="${ACR_NAME}.azurecr.io"
NETWORK_SERVICE="bank-runtime-net.service"

# ACR image name → local Quadlet tag
declare -A IMAGES=(
  [gorobi]="localhost/bank-runtime-gorobi:current"
  [ingestion]="localhost/bank-runtime-ingestion:current"
  [fastapi-apis]="localhost/bank-runtime-fastapi-apis:current"
  [dagster]="localhost/bank-runtime-dagster:current"
  [nginx-proxy]="localhost/bank-runtime-nginx:current"
)

SERVICES=(gorobi ingestion fastapi-apis dagster nginx-proxy)

log() { echo "[deploy-runtime-stack] $*"; }

az login --identity -u "${RUNTIME_UAMI_ID}" --output none
az acr login --name "${ACR_NAME}"

for name in "${!IMAGES[@]}"; do
  remote="${REGISTRY}/${name}:${IMAGE_TAG}"
  local_tag="${IMAGES[$name]}"
  log "Pulling ${remote}"
  podman pull "${remote}"
  podman tag "${remote}" "${local_tag}"
done

cat > /etc/containers/runtime/stack.env <<EOF
ACR_NAME=${ACR_NAME}
IMAGE_TAG=${IMAGE_TAG}
DEPLOYED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)
SERVICES=${SERVICES[*]}
EOF
chmod 0640 /etc/containers/runtime/stack.env

systemctl daemon-reload
systemctl enable "${NETWORK_SERVICE}"
for unit in "${SERVICES[@]}"; do
  systemctl enable "${unit}.service"
done

systemctl restart "${NETWORK_SERVICE}"
for unit in "${SERVICES[@]}"; do
  systemctl restart "${unit}.service"
done

systemctl --no-pager --full status gorobi.service ingestion.service fastapi-apis.service dagster.service nginx-proxy.service || true

log "Platform stack deployed:"
log "  http://<runtime-ip>:8080/health"
log "  http://<runtime-ip>:8080/gorobi/v1/positions"
log "  http://<runtime-ip>:8080/ingestion/v1/staging/status"
log "  http://<runtime-ip>:8080/api/v1/status"
log "  http://<runtime-ip>:8080/dagster/"
