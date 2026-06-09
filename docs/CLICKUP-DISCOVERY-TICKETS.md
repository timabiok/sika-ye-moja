# ClickUp discovery tickets

> **Engagement:** [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md) — **Track A** stabilize RHEL · **Track B** stabilize network.

Copy into ClickUp. **List:** Stabilization discovery · **Priority:** High until complete.

| Tag | Meaning |
|-----|---------|
| **In scope** | Consultant delivers |
| **Advisory** | Consultant drafts; client implements |
| **Client** | Client owns execution |
| **Out of scope** | Change order or redirect |
| **Blocker** | Gates next work |

**Track:** A = RHEL · B = Network

---

## 1. Request client network architecture packet · **Track B**

**Description:** Ask client network team for **as-built** documentation (network not in IaC — portal/tickets OK).

**Deliverables required from client:**
- Hub–spoke (or vWAN) diagram with regions, peering, firewall/NVA, ExpressRoute/VPN
- Subnet/CIDR list (prod, non-prod, DR)
- Egress path diagram or note (UDR → firewall vs direct)

**Acceptance criteria:**
- [ ] Dated diagram with named owner/contact
- [ ] Prod and non-prod spokes identifiable
- [ ] Build/CI VNet shown or confirmed “not built yet”

**Owner:** Client network · **Consultant:** Facilitate request · **Tag:** Client · **Blocker** for tickets 3–5

---

## 2. Confirm stabilization RACI and decision-maker · **A + B**

**Description:** Align roles per [ENGAGEMENT-ALIGNMENT.md](ENGAGEMENT-ALIGNMENT.md)—stabilize RHEL + network; no app remediation by consultant.

**Acceptance criteria:**
- [ ] Primary approver named (CAB / network architect)
- [ ] RACI signed: network, platform, app, consultant for cutover and firewall changes
- [ ] Environments in scope listed (prod / DR / UAT / dev)
- [ ] Freeze/blackout dates documented

**Owner:** Client PM + network lead · **Consultant:** Draft RACI for review · **Tag:** In scope

---

## 3. Pre-fill discovery questionnaire from architecture packet

**Description:** Map client diagrams/docs to [NETWORK-DISCOVERY-QUESTIONNAIRE.md](NETWORK-DISCOVERY-QUESTIONNAIRE.md); list open gaps only.

**Acceptance criteria:**
- [ ] Questionnaire sections 2–3 marked answered or gap
- [ ] Gap list shared with client (≤15 items target)
- [ ] Out-of-scope items flagged (app testing, licensing, audit)

**Owner:** Consultant · **Tag:** In scope · **Depends on:** Ticket 1

---

## 4. Network discovery workshop (gaps only)

**Description:** 60–90 min session with network/platform—do not re-ask what diagrams already answer.

**Agenda:**
- Egress, proxy, forced tunneling (§3)
- Image-build subnet + private endpoints (§4)
- Cutover: IP/LB/DNS per wave (§8)
- CAB lead time and escalation (§10)

**Acceptance criteria:**
- [ ] Workshop notes attached to ticket
- [ ] All **In scope** gaps closed or owned with due date
- [ ] Client-owned actions assigned (firewall apply, PE, DNS links)

**Owner:** Consultant facilitates · **Tag:** In scope · **Depends on:** Tickets 1, 3

---

## 5. Document firewall allow-list for RHEL workloads · **Track B**

**Description:** Draft FQDN/IP rules for **prod VM**: dnf, RHSM, Snowflake, GitHub Actions, Azure APIs. Add AIB/storage only if golden image adopted. **Out of scope:** consultant applies rules.

**Acceptance criteria:**
- [ ] Allow-list doc attached (sources: Red Hat, Microsoft, client Satellite if any)
- [ ] Proxy/PAC exceptions noted if required
- [ ] Client ticket # or owner assigned for rule implementation

**Owner:** Consultant draft · **Client implements** · **Tag:** Advisory · **Depends on:** Ticket 4

---

## 6. IPAM: reserve image-build spoke CIDR · **Track B** · **optional**

**Description:** Only if client adopts golden image pipeline. Otherwise **out of scope** — skip ticket.

**Acceptance criteria:**
- [ ] CIDR documented in IPAM
- [ ] Peering + UDR owner named
- [ ] Target date for provisioning agreed

**Owner:** Client network · **Tag:** Client-owned · **Out of scope** for default Workshop 1 path

---

## 7. Private DNS and private endpoint ownership · **Track B**

**Description:** For **prod VM** private access (Key Vault, storage, PaaS). Add `privatelink.blob` for image build only if ticket 6 in scope.

**Acceptance criteria:**
- [ ] DNS team contact identified
- [ ] Process for VNet link + PE approval documented
- [ ] Public access on build storage: allowed or denied (decision recorded)

**Owner:** Client DNS/network · **Tag:** Client-owned · **Depends on:** Ticket 4

---

## 8. Azure Policy check for RHEL VMs · **Track A**

**Description:** Verify policies for existing/planned VMs (public IP, etc.). Image Builder checks **out of scope** unless ticket 6 adopted.

**Acceptance criteria:**
- [ ] Policy export or screenshot reviewed
- [ ] Exceptions/process documented if blocked
- [ ] `Microsoft.VirtualMachineImages` registration status confirmed

**Owner:** Client platform · **Consultant:** Review · **Tag:** Client-owned

---

## 9. RHSM / licensing network path (client-owned)

**Description:** Per SOW, client owns licensing—confirm how build VMs reach Key Vault and Red Hat.

**Acceptance criteria:**
- [ ] BYOS vs Satellite documented
- [ ] Key Vault + secret owner named
- [ ] Network path to KV (PE/firewall) confirmed or gap ticket opened

**Owner:** Client platform + procurement · **Tag:** Client-owned · **Out of scope:** license purchase

---

## 10. Publish RHEL + network standards (draft) · **A + B**

**Description:** SOW item 2 — separate sections: **RHEL/Podman on Azure** (Track A) and **network requirements** (Track B). Not full landing-zone build.

**Acceptance criteria:**
- [ ] RHEL: Podman, mount, SELinux, patching, monitoring, CI/CD promotion
- [ ] Network: egress, DNS/NTP, admin access, allow-list refs; build spoke **optional**
- [ ] “Client implements” vs “consultant advised” on every item
- [ ] Out-of-scope appendix (app, K8s, hub build, audit)

**Owner:** Consultant · **Tag:** In scope · **Depends on:** Tickets 4, 5

---

## 11. Cutover network runbook template (per wave)

**Description:** Draft LB/DNS/IP/rollback steps—client executes during window.

**Acceptance criteria:**
- [ ] Template attached with placeholders per application
- [ ] Rollback and RTO/RPO fields included
- [ ] App vs network actions separated (app remediation out of scope)

**Owner:** Consultant draft · **Client executes** · **Tag:** In scope · **Depends on:** Ticket 4

---

## 12. Network risk register (initial)

**Description:** SOW item 3 — document top network risks from discovery.

**Acceptance criteria:**
- [ ] ≥5 risks logged (firewall, DNS, FIPS, CAB delay, CIDR overlap, etc.)
- [ ] Owner and mitigation per risk
- [ ] Shared with client PM

**Owner:** Consultant · **Tag:** In scope · **Depends on:** Ticket 4

---

## 13. Dev Linux / Podman assessment (deep-dive) · **Track A** · **In progress**

**Description:** Tim reviews **dev** Linux VM — Podman, systemd, mount, SELinux, deploy path. **Out of scope:** fixing issues (client).

**Acceptance criteria:**
- [ ] Assessment doc attached
- [ ] P0/P1 findings with owners
- [ ] UAT/prod Linux design recommendation recorded

**Owner:** Consultant · **Linux access:** done

---

## 14. Azure subscription read access · **Track A + B** · **Blocker** for Azure context

**Description:** Grant Tim **Reader** on dev and prod **subscriptions** (both tenants). No write roles required for assessment.

**Acceptance criteria:**
- [ ] Reader on dev subscription
- [ ] Reader on prod subscription (for future UAT/prod VM planning)
- [ ] Vaco identity documented (email / Entra object ID)
- [ ] Or: client provides weekly resource exports if RBAC denied

**Owner:** Patrick / platform · **Tag:** Client · **Blocks:** full Track B validation, VM↔Azure mapping

---

## Suggested ClickUp structure

| Phase | Tickets |
|-------|---------|
| **Week 1** | 13 (Podman assess — **started**), **14 (Azure Reader)**, 2, 1, 8 |
| **Week 2** | 3, 4, 9 |
| **Week 3** | 5, 7, 12 (skip 6 unless golden image) |
| **Week 4** | 10, 11 |

**Dependencies:** 1 → 3 → 4 → (5, 10, 11, 12) · 13 blocks Track A standards · 6/7 optional
