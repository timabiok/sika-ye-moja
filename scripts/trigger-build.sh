#!/usr/bin/env bash
# Triggers an Azure Image Builder run after Terraform has created the template.
set -euo pipefail

RESOURCE_GROUP="${1:?Usage: $0 <resource-group> <template-name>}"
TEMPLATE_NAME="${2:?Usage: $0 <resource-group> <template-name>}"

az image builder show \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${TEMPLATE_NAME}" \
  --query "provisioningState" -o tsv

az image builder run \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${TEMPLATE_NAME}" \
  --no-wait

echo "Build started. Monitor:"
echo "  az image builder show -g ${RESOURCE_GROUP} -n ${TEMPLATE_NAME} --query lastRunStatus"
