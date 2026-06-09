# Next steps plan

> **Based on:** [SOW.md](SOW.md) (contract) · [CHARTER-ADDENDUM.md](CHARTER-ADDENDUM.md) · [discovery-workshop-2.md](discovery-workshop-2.md) · [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md)

**Last updated:** _[date]_

**Confirmed:** **No production Linux environments.** **Dev hosts = Podman.** Path: **dev → UAT → prod**.

---

## Executive summary

| Fact | Implication |
|------|-------------|
| **No prod Linux** | No in-place prod hardening; **greenfield** UAT then prod |
| **Dev = Podman** | Standards target **Podman + systemd**, not Docker |
| **Deploy manual** | Priority: registry (ACR vs GHCR) + CI/CD automation |
| **Hybrid stack** | Dagster, dbt, Snowflake, data center, trading APIs |
| **Shared admin** | P0 security — Entra/per-user (client) |

**Consultant focus:** Assess **dev Podman** → standards → **UAT/prod Linux design** → network allow-list — **not** APIM build or pen test execution.

**Deliverable tracker:** [DELIVERABLES-CHECKLIST.md](DELIVERABLES-CHECKLIST.md)

---

## Phase 0 — This week

| # | Action | Owner | Status |
|---|--------|--------|--------|
| 0.1 | ~~Reconcile prod Linux~~ | — | **Done** — no prod Linux |
| 0.2 | **PDF architecture diagram** in ClickUp | Anatoliy | Pending |
| 0.3 | **Podman** walkthrough: build → store → deploy | Tim + Anatoliy | Pending |
| 0.4 | **SSH/Bastion** to **dev** Linux host(s) | Letron / Patrick | **Done** — Tim has Linux VM access |
| 0.4b | **Azure subscription** read access (dev + prod subs) | Patrick / platform | **Pending** — Tim needs RBAC |
| 0.5 | **Charter addendum** — dev Podman → UAT → prod | Tim | Pending |

**Exit:** Diagram dated; **Azure RBAC** granted or dated; charter sent.

### Azure access request (send to Patrick / platform)

**Developers (CLI):** PIM eligible roles on **dev sub** + `./scripts/az-developer-login.sh` — [DEVELOPER-AZURE-CLI-ACCESS.md](DEVELOPER-AZURE-CLI-ACCESS.md). Module: `developer-cli-access`.

**Consultant (Track B portal):** individual Entra user + **PIM eligible** `Reader` — [NETWORK-IAM-STANDARDS.md](NETWORK-IAM-STANDARDS.md).

| Need | Suggested RBAC | Activation model | Why |
|------|----------------|------------------|-----|
| Dev + prod **subscriptions** | `Reader` (eligible, not active) | PIM JIT — MFA, ≤8h, optional approver | NSG, VNet, PE, peering inventory for Track B |
| Consultant identity | Entra **guest** (`user@vaco.com`) | Invite + eligible role only | Individual attribution; revoke at engagement end |
| Log Analytics / Monitor | `Reader` on workspace if separate | Same PIM pattern | Monitoring discovery |
| Optional | `Virtual Machine Contributor` | **Do not grant** for assess | Consultant documents only — client implements |
| Deny | Owner, UAA, Contributor, KV secrets, permanent Reader | — | Least privilege; banking access-review norms |

**Offboarding:** Patrick/platform removes PIM eligibility + guest account within 5 business days of engagement end.

**Without Azure access:** Linux VM assessment (Track A) can proceed; Track B (network, hybrid diagram validation) is **limited** to PDF + client exports.

---

## Phase 1 — Weeks 1–3 (assess dev Podman)

### Track A

| # | Action | Owner |
|---|--------|--------|
| 1.1 | Deep-dive **dev** hosts: RHEL, Podman, systemd units, volumes, SELinux | Tim assess |
| 1.2 | Inventory containers/services (Gorobi, ingestion, APIs) | Anatoliy |
| 1.3 | Document deploy path: GitHub runner VM → registry → Podman runtime VM (confirm vs current combined host) | Tim |
| 1.4 | **Registry** recommendation (ACR vs GHCR) + automated deploy target | Tim advisory |
| 1.5 | Access model: end shared admin; Entra SSH; **developer PIM + az CLI** ([DEVELOPER-AZURE-CLI-ACCESS.md](DEVELOPER-AZURE-CLI-ACCESS.md)) | Tim draft; Patrick impl `developer-cli-access` |
| 1.6 | Pen test / Arctic Wolf — **prioritize** for dev Linux | Client remediate |
| 1.7 | Fix mount/SELinux on **dev** if needed | Anatoliy |

### Track B

| # | Action | Owner |
|---|--------|--------|
| 1.8 | Review PDF — cloud vs on-prem, dev VM network path | Tim |
| 1.9 | Draft egress allow-list: **runtime** vs **runner** VMs (Snowflake, GitHub, registry, SFTP, Charles River) | Tim |
| 1.10 | Network workshop with Patrick | Tim schedule |
| 1.11 | Request **PIM eligible Reader** (temp Entra) for consultant on dev + prod subs | Tim request; Patrick approve |

**Exit:** Dev assessment v0.1; Podman deploy gap list.

---

## Phase 2 — Weeks 3–6 (standards)

| Deliverable | Focus |
|-------------|--------|
| **RHEL + Podman standards** v0.1 | [STANDARDS-RHEL-PODMAN-v0.1.md](STANDARDS-RHEL-PODMAN-v0.1.md) |
| **CI/CD standards** | GitHub self-hosted runner on **dedicated VM**; runtime **pull-only**; Actions promotes to registry |
| **Access standards** | No shared admin; **two UAMIs** (runner `AcrPush`, runtime `AcrPull`) + `azure-cli` on both VMs |
| **UAT/prod Linux design** | **Two VMs per env** — [VM-DESIGN-CONSIDERATIONS.md](VM-DESIGN-CONSIDERATIONS.md) §1 |
| **Network requirements** | [EGRESS-ALLOW-LIST.md](EGRESS-ALLOW-LIST.md), [NETWORK-IAM-STANDARDS.md](NETWORK-IAM-STANDARDS.md), [NETWORK-TO-TFVARS-BRIDGE.md](NETWORK-TO-TFVARS-BRIDGE.md) |
| **Risk register** v1 | [RISK-REGISTER-v1.md](RISK-REGISTER-v1.md) |
| **Reference IaC KT** | VM module; golden image **optional** (fleet TBD) |

**Out of scope:** APIM implementation, Dagster/app code changes.

**Ingress decision (W2-Q1):** [INGRESS-DECISION-NGINX-SIDECAR.md](INGRESS-DECISION-NGINX-SIDECAR.md) — client sign-off (ING-6) after service inventory (1.2).

---

## Phase 3 — Weeks 6–10 (UAT Linux)

| # | Action | Owner |
|---|--------|--------|
| 3.1 | Client provisions **first UAT** RHEL VM | Client platform |
| 3.2 | Deploy **same Podman** pattern as stabilized dev | Client |
| 3.3 | Automated pipeline to UAT | Client |
| 3.4 | App integration sign-off | Client app |

---

## Phase 4 — Weeks 10–14 (first prod Linux)

| # | Action | Owner |
|---|--------|--------|
| 4.1 | Provision **first production** Linux environment(s) | Client |
| 4.2 | Promote dev → UAT → prod via pipeline | Client |
| 4.3 | DR/ASR for prod Linux VM | Client |
| 4.4 | Cutover support (agreed window) | Tim support |

---

## Out of scope (unchanged)

APIM build · pen test execution · app remediation · network rule apply · consultant terraform apply · golden image unless multi-VM fleet

---

## Meetings

| When | Meeting |
|------|---------|
| Week 0 | Charter sign-off (dev Podman → UAT → prod) |
| Week 0–1 | Podman deploy walkthrough |
| Week 1 | Dev Linux deep-dive |
| Week 2 | Network + hybrid |
| Week 5–6 | Standards review |

---

## Doc updates after confirmation

- [x] ENGAGEMENT-ALIGNMENT.md
- [x] discovery-workshop-2.md
- [x] discovery-workshop-1.md (superseded notes)
- [x] NEXT-STEPS.md
- [x] STRATEGY-POST-RHEL.md
- [x] CLARIFICATIONS-WITH-DEV-TEAM.md answer log
- [x] README.md
- [x] INGRESS-DECISION-NGINX-SIDECAR.md (W2-Q1)
