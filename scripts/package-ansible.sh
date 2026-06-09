#!/usr/bin/env bash
# Packages Ansible content for Azure Image Builder upload.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${1:-dev}"
OUT_DIR="${ROOT}/ansible/dist"
ARCHIVE="${OUT_DIR}/ansible-${VERSION}.tar.gz"

STAGE="${OUT_DIR}/stage"
LAYER2_FILES="${STAGE}/roles/rhel9_bank_baseline/files/layer2"
rm -rf "${STAGE}"
mkdir -p "${LAYER2_FILES}"
cp -R "${ROOT}/ansible/playbooks" "${ROOT}/ansible/roles" "${ROOT}/ansible/requirements.yml" "${STAGE}/"
BUILD_LAYER_FILES="${ROOT}/ansible/layer2/roles/podman_build_layer/files/build"
mkdir -p "${BUILD_LAYER_FILES}"
cp -R "${ROOT}/build/." "${BUILD_LAYER_FILES}/"
cp "${ROOT}/scripts/az-developer-login.sh" "${ROOT}/ansible/roles/rhel9_bank_baseline/files/az-developer-login.sh"
cp -R "${ROOT}/ansible/layer2/." "${LAYER2_FILES}/"

mkdir -p "${OUT_DIR}"
tar -czf "${ARCHIVE}" -C "${STAGE}" playbooks roles requirements.yml

echo "Created ${ARCHIVE}"
echo "Set ansible_archive_path in terraform.tfvars and enable_ansible_customization = true"
