# Azure network architecture (industry-standard hub–spoke)

> **Engagement:** **Track B — stabilize network** ([ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md)). Use this doc for **target-state recommendations** and standards language. **Out of scope:** consultant builds hub, spoke, firewall, or network IaC in client Azure.

> **SOW:** Advisory reference only — items **1, 2, 4** (planning, standards, environment recommendations); [SOW.md](SOW.md). Client network **implements** via portal, Firewall Manager, or tickets. Discovery: [NETWORK-DISCOVERY-QUESTIONNAIRE.md](NETWORK-DISCOVERY-QUESTIONNAIRE.md).

> **Network not in IaC:** As-built from diagrams/IPAM/firewall exports → gaps in **risks + recommendations**, not `infra/terraform/`. See [When client network is not in IaC](NETWORK-DISCOVERY-QUESTIONNAIRE.md#when-client-network-is-not-in-iac).

In Azure, a **Virtual Network (VNet)** is the equivalent of an AWS **VPC**. The pattern below is the de facto enterprise and regulated-industry design (Microsoft Cloud Adoption Framework, Azure Landing Zones, and common OCC/FFIEC examiner expectations for segmentation and egress control).

This repo’s golden-image build VNet is a **special-purpose spoke**; production workloads typically land in separate spokes peered to a shared hub.

---

## High-level topology

```mermaid
flowchart TB
  subgraph onprem [On-premises / Partner]
    DC[Data center / Branch]
  end

  subgraph connectivity [Connectivity subscription]
    ER[ExpressRoute or VPN Gateway]
  end

  subgraph hub [Hub VNet — shared services]
    FW[Azure Firewall<br/>or NVA]
    DNS[Private DNS resolver<br/>or custom DNS]
    BAST[Azure Bastion]
    MON[Monitoring agents / jump]
  end

  subgraph spokes [Spoke VNets — workloads]
    S1[Spoke: Production apps]
    S2[Spoke: Non-prod / DevTest]
    S3[Spoke: Image build / CI]
    S4[Spoke: Data / Analytics]
  end

  subgraph paas [Azure PaaS — private access]
    KV[Key Vault]
    STG[Storage / Data Lake]
    SQL[Azure SQL / PostgreSQL]
    LA[Log Analytics]
  end

  DC <-->|Private circuit or IPsec| ER
  ER --> hub
  S1 & S2 & S3 & S4 -->|VNet peering<br/>gateway transit| hub
  S1 & S2 & S3 & S4 -.->|Private endpoints| paas
  hub -->|Forced tunneling<br/>0.0.0.0/0| FW
  FW -->|Inspected egress| Internet((Internet))
```

**Rules of thumb**

| Principle | Implementation |
|-----------|----------------|
| No spoke-to-spoke peering | Traffic between apps crosses the hub (firewall/NVA) |
| Single controlled egress | `0.0.0.0/0` → Azure Firewall in hub via UDR on spoke route tables |
| No public PaaS by default | Private endpoints + `privatelink.*` DNS zones |
| Segregate environments | Separate spokes (or subscriptions) per prod / non-prod |
| Identity over keys | Managed identities + RBAC to PaaS over connection strings |

---

## Hub VNet (shared services)

Typical hub address space: one `/16` or `/20` per region, carved into functional subnets.

```mermaid
flowchart LR
  subgraph hub_vnet [Hub VNet e.g. 10.0.0.0/16]
    direction TB
    GW[GatewaySubnet<br/>10.0.0.0/27]
    FW_SUB[AzureFirewallSubnet<br/>10.0.1.0/26]
    BAST_SUB[BastionSubnet<br/>10.0.2.0/26]
    DNS_SUB[DNS / Resolver<br/>10.0.3.0/24]
    MGMT[Management<br/>10.0.4.0/24]
  end

  ER_GW[ExpressRoute / VPN GW] --- GW
  FW[Azure Firewall] --- FW_SUB
  BAST[Azure Bastion] --- BAST_SUB
```

| Subnet | Purpose |
|--------|---------|
| `GatewaySubnet` | ExpressRoute or VPN gateway (required name/size) |
| `AzureFirewallSubnet` | Azure Firewall (minimum /26) |
| `AzureBastionSubnet` | Browser-based RDP/SSH without public VM IPs |
| DNS / resolver | Private DNS resolver inbound/outbound endpoints |
| Management | Jump boxes, automation, optional backup proxies |

---

## Spoke VNet (application landing zone)

Each workload or environment gets its own VNet (often its own subscription in landing-zone models).

```mermaid
flowchart TB
  subgraph spoke [Spoke VNet e.g. 10.10.0.0/16]
  subgraph tiers [Typical three-tier subnets]
    WEB[Web / App Gateway<br/>10.10.1.0/24]
    APP[Application tier<br/>10.10.2.0/24]
    DATA[Data tier<br/>10.10.3.0/24]
  end
  PE[Private endpoint subnet<br/>10.10.4.0/24]
  end

  HUB[Hub VNet + Firewall]
  AGW[Application Gateway + WAF<br/>optional DMZ in hub or spoke]
  PaaS[(PaaS via private link)]

  AGW --> WEB
  WEB --> APP
  APP --> DATA
  APP & DATA -.-> PE
  PE --- PaaS
  spoke -->|Peering + UDR default route| HUB
```

| Tier | Controls |
|------|----------|
| Web | NSG allow 443 from App Gateway only; no direct Internet inbound to VMs |
| App | NSG allow only from web subnet; outbound via hub firewall |
| Data | Deny Internet; allow app tier only; private endpoints for databases |
| Private endpoints | Dedicated subnet(s) for `Microsoft.*` private link NICs |

---

## Routing and traffic flow

```mermaid
sequenceDiagram
  participant VM as VM in spoke
  participant RT as Spoke route table UDR
  participant Hub as Hub firewall
  participant Dest as Internet or other spoke

  VM->>RT: Egress packet
  RT->>Hub: 0.0.0.0/0 via peering to firewall IP
  Hub->>Hub: Policy / TLS inspect / FQDN filter
  alt Allowed
    Hub->>Dest: Forward
  else Denied
    Hub-->>VM: Drop + log
  end
```

| Route table association | Route | Next hop |
|-------------------------|-------|----------|
| Spoke app subnet | `0.0.0.0/0` | Virtual appliance (firewall private IP in hub) |
| Spoke app subnet | `10.0.0.0/8` (corporate) | Virtual network gateway (via hub) |
| Hub | System routes + optional BGP from ExpressRoute | — |

Enable **gateway transit** on hub peering so spokes use the hub’s ExpressRoute/VPN gateway for hybrid connectivity.

---

## Private DNS and PaaS connectivity

```mermaid
flowchart LR
  subgraph vnets [VNets linked to Private DNS zone]
    H[Hub]
    S1[Spoke prod]
    S2[Spoke nonprod]
  end

  subgraph zones [Private DNS zones]
    Z1[privatelink.blob.core.windows.net]
    Z2[privatelink.vaultcore.azure.net]
    Z3[privatelink.database.windows.net]
  end

  PE[Private endpoint NICs]
  PaaS[(Azure PaaS)]

  H & S1 & S2 --> zones
  PE --- PaaS
  zones --> PE
```

- Create one private DNS zone per PaaS type; link to **all** VNets that must resolve the private endpoint.
- Avoid public endpoints for storage, Key Vault, SQL, etc., in regulated workloads.
- This repo’s **image-build spoke** uses the same pattern for script storage and optional Key Vault during AIB builds.

---

## Landing zone subscriptions (optional scale-out)

Large banks often mirror this logical diagram across **management group** hierarchy:

```mermaid
flowchart TB
  MG[Management group — policies & guardrails]
  MG --> CONN[Connectivity sub<br/>hub, ER, VPN, firewall]
  MG --> ID[Identity sub<br/>Entra ID / AD DS if needed]
  MG --> MGMT[Management sub<br/>Log Analytics, Automation]
  MG --> CORP[Corp sub<br/>shared services]
  MG --> LANDING[Landing zone subs]
  LANDING --> PROD[Production spokes]
  LANDING --> NP[Non-production spokes]
```

---

## How this repo fits

| Component in **sika-ye-moja** | Network role | In scope? |
|-------------------------------|--------------|-----------|
| `modules/build-network` | Optional image-build spoke | Reference only; **out of scope** consultant apply |
| This hub–spoke doc | Target-state for **stabilize network** standards | **Advisory** |
| Client prod VM (Workshop 1) | Lives in **existing** manual VNet | Client documents as-built |

Production VMs belong in **app spokes** behind hub policy long term. **Stabilize network** now = document current VNet, fix egress/DNS/firewall for RHEL workloads; **greenfield hub** = Phase 6 / change order, not default SOW.

---

## Reference patterns

Full authority map: [INDUSTRY-REFERENCES.md](INDUSTRY-REFERENCES.md)

- [Azure landing zone — network topology](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity)
- [Hub-spoke network topology](https://learn.microsoft.com/azure/architecture/networking/architecture/hub-spoke)
- [Azure Firewall as forced tunnel](https://learn.microsoft.com/azure/firewall/firewall-multi-virtual-network)
- [Microsoft Cloud Security Benchmark — network](https://learn.microsoft.com/en-us/security/benchmark/azure/security-controls-v3-network-security)
- [FFIEC IS Handbook](https://ithandbook.ffiec.gov/)
