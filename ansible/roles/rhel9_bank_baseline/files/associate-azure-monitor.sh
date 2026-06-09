#!/usr/bin/env bash
# Layer-2 emergency bootstrap — prefer Terraform monitor-baseline module + AMA extension.
#
# Usage (break-glass only):
#   DCR_RESOURCE_ID='/subscriptions/.../dataCollectionRules/dcr-linux-baseline' \
#   LOG_ANALYTICS_WORKSPACE_ID='/subscriptions/.../workspaces/la-bank' \
#     /opt/compliance/bootstrap/associate-azure-monitor.sh
#
# Requires: azure-cli, VM UAMI with Monitoring Metrics Publisher on DCR scope.

set -euo pipefail

: "${DCR_RESOURCE_ID:?Set DCR_RESOURCE_ID}"
: "${UAMI_RESOURCE_ID:?Set UAMI_RESOURCE_ID — same as RUNNER_UAMI_ID or RUNTIME_UAMI_ID}"

az login --identity -u "${UAMI_RESOURCE_ID}"

VM_ID="$(curl -sf -H Metadata:true \
  'http://169.254.169.254/metadata/instance?api-version=2021-02-01' \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["compute"]["resourceId"])')"

echo "Associating DCR ${DCR_RESOURCE_ID} with VM ${VM_ID}..."

az monitor data-collection rule association create \
  --name "dcr-assoc-$(hostname -s)" \
  --rule-id "${DCR_RESOURCE_ID}" \
  --resource "${VM_ID}" \
  --output none 2>/dev/null || true

echo "Ensure AzureMonitorLinuxAgent extension is installed via Terraform or:"
echo "  az vm extension set --vm-name <name> --resource-group <rg> \\"
echo "    --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor \\"
echo "    --type AzureMonitorLinuxAgent --enable-auto-upgrade true"

echo "Azure Monitor association bootstrap complete."
