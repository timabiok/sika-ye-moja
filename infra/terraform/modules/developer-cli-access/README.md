# developer-cli-access

**Temporary Entra credentials for developers** — PIM eligible RBAC on **dev subscription only**, then interactive `az login` for CLI.

| Role (eligible) | Scope | CLI use |
|-----------------|-------|---------|
| `Reader` | Dev sub or RG | `az vm list`, `az network nsg show`, inventory |
| `AcrPush` | Dev ACR | `az acr login` + `podman push` from laptop |
| `Key Vault Secrets User` | Dev KV | `az keyvault secret show` for local dev |

**Not for:** UAT/prod subscriptions, standing Contributor, service principal secrets on laptops.

## Example

```hcl
module "developer_cli" {
  source = "../../modules/developer-cli-access"

  name_prefix               = "dev-data"
  developer_group_object_id = var.entra_group_platform_developers_id
  dev_subscription_id       = var.dev_subscription_id
  dev_resource_group_id     = azurerm_resource_group.dev.id
  acr_id                    = module.acr.acr_id
  key_vault_id              = module.kv.id
  pim_activation_max_hours  = 8
}
```

Developers: activate PIM → `./scripts/az-developer-login.sh`

See [docs/DEVELOPER-AZURE-CLI-ACCESS.md](../../../docs/DEVELOPER-AZURE-CLI-ACCESS.md).
