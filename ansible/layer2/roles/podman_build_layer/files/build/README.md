# Container build layer (Layer 3 — build)

Builds OCI images from Dockerfiles on the **GitHub runner VM** and pushes to **Azure Container Registry (ACR)**.

| Artifact | Purpose |
|----------|---------|
| `images.manifest.json` | Declarative image catalog |
| `scripts/build-push-images.sh` | Standardized Podman build + push + digest manifest |
| `artifacts/build-manifest.json` | CI output — image digests for deploy pinning |

## Quick start

```bash
ACR_NAME=myacr IMAGE_TAG="$(git rev-parse HEAD)" \
  IMAGE_SOURCE="$(git config --get remote.origin.url)" \
  ./build/scripts/build-push-images.sh
```

With runner UAMI:

```bash
RUNNER_UAMI_ID=/subscriptions/.../uami-github-runner \
  ACR_NAME=myacr IMAGE_TAG="$(git rev-parse HEAD)" \
  ./build/scripts/build-push-images.sh
```

## Add an image

1. Add Dockerfile under `examples/runtime-images/` or client path.
2. Register in `images.manifest.json`.
3. Re-run build — no workflow edits required.

See [docs/BUILD-LAYER.md](../docs/BUILD-LAYER.md).
