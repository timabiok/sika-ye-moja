# Draft RHEL + Podman Standards Pack — Review (v0.1)

**Subject:** Draft RHEL + Podman Standards Pack — Review

Hi all,

Following Workshop 2 and the architecture diagram review, I'm sharing our draft stabilization and standards pack for review.
These materials align with the engagement scope (planning, standards, risks, environment recommendations, and knowledge transfer).
They are working drafts for discussion and will be finalized after platform review and closure of the open items identified during the assessment phase.

## Materials for Review

| Section | Item (email) | Link |
|---------|--------------|------|
| Program & Planning | Stabilization strategy and phased plan | [stabilization-strategy.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/program/stabilization-strategy.pdf) |
| Program & Planning | Podman deployment gap list (prioritized P0–P2) | [podman-gap-list.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/program/podman-gap-list.pdf) |
| Program & Planning | Environment improvement backlog (ticket-ready) | [env-improvement-backlog.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/program/env-improvement-backlog.pdf) |
| Program & Planning | Risk register v1 | [risk-register.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/program/risk-register.pdf) |
| Program & Planning | Knowledge transfer & support plan (proposed schedule) | [kt-support-plan.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/program/kt-support-plan.pdf) |
| Platform & Security | RHEL + Podman standards v0.1 | [rhel-podman-standards-v0.1.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/standards/rhel-podman-standards-v0.1.pdf) |
| Platform & Security | Banking platform standards (access, registry, DR, naming, security gates) | [banking-platform-standards.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/standards/banking-platform-standards.pdf) |
| Platform & Security | Network & IAM standards (NSG, UAMI, PIM) | [network-iam-standards.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/standards/network-iam-standards.pdf) |
| Platform & Security | Registry & supply chain advisory (ACR Premium recommended) | [registry-supply-chain-advisory.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/standards/registry-supply-chain-advisory.pdf) |
| Platform & Security | Egress allow-list draft (for CAB / network review) | [egress-allow-list.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/standards/egress-allow-list.pdf) |
| Platform & Security | VM design considerations (runner + runtime per environment) | [vm-design-considerations.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/standards/vm-design-considerations.pdf) |
| Platform & Security | Ingress approach (nginx sidecar until APIM is in scope) | [ingress-nginx-sidecar.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/standards/ingress-nginx-sidecar.pdf) |
| Platform & Security | Developer Azure CLI access pattern (PIM, dev subscription) | [dev-azure-cli-access-pattern.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/standards/dev-azure-cli-access-pattern.pdf) |
| Development & Operations | Clarification questions (Podman session pre-read) | [podman-session-preread.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/operations/podman-session-preread.pdf) |
| Development & Operations | Promotion runbook (dev → UAT → prod) | [promotion-runbook.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/runbooks/promotion-runbook.pdf) |
| Development & Operations | Operations runbook (patching, incidents, disk, rollback) | [operations-runbook.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/runbooks/operations-runbook.pdf) |
| Network | Network discovery questionnaire | [network-discovery-questionnaire.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/network/network-discovery-questionnaire.pdf) |
| Network | Network cutover runbook template | [network-cutover-runbook.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/network/network-cutover-runbook.pdf) |
| GRC / Security (informational) | Compliance mapping (CIS L1 baseline; STIG only if required) | [compliance-mapping.pdf](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/grc/compliance-mapping.pdf) |

## Opinionated Defaults (Please Confirm)

Unless advised otherwise, the following assumptions are in place:

- ACR Premium (in place before UAT)
- CIS RHEL 9 Level 1 baseline (not STIG unless mandated)
- Separate runner and runtime VMs per environment
- nginx sidecar for ingress (until APIM is introduced)
- Entra ID–based SSH access (retiring shared Linux admin accounts)
- P0 security findings remediated in dev prior to UAT promotion

All defaults are documented in the standards pack with decision IDs for formal sign-off.

## Next Deliverables (Post-Review)

Following the ongoing sessions and inputs:

- Completed dev Podman assessment
- Terraform tfvars bridge (subnet / ACR / Key Vault IDs)
- Reference IaC walkthrough (KT Session 1)

## Out of Scope (Unchanged)

- Application remediation
- Firewall implementation
- Terraform execution within your tenant
- Penetration testing
- APIM delivery
- RHEL licensing

(Available separately if needed.)

---

_Generated from `deliverables/stabilization-pack/manifest.json`. Re-run: `python3 scripts/generate-review-email.py`_
