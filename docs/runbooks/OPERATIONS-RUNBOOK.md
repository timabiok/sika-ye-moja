# Runbook: Day-2 operations (patch, incident, disk)

> **SOW item 5/6.** Client Linux admin / platform on-call.

---

## 1. Monthly OS patch window

| Step | Action |
|------|--------|
| 1 | Open standard change CHG-XXXX |
| 2 | `sudo dnf update --security` on runner + runtime |
| 3 | Reboot if kernel updated: `sudo shutdown -r +5` |
| 4 | Post-reboot: `systemctl --failed`; `podman ps` |
| 5 | Close change with evidence screenshot |

**Window:** Second Sunday 02:00–06:00 local (industry default).

---

## 2. Container service restart

```bash
sudo systemctl restart <service>.container
sudo journalctl -u <service>.service -f
```

| Service | Unit |
|---------|------|
| Gorobi API | `gorobi.container` |
| Dagster | `dagster.container` |
| nginx | `nginx.container` |

---

## 3. Disk full (runtime / ingestion)

| Step | Action |
|------|--------|
| 1 | `df -h`; identify mount (`/data`, `/var/lib/containers`) |
| 2 | `podman system prune -f` (**runner only** — not prod runtime without approval) |
| 3 | Archive old ingestion files per retention policy |
| 4 | Expand data disk in Azure portal + grow partition |
| 5 | Post-incident: tune retention / alerts |

**Alert threshold:** 80% warning; 90% critical.

---

## 4. Failed GitHub runner job

| Symptom | Action |
|---------|--------|
| Queue stuck | `sudo systemctl restart actions-runner` |
| Disk full on runner | Prune build cache; expand OS disk |
| ACR login fail | `az login --identity -u $UAMI_ID`; check UAMI RBAC |
| Malicious PR | Isolate runner; rotate credentials; security ticket |

---

## 5. ACR pull failure on runtime

```bash
az login --identity -u $UAMI_ID
az acr login --name <acr>
podman pull <acr>.azurecr.io/gorobi:<tag>
```

| Cause | Fix |
|-------|-----|
| PE DNS | Fix privatelink DNS zone |
| Quarantine | Complete security scan in ACR |
| Wrong tag | Redeploy correct sha |

---

## 6. SELinux denial

```bash
sudo ausearch -m avc -ts recent
sudo setsebool -P <bool> on   # only if in standards doc
```

Document new contexts in [STANDARDS-RHEL-PODMAN-v0.1.md](../STANDARDS-RHEL-PODMAN-v0.1.md) appendix.

---

## 7. Incident severity

| Sev | Example | Response |
|-----|---------|----------|
| **P1** | Prod runtime down; trading API unreachable | 15m acknowledge; bridge call |
| **P2** | UAT deploy fail | 1h acknowledge |
| **P3** | Dev runner flake | Next business day |

---

## 8. Break-glass

Follow [BANKING-PLATFORM-STANDARDS-v1.md §11](../BANKING-PLATFORM-STANDARDS-v1.md#11-break-glass-and-emergency-access). Log all actions in ticket.

---

## 9. Evidence for audit

Retain 90 days:

- Change tickets linked to deploys
- `journalctl` exports for P1 incidents
- PIM activation logs for human access
