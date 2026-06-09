# Egress allow-list draft v0.1

> **SOW item 4** — environment improvement recommendations. **Client implements** on hub firewall / NSG. Consultant draft for CAB submission.

---

## GitHub runner VM

| Destination | FQDN / tag | Port | Purpose |
|-------------|------------|------|---------|
| GitHub | `github.com`, `api.github.com`, `codeload.github.com`, `objects.githubusercontent.com` | 443 | Actions, clone, artifacts |
| Azure AD | `login.microsoftonline.com` | 443 | UAMI / OIDC |
| Azure ARM | `management.azure.com` | 443 | `az acr login`, deploy |
| ACR | `<acr>.azurecr.io` | 443 | Image **push** |
| Key Vault | `<kv>.vault.azure.net` | 443 | Secrets |
| RHSM | `subscription.rhsm.redhat.com` | 443 | Patching |
| NTP | `169.254.169.254` (Azure) | 123 | chrony |
| Azure Monitor | `*.ods.opinsights.azure.com`, `*.oms.opinsights.azure.com`, `dc.services.visualstudio.com` | 443 | AMA → Log Analytics (DCR) |

---

## Podman runtime VM

| Destination | FQDN / tag | Port | Purpose |
|-------------|------------|------|---------|
| Snowflake | `*.snowflakecomputing.com` | 443 | Data platform |
| ACR | `<acr>.azurecr.io` | 443 | Image **pull** |
| Key Vault | `<kv>.vault.azure.net` | 443 | App secrets |
| RHSM | `subscription.rhsm.redhat.com` | 443 | Patching |
| SFTP peers | _[client IPs/FQDNs]_ | 22 | Ingestion |
| Charles River | _[client endpoints]_ | 443 | Trading APIs |
| Azure Files | `privatelink.file.core.windows.net` | 443/2049 | Optional NFS share |
| Azure AD / ARM | `login.microsoftonline.com`, `management.azure.com` | 443 | UAMI |
| Azure Monitor | `*.ods.opinsights.azure.com`, `*.oms.opinsights.azure.com`, `dc.services.visualstudio.com` | 443 | AMA → Log Analytics (DCR) |

**Not required on runtime:** `github.com` (no CI on runtime VM).

---

## Shared deny

| Traffic | Action |
|---------|--------|
| Inbound from Internet | **Deny** (except via APIM path to runtime) |
| Outbound RDP/SSH to Internet | **Deny** |
| Metadata | **Allow** `169.254.169.254` (UAMI) |

---

## Industry references

Full map: [INDUSTRY-REFERENCES.md](INDUSTRY-REFERENCES.md)

| Topic | Source |
|-------|--------|
| Egress control (banking) | [FFIEC IS Handbook](https://ithandbook.ffiec.gov/) — data flow and network monitoring |
| Azure outbound / firewall | [Azure Firewall documentation](https://learn.microsoft.com/en-us/azure/firewall/overview) · [MCSB network security](https://learn.microsoft.com/en-us/security/benchmark/azure/security-controls-v3-network-security) |
| Private endpoints | [Private Link overview](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) |
| Azure Monitor egress | [Azure Monitor Agent](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview) |
| RHSM patching | [Red Hat subscription management](https://access.redhat.com/products/red-hat-subscription-management) |

---

## Document history

| Version | Date | Notes |
|---------|------|-------|
| 0.1 | 2026-05-28 | Runner vs runtime split |
| 0.2 | 2026-05-28 | Azure Monitor AMA egress (both VMs) |
