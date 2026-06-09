# monitor-baseline

Banking prescriptive **Azure Monitor** for Linux VMs:

- **Data Collection Rule (DCR):** syslog (auth/daemon/kern) + performance counters → Log Analytics
- **UAMI RBAC:** `Monitoring Metrics Publisher` on DCR
- **VM extension:** `AzureMonitorLinuxAgent` (wired via `compute-linux` `enable_azure_monitor`)

Golden image (Layer 1) installs prerequisites + rsyslog config via Ansible `azure_monitor.yml`.  
Layer 2 Terraform attaches DCR + extension at deploy.

## Egress (add to firewall allow-list)

- `*.ods.opinsights.azure.com` (443)
- `*.oms.opinsights.azure.com` (443)
- `dc.services.visualstudio.com` (443)

## Example

```hcl
module "monitor" {
  source = "../../modules/monitor-baseline"

  name_prefix                = "uat-data"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.app.name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  vm_identity_principal_ids  = [
    azurerm_user_assigned_identity.runner.principal_id,
    azurerm_user_assigned_identity.runtime.principal_id,
  ]
}
```
