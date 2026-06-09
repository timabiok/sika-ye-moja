# acr-baseline

Banking prescriptive **Azure Container Registry**:

- **Premium SKU** (private endpoint, retention, quarantine, geo-replication)
- **Admin disabled** — UAMI `AcrPush` / `AcrPull` only
- **Public access disabled** — private endpoint for runner/runtime subnets
- **Quarantine policy** — scan-before-use (Defender for Containers)
- **Retention** — untagged manifest cleanup

## Example

```hcl
module "acr" {
  source = "../../modules/acr-baseline"

  name_prefix                = "uat-data"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.app.name
  acr_name                   = "uatdataplatformacr"
  private_endpoint_subnet_id = var.private_endpoint_subnet_id
  private_dns_zone_ids       = [var.acr_private_dns_zone_id]
}
```

Wire `module.acr.acr_id` into `layer2-workload-stack` `acr_id`.
