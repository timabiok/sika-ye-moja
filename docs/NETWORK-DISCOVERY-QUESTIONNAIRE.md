# Network team discovery questionnaire

> **Engagement:** **Stabilize network** for existing **RHEL on Azure** workloads — document as-built, identify blockers, recommend controls. **Not** build hub/spoke or network IaC in client tenant. Master scope: [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md).

**Purpose:** Track B discovery — network requirements and gaps for **RHEL + Podman** (Snowflake / data platform), aligned with [SOW.md](SOW.md) (contract items **1–6**), [CHARTER-ADDENDUM.md](CHARTER-ADDENDUM.md), and [STRATEGY-POST-RHEL.md](STRATEGY-POST-RHEL.md).

**Audience:** Client network / cloud networking / security architecture teams.

**How to use:** Use only questions marked **In scope**, **Client-owned**, or **Advisory**. **Out of scope** = consultant does not implement.

---

## Scope legend

| Tag | Meaning |
|-----|---------|
| **In scope** | Consultant documents answers and drives recommendations, standards, risks, cutover guidance, or KT per SOW. |
| **Client-owned** | Must be asked in discovery; **client executes or decides**. Consultant does not implement or own outcome. |
| **Advisory** | Consultant may recommend or draft standards/runbooks; **client implements** in production. |
| **Out of scope** | Do **not** expand engagement to cover; redirect to client app, GRC, ops, or separate SOW. |

---

## SOW quick reference (contract items 1–6)

| SOW item | Contract scope | Track B in this engagement |
|----------|----------------|------------------------------|
| **1** | Migration planning and technical guidance | As-built review, RACI, environment scope |
| **2** | RHEL standards & best practices | Network controls **for** RHEL workloads (draft) |
| **3** | Risk identification and mitigation | Network risk register entries |
| **4** | Environment improvement recommendations | PE, build spoke, egress recommendations |
| **5** | Cutover support | Network runbook **draft**; support in agreed window |
| **6** | Knowledge transfer & support planning | KT on network runbooks; post-KT ownership |

| In scope (consultant) | Out of scope (client / change order) |
|-----------------------|--------------------------------------|
| Network **requirements**, allow-list **draft**, risks, runbook **drafts** | Firewall/peering/PE **implementation**, hub greenfield, network Terraform in client sub, SOC deploy, audit sign-off |
| Parallel Track A (RHEL + Podman stabilize) | App remediation, license purchase, DR **execution** |

Master mapping: [ENGAGEMENT-ALIGNMENT.md — SOW contract baseline](ENGAGEMENT-ALIGNMENT.md#sow-contract-baseline-fortified-data-743101). Original contract: [SOW.md](SOW.md).

---

## When client network is not in IaC

**Typical for this engagement:** Hub, spoke, firewall, peering, NSG, and private endpoints are built and changed via **Azure Portal, Firewall Manager, tickets, or vendor runbooks**—not Terraform/Bicep in the client’s (or this) repo. Workshop 1 also noted **manual** server provisioning.

That is **expected**. It does **not** block discovery or the RHEL uplift strategy ([STRATEGY-POST-RHEL.md](STRATEGY-POST-RHEL.md)).

### What the consultant does instead

| Activity | Use as input | Do not do |
|----------|--------------|-----------|
| Discovery | Visio/diagram, IPAM spreadsheet, firewall export, portal screenshots, change tickets | Wait for network Terraform or recreate hub in this repo |
| Gaps | **Risk register** + **recommendations** with owner (Network, DNS, Platform) | Imply consultant will apply rules in production |
| Standards | “RHEL/Podman workloads **require** these network controls” | Mandate client adopt Terraform for network |
| Reference IaC in repo | Build spoke, SIG, VM patterns for **platform** team | Replace client’s entire landing zone |

### Classify every discovery finding

| Bucket | Example | Consultant output | Implementer |
|--------|---------|-------------------|---------------|
| **Platform IaC** | VM, disk, SIG, image-build VNet module | Reference in repo; client forks | Client platform |
| **Network config (manual)** | Missing UDR, firewall deny, wrong PE DNS link | Allow-list doc, annotated diagram, ticket text | Client network |
| **Process** | 6-week CAB, no IPAM owner | Risk + RACI | Client PM / network lead |
| **Architecture** | Flat VNet, spoke-to-spoke | Target-state memo ([AZURE-NETWORK-ARCHITECTURE.md](AZURE-NETWORK-ARCHITECTURE.md)) | Client architect |
| **App / data path** | Snowflake, trading platform egress | Dependency in cutover plan | App + network |
| **Out of SOW** | Greenfield hub, SOC, pen test | Deferred / change order | Client or vendor |

### Extra questions when network is manual

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| M1 | **Client-owned** | How are VNets, peerings, NSGs, and firewall rules **documented and changed** today (portal, vendor, ticket system)? | Defines how recommendations are delivered |
| M2 | **Client-owned** | Who can provide an **as-built** export (diagram, IPAM, rule matrix) without IaC? | Discovery blocker |
| M3 | **In scope** | For each RHEL change (build, UAT, patch), what is the **network change ticket** template and SLA? | Schedules migration |
| M4 | **Advisory** | Which network changes are **blockers** vs **nice-to-have** for UAT/prod? | Prioritized backlog |
| M5 | **Out of scope** | Will client adopt **network IaC** later? | Optional future-state note only—not consultant build |

### Finding log template (copy per item)

```text
ID:
Title:
Bucket: Platform IaC | Network manual | Process | Architecture | App | Out of SOW
Blocks: UAT | Prod | Image build | None
Recommendation:
Owner (team):
Client ticket #:
Consultant doc reference:
```

### Client-facing line

*“We are not rebuilding your network in Terraform. We need your as-built and network changes as client-owned work, while we standardize RHEL and Podman on top of the network you already have.”*

---

## 1. Engagement alignment

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 1.1 | **In scope** | Who is the **primary decision-maker** for network changes (CAB approver)? | SOW requires client coordinator. |
| 1.2 | **In scope** | Agree written **RACI**: network vs platform vs app vs consultant for migration? | Prevents scope creep (SOW: no app remediation). |
| 1.3 | **In scope** | Which environments are in scope (**prod, DR, UAT, dev**)? **Freeze / blackout** dates? | Migration planning (SOW item 1). |
| 1.4 | **Client-owned** | Provide existing **documentation** (IPAM, firewall matrix, diagrams, IaC repos). | Client access obligation; consultant consumes. |
| 1.5 | **In scope** | What **network-level success criteria** define “migration complete” for each wave? | Aligns cutover support (SOW item 5). |
| 1.6 | **Out of scope** | Business **application** acceptance criteria (functional test cases)? | **App team** — not network discovery. |

---

## 2. Azure landing zone & topology

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 2.1 | **In scope** | **As-built** model: hub–spoke, vWAN, or flat VNets? Where will **migrated RHEL** and **image-build** attach? | Planning + standards (SOW items 1–2). |
| 2.2 | **Advisory** | **Address space** standards and a non-overlapping block for image-build spoke (e.g. /26). | Recommendation; **client allocates** in IPAM. |
| 2.3 | **In scope** | **Spoke-to-spoke** allowed or hub-only east–west? | Risk + standards documentation. |
| 2.4 | **Client-owned** | Approved **regions** and **data residency** (US-only, etc.)? | Client policy; consultant designs within constraints. |
| 2.5 | **In scope** | Existing **Azure Policy** affecting VMs (no public IP, Trusted Launch, Image Builder)? | Risk identification (SOW item 3). |
| 2.6 | **Out of scope** | **Greenfield** design and build of entire hub/spoke landing zone? | Only **recommendations** unless change order; **client implements**. |
| 2.7 | **Out of scope** | **Procurement** of ExpressRoute circuits or hardware? | Client / telecom vendor. |

---

## 3. Hybrid connectivity & egress

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 3.1 | **Client-owned** | **ExpressRoute / VPN** as-built; who owns connectivity subscription? | Consultant needs facts; **client operates**. |
| 3.2 | **In scope** | **Gateway transit** on hub peering for spokes? | Blocks hybrid access if wrong. |
| 3.3 | **In scope** | **Default egress** path (UDR → firewall/NVA vs direct)? | Image build + patching risk (SOW item 3). |
| 3.4 | **Advisory** | Draft **firewall allow-list** for RHEL build/patch (Red Hat, Microsoft, storage, AIB). | Consultant recommends; **client implements** rules. |
| 3.5 | **In scope** | **Mandatory HTTP proxy**? PAC URL and required exceptions? | Migration / image-build risk. |
| 3.6 | **In scope** | **Forced tunneling** to on-prem for all Internet? | Risk if build/patch paths unclear. |
| 3.7 | **Out of scope** | **Implementing** or **tuning** Azure Firewall / NVA rulebases long-term? | Client network ops (consultant advises only). |

---

## 4. Golden image build network (Azure Image Builder)

*Reference IaC: [ARCHITECTURE.md](ARCHITECTURE.md) — illustrative; deployment is **client-owned** unless contracted.*

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 4.1 | **Advisory** | **Dedicated build spoke** vs shared CI VNet? | Standard recommendation (SOW item 2). |
| 4.2 | **Client-owned** | Approve **subnet** for AIB staging (e.g. /26) and **peering/UDR** implementation? | Client provisions network. |
| 4.3 | **In scope** | **Inbound** policy for build subnet (deny-all recommended)? | Hardening standard. |
| 4.4 | **Advisory** | **Private endpoint** for build script storage + DNS linkage approved? | Environment recommendation (SOW item 4). |
| 4.5 | **Client-owned** | Who owns **Private DNS zones** (`privatelink.blob`, `privatelink.vaultcore`) and VNet links? | Client DNS team executes. |
| 4.6 | **Client-owned** | Is **Microsoft.VirtualMachineImages** registered and allowed by policy? | Client subscription governance. |
| 4.7 | **Client-owned** | **CAB process** for firewall/peering/PE changes; lead time? | Client change management. |
| 4.8 | **Out of scope** | Consultant **terraform apply** in client production subscription? | Reference code in repo only unless change order. |
| 4.9 | **Out of scope** | **Operating** image pipeline on-call 24×7 after KT? | Client platform ops. |

---

## 5. DNS, NTP, and identity

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 5.1 | **In scope** | **DNS** model for RHEL VMs (Azure, resolver, on-prem AD forward)? | Golden image + migration planning. |
| 5.2 | **In scope** | Required **NTP** sources for CIS/compliance? | RHEL standard (SOW item 2). |
| 5.3 | **Client-owned** | **AD / Entra** join required (SSSD)? OU, GPO, Kerberos constraints? | **Identity team**; consultant captures requirements for image. |
| 5.4 | **Advisory** | **PTR / reverse DNS** requirements? | Recommend in standards; client DNS implements. |
| 5.5 | **Out of scope** | **Designing** enterprise Active Directory or Entra tenant? | Identity architecture — separate engagement. |
| 5.6 | **Advisory** | **Developer CLI access** — Entra group + PIM eligible roles on **dev sub** (`Reader`, `AcrPush`, `KV Secrets User`)? Max activation hours? | Developers use `az login` after PIM — [DEVELOPER-AZURE-CLI-ACCESS.md](DEVELOPER-AZURE-CLI-ACCESS.md); module `developer-cli-access`. |
| 5.6b | **Advisory** | **Consultant / network engineer** portal read — PIM eligible `Reader` only? | Track B discovery — separate from developer CLI roles. |
| 5.7 | **Client-owned** | **Access review / offboarding** date when vendor engagement ends? | Remove PIM eligibility and guest accounts; audit trail for examiners. |
| 5.8 | **Advisory** | **Entra ID SSH** or Bastion for Linux jump — per-user only? | Aligns human Azure access with VM admin model; no shared `deploy` passwords. |

---

## 6. Security, segmentation, and compliance

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 6.1 | **In scope** | Required OS baseline (**CIS L1/L2, STIG**, internal standard)? | RHEL standards doc (SOW item 2). |
| 6.2 | **Client-owned** | **FIPS 140** required for which workloads? | **Client + app teams** test compatibility (SOW assumption). |
| 6.3 | **Advisory** | **NSG / ASG** patterns per tier for RHEL spokes? | Standards recommendation; client implements. |
| 6.4 | **In scope** | **Public IPs** on VMs allowed? Bastion / jump model? | Migration admin access planning. |
| 6.5 | **Out of scope** | **Deploying** DDoS Standard on all VNets? | Client implements if policy requires. |
| 6.6 | **Out of scope** | **Implementing** micro-segmentation products (Illumio, NSX, etc.)? | Client security vendor scope. |
| 6.7 | **Advisory** | **Evidence** expectations (flow logs, firewall log retention) for audits? | Recommend; **GRC/audit** owns sign-off ([COMPLIANCE.md](COMPLIANCE.md) is informational only). |
| 6.8 | **Out of scope** | Formal **regulatory examination** or **PCI ROC** attestation? | Client GRC / QSA. |

---

## 7. Secrets, RHSM, and PaaS private access

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 7.1 | **Client-owned** | **RHEL licensing** model (BYOS, Satellite)? Who stores **activation keys** in Key Vault? | **SOW: client obtains licensing.** |
| 7.2 | **Advisory** | Network path for build VMs to **Key Vault** (PE, firewall)? | Recommendation; client implements. |
| 7.3 | **Client-owned** | **Satellite / internal repo** URLs and ports vs public CDN? | Client owns repo architecture. |
| 7.4 | **Advisory** | **Managed identity** pattern for RHEL VMs (per-app UAMI)? | Standards (SOW item 2); client implements RBAC. |
| 7.5 | **Out of scope** | **Purchasing** Red Hat subscriptions or **legal** review of license terms? | Client procurement / legal. |

---

## 8. Migration & cutover (network impact)

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 8.1 | **In scope** | **Same IP** required vs new NIC / LB backend? | Cutover planning (SOW items 1 and 5). |
| 8.2 | **Client-owned** | **Load balancer / App Gateway** config changes—who executes? | Network/app teams; consultant **supports** (SOW item 5). |
| 8.3 | **In scope** | **Firewall rule deltas** when moving Ubuntu → RHEL (agents, ports)? | Risk identification (SOW item 3). |
| 8.4 | **Advisory** | **Blue/green** temporary subnets or parallel rules needed? | Recommendation; client implements. |
| 8.5 | **In scope** | **Rollback** network steps (DNS, LB)? **RTO/RPO** expectations? | Cutover support planning. |
| 8.6 | **Client-owned** | Approved **maintenance window** length per tier? | Client CAB / business. |
| 8.7 | **Out of scope** | **Application** load testing, performance tuning, or code fixes during cutover? | **Application remediation** — out of SOW. |
| 8.8 | **Out of scope** | **Database** migration or schema changes? | Out of OS migration scope. |

---

## 9. Observability & operations

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 9.1 | **Advisory** | **SIEM** agents: install in golden image vs post-deploy? Required egress to collectors? | Standard recommendation; **client SOC** operates SIEM. |
| 9.2 | **Out of scope** | **Deploying** Sentinel/Splunk/QRadar or writing detection rules? | Client SOC / separate SOW. |
| 9.3 | **Client-owned** | **Firewall ticket** process and SLA for rule changes? | Client operations. |
| 9.4 | **In scope** | **Escalation contacts** for migration weekend (network L2/L3)? | Post-implementation support (SOW item 5). |
| 9.5 | **Out of scope** | **24×7 NOC** for client production after engagement? | Client ops unless MSSP contract. |

---

## 10. Governance, change control, and knowledge transfer

| # | Scope | Question | Why it matters |
|---|--------|----------|----------------|
| 10.1 | **Client-owned** | **CAB** cadence and lead time? | Client governance. |
| 10.2 | **In scope** | Who **maintains network IaC** after KT? | Support planning (SOW item 6). |
| 10.3 | **In scope** | Which **runbooks** to create/update (peering, PE, cutover, image rebuild)? | Knowledge transfer (SOW item 6). |
| 10.4 | **Client-owned** | Named **successors** for firewall policy and IPAM? | Client org design. |
| 10.5 | **Out of scope** | **Staff augmentation** (consultant embedded as network engineer for 12 months)? | Advisory SOW — not staff aug unless contracted. |

---

## 11. Risk register inputs (in scope to document; client mitigates)

Consultant maintains **network-related risks** (SOW item 3). Client owns remediation.

| Risk | Scope of consultant action |
|------|----------------------------|
| Firewall blocks image build / patch / RHSM | Document; advise allow-list |
| Private endpoint DNS not linked to build VNet | Document; advise fix |
| FIPS breaks applications | **Flag only** — app compatibility is **client-owned** |
| Forced tunneling blocks AIB endpoints | Document; advise path |
| Policy blocks Image Builder / Trusted Launch | Document; advise exception process |
| Overlapping CIDR / insufficient IP space | Document; advise IPAM change |
| CAB lead time exceeds migration timeline | Document; advise schedule |
| Expectation that consultant fixes **application** issues | **Redirect** — out of SOW |
| Network exists only in portal/tribal knowledge (no IaC) | Document as-built; **do not** block on Terraform |
| Discovery finds issues IaC cannot fix (process, architecture) | Classify per buckets above; **recommendations** not repo modules |

---

## 12. Deliverables checklist (consultant vs client)

| Deliverable | SOW item | Consultant | Client network / platform |
|-------------|-------|--------------|-------------------------|
| Discovery summary & RACI | 1 | ✓ Author | ✓ Review / approve |
| RHEL-on-Azure **network standards** (draft) | 2 | ✓ Author | ✓ Approve / adopt |
| Network risk register | 3 | ✓ Maintain | ✓ Mitigate owned items |
| Environment **recommendations** (PE, build spoke, egress) | 4 | ✓ Advise | ✓ Implement |
| Cutover **network runbook** (draft) | 5 | ✓ Author; support in window | ✓ Execute |
| KT sessions & runbook handoff | 6 | ✓ Deliver | ✓ Attend; operate |
| Hub–spoke **terraform apply** in prod | — | ✗ Unless CO | ✓ |
| Firewall rule **implementation** | — | ✗ Advise only | ✓ |
| Application remediation | — | ✗ Out of scope | ✓ App teams |
| RHEL license purchase | — | ✗ Out of scope | ✓ Client |

---

## 13. Questions to decline or redirect (out of scope)

Use this list when workshops drift. Polite redirect: *“That’s out of this engagement per SOW; we can note it as a dependency for [team].”*

- Fix application bugs, middleware config, or JVM/crypto stacks after FIPS  
- Run QA/UAT test suites or sign off business functionality  
- Buy RHEL subscriptions or negotiate Red Hat contracts  
- Perform backups/restores or DR tests (client executes)  
- Build greenfield hub, ExpressRoute, or firewall from scratch (without change order)  
- Operate SIEM/SOC, write detections, or respond to incidents 24×7  
- Provide legal, PCI, OCC, or audit attestation  
- Penetration test or red team  
- On-call as primary network engineer after KT period ends  

---

## Related project docs

| Doc | Scope note |
|-----|------------|
| [SOW.md](SOW.md) | Original contract (items 1–6); charter aligns discovery |
| [ARCHITECTURE.md](ARCHITECTURE.md) | **Reference** golden-image design — not an implied deploy obligation |
| [AZURE-NETWORK-ARCHITECTURE.md](AZURE-NETWORK-ARCHITECTURE.md) | **Reference** hub–spoke patterns |
| [COMPLIANCE.md](COMPLIANCE.md) | **Informational** — not legal or audit sign-off |
| [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md) | Master scope — start here |
| [STRATEGY-POST-RHEL.md](STRATEGY-POST-RHEL.md) | Phased plan; network = recommend, client implements |
