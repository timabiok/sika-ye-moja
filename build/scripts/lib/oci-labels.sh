#!/usr/bin/env bash
# Emit podman --label arguments for banking OCI image metadata.

set -euo pipefail

oci_label_args() {
  local revision="${IMAGE_REVISION:-unknown}"
  local version="${IMAGE_VERSION:-${revision}}"
  local source="${IMAGE_SOURCE:-unknown}"
  local created
  created="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  local -a args=(
    --label "org.opencontainers.image.revision=${revision}"
    --label "org.opencontainers.image.version=${version}"
    --label "org.opencontainers.image.source=${source}"
    --label "org.opencontainers.image.created=${created}"
    --label "org.opencontainers.image.vendor=${IMAGE_VENDOR:-client-platform}"
  )

  if [[ -n "${IMAGE_TITLE:-}" ]]; then
    args+=(--label "org.opencontainers.image.title=${IMAGE_TITLE}")
  fi
  if [[ -n "${IMAGE_DESCRIPTION:-}" ]]; then
    args+=(--label "org.opencontainers.image.description=${IMAGE_DESCRIPTION}")
  fi

  printf '%s\n' "${args[@]}"
}
