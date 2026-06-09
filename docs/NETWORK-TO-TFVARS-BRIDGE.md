# Network as-built → Terraform tfvars bridge

> Client platform fills this from PDF diagram + Azure Reader inventory. Maps **manual** network to **layer 2** IaC.

---

## Template (copy to `workload/terraform.tfvars`)

```hcl
# --- From client as-built diagram (Anatoliy / Patrick) ---

runner_subnet_id  = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<ci-subnet>"
runtime_subnet_id = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<app-subnet>"

# Static IPs — allocate from IPAM; document in firewall
runner_private_ip_address  = "10.x.x.10"
runtime_private_ip_address = "10.x.x.20"

# NSG inbound — Bastion/jump subnet CIDR
bastion_subnet_prefix = "10.x.x.0/24"

# Optional — APIM fronting runtime APIs
# apim_subnet_prefix = "10.x.x.0/24"

acr_id       = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.ContainerRegistry/registries/<acr>"
key_vault_id = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<kv>"
```

---

## Mapping checklist

| As-built item | tfvars variable | ClickUp |
|---------------|-----------------|---------|
| CI/build subnet ARM ID | `runner_subnet_id` | #4 |
| App/data subnet ARM ID | `runtime_subnet_id` | #4 |
| Bastion subnet CIDR | `bastion_subnet_prefix` | #5 |
| APIM subnet CIDR | `apim_subnet_prefix` | W2-Q1 |
| ACR resource ID | `acr_id` | W2-Q2 |
| Key Vault ID | `key_vault_id` | §7 |
| SIG image version | `sig_image_version_id` | Layer 1 output |

---

## Hub firewall vs NSG

| Control plane | This repo | Client |
|---------------|-----------|--------|
| NSG on NIC | `nsg-baseline` module | Apply via workload stack |
| Hub firewall egress | [EGRESS-ALLOW-LIST.md](EGRESS-ALLOW-LIST.md) | CAB ticket |
| Peering / UDR | Not in repo | Network team |

---

## Document history

| Version | Date |
|---------|------|
| 0.1 | 2026-05-28 |
