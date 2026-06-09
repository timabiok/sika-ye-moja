#!/usr/bin/env bash
# Runner VM wrapper — build all manifest images and push to ACR.
#
# Usage:
#   ACR_NAME=myacr IMAGE_TAG=<git-sha> RUNNER_UAMI_ID=<uami> build-images.sh
#
# Optional: CHECKOUT_ROOT=/path/to/repo (default: current directory)

set -euo pipefail

CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(pwd)}"
BUILD_INSTALL="/opt/compliance/build"

: "${ACR_NAME:?Set ACR_NAME}"
: "${IMAGE_TAG:?Set IMAGE_TAG}"

export MANIFEST="${BUILD_INSTALL}/images.manifest.json"
export BUILD_OUTPUT="${CHECKOUT_ROOT}/build/artifacts/build-manifest.json"

if [[ -x "${CHECKOUT_ROOT}/build/scripts/build-push-images.sh" ]]; then
  exec "${CHECKOUT_ROOT}/build/scripts/build-push-images.sh"
fi

if [[ -x "${BUILD_INSTALL}/scripts/build-push-images.sh" ]]; then
  # Fallback when repo checkout not present — uses staged manifest only.
  ROOT="${CHECKOUT_ROOT}" exec "${BUILD_INSTALL}/scripts/build-push-images.sh"
fi

echo "ERROR: build-push-images.sh not found in checkout or ${BUILD_INSTALL}" >&2
exit 1
