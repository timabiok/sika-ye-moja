# Discovery Workshop 1 — Summary

| Field | Value |
|-------|--------|
| **Date** | _[add]_ |
| **Goal** | Walk Tim through the current Linux environment and state (Anatoliy, chief architect, presenting) |
| **Attendees** | Anatoliy, Patrick, Tim, Letron, Brad |
| **Facilitator / consultant** | Tim (Vaco) |
| **Related** | [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md) · [SOW.md](SOW.md) · [STRATEGY-POST-RHEL.md](STRATEGY-POST-RHEL.md) · [NETWORK-DISCOVERY-QUESTIONNAIRE.md](NETWORK-DISCOVERY-QUESTIONNAIRE.md) · [CLICKUP-DISCOVERY-TICKETS.md](CLICKUP-DISCOVERY-TICKETS.md) |

---

## Engagement alignment (action required)

> **Aligned model:** [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md) — **Track A** stabilize RHEL + **Track B** stabilize network (recommend only).

> **Superseded:** Client confirmed **no production Linux**; **dev hosts use Podman**. See [discovery-workshop-2.md](discovery-workshop-2.md) and [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md).

Workshop 1 notes below may be **inaccurate on prod** — use for historical context only.

| Observation (W1) | **Confirmed** |
|--------------------|---------------|
| “RHEL in production” | **Wrong** — no prod Linux environments |
| Docker on server | **Dev uses Podman** |
| WSL2 / Ubuntu locally | Still valid for laptop dev |
| Manual Azure build | Still valid |

**Consultant action:** Send 1-page charter clarification email; do not treat golden-image pipeline as committed scope until confirmed.

**Recommended strategy (post-RHEL):** See **[STRATEGY-POST-RHEL.md](STRATEGY-POST-RHEL.md)** — operational uplift, **Podman on RHEL**, dev → UAT → prod, client-owned IaC.

**Network not in IaC:** Manual Azure/network builds are expected; consultant documents as-built and recommendations—does not recreate hub in Terraform. See [NETWORK-DISCOVERY-QUESTIONNAIRE.md](NETWORK-DISCOVERY-QUESTIONNAIRE.md#when-client-network-is-not-in-iac).

---

## Scope legend

| Tag | Meaning |
|-----|---------|
| **In scope** | Consultant documents, advises, drafts standards/risks (SOW) |
| **Client** | Client provides access, executes changes, owns systems |
| **Advisory** | Consultant recommends; client implements |
| **Out of scope** | Redirect unless change order |

---

## Decisions (agreed in session)

| # | Decision | Scope | Owner |
|---|----------|--------|--------|
| D1 | **Architecture diagram** of Linux box and target environments will be created | In scope input | Anatoliy |
| D2 | **Access for Tim** to Linux box will be set up | Client | Letron / Patrick |
| D3 | **UAT** established **after** assessment and recommendations | In scope plan | Client + consultant |
| D4 | **Dev** fixed before UAT and production | Advisory sequence | Client |

---

## Open questions (tagged)

| # | Question | Scope | Next step |
|---|----------|--------|-----------|
| Q1 | Mount/filesystem fix for data access after reboot | Client executes | Anatoliy — fstab/cloud-init pattern |
| Q2 | Containerization and **Kubernetes** migration approach | **Advisory** assess only; K8s build = out of scope | Bound in Workshop 2 / charter |
| Q3 | **RHEL + Podman** best practices (UAT/prod path) | **In scope** (SOW item 2) | Standards doc |
| Q4 | User access and account management on shared server | Advisory + client implements | Anatoliy |
| Q5 | **Monitoring** (Logic Monitor vs alternatives) | Client | Patrick |
| Q6 | Migration to **Azure services** and cloud architecture | In scope planning | Needs diagram + Workshop 2 (network) |
| Q7 | Tech stack: SaaS vs open source preferences | Advisory / business | Document; not blocking infra |
| Q8 | Security and **IAM** baseline for cloud | Advisory | Platform team; FIPS = client app test |
| Q9 | **Network** hub/spoke, egress, private endpoints | **Not discussed** | Workshop 2 + architecture packet |

---

## Current environment (as-is)

### Platform

- **History:** On-prem Windows + SQL Server → Linux on Azure for **Snowflake Warehouse** platform.
- **OS:** ~~RHEL prod~~ **Confirmed: no prod Linux**; dev hosts **Podman** on RHEL (see W2).
- **Azure:** Two tenants — **lower environments** and **production**.
- **Provisioning:** **Manual** setup; no Terraform/Bicep today; team agrees IaC is desirable for future envs.
- **DR:** **Azure Site Recovery (ASR)** used elsewhere; plan to extend to this Linux environment.

### Workload

- **Stack:** GitHub Actions (CI/CD), Dagster (orchestration), dbt (transform), Power BI, Python, SQL.
- **Runtime:** Containerized services (FastAPI); **dev = Podman** (confirmed); ELT via Python/SQL.
- **Integrations:** Snowflake, SQL Server, trading platform, optimization engine.
- **Edge:** NGINX as reverse proxy today; discussion of **Azure API Management** + **Azure Front Door** for tokens.

### Development

- Developers use **WSL2 + Ubuntu** locally before deploy to server.
- Shared Linux server: need **user isolation** (workspaces / subfolders).
- **Clarify with Anatoliy:** full question list → [CLARIFICATIONS-WITH-DEV-TEAM.md](CLARIFICATIONS-WITH-DEV-TEAM.md) (§2 dev environment, §3 VMs).

### Known issues

- **Additional drive mount** incorrect → data inaccessible after reboot; manual fix required.
- **SELinux** conflicts with **container folder** access (Anatoliy, Patrick to review).

### Team context

- Preference for **SaaS** over OSS where support/maintenance matters (cost + internal review).
- **Limited Kubernetes** experience; prefer Linux/container foundations before K8s.
- Considering hiring a **Linux administrator** (client staffing).
- **Claude Code** in pilot (Patrick) — awareness only; out of consultant scope.

---

## Gaps vs network / golden-image discovery

Workshop 1 did **not** cover [NETWORK-DISCOVERY-QUESTIONNAIRE.md](NETWORK-DISCOVERY-QUESTIONNAIRE.md) items: hub–spoke, firewall egress, image-build VNet, private endpoints, RHSM, CAB, cutover RACI.

| Blocker | ClickUp ticket |
|---------|----------------|
| No architecture diagram received yet | #1 Request client network architecture packet |
| ~~Tim Linux box access~~ **Done** | Azure subscription Reader **pending** (#2 RACI + platform) |

---

## Risk register (initial)

| ID | Risk | Owner | Mitigation |
|----|------|--------|------------|
| R1 | SOW says Ubuntu→RHEL; prod is already RHEL | Client PM + Tim | Charter clarification |
| R2 | Manual prod; mount/DR may not survive rebuild | Anatoliy | Repeatable build + standards; fix fstab |
| R3 | Shared box, multi-service Docker — hard to golden-image without refactor | Anatoliy | Assess VM vs container platform path |
| R4 | K8s scope creep | Tim | Assessment only unless change order |
| R5 | No network/egress discovery | Client network | Workshop 2 + diagram |
| R6 | Consultant access delayed | Letron / Patrick | P0 access ticket |

---

## Action items

### P0 — Blockers

| Task | Owner | Due | Scope |
|------|--------|-----|--------|
| Forward meeting invite to Tim’s **Vaco** email; confirm Teams license | Letron | _[date]_ | Client |
| Grant Tim **access to Linux box** for deep-dive / snapshots | Patrick / Anatoliy | _[date]_ | Client |
| Create **high-level architecture diagram** (hybrid + Azure + Linux box + integrations) | Anatoliy | _[date]_ | Client → feeds consultant review |

### P1 — In scope / advisory

| Task | Owner | Due | Scope |
|------|--------|-----|--------|
| Tim: **Review** outline + add clarifying questions before solution design | Tim | _[date]_ | In scope |
| Tim: Send **engagement clarification** (RHEL vs Ubuntu, deliverables) | Tim | _[date]_ | In scope |
| **SELinux** + container folder access review | Anatoliy, Patrick | _[date]_ | Client |
| **User account management** on Linux server (dev + support) | Anatoliy | _[date]_ | Client |
| **Production design** for repeatability + DR (incl. data disk, ASR) | Anatoliy, Patrick, Tim | _[date]_ | Advisory; client implements |
| High-level **schema/docs** of service areas and issues | Anatoliy | _[date]_ | Client |

### P2 — Client-owned / out of scope

| Task | Owner | Due | Scope |
|------|--------|-----|--------|
| Configure **Logic Monitor** for Linux | Patrick | _[date]_ | Client |
| **APIM / Front Door** vs NGINX for token validation | Anatoliy | _[date]_ | Out of scope unless CO |
| Fix **mount/filesystem** persistence | Anatoliy | _[date]_ | Client |

---

## Consultant deliverables (from this workshop)

| Deliverable | Target | SOW item |
|-------------|--------|----------|
| Engagement clarification email | _[date]_ | 1 |
| Question list for client (tagged by scope) | _[date]_ | 1 |
| Workshop 1 summary (this doc) | Done | 1 |
| Await diagram → pre-fill questionnaire | After Anatoliy diagram | 1 |
| RHEL / Linux standards draft | TBD | 2 |

---

## Workshop 2 — Proposed agenda (network + platform)

**Duration:** 60–90 min · **Prereq:** Architecture diagram (D1), Tim has Linux access (D2)

| Time | Topic | Questionnaire § |
|------|--------|-----------------|
| 0–10 | Confirm engagement charter (RHEL stabilize vs migrate) | §1 |
| 10–25 | Review diagram: tenants, subnets, egress, firewall | §2–3 |
| 25–40 | Image build / IaC path: adopt reference repo vs VM hardening | §4, §10 |
| 40–55 | Cutover: dev → UAT → prod, ASR, mount/DR | §8 |
| 55–60 | Actions, owners, dates | — |

**Attendees needed:** Anatoliy, Patrick, **network/platform** contact (if different)

---

## Raw meeting notes (reference)

<details>
<summary>Expand original notes</summary>

### Access

- Letron: Tim lost Teams access; shared phone number.
- Brad: Vaco email created; update invites.
- Patrick: Teams license restored; Letron to forward invite to Vaco email.

### Technical overview

- Transition: on-prem Windows/SQL → Linux on Azure for Snowflake Warehouse (**RHEL**).
- Mount issue on additional drive after reboot.
- Stack: GitHub Actions, Dagster, dbt, Power BI, Python/SQL.
- SaaS vs OSS discussion; SaaS favored for support.
- Linux box: Dockerized REST (FastAPI); Snowflake, SQL Server, trading platform, optimization engine.
- Scalability: possible future **Kubernetes**; limited experience today.
- Need Linux admin; two Azure tenants; manual deploy; IaC benefits discussed.
- Tim: start small, plan scale; Patrick: Claude Code pilot.
- Dev: WSL2/Ubuntu; shared server user isolation options.
- Tim: deep-dive access + snapshots requested.
- CI/CD: dev → UAT → prod via scripts.
- DR: rebuildable prod; ASR for Linux planned.
- FIPS discussed for internal apps.
- Tim: ongoing access + escalation to Anatoliy.

</details>

---

## Sign-off

| Role | Name | Date |
|------|------|------|
| Client architect | Anatoliy | |
| Client platform | Patrick | |
| Consultant | Tim | |
