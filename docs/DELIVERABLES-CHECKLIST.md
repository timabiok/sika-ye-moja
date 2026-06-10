# Deliverables checklist

> **Your tracker** — check boxes as each item is **formally done** (draft sent, client reviewed, signed off, or session delivered).  
> Master scope: [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md) · Plan: [NEXT-STEPS.md](NEXT-STEPS.md)

**Legend:** `[ ]` = not done · `[x]` = done · **Draft in repo** = artifact exists; still check when client-facing delivery is complete · **In PDF pack** = included in `stabilization-pack/v0.1` (22 PDFs per manifest).

### Client PDF pack (`stabilization-pack/v0.1`)

Source markdown on GitHub: [docs/](https://github.com/timabiok/sika-ye-moja/tree/main/docs). Client PDF pack: [stabilization-pack/v0.1](https://github.com/timabiok/sika-ye-moja/tree/main/deliverables/stabilization-pack/v0.1).

```bash
./scripts/build-deliverable-pdfs.sh          # build all PDFs
python3 scripts/generate-review-email.py     # local email draft → .deliverables-build/review-email.md
```

Source docs: [`docs/`](https://github.com/timabiok/sika-ye-moja/tree/main/docs) · Manifest (22 PDFs): [`manifest.json`](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/manifest.json)

### SOW contract mapping (Fortified #743101)

| SOW item | Checklist phases |
|----------|------------------|
| **1** Planning | Phase 0–1 (charter, assessment, network discovery) |
| **2** Standards | Phase 2 (`STANDARDS-RHEL-PODMAN-v0.1.md`, VM design) |
| **3** Risks | Phase 1–2 (`RISK-REGISTER-v1.md`) |
| **4** Environment recommendations | Phase 2 (egress, network/IAM, ingress) |
| **5** Cutover support | Phase 4 (runbooks, agreed window) |
| **6** KT & support planning | Phase 2 (IaC handoff) + Phase 4 (close-out) |

Full mapping: [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md#sow-contract-baseline-fortified-data-743101).

---

## Phase 0 — Kickoff

### Governance & access

- [x] [CHARTER-ADDENDUM.md](CHARTER-ADDENDUM.md) sent, signed (async), and in PDF pack (**Draft in repo · in PDF pack**)
- [x] Azure **PIM eligible Reader** requested (consultant, dev + prod subs)
- [x] Azure **PIM eligible Reader** granted and tested
- [x] **Developer CLI** pattern shared with Patrick ([DEVELOPER-AZURE-CLI-ACCESS.md](DEVELOPER-AZURE-CLI-ACCESS.md) — **In PDF pack**)

### Client inputs (blockers — not your deliverable, but chase)

- [x] PDF architecture diagram received (Anatoliy → ClickUp)
- [x] Podman walkthrough completed (Tim + Anatoliy: build → store → deploy)
- [x] Service inventory: Gorobi, ingestion, APIs, Dagster (Anatoliy)

### Meetings

- [x] Charter sign-off meeting held
- [x] Podman deploy walkthrough scheduled / completed

---

## Phase 1 — Assess dev Podman (weeks 1–3)

### Track A — Assessment

- [ ] Dev Linux **deep-dive** (SSH/Bastion) — walkthrough done; formal inventory + metrics pending
- [ ] [DEV-PODMAN-ASSESSMENT.md](DEV-PODMAN-ASSESSMENT.md) v0.1 filled (host, services, metrics)
- [ ] Deploy path documented (runner vs runtime vs combined host today)
- [x] Registry recommendation delivered — [REGISTRY-AND-SUPPLY-CHAIN.md](REGISTRY-AND-SUPPLY-CHAIN.md) (**Draft in repo · in PDF pack**)
- [x] Access model draft shared — [BANKING-PLATFORM-STANDARDS-v1.md](BANKING-PLATFORM-STANDARDS-v1.md) §1 + [NETWORK-IAM-STANDARDS.md](NETWORK-IAM-STANDARDS.md) (**Draft in repo · in PDF pack**)
- [x] Podman deploy **gap list** published — [PODMAN-DEPLOY-GAP-LIST.md](PODMAN-DEPLOY-GAP-LIST.md) (**Draft in repo · in PDF pack**)
- [x] [CLARIFICATIONS-WITH-DEV-TEAM.md](CLARIFICATIONS-WITH-DEV-TEAM.md) — open items closed or deferred (**Draft in repo · in PDF pack**)

### Track B — Network discovery

- [x] PDF / as-built diagram reviewed
- [ ] [NETWORK-DISCOVERY-QUESTIONNAIRE.md](NETWORK-DISCOVERY-QUESTIONNAIRE.md) — key sections answered with client (**Draft in repo · in PDF pack**)
- [x] Network workshop with Patrick held
- [ ] Network blocker tickets logged with owners + due dates

**Phase 1 exit:** Dev assessment v0.1 + gap list accepted internally.

---

## Phase 2 — Standards & reference patterns (weeks 3–6)

### Core SOW deliverables

- [x] [STRATEGY-POST-RHEL.md](STRATEGY-POST-RHEL.md) — stabilization plan delivered (**Draft in repo · in PDF pack**)
- [ ] [STANDARDS-RHEL-PODMAN-v0.1.md](STANDARDS-RHEL-PODMAN-v0.1.md) — **client review** / v1.0 sign-off (**Draft in repo · in PDF pack**)
- [x] [BANKING-PLATFORM-STANDARDS-v1.md](BANKING-PLATFORM-STANDARDS-v1.md) — opinionated industry baseline for missing areas (**Draft in repo · in PDF pack**)
- [x] [INDUSTRY-REFERENCES.md](INDUSTRY-REFERENCES.md) — CIS, NIST, FFIEC, Azure, Red Hat links for standards pack (**Draft in repo · in PDF pack**)
- [ ] GRC records **CIS L1 vs STIG** decision (standards §5 — STIG only if mandated)
- [ ] Vulnerability **gates** agreed with Kirk/security (P0 dev → UAT → prod re-scan)
- [ ] [VM-DESIGN-CONSIDERATIONS.md](VM-DESIGN-CONSIDERATIONS.md) — UAT/prod VM design reviewed with platform (**Draft in repo · in PDF pack**)
- [ ] [EGRESS-ALLOW-LIST.md](EGRESS-ALLOW-LIST.md) — submitted for CAB / network team (**Draft in repo · in PDF pack**)
- [ ] [NETWORK-IAM-STANDARDS.md](NETWORK-IAM-STANDARDS.md) — NSG + UAMI + developer CLI reviewed (**Draft in repo · in PDF pack**)
- [ ] [NETWORK-TO-TFVARS-BRIDGE.md](NETWORK-TO-TFVARS-BRIDGE.md) — filled with client subnet IDs / ARM IDs (post-review; not in PDF pack)
- [ ] [RISK-REGISTER-v1.md](RISK-REGISTER-v1.md) — reviewed; priorities agreed (**Draft in repo · in PDF pack**)
- [x] Environment improvement recommendations — [ENVIRONMENT-IMPROVEMENT-BACKLOG.md](ENVIRONMENT-IMPROVEMENT-BACKLOG.md) (**Draft in repo · in PDF pack**)
- [ ] [INGRESS-DECISION-NGINX-SIDECAR.md](INGRESS-DECISION-NGINX-SIDECAR.md) — client sign-off (ING-6) (**Draft in repo · in PDF pack**)

### Supporting technical docs

- [ ] [ARCHITECTURE.md](ARCHITECTURE.md) — three-layer model KT-ready
- [ ] [BUILD-LAYER.md](BUILD-LAYER.md) — container build + ACR pattern
- [ ] [RUNTIME-WORKLOAD-EXAMPLE.md](RUNTIME-WORKLOAD-EXAMPLE.md) — platform stack reference
- [ ] [DEVELOPER-AZURE-CLI-ACCESS.md](DEVELOPER-AZURE-CLI-ACCESS.md) — Patrick implements `developer-cli-access` (pattern shared Phase 0; **In PDF pack**)
- [ ] [COMPLIANCE.md](COMPLIANCE.md) — shared with GRC (informational) (**Draft in repo · in PDF pack**)
- [ ] [AZURE-NETWORK-ARCHITECTURE.md](AZURE-NETWORK-ARCHITECTURE.md) — target-state reference (if used in workshop)

### Reference IaC handoff (consultant authors; client applies)

- [ ] `infra/terraform/README.md` — layer overview walked through
- [ ] Layer 1: `environments/prod/` + Ansible golden image pipeline
- [ ] Layer 2: `layer2-workload-stack`, NSG, UAMI, Monitor, `environments/workload/`
- [ ] Layer 3: `build/` + `.github/workflows/`
- [ ] Modules: `acr-baseline`, `developer-cli-access`, `storage-fileshare`
- [ ] `ansible/` — layer 1 + layer 2 roles documented
- [ ] `examples/runtime-images/` — Gorobi, ingestion, FastAPI, Dagster + nginx
- [ ] `policies/` — Azure Policy samples shared with GRC

### Knowledge transfer

- [x] [KT-AND-SUPPORT-PLAN.md](KT-AND-SUPPORT-PLAN.md) — session plan drafted (**Draft in repo · in PDF pack**)
- [ ] KT session 1 — architecture + three layers
- [ ] KT session 2 — Terraform workload stack + tfvars bridge
- [ ] KT session 3 — build layer + runtime deploy (`deploy-runtime-stack.sh`)
- [ ] Standards review meeting (week 5–6)
- [ ] **Stabilization pack** sent for client review (`python3 scripts/generate-review-email.py` → local email with links to `docs/` on GitHub)

**Phase 2 exit:** Standards pack accepted; client platform knows how to adopt IaC.

---

## Phase 3 — UAT Linux (weeks 6–10) — mostly client; consultant support

- [ ] Client provisions first UAT VMs (runner + runtime)
- [ ] Client applies reference IaC or equivalent (Patrick)
- [ ] Automated pipeline to UAT validated
- [ ] Consultant: UAT readiness review / gap closure
- [ ] App integration sign-off (client)

---

## Phase 4 — First prod Linux (weeks 10–14)

- [ ] Client provisions prod Linux environment(s)
- [ ] dev → UAT → prod promotion via pipeline (client)
- [x] Cutover **runbook drafts** delivered — [runbooks/CUTOVER-RUNBOOK.md](runbooks/CUTOVER-RUNBOOK.md), [runbooks/NETWORK-CUTOVER-RUNBOOK.md](runbooks/NETWORK-CUTOVER-RUNBOOK.md), [runbooks/PROMOTION-RUNBOOK.md](runbooks/PROMOTION-RUNBOOK.md), [runbooks/OPERATIONS-RUNBOOK.md](runbooks/OPERATIONS-RUNBOOK.md) (**Draft in repo · in PDF pack**)
- [ ] Cutover support in agreed window (consultant on-call)
- [ ] DR/ASR for prod Linux (client executes)
- [ ] Engagement close-out / lessons learned

---

## Explicitly out of scope (do not check — client owns)

- [ ] ~~APIM build~~
- [ ] ~~Firewall / NSG implementation~~
- [ ] ~~Consultant `terraform apply` in client tenant~~
- [ ] ~~Pen test remediation execution~~
- [ ] ~~Application code changes (Dagster, Gorobi, APIs)~~
- [ ] ~~RHEL license purchase~~
- [ ] ~~Logic Monitor / SIEM deploy~~
- [ ] ~~CIS / audit attestation~~

---

## Quick status (update manually)

| Phase | Done | Total |
|-------|------|-------|
| 0 Kickoff | 10 | 10 |
| 1 Assess | 6 | 11 |
| 2 Standards + KT | 5 | 33 |
| 3 UAT | 0 | 5 |
| 4 Prod + close | 1 | 5 |

**Next actions:** send stabilization pack (Phase 2) · complete dev assessment + deploy path (Phase 1) · network questionnaire answers + blocker tickets (Phase 1).

**Last updated:** 2026-06-09 (PDF pack = 22 deliverables per manifest)
