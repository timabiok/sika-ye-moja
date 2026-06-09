# sika-ye-moja

Documentation and **reference** IaC for **stabilizing RHEL on Azure** and **stabilizing network posture** (document + recommend; client implements), per [docs/ENGAGEMENT-ALIGNMENT.md](docs/ENGAGEMENT-ALIGNMENT.md).

**Confirmed:** **No production Linux**; **dev hosts use Podman**. Path: stabilize dev → UAT → first prod Linux. Network **not in client IaC**. See **[Next steps](docs/NEXT-STEPS.md)**.

## Dual workstreams

| Track | Focus | Consultant | Client |
|-------|--------|------------|--------|
| **A — RHEL** | Reliable VM, standards, UAT path | Assess, standards, runbooks, optional reference IaC | Fix mount/SELinux, monitoring, deploy |
| **B — Network** | Egress, DNS, firewall for RHEL | As-built review, allow-list draft, risks | Implement rules, PE, DNS (portal/tickets) |

**Out of scope (default):** App remediation, network build, prod terraform apply by consultant, licensing, audit sign-off, mandatory golden image for one bespoke host.

## Documentation (start here)

1. **[Engagement alignment](docs/ENGAGEMENT-ALIGNMENT.md)** — scope, in/out, doc map  
1b. **[Deliverables checklist](docs/DELIVERABLES-CHECKLIST.md)** — track completion  
1c. **[Stabilization pack PDFs](https://github.com/timabiok/sika-ye-moja/tree/main/deliverables/stabilization-pack/v0.1)** — client review pack ([review email](https://github.com/timabiok/sika-ye-moja/blob/main/deliverables/stabilization-pack/v0.1/REVIEW-EMAIL.md); rebuild: `./scripts/build-deliverable-pdfs.sh`)  
2. **[SOW](docs/SOW.md)** — original contract (Fortified #743101, 60h advisory); [charter](docs/CHARTER-ADDENDUM.md) aligns discovery  
3. **[Stabilization strategy](docs/STRATEGY-POST-RHEL.md)** — phased plan  
4. **[Workshop 1 summary](docs/discovery-workshop-1.md)** — current state  
4b. **[Clarifications for Anatoliy](docs/CLARIFICATIONS-WITH-DEV-TEAM.md)** — dev/platform question list  
5. **[Network discovery](docs/NETWORK-DISCOVERY-QUESTIONNAIRE.md)** — Track B  
6. **[ClickUp tickets](docs/CLICKUP-DISCOVERY-TICKETS.md)** — discovery tasks  
7. **[VM design considerations](docs/VM-DESIGN-CONSIDERATIONS.md)** — UAT/prod Linux VM outline  
8. **[Banking standards](docs/STANDARDS-RHEL-PODMAN-v0.1.md)** — prescriptive RHEL + Podman baseline  
8b. **[Platform standards (gaps)](docs/BANKING-PLATFORM-STANDARDS-v1.md)** — opinionated industry defaults  
8c. **[Industry references](docs/INDUSTRY-REFERENCES.md)** — CIS, NIST, FFIEC, Azure, Red Hat authority links  
8d. **[Gap list](docs/PODMAN-DEPLOY-GAP-LIST.md)** · **[Env backlog](docs/ENVIRONMENT-IMPROVEMENT-BACKLOG.md)** · **[Runbooks](docs/runbooks/)**  
9. **[Network & IAM standards](docs/NETWORK-IAM-STANDARDS.md)** — NSG + UAMI model  
10. **[Charter addendum](docs/CHARTER-ADDENDUM.md)** — client sign-off draft  

**Reference (optional):**

- [Golden image architecture](docs/ARCHITECTURE.md) — AIB/SIG pipeline for VM fleets  
- [Hub–spoke network patterns](docs/AZURE-NETWORK-ARCHITECTURE.md) — target state; not consultant build  
- [Compliance mapping](docs/COMPLIANCE.md) — informational only  

## Reference IaC (SOW item 6 — client adopts; not consultant prod deploy)

Per SOW scope boundaries, security/monitoring/automation **implementation** is client-owned; this repo delivers **draft standards and KT patterns** (items 2, 4, 6).

**Three layers:** golden image (1) → VM role bootstrap (2) → GitHub Actions workloads (3). See [infra/terraform/README.md](infra/terraform/README.md).

```bash
# Layer 1 — SIG / AIB golden image
./scripts/package-ansible.sh 1.0.0
cd infra/terraform/environments/prod
terraform init && terraform plan

# Layer 2 — runner + runtime VMs from SIG
cd ../workload
terraform init && terraform plan
```

Includes: image builder, SIG, `layer2-workload-stack`, compute-linux, storage-fileshare, Ansible baseline (Python, pip, venv, Ansible Core). See [ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Disclaimer

Advisory engagement per [SOW](docs/SOW.md). Client validates with security, GRC, and network teams before production changes.
