# Runbook: Image build and environment promotion

> **SOW item 5/6.** Client executes. Opinionated banking flow: dev → UAT → prod.

---

## Preconditions

- [ ] Runner VM online; `actions-runner` active
- [ ] Runtime VM online; quadlet units enabled
- [ ] ACR reachable from both VMs (PE + UAMI)
- [ ] GitHub Environment reviewers configured for `uat` and `prod`
- [ ] Change ticket approved (UAT/prod)

---

## 1. Build and push (dev)

**Trigger:** Push to `main` or manual `workflow_dispatch`

```bash
# On runner VM — normally via GitHub Actions
cd /opt/actions-runner/_work/<repo>/<repo>
./build/scripts/build-push-images.sh --env dev --tag "$(git rev-parse --short HEAD)"
```

**Verify:**

```bash
az acr repository show-tags --name <acr> --repository gorobi --orderby time_desc --top 3
```

---

## 2. Deploy to dev runtime

```bash
# Runner or workflow step — refresh runtime
export IMAGE_TAG="<git-sha>"
ssh -i <key> runtime-dev.internal 'sudo /opt/compliance/bootstrap/deploy-runtime-stack.sh --tag '"$IMAGE_TAG"
```

**Or** runtime self-pull (preferred):

```bash
# On runtime VM
sudo systemctl set-environment IMAGE_TAG=<git-sha>
sudo systemctl restart gorobi.container dagster.container nginx.container
sudo systemctl --failed
```

---

## 3. Promote to UAT

| Step | Action | Owner |
|------|--------|-------|
| 1 | Open PR `main` → `release/uat` or tag `uat-YYYY-MM-DD` | Dev |
| 2 | GitHub Environment **uat** — required reviewer approves | Platform |
| 3 | Workflow runs on **UAT runner** with label `uat` | CI |
| 4 | Deploy to **UAT runtime** with same git-sha | CI |
| 5 | App owner smoke test | App team |

**Rollback (UAT):** Redeploy previous git-sha from ACR (see §6).

---

## 4. Promote to prod

| Step | Action | Owner |
|------|--------|-------|
| 1 | Tag `vX.Y.Z` on validated UAT sha | Release manager |
| 2 | GitHub Environment **prod** — two reviewers (platform + app) | CAB |
| 3 | Workflow on **prod runner** | CI |
| 4 | Deploy during **change window** | Platform |
| 5 | Monitor 30m — Logic Monitor + Azure Monitor alerts | On-call |

**Go/no-go:** Security sign-off if within 7 days of prod scan.

---

## 5. Post-deploy validation

```bash
# Runtime VM
curl -sf http://127.0.0.1:8080/health
sudo podman ps
sudo journalctl -u gorobi.service -u nginx.service --since "15 min ago" | tail -50
```

| Check | Pass criteria |
|-------|---------------|
| Health endpoint | HTTP 200 |
| Containers | All `Up` |
| Snowflake connectivity | Dagster job test (app) |
| No CRITICAL alerts | 30m clean |

---

## 6. Rollback

| Step | Command / action |
|------|------------------|
| 1 | Identify `PREVIOUS_SHA` from deployment log or ACR |
| 2 | `systemctl set-environment IMAGE_TAG=$PREVIOUS_SHA` |
| 3 | `systemctl restart <affected>.container` |
| 4 | Verify health |
| 5 | Open incident ticket; root-cause within 48h |

**Max rollback window:** 4 hours after prod deploy without CAB re-approval.

---

## Contacts

| Role | Contact |
|------|---------|
| Platform on-call | _[client]_ |
| App owner | _[App team]_ |
| Network (egress) | _[Network team]_ |
