# Risk register v1

> **SOW item 3** — risk identification and mitigation. Consolidates Workshop 1/2 risks. **Supersedes** stale W1 items referencing prod Docker.

| ID | Risk | Impact | Likelihood | Mitigation | Owner | Status |
|----|------|--------|------------|------------|-------|--------|
| R1 | **Shared admin** on dev Linux | High | High | Entra SSH; per-user accounts; standards §2 | Client | Open |
| R2 | **Mount/fstab failures** on dev | High | Medium | `mount-data-disk.sh` + IaC data disk; UAT test | Client + Vaco | Mitigating |
| R3 | **SELinux vs Podman** conflicts | Medium | High | Document booleans/paths on dev before UAT template | Anatoliy | Open |
| R4 | **No prod Linux** — greenfield UAT/prod | Medium | Certain | VM design doc; three-layer IaC; charter addendum | Vaco | Addressed (design) |
| R5 | **Network unknown** — manual Azure | High | High | PDF diagram; Azure Reader; egress allow-list | Patrick | Open |
| R6 | **Pen test / Arctic Wolf** Linux findings | High | Medium | **P0 on dev before UAT**; re-scan before prod; standards §5 gates | Kirk | Open |
| R7 | **Registry undecided** (ACR vs GHCR) | Medium | Medium | Standards recommend ACR + UAMI; `acr-baseline` + `build/` layer reference | Client | Mitigated (reference) |
| R8 | **Runner on same host as apps** (dev today) | Medium | High | Split runner/runtime VMs per env | Client | Planned |
| R9 | **Layer 1 Ansible disabled** breaks layer 2 | High | Low | `enable_ansible_customization` required in prod validation | Vaco | **Closed** (IaC) |
| R10 | **Consultant lacks Azure Reader** | Medium | Current | ClickUp #14; Patrick | Tim | Open |

---

## Document history

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-05-28 | Consolidated register |
