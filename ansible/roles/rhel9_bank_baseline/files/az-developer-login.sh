#!/usr/bin/env bash
# Temporary developer Azure CLI login — use after activating PIM eligible roles in Entra.
#
# Usage:
#   AZURE_TENANT_ID=<tenant> AZURE_DEV_SUBSCRIPTION_ID=<dev-sub> ./scripts/az-developer-login.sh
#
# Optional:
#   AZURE_DEV_RESOURCE_GROUP=<rg>   — verify read access to expected RG
#   PIM_PORTAL_URL                  — override Entra My Roles link
#   SKIP_PIM_PROMPT=true            — non-interactive CI smoke (caller must have active PIM)

set -euo pipefail

: "${AZURE_TENANT_ID:?Set AZURE_TENANT_ID}"
: "${AZURE_DEV_SUBSCRIPTION_ID:?Set AZURE_DEV_SUBSCRIPTION_ID}"

PIM_PORTAL_URL="${PIM_PORTAL_URL:-https://portal.azure.com/#view/Microsoft_Azure_PIMCommon/ActivationMenuBlade/~/aadmigrationroles}"
SKIP_PIM_PROMPT="${SKIP_PIM_PROMPT:-false}"

log() { echo "[az-developer-login] $*"; }
die() { echo "[az-developer-login] ERROR: $*" >&2; exit 1; }

command -v az >/dev/null || die "Azure CLI not installed — brew install azure-cli or dnf install azure-cli"

if [[ "${SKIP_PIM_PROMPT}" != "true" ]]; then
  log "Activate PIM eligible roles (dev subscription only, max ~8h):"
  log "  ${PIM_PORTAL_URL}"
  log "Typical roles: Reader (dev), AcrPush (dev ACR), Key Vault Secrets User (dev KV)"
  read -r -p "Press Enter after PIM activation completes..."
fi

log "Signing in with Entra user (interactive)..."
az login --tenant "${AZURE_TENANT_ID}" --only-show-errors

log "Setting subscription to dev: ${AZURE_DEV_SUBSCRIPTION_ID}"
az account set --subscription "${AZURE_DEV_SUBSCRIPTION_ID}"

if [[ -n "${AZURE_DEV_RESOURCE_GROUP:-}" ]]; then
  log "Verifying read access to resource group: ${AZURE_DEV_RESOURCE_GROUP}"
  az group show --name "${AZURE_DEV_RESOURCE_GROUP}" --output none \
    || die "Cannot read RG — activate Reader PIM role or check group membership"
fi

log "Active account:"
az account show --query "{user:user.name, subscription:name, id:id}" --output table

log "Temporary CLI session ready. Token expires when PIM activation ends."
log "Run 'az logout' when finished."
