# Clarifications with dev / platform team

**Purpose:** Questions for the client dev lead (and client platform as needed) to close Workshop 1 gaps, align [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md), and unblock Track A (RHEL) + Track B (network).

**How to use:** Schedule 45–60 min; send list in advance; record answers in this doc or meeting notes. Tag each answer: **Decided** / **TBD** / **Owner** / **Due**.

**Scope:** **In scope** = consultant documents/advises · **Client** = Client dev lead/team executes · **Out of scope** = redirect (app, network build, licensing).

---

## 1. Engagement scope & charter

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 1.1 | Confirm focus is **stabilize dev Podman** → **UAT → first prod Linux** (no prod Linux today), not contract Ubuntu→RHEL wording? | Aligns [SOW.md](SOW.md) vs [CHARTER-ADDENDUM.md](CHARTER-ADDENDUM.md) | In scope |
| 1.2 | Is **WSL2/Ubuntu on laptops** staying, or moving dev to **RHEL VMs**? | Standards + CI parity | Client decision |
| 1.3 | Who is **primary approver** (Client platform, Client dev lead, CAB)? | Changes and cutover | Client |
| 1.4 | Environments in scope: **prod only**, or prod + **UAT + dev** + DR? | Phase plan | In scope |
| 1.5 | **Freeze / blackout** dates for prod? | Scheduling | Client |
| 1.6 | Is consultant delivering **reference IaC only**, or expected to **apply** in Azure? | Scope boundary | **Out of scope:** apply unless CO |
| 1.7 | Is **golden image / AIB / SIG** in plan, or **in-place** harden of current VM? | Repo vs Ansible path | Advisory |

---

## 2. Development environment (WSL vs server)

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 2.1 | Today: do developers **only** use WSL locally, or also **SSH to a Linux server** for dev? | Line 90–91 in workshop | Client |
| 2.2 | Is there a **shared dev Linux VM** (separate from prod), or only laptop + prod? | User isolation need | Client |
| 2.3 | If shared server: **one Linux account per developer** or shared login today? | Security (Q4) | Client |
| 2.4 | Planned **user isolation**: separate users, subfolders only, or dev VMs per person? | Standards | Advisory draft |
| 2.5 | Should **prod** allow interactive SSH for developers, or **CI/CD + Bastion** only? | Prod hardening | Advisory |
| 2.6 | Same **container images** built locally (WSL) and in CI as on dev/UAT? | Parity | Client / app |
| 2.7 | Does CI (GitHub Actions) run on **RHEL**, Ubuntu, or container-only runners? | Catch OS drift | Client |

---

## 3. Production & UAT VMs (Azure RHEL)

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 3.1 | **Hostname, subscription, resource group, region** of prod Linux VM? | Assessment access | Client |
| 3.2 | **VM size**, OS disk + **data disk** layout (what’s on each)? | Mount issue | Client |
| 3.3 | How is the **extra data drive** mounted today (fstab, UUID, manual)? Who fixes? | Reboot data loss | **Client executes** |
| 3.4 | **RHEL version** and subscription (RHSM, Satellite, BYOS)? | Patching | Client owns license |
| 3.5 | **UAT**: exists today or greenfield? Same VM pattern as prod? | Phase 3 | In scope plan |
| 3.6 | **Dev “fixed before UAT”** (D4): what is broken in dev today specifically? | Sequencing | Client |
| 3.7 | Timeline to stand up **UAT** after assessment? | Roadmap | Client |
| 3.8 | **In-place** prod harden vs **new VM + cutover** preference? | Risk | Client decides |

---

## 4. Podman & applications (dev today)

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 4.1 | List of **Podman services** on dev (names, compose/quadlet files, systemd units)? | Inventory | Client |
| 4.2 | Where do **images** come from (GHCR, ACR, local build on server)? | Supply chain | Client |
| 4.3 | **SELinux** errors today—which paths/containers fail? | Known issue | **Client fixes** |
| 4.4 | **Rootful vs rootless** Podman? | Hardening | Advisory |
| 4.5 | **Secrets** in env files, Key Vault, or mixed? | Standards | Advisory |
| 4.6 | Connection details for **Snowflake, SQL Server, trading, optimization**—static IPs, DNS, private link? | Network allow-list | Client + network |
| 4.7 | Any **app changes** expected for RHEL (libraries, paths)—who owns testing? | **Out of scope:** app remediation | App team |
| 4.8 | **Kubernetes** timeline: assess only, pilot date, or not planned 12 months? | Scope creep | Advisory assess |

---

## 5. CI/CD & deployment

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 5.1 | **GitHub Actions** flow: branch → which env → prod? Manual approvals? | Runbooks | In scope |
| 5.2 | What is deployed to server (**git pull**, **docker compose pull**, scripts, Ansible)? | Repeatability | Client |
| 5.3 | **Downtime** acceptable per deploy? Maintenance windows? | Cutover | Client |
| 5.4 | Who can **deploy to prod** today (people, service accounts)? | Access model | Client |
| 5.5 | **Rollback** process if deploy fails? | Runbook | Advisory draft |

---

## 6. Consultant access

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 6.1 | **Consultant email / Teams** — fully working? | Collaboration | Client |
| 6.2 | **SSH or Bastion** access to dev Linux VM for read-only assessment? | Phase 1 | **Done** — Consultant has Linux VM access |
| 6.3 | Read-only **Azure RBAC** on dev + prod subscriptions? | Track B; VM Azure context | **Pending** — request `Reader` from client platform |
| 6.4 | **Ongoing access** duration and escalation (Client dev lead, Client platform)? | SOW KT period | In scope |
| 6.5 | NDA / **data handling** on prod (PII, trading data)—snapshots allowed? | Compliance | Client GRC |

---

## 7. Network & integrations (loop in client platform / network if needed)

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 7.1 | **Architecture diagram** (Azure + hybrid + Linux box)—who delivers by when? | Blocker | **Client** (Client dev lead) |
| 7.2 | Prod VM: **public IP**, private only, VPN/ExpressRoute to access? | Security | Client / network |
| 7.3 | **Egress** from VM: direct Internet, proxy, firewall in path? | Patch, Snowflake, GH | Network |
| 7.4 | **NGINX** on VM: stay, move to APIM/Front Door when? | Separate workstream | **Out of scope** unless CO |
| 7.5 | **Two tenants** (lower vs prod): which VM in which? | Assessment | Client |

*Full network list: [NETWORK-DISCOVERY-QUESTIONNAIRE.md](NETWORK-DISCOVERY-QUESTIONNAIRE.md) Workshop 2.*

---

## 8. Monitoring, DR, operations

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 8.1 | **Logic Monitor** rollout for this Linux host—timeline? | Q5 | **Client** (Client platform) |
| 8.2 | What is monitored today (OS, Podman/containers, disks, APIs)? | Gaps | Client |
| 8.3 | **ASR** for this VM: configured, tested, includes data disk? | DR | **Client executes** test |
| 8.4 | **Backup** policy (Azure Backup, snapshots)—RPO/RTO expectations? | Standards | Client |
| 8.5 | On-call for **Linux incidents**—who? Hiring Linux admin still planned? | Ops model | Client |
| 8.6 | **Patching** cadence for RHEL (monthly, autoupdate)? | Standards | Advisory |

---

## 9. Security & compliance

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 9.1 | **FIPS** required for these apps now or later? | Crypto policy | **App + client** test |
| 9.2 | **CIS / internal hardening** baseline required? | Standards | In scope advise |
| 9.3 | **AD / SSO** for SSH or local users only? | Account model | Client identity |
| 9.4 | **Break-glass** / emergency access process? | Runbook | Advisory |
| 9.5 | **Claude Code** pilot—any impact on server tooling policy? | Awareness | Out of scope |

---

## 10. Documentation & deliverables

| # | Question | Why it matters | Scope |
|---|----------|----------------|-------|
| 10.1 | **High-level schema** Client dev lead offered—format and due date? | Follow-up task | Client |
| 10.2 | Existing **runbooks**, architecture docs, passwords in KV? | Discovery | Client provides |
| 10.3 | Preferred format for **standards** (Word, Confluence, repo markdown)? | Deliverable | Client |
| 10.4 | Review cadence: weekly with client dev lead + Client platform? | Engagement | In scope |

---

## 11. Out of scope — confirm redirects

Confirm Client dev lead agrees consultant will **not**:

- Fix application code or container image bugs  
- Implement firewall rules or build hub/spoke  
- Purchase RHEL licenses  
- Run prod `terraform apply` or operate monitoring 24×7  
- Build AKS / APIM in this engagement  

| # | Question |
|---|----------|
| 11.1 | Agree on redirects to **app team**, **network team**, **procurement**? |
| 11.2 | Any item client still expects from Consultant outside list above? |

---

## Answer log (fill in meeting)

| # | Answer | Owner | Due | Status |
|---|--------|-------|-----|--------|
| 1.1 | **No production Linux environments** | Client | — | **Confirmed** |
| 1.2 | **Dev hosts = Podman**; WSL/Ubuntu on laptops TBD | Client | — | **Confirmed** |
| 1.7 | Golden image **optional** for UAT/prod fleet | Advisory | — | Open |
| 3.1–3.5 | Prod Linux **greenfield** after UAT | Client | — | **Confirmed** |
| W2-Q9 | **Podman** (not Docker) on dev | Client | — | **Confirmed** |
| 6.2 | Linux VM access for consultant | Client | — | **Done** |
| 6.3 | Azure subscription **Reader** for consultant | Client platform | _[date]_ | **Pending** |
| … | | | | |

---

## Related docs

- [discovery-workshop-1.md](discovery-workshop-1.md)  
- [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md)  
- [STRATEGY-POST-RHEL.md](STRATEGY-POST-RHEL.md)  
- [CLICKUP-DISCOVERY-TICKETS.md](CLICKUP-DISCOVERY-TICKETS.md) (#13 RHEL assessment)
