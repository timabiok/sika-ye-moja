# Charter addendum — engagement alignment

**Parties:** Client PM + Vaco consultant  
**Purpose:** Align [SOW.md](SOW.md) contract language to confirmed discovery (Workshop 2).  
**Status:** Draft for client signature.

---

## Agreed facts (supersedes Workshop 1 prod assumptions)

| Item | Confirmed |
|------|-----------|
| Production Linux | **None today** |
| Dev container runtime | **Podman** (not Docker) |
| Path | Stabilize **dev** → **UAT** → **first prod Linux** (greenfield) |
| Azure network | **Manual** — client implements firewall/NSG/peering |
| Consultant deploy | **Reference IaC + advisory** — client `terraform apply` |

---

## Scope adjustment

| SOW wording | Agreed delivery |
|-------------|-----------------|
| Ubuntu → RHEL migration | **RHEL + Podman operational uplift** on dev; UAT/prod **design + reference IaC** |
| Prod VM assessment | **Dev Podman assessment** + UAT/prod design |
| Standards | **RHEL + Podman + GitHub Actions** standards v0.1 |
| Network | **Allow-list draft + requirements** — client implements |

---

## Deliverables (maps to SOW contract items 1–6)

| SOW item | Deliverable | Artifact |
|----------|-------------|----------|
| **1** | Migration / stabilization plan | [STRATEGY-POST-RHEL.md](STRATEGY-POST-RHEL.md), [NEXT-STEPS.md](NEXT-STEPS.md) |
| **2** | RHEL + Podman standards | [STANDARDS-RHEL-PODMAN-v0.1.md](STANDARDS-RHEL-PODMAN-v0.1.md) |
| **3** | Risk register | [RISK-REGISTER-v1.md](RISK-REGISTER-v1.md) |
| **4** | Environment improvement recommendations | [EGRESS-ALLOW-LIST.md](EGRESS-ALLOW-LIST.md), [NETWORK-IAM-STANDARDS.md](NETWORK-IAM-STANDARDS.md), [VM-DESIGN-CONSIDERATIONS.md](VM-DESIGN-CONSIDERATIONS.md) |
| **5** | Cutover support + runbook drafts | Agreed cutover window (client executes) |
| **6** | Knowledge transfer & support planning | Reference IaC KT (`infra/terraform/`, [ARCHITECTURE.md](ARCHITECTURE.md)); [DELIVERABLES-CHECKLIST.md](DELIVERABLES-CHECKLIST.md) |

**SOW boundary (unchanged):** Additional security, monitoring, or automation enhancements are **out of scope unless defined** in the contract. Reference monitoring/build modules in this repo are **draft patterns for items 2, 4, and 6** — client deploys SIEM, Logic Monitor, and prod changes.

---

## Explicitly out of scope (no change order unless agreed)

- Application remediation, APIM build, pen test execution
- Client firewall/NSG **implementation**
- Consultant `terraform apply` in client prod
- RHEL license procurement, 24×7 ops, SIEM deploy

---

## Sign-off

| Role | Name | Date |
|------|------|------|
| Client PM | | |
| Client platform (Patrick) | | |
| Vaco lead | | |
