# Podman deploy gap list — dev → industry target

> **SOW items 1 and 4.** Opinionated gap analysis: **current dev state** (Workshop 2) vs **banking target** ([BANKING-PLATFORM-STANDARDS-v1.md](BANKING-PLATFORM-STANDARDS-v1.md)). Client fills “as-is” during assessment.

**Status:** Draft — update after [DEV-PODMAN-ASSESSMENT.md](DEV-PODMAN-ASSESSMENT.md) deep-dive.  
**Industry authorities:** [INDUSTRY-REFERENCES.md](INDUSTRY-REFERENCES.md)

---

## Summary

| Category | Gaps | P0 count |
|----------|------|----------|
| Identity & access | 3 | 1 |
| Deploy automation | 4 | 2 |
| Registry & supply chain | 3 | 1 |
| Runtime architecture | 4 | 1 |
| Network & security | 3 | 0 |
| Operations | 3 | 0 |
| **Total** | **20** | **5** |

---

## Gap register

| ID | Area | As-is (W2) | Target (industry) | Sev | Owner | Due |
|----|------|------------|-------------------|-----|-------|-----|
| G01 | Access | Shared admin on dev Linux | Entra ID SSH; per-user accounts | **P0** | Patrick / Anatoliy | Week 2 |
| G02 | Access | No PIM for developers | PIM eligible dev sub roles | P1 | Patrick | Week 3 |
| G03 | Access | Consultant lacks Azure Reader | PIM Reader dev+prod subs | P1 | Patrick | Week 1 |
| G04 | Deploy | Images built locally; partial push | Full CI: build → ACR → runtime pull | **P0** | Anatoliy | Week 6 |
| G05 | Deploy | No automated deploy to runtime | GitHub Actions + quadlet refresh | **P0** | Anatoliy | Week 6 |
| G06 | Deploy | Runner co-located with apps | Split runner + runtime VMs per env | P1 | Client platform | UAT |
| G07 | Deploy | Manual systemd/compose | Quadlet units in git | P1 | Anatoliy | Week 4 |
| G08 | Registry | ACR vs GHCR undecided | **ACR Premium** + UAMI | **P0** | Patrick | Week 3 |
| G09 | Registry | No image signing | Content trust / notation before prod | P1 | Client security | Pre-prod |
| G10 | Registry | No vulnerability gate in CI | Trivy/Defender block CRITICAL | P1 | Kirk | UAT |
| G11 | Runtime | Mount/fstab manual repair | UUID fstab + `mount-data-disk.sh` | **P0** | Anatoliy | Week 2 |
| G12 | Runtime | SELinux issues possible | Documented contexts; test on UAT | P1 | Anatoliy | Week 3 |
| G13 | Runtime | Podman graph on OS disk | Data disk `/var/lib/containers` | P1 | Client platform | UAT |
| G14 | Runtime | Ingress unclear (nginx vs APIM) | nginx sidecar default; APIM later | P2 | Anatoliy | Week 5 |
| G15 | Network | Egress not documented | [EGRESS-ALLOW-LIST.md](EGRESS-ALLOW-LIST.md) in CAB | P1 | Patrick | Week 4 |
| G16 | Network | Static IPs not in IPAM | Document runner/runtime IPs | P2 | Network team | UAT |
| G17 | Network | No Azure Monitor on Linux | AMA + DCR on UAT/prod VMs | P1 | Patrick | UAT |
| G18 | Ops | No promotion runbook | [runbooks/PROMOTION-RUNBOOK.md](runbooks/PROMOTION-RUNBOOK.md) | P1 | Vaco draft | Week 5 |
| G19 | Ops | No rollback tested | Rollback drill on UAT | P1 | Anatoliy | UAT |
| G20 | Ops | Pen test findings open | P0 closed before UAT template | **P0** | Kirk | UAT gate |

---

## Exit criteria (Phase 1)

- [ ] All **P0** gaps have owner + due date accepted by client PM
- [ ] G04/G05 remediation plan agreed (automation sprint)
- [ ] G08 registry decision recorded (default: ACR)
- [ ] Assessment doc updated with measured metrics

---

## Out of scope (do not track as consultant gaps)

- Application code defects (Dagster, Gorobi, APIs)
- APIM build
- Hub/spoke greenfield
- Pen test execution / remediation labor
