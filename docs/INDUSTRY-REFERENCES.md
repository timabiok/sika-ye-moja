# Industry references (standards authority map)

> **Purpose:** Authoritative external sources behind prescriptive choices in this engagement’s standards pack. Use for client GRC review, CAB packets, and auditor evidence. **Not legal advice** — client GRC validates applicability.
>
> **Internal standards using these references:** [STANDARDS-RHEL-PODMAN-v0.1.md](STANDARDS-RHEL-PODMAN-v0.1.md) · [BANKING-PLATFORM-STANDARDS-v1.md](BANKING-PLATFORM-STANDARDS-v1.md) · [NETWORK-IAM-STANDARDS.md](NETWORK-IAM-STANDARDS.md) · [COMPLIANCE.md](COMPLIANCE.md)

---

## 1. US financial sector governance

| Framework | Reference | Used for |
|-----------|-----------|----------|
| **FFIEC Information Security Handbook** | [ithandbook.ffiec.gov](https://ithandbook.ffiec.gov/) | Secure configuration, access control, change management, vendor/cloud risk |
| **FFIEC Cybersecurity Assessment Tool (CAT)** | [ffiec.gov/cyberassessmenttool.htm](https://www.ffiec.gov/cyberassessmenttool.htm) | Maturity mapping for platform controls |
| **FFIEC Outsourcing Technology Services** | [FFIEC IT Examination Handbook — Outsourcing](https://ithandbook.ffiec.gov/it-booklets/outsourcing-technology-services/) | Cloud (Azure) third-party dependency documentation |
| **GLBA Safeguards Rule** | [FTC Safeguards Rule](https://www.ftc.gov/business-guidance/privacy-security/gramm-leach-bliley-act) | Administrative/technical safeguards for customer information |
| **SOX ITGC** | [COSO Internal Control Framework](https://www.coso.org/guidance-on-ic) | Change management evidence (IaC, image versions, deploy approvals) |
| **PCI DSS v4** (if CDE) | [pcisecuritystandards.org](https://www.pcisecuritystandards.org/document_library/) | Req. 2 (secure config), 6 (secure dev), 10 (logging) |

---

## 2. Cybersecurity frameworks

| Framework | Reference | Maps to our controls |
|-----------|-----------|----------------------|
| **NIST Cybersecurity Framework 2.0** | [nist.gov/cyberframework](https://www.nist.gov/cyberframework) | Identify, Protect, Detect, Respond, Recover |
| **NIST SP 800-53 Rev. 5** | [csrc.nist.gov SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) | CM-*, SI-*, AU-*, IA-*, AC-* families |
| **NIST SP 800-190** (application container security) | [csrc.nist.gov SP 800-190](https://csrc.nist.gov/publications/detail/sp/800-190/final) | Podman runtime, image build, registry isolation |
| **NIST SP 800-207** (Zero Trust) | [csrc.nist.gov SP 800-207](https://csrc.nist.gov/publications/detail/sp/800-207/final) | Per-VM UAMI, least privilege, no standing admin |
| **CIS Critical Security Controls v8** | [cisecurity.org/controls](https://www.cisecurity.org/controls) | Inventory, secure config, continuous vuln management, audit logs |
| **CIS Benchmarks program** | [cisecurity.org/cis-benchmarks](https://www.cisecurity.org/cis-benchmarks) | OS and cloud hardening methodology |

---

## 3. OS baseline — RHEL 9

| Topic | Reference | Our implementation |
|-------|-----------|-------------------|
| **CIS Red Hat Enterprise Linux 9 Benchmark (Level 1)** | [CIS RHEL 9 Benchmark](https://www.cisecurity.org/benchmark/red_hat_linux) | Primary baseline — OpenSCAP in golden image |
| **DISA STIG — RHEL 9** | [cyber.mil STIGs](https://public.cyber.mil/stigs/) · [STIG Viewer](https://stigviewer.com/stigs) | Optional only if GRC mandates — do not stack with CIS L1 without approval |
| **OpenSCAP** | [open-scap.org](https://www.open-scap.org/) | Scan/remediate/verify in AIB |
| **ComplianceAsCode / scap-security-guide** | [github.com/ComplianceAsCode/content](https://github.com/ComplianceAsCode/content) | CIS and STIG profiles for RHEL 9 |
| **RHEL 9 Security Hardening** | [Red Hat — Security hardening](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/) | SELinux, SSH, audit, crypto policy |
| **RHEL 9 Managing systems with RHEL system roles** | [Red Hat — RHEL system roles](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/security-hardening-with-opa-scan-and-ansible-system-roles_managing-systems-using-the-rhel-9-web-console) | Ansible hardening patterns |
| **SELinux for containers** | [Red Hat — Container SELinux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/assembly_using-selinux-with-containers_using-selinux) | Podman volume contexts |
| **dnf-automatic** | [Red Hat — dnf-automatic](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_software_with_the_dnf_tool/automating-software-updates-in-rhel-9_managing-software-with-the-dnf-tool) | Security-only patching |
| **FIPS 140** | [Red Hat — FIPS mode](https://access.redhat.com/articles/144653) | App-team validation before enable |

---

## 4. Containers — Podman, supply chain, CI/CD

| Topic | Reference | Our implementation |
|-------|-----------|-------------------|
| **Podman documentation** | [docs.podman.io](https://docs.podman.io/) | Runtime standard (no Docker daemon) |
| **Quadlet / systemd units** | [podman-systemd.unit(5)](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) | `.container`, `.network` under `/etc/containers/systemd/` |
| **Red Hat UBI 9** | [catalog.redhat.com — UBI](https://catalog.redhat.com/software/containers/ubi9/6189f9ab0f2ec38f9458bc79) | Base image recommendation |
| **NIST SP 800-190** | [SP 800-190](https://csrc.nist.gov/publications/detail/sp/800-190/final) | Registry isolation, non-root where feasible, image provenance |
| **SLSA (Supply-chain Levels for Software Artifacts)** | [slsa.dev](https://slsa.dev/) | Build provenance target (Level 2+) |
| **OpenSSF Best Practices** | [openssf.org](https://openssf.org/) | OSS dependency and CI hygiene |
| **GitHub Actions — self-hosted runners** | [About self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners) | Dedicated runner VM, lower trust zone |
| **GitHub Actions — environments** | [Using environments for deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) | Required reviewers for UAT/prod |
| **GitHub OIDC with Azure** | [OIDC in Azure](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure) | Federated credentials vs SP secrets |
| **CNCF Software Supply Chain Best Practices** | [tag-security/supply-chain](https://github.com/cncf/tag-security/blob/main/supply-chain-security/supply-chain-security-paper/CNCF_SSCP_v1.pdf) | Image signing, SBOM |

---

## 5. Azure platform — identity, network, compute

| Topic | Reference | Our implementation |
|-------|-----------|-------------------|
| **Microsoft Cloud Security Benchmark (MCSB)** | [Azure security baseline](https://learn.microsoft.com/en-us/security/benchmark/azure/) | NSG, identity, logging alignment |
| **CIS Microsoft Azure Foundations Benchmark** | [CIS Azure Benchmark](https://www.cisecurity.org/benchmark/azure) | Subscription/resource hardening |
| **Azure Landing Zone** | [Cloud Adoption Framework — Landing zone](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) | Hub/spoke advisory (client implements) |
| **Network Security Groups** | [NSG overview](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) | Deny-all inbound default |
| **Azure Bastion** | [Bastion overview](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview) | SSH path — no public IP |
| **Private Link / Private Endpoint** | [Private Endpoint overview](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) | ACR, Key Vault, Azure Files |
| **User-assigned managed identity** | [Managed identities overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview) | One UAMI per VM |
| **Entra ID — Linux SSH sign-in** | [Sign in to Linux with Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-vm-sign-in-azure-ad-linux) | Retire shared admin |
| **Privileged Identity Management** | [PIM overview](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure) | Developer + consultant JIT access |
| **Key Vault best practices** | [Key Vault best practices](https://learn.microsoft.com/en-us/azure/key-vault/general/best-practices) | No secrets in images/git |
| **Trusted Launch** | [Trusted Launch](https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch) | Secure Boot + vTPM |
| **Azure Shared Image Gallery** | [SIG overview](https://learn.microsoft.com/en-us/azure/virtual-machines/shared-image-galleries) | Golden image versioning |
| **Azure Image Builder** | [AIB overview](https://learn.microsoft.com/en-us/azure/virtual-machines/image-builder-overview) | Layer 1 pipeline |
| **Azure Policy** | [Azure Policy documentation](https://learn.microsoft.com/en-us/azure/governance/policy/) | SIG-only, no public IP samples |

---

## 6. Azure Container Registry and monitoring

| Topic | Reference | Our implementation |
|-------|-----------|-------------------|
| **ACR best practices** | [Container registry best practices](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-best-practices) | Premium, PE, RBAC |
| **ACR security baseline** | [ACR security](https://learn.microsoft.com/en-us/azure/container-registry/acs-authentication-managed-identity) | UAMI auth, admin disabled |
| **ACR content trust / signing** | [Container image trust](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-content-trust) | Required before prod |
| **Defender for Containers** | [Defender for Cloud — containers](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-introduction) | Vulnerability scanning |
| **Azure Monitor Agent** | [AMA overview](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-overview) | DCR + Log Analytics |
| **Data Collection Rules** | [DCR overview](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-collection-rule-overview) | Syslog + perf counters |
| **Azure Monitor logs for Linux** | [Log Analytics agent migration](https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-migration) | AMA (not legacy MMA) |

---

## 7. Backup, DR, and operations

| Topic | Reference | Our implementation |
|-------|-----------|-------------------|
| **Azure Backup** | [Azure Backup overview](https://learn.microsoft.com/en-us/azure/backup/backup-overview) | Runtime data disk |
| **Azure Site Recovery** | [ASR overview](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview) | Runtime VM + disk replication |
| **Azure Files NFS** | [Azure Files NFS](https://learn.microsoft.com/en-us/azure/storage/files/files-nfs-protocol) | Optional shared ingestion |
| **ITIL change management** | [Axelos ITIL 4](https://www.axelos.com/certifications/itil-service-management/itil-4-foundation) | CAB, standard vs emergency change |

---

## 8. Ingress and API edge (advisory)

| Topic | Reference | Our default |
|-------|-----------|-------------|
| **nginx reverse proxy** | [nginx — proxy module](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) | Sidecar on runtime VM :8080 |
| **Azure API Management** | [APIM overview](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts) | Future option — change order |
| **OWASP API Security Top 10** | [owasp.org/API-Security](https://owasp.org/www-project-api-security/) | Token validation, ingress hardening |

---

## 9. Per-document quick index

| Internal doc | Primary external authorities |
|--------------|------------------------------|
| [STANDARDS-RHEL-PODMAN-v0.1.md](STANDARDS-RHEL-PODMAN-v0.1.md) | CIS RHEL 9 L1, Red Hat hardening, Podman/Quadlet, MCSB, SP 800-190 |
| [BANKING-PLATFORM-STANDARDS-v1.md](BANKING-PLATFORM-STANDARDS-v1.md) | FFIEC IS Handbook, NIST CSF, CIS Controls, SLSA, ITIL |
| [NETWORK-IAM-STANDARDS.md](NETWORK-IAM-STANDARDS.md) | MCSB, CIS Azure, PIM, Entra SSH, NSG, SP 800-207 |
| [REGISTRY-AND-SUPPLY-CHAIN.md](REGISTRY-AND-SUPPLY-CHAIN.md) | ACR best practices, SP 800-190, SLSA, Defender for Containers |
| [EGRESS-ALLOW-LIST.md](EGRESS-ALLOW-LIST.md) | FFIEC data flows, Azure outbound rules, Private Link |
| [VM-DESIGN-CONSIDERATIONS.md](VM-DESIGN-CONSIDERATIONS.md) | CAF landing zone, Trusted Launch, CIS Azure |
| [DEVELOPER-AZURE-CLI-ACCESS.md](DEVELOPER-AZURE-CLI-ACCESS.md) | PIM, least privilege, MCSB identity |
| [INGRESS-DECISION-NGINX-SIDECAR.md](INGRESS-DECISION-NGINX-SIDECAR.md) | OWASP API, APIM, nginx |
| [BUILD-LAYER.md](BUILD-LAYER.md) | ACR, GitHub Actions, SP 800-190 |
| [ARCHITECTURE.md](ARCHITECTURE.md) | SIG, AIB, CIS, MCSB, three-layer separation |
| [COMPLIANCE.md](COMPLIANCE.md) | FFIEC, NIST 800-53, PCI, CIS, STIG |
| [runbooks/](runbooks/) | ITIL change, NIST IR, Red Hat ops guides |

---

## 10. Red Hat subscription and support

| Topic | Reference |
|-------|-----------|
| **RHEL on Azure** | [Red Hat on Azure](https://www.redhat.com/en/partners/microsoft-azure) |
| **RHSM** | [Red Hat Subscription Management](https://access.redhat.com/products/red-hat-subscription-management) |
| **Red Hat Customer Portal** | [access.redhat.com](https://access.redhat.com/) |

---

## Maintenance

Review links **quarterly** or when CIS/NIST/Azure releases major updates. Report broken links to platform team.

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-05-28 | Initial authority map for standards pack |
