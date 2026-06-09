#!/usr/bin/env bash
# Banking build layer — build Dockerfiles with Podman and push to ACR (industry-standard registry).
#
# Usage:
#   ACR_NAME=myacr IMAGE_TAG=<git-sha> ./build/scripts/build-push-images.sh
#
# Optional:
#   RUNNER_UAMI_ID=<uami>     — az login --identity before acr login
#   MANIFEST=build/images.manifest.json
#   BUILD_OUTPUT=build/artifacts/build-manifest.json
#   IMAGE_SOURCE=https://github.com/org/repo
#   IMAGE_REVISION=<git-sha>
#   PUSH_LATEST=true          — also tag :latest on default branch only (use with care)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MANIFEST="${MANIFEST:-${ROOT}/build/images.manifest.json}"
BUILD_OUTPUT="${BUILD_OUTPUT:-${ROOT}/build/artifacts/build-manifest.json}"
PUSH_LATEST="${PUSH_LATEST:-false}"

: "${ACR_NAME:?Set ACR_NAME (Azure Container Registry name)}"
: "${IMAGE_TAG:?Set IMAGE_TAG (immutable tag — use git SHA)}"

REGISTRY="${ACR_NAME}.azurecr.io"
IMAGE_REVISION="${IMAGE_REVISION:-${IMAGE_TAG}}"
IMAGE_VERSION="${IMAGE_VERSION:-${IMAGE_TAG}}"

# shellcheck source=lib/oci-labels.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib/oci-labels.sh"

log() { echo "[build-push] $*"; }
die() { echo "[build-push] ERROR: $*" >&2; exit 1; }

command -v podman >/dev/null || die "podman required"
command -v jq >/dev/null || die "jq required"
[[ -f "${MANIFEST}" ]] || die "manifest not found: ${MANIFEST}"

if [[ -n "${RUNNER_UAMI_ID:-}" ]]; then
  log "Azure login with UAMI ${RUNNER_UAMI_ID}"
  az login --identity -u "${RUNNER_UAMI_ID}" --output none
fi

log "ACR login: ${ACR_NAME}"
az acr login --name "${ACR_NAME}"

mkdir -p "$(dirname "${BUILD_OUTPUT}")"
built_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

results=()
image_count="$(jq '.images | length' "${MANIFEST}")"

for ((i = 0; i < image_count; i++)); do
  name="$(jq -r ".images[${i}].name" "${MANIFEST}")"
  context="$(jq -r ".images[${i}].context" "${MANIFEST}")"
  dockerfile="$(jq -r ".images[${i}].dockerfile" "${MANIFEST}")"
  description="$(jq -r ".images[${i}].description // \"\"" "${MANIFEST}")"
  platform="$(jq -r ".defaults.platform // \"linux/amd64\"" "${MANIFEST}")"

  ctx_path="${ROOT}/${context}"
  df_path="${ctx_path}/${dockerfile}"
  [[ -d "${ctx_path}" ]] || die "context missing: ${ctx_path}"
  [[ -f "${df_path}" ]] || die "dockerfile missing: ${df_path}"

  primary_ref="${REGISTRY}/${name}:${IMAGE_TAG}"
  log "Building ${name} → ${primary_ref}"

  IMAGE_TITLE="${name}"
  IMAGE_DESCRIPTION="${description}"
  mapfile -t label_args < <(oci_label_args)

  podman build \
    --platform "${platform}" \
    --pull=missing \
    --file "${df_path}" \
    --tag "${primary_ref}" \
    "${label_args[@]}" \
    "${ctx_path}"

  if [[ "${PUSH_LATEST}" == "true" ]]; then
    podman tag "${primary_ref}" "${REGISTRY}/${name}:latest"
  fi

  log "Pushing ${primary_ref}"
  podman push "${primary_ref}"

  digest="$(podman inspect --format '{{.Digest}}' "${primary_ref}")"

  if [[ "${PUSH_LATEST}" == "true" ]]; then
    podman push "${REGISTRY}/${name}:latest"
  fi

  results+=("$(jq -n \
    --arg name "${name}" \
    --arg ref "${primary_ref}" \
    --arg digest "${digest}" \
    --arg context "${context}" \
    '{name: $name, reference: $ref, digest: $digest, context: $context}')")
done

jq -n \
  --arg schema "bank-build-manifest/v1" \
  --arg registry "${REGISTRY}" \
  --arg tag "${IMAGE_TAG}" \
  --arg built_at "${built_at}" \
  --argjson images "$(printf '%s\n' "${results[@]}" | jq -s '.')" \
  '{schema: $schema, registry: $registry, tag: $tag, built_at: $built_at, images: $images}' \
  > "${BUILD_OUTPUT}"

log "Wrote ${BUILD_OUTPUT}"
cat "${BUILD_OUTPUT}"
