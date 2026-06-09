# Dev Podman assessment v0.1

> **SOW item 1.** Complete on client Linux VM via SSH/Bastion. Industry benchmarks from [BANKING-PLATFORM-STANDARDS-v1.md](BANKING-PLATFORM-STANDARDS-v1.md).

**Status:** In progress (ClickUp #13)

---

## Assessment methodology

| Step | Command / source | Record in |
|------|------------------|-----------|
| OS version | `cat /etc/redhat-release` | Host inventory |
| Podman | `podman --version` | Host inventory |
| Units | `systemctl list-units '*.container'` | Services table |
| Images | `podman images` | Services table |
| Disk | `df -h`, `lsblk` | Resource table |
| CPU/RAM | 2-week Azure Monitor or `sar` | Resource table |
| SELinux | `getenforce`, `ausearch -m avc -ts today` | Findings |
| Mount | `/etc/fstab`, `findmnt` | Findings |
| Access | `/etc/ssh/sshd_config`, local users | Findings |
| Registry | Where images pulled from | Findings |

**Gap output:** [PODMAN-DEPLOY-GAP-LIST.md](PODMAN-DEPLOY-GAP-LIST.md)

---

## Host inventory

| Item | Value | Industry benchmark |
|------|-------|-------------------|
| Hostname | _[TBD]_ | CMDB naming: `fd-dev-eus-podman-runtime-01` |
| RHEL version | _[TBD]_ | **9.x** latest minor |
| Podman version | _[TBD]_ | **≥ 4.4** |
| Kernel | _[TBD]_ | Matches RHSM channel |
| Runner location | _[TBD]_ | **Separate VM** (not co-located) |
| Entra SSH | _[TBD]_ | **Enabled** — no shared admin |
| SELinux | _[TBD]_ | **Enforcing** |
| Data disk | _[TBD]_ | UUID in fstab; `/var/lib/containers` on data disk |

---

## Services (systemd / quadlet)

| Service | Unit file | Image | Status | Target |
|---------|-----------|-------|--------|--------|
| Gorobi API | _[TBD]_ | _[TBD]_ | | Quadlet + ACR pull |
| Ingestion | _[TBD]_ | _[TBD]_ | | Quadlet |
| FastAPI APIs | _[TBD]_ | _[TBD]_ | | Quadlet |
| Dagster | _[TBD]_ | _[TBD]_ | | Quadlet |
| nginx | _[TBD]_ | _[TBD]_ | | Sidecar on 8080 |
| GitHub runner | _[TBD]_ | N/A | | **Move to runner VM** |

---

## Resource utilization (2-week sample)

| Metric | As-is | Industry sizing hint | UAT SKU | Prod SKU |
|--------|-------|---------------------|---------|----------|
| CPU avg | _[TBD]_ | <40% sustained | `D8s_v5` | Scale if avg >50% |
| CPU peak | _[TBD]_ | <80% | | `D16s_v5` if peak >70% |
| RAM avg | _[TBD]_ | <70% | 32 GiB | 64 GiB if peak >80% |
| RAM peak | _[TBD]_ | | | |
| OS disk % | _[TBD]_ | **<70%** | 64 GiB OS | Same |
| Data disk % | _[TBD]_ | **<80%** | 512 GiB | 1 TiB ingestion |
| Podman graph path | _[TBD]_ | Data disk | | |

---

## Deploy path (as-is vs target)

| Step | As-is today | Target |
|------|-------------|--------|
| Build | _[TBD]_ | Runner VM + `build-push-images.sh` |
| Registry | _[TBD]_ | ACR Premium |
| Deploy | _[TBD]_ | GHA → runtime quadlet refresh |
| Secrets | _[TBD]_ | Key Vault + UAMI |
| Ingress | _[TBD]_ | nginx sidecar :8080 |

---

## Findings

| ID | Finding | Severity | Industry remediation | Owner |
|----|---------|----------|---------------------|-------|
| F1 | Mount/fstab | _[TBD]_ | UUID + `mount-data-disk.sh` | Client |
| F2 | SELinux AVCs | _[TBD]_ | Document booleans/contexts | Anatoliy |
| F3 | Shared admin | **P0** | Entra ID SSH | Patrick |
| F4 | Runner co-located | P1 | Split VMs | Platform |
| F5 | No CI deploy | **P0** | GHA promotion runbook | Anatoliy |
| F6 | Registry | _[TBD]_ | ACR — [REGISTRY-AND-SUPPLY-CHAIN.md](REGISTRY-AND-SUPPLY-CHAIN.md) | Patrick |

---

## Assessment sign-off

| Role | Name | Date |
|------|------|------|
| Assessor (Vaco) | Tim | |
| Client technical (Anatoliy) | | |
| Platform (Patrick) | | |
