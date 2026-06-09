#!/usr/bin/env bash
# On dev Linux VM (Bastion) — developer Entra login for exploratory az cli (not UAMI).
# VMs in UAT/prod use: az login --identity -u <uami-id>
#
# Usage:
#   AZURE_TENANT_ID=<tenant> AZURE_DEV_SUBSCRIPTION_ID=<sub> \
#     /opt/compliance/bootstrap/az-login-developer.sh

set -euo pipefail

REPO_SCRIPT="/opt/compliance/scripts/az-developer-login.sh"
if [[ -x "${REPO_SCRIPT}" ]]; then
  exec "${REPO_SCRIPT}"
fi

: "${AZURE_TENANT_ID:?Set AZURE_TENANT_ID}"
: "${AZURE_DEV_SUBSCRIPTION_ID:?Set AZURE_DEV_SUBSCRIPTION_ID}"

echo "Activate PIM roles in Entra portal, then press Enter."
read -r
az login --tenant "${AZURE_TENANT_ID}"
az account set --subscription "${AZURE_DEV_SUBSCRIPTION_ID}"
az account show --output table
