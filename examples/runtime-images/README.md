# Runtime workload examples (Layer 3 reference)

Data platform **Podman** stack aligned with client discovery (Workshop 2):

| Container | Image | Route (via nginx) | Role |
|-----------|-------|-------------------|------|
| `gorobi` | `gorobi` | `/gorobi/` | Trading/Gorobi API integration |
| `ingestion` | `ingestion` | `/ingestion/` | File staging → Snowflake path |
| `fastapi-apis` | `fastapi-apis` | `/api/` | FastAPI microservices |
| `dagster` | `dagster` | `/dagster/` | Orchestration webserver |
| `nginx-proxy` | `nginx-proxy` | `:8080` (host) | Reverse proxy ingress |

All app containers attach to `bank-runtime-net`. Only **nginx** publishes port 8080.

## Build (runner VM / CI)

Images are built from `build/images.manifest.json`:

```bash
ACR_NAME=<acr> IMAGE_TAG=<git-sha> ./build/scripts/build-push-images.sh
```

## Deploy (runtime VM)

```bash
ACR_NAME=<acr> IMAGE_TAG=<sha> RUNTIME_UAMI_ID=<uami> \
  /opt/compliance/bootstrap/deploy-runtime-stack.sh
```

## Verify

```bash
curl http://<runtime-ip>:8080/health
curl http://<runtime-ip>:8080/gorobi/v1/positions
curl http://<runtime-ip>:8080/ingestion/v1/staging/status
curl http://<runtime-ip>:8080/api/v1/status
curl http://<runtime-ip>:8080/dagster/
```

See [docs/RUNTIME-WORKLOAD-EXAMPLE.md](../../docs/RUNTIME-WORKLOAD-EXAMPLE.md).
