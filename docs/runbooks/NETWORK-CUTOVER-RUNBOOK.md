# Runbook: Network cutover (LB / DNS / firewall)

> **SOW item 5.** Client network executes. Consultant drafted steps.

---

## When to use

- New prod Linux runtime gets **new private IP** behind existing LB/APIM
- Firewall allow-list updates for static IPs
- DNS points consumers to new endpoint
- **Not** hub/spoke rebuild (change order)

---

## Pre-requisites

| Item | Owner |
|------|-------|
| Static IPs allocated (runner + runtime) | Network |
| [EGRESS-ALLOW-LIST.md](../EGRESS-ALLOW-LIST.md) approved | Network / CAB |
| NSG rules applied (`nsg-baseline`) | Platform |
| Rollback DNS TTL documented | Network |

---

## Wave template (per application)

| Step | Action | Owner | Rollback |
|------|--------|-------|----------|
| 1 | Add **new backend** to LB/APIM pool (runtime IP:8080) | Network | Remove backend |
| 2 | **Health probe** `/health` on 8080 | Network | Disable probe |
| 3 | **Drain** old backend (if any) | Network | Re-enable old |
| 4 | Update **private DNS** if used | DNS team | Revert record |
| 5 | Update **firewall** egress if new Snowflake path | Network | Revert rule |
| 6 | **Smoke test** from consumer subnet | App | — |
| 7 | Remove old backend after 24h stable | Network | — |

---

## Firewall change packet (CAB)

Include for each rule:

| Field | Example |
|-------|---------|
| Source | `10.1.2.20/32` (runtime static) |
| Destination | `*.snowflakecomputing.com` |
| Port | 443 |
| Justification | Prod Linux Dagster runtime |
| Expiry | N/A (permanent) |
| Ticket | CHG-XXXX |

---

## DNS cutover

| Record | Before | After | TTL |
|--------|--------|-------|-----|
| `api.internal.example.com` | old IP | runtime IP or LB front | **300s** for cutover week |

**Rollback:** Restore previous A record; TTL 300 limits propagation delay.

---

## Validation

```bash
# From jump host in consumer VNet
curl -vk https://api.internal.example.com/health
nslookup api.internal.example.com
```

| Test | Pass |
|------|------|
| TLS terminates correctly | Cert valid |
| Health 200 | Yes |
| Snowflake egress | App job succeeds |

---

## Escalation

| Level | Contact |
|-------|---------|
| L1 | Platform on-call |
| L2 | Network (Network team) |
| L3 | Firewall vendor / Azure support |

**Consultant:** Advisory during cutover window only.
