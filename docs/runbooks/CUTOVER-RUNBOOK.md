# Runbook: First prod Linux cutover (greenfield)

> **SOW item 5.** Client executes; consultant **on-call** in agreed window. Applies when **first prod Linux VMs** go live (not Ubuntu migration).

---

## Scope

| In scope | Out of scope |
|----------|--------------|
| Boot prod runner + runtime from IaC | Application code fixes |
| Deploy container stack from ACR | APIM configuration |
| Validate monitoring + egress | Data migration from on-prem |
| Rollback to “no prod Linux” state | Trading platform changes |

---

## Cutover types

| Type | When | Risk |
|------|------|------|
| **A — Greenfield** | No prod Linux today (**this client**) | Low — new IPs/services |
| **B — Parallel** | Cutover from existing VM | Medium — DNS/LB |
| **C — In-place** | Rebuild same VM | High — not recommended |

**Default:** Type **A**.

---

## Timeline (example — 4h window)

| Time | Activity | Owner |
|------|----------|-------|
| T-7d | CAB approval; freeze comms | PM |
| T-24h | Pre-stage images in prod ACR | Platform |
| T-1h | Go/no-go call | PM + Kirk + Platform |
| T+0 | `terraform apply` prod workload stack | Platform |
| T+30m | Layer-2 Ansible completes; runner registers | Platform |
| T+45m | Deploy prod image tag (validated UAT sha) | Platform |
| T+60m | App smoke tests | App |
| T+90m | Monitoring green | Patrick |
| T+120m | Sign-off or rollback decision | PM |

---

## Pre-cutover checklist

- [ ] UAT sign-off on **same git-sha** to be deployed
- [ ] **P0** pen test items closed
- [ ] Prod tfvars complete ([NETWORK-TO-TFVARS-BRIDGE.md](../NETWORK-TO-TFVARS-BRIDGE.md))
- [ ] Firewall rules for prod static IPs
- [ ] ASR enabled on runtime + data disk
- [ ] Runbook reviewers assigned
- [ ] Rollback decision maker named

---

## Execution steps

### 1. Provision VMs

```bash
cd infra/terraform/environments/workload
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

### 2. Validate Layer 2

```bash
# Runner
ssh runner-prod 'sudo systemctl status actions-runner'
ssh runner-prod 'az login --identity -u $UAMI_ID && az acr login --name <acr>'

# Runtime
ssh runtime-prod 'lsblk; mount | grep containers'
ssh runtime-prod 'az login --identity -u $UAMI_ID && az acr login --name <acr>'
```

### 3. Deploy workloads

```bash
export IMAGE_TAG="<uat-validated-sha>"
# From runner or CI prod environment
./examples/deploy-runtime-stack.sh --env prod --tag "$IMAGE_TAG"
```

### 4. Validate

- Health endpoints via internal LB/APIM path
- Snowflake / Dagster test job (app)
- Azure Monitor + Logic Monitor dashboards

---

## Rollback

| Condition | Action |
|-----------|--------|
| VM provision failure | `terraform destroy` targeted resources; remain on pre-Linux prod |
| Deploy failure | Stop quadlet units; keep VMs for debug |
| App functional failure | Rollback image tag per [PROMOTION-RUNBOOK.md](PROMOTION-RUNBOOK.md) |
| Security incident | Isolate NSG; invoke break-glass; Kirk |

**RTO target:** 4 hours to restored state (industry default).

---

## Post-cutover (T+24h)

- [ ] Hypercare monitoring
- [ ] Lessons learned doc
- [ ] Update CMDB with prod Linux assets
- [ ] Close change ticket

---

## Consultant on-call (agreed window)

| Service | Availability |
|---------|--------------|
| Phone/Slack guidance | Cutover window only |
| terraform apply | **No** — client executes |
| App debugging | **Out of scope**
