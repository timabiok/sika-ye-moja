# Knowledge transfer and support plan

> **SOW item 6** — structured KT, handoff artifacts, and post-engagement support boundaries.

---

## Objectives

After KT, client platform can **without consultant**:

1. Build and promote container images via runner VM → ACR
2. Deploy workloads to runtime VM via quadlet + GitHub Actions
3. Provision UAT/prod VMs from reference Terraform (layers 1–2)
4. Operate patch, rollback, and incident runbooks
5. Maintain network allow-lists and NSG model

---

## Audience

| Session | Primary | Optional |
|---------|---------|----------|
| KT-1 Architecture | Patrick, Anatoliy | Kirk (security overview) |
| KT-2 Terraform | Patrick, IaC engineer | — |
| KT-3 Build + runtime | Anatoliy, dev lead | — |
| KT-4 Standards review | Patrick, Anatoliy, PM | GRC |
| KT-5 Runbooks | Platform on-call | Network (KT-5b) |

---

## Session plan

| # | Duration | Topics | Artifacts |
|---|----------|--------|-----------|
| **KT-1** | 90 min | Three-layer model; SIG vs marketplace; engagement scope | [ARCHITECTURE.md](ARCHITECTURE.md), [BANKING-PLATFORM-STANDARDS-v1.md](BANKING-PLATFORM-STANDARDS-v1.md) |
| **KT-2** | 90 min | `layer2-workload-stack`, tfvars bridge, UAMI, monitor, NSG | [NETWORK-TO-TFVARS-BRIDGE.md](NETWORK-TO-TFVARS-BRIDGE.md), `infra/terraform/README.md` |
| **KT-3** | 90 min | `build/`, workflows, `deploy-runtime-stack.sh`, examples | [BUILD-LAYER.md](BUILD-LAYER.md), [RUNTIME-WORKLOAD-EXAMPLE.md](RUNTIME-WORKLOAD-EXAMPLE.md) |
| **KT-4** | 60 min | Standards walkthrough; client sign-off gaps | [STANDARDS-RHEL-PODMAN-v0.1.md](STANDARDS-RHEL-PODMAN-v0.1.md) |
| **KT-5** | 60 min | Promotion, rollback, patch, incident | [runbooks/](runbooks/) |
| **KT-5b** | 45 min | Network cutover, egress, DNS | [runbooks/NETWORK-CUTOVER-RUNBOOK.md](runbooks/NETWORK-CUTOVER-RUNBOOK.md) |

**Recording:** Client owns Teams recording; store in internal KB.

---

## Pre-reads (send 48h before)

- [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md)
- [DELIVERABLES-CHECKLIST.md](DELIVERABLES-CHECKLIST.md)
- [CHARTER-ADDENDUM.md](CHARTER-ADDENDUM.md) (signed)

---

## Handoff package

| Artifact | Location | Owner after KT |
|----------|----------|----------------|
| Reference Terraform | `infra/terraform/` | Client platform |
| Ansible roles | `ansible/` | Client platform |
| Build manifests | `build/` | Client dev/platform |
| Workflows | `.github/workflows/` | Client dev |
| Standards pack | `docs/STANDARDS-*`, `docs/BANKING-*` | Client platform maintains |
| Policies | `policies/` | Client GRC assigns |
| Runbooks | `docs/runbooks/` | Client on-call |

---

## Support model (during engagement)

| Activity | Consultant | Client |
|----------|------------|--------|
| Advisory questions | **60h SOW** — email/Slack async | Primary implementer |
| Cutover window | **Agreed weekend** — on-call phone | Executes runbooks |
| terraform apply | **No** (reference only) | Client |
| Emergency prod fix | **Best-effort guidance** — not 24×7 | Client on-call |

---

## Post-KT support (after hour 60)

| Item | Standard |
|------|----------|
| Duration | **2 weeks** email clarification (included in SOW close-out unless CO) |
| Scope | KT artifacts only — no new features |
| Channel | Client PM single point of contact |
| Escalation | Change order for work outside charter |

---

## KT sign-off checklist

- [ ] KT-1 through KT-5 delivered
- [ ] Client ran **test deploy** to UAT without consultant driving commands
- [ ] `NETWORK-TO-TFVARS-BRIDGE.md` filled for at least dev
- [ ] Runbooks stored in client ITSM / Confluence
- [ ] Consultant access removed (PIM eligible revoked)

| Role | Name | Date |
|------|------|------|
| Client platform | | |
| Vaco lead | | |

---

## Industry references

Standards pack authorities for GRC pre-read: [INDUSTRY-REFERENCES.md](INDUSTRY-REFERENCES.md)
