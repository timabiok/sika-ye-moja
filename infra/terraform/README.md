# Terraform — three-layer banking baseline

Reference IaC — **client deploys**. Prescriptive defaults per [docs/STANDARDS-RHEL-PODMAN-v0.1.md](../../docs/STANDARDS-RHEL-PODMAN-v0.1.md).

## Layers

| Layer | Path | Delivers |
|-------|------|----------|
| **1** | `environments/prod/` or `layer1-image-pipeline/` (symlink) | SIG + AIB + Ansible layer-1 (`enable_ansible_customization` **required**) |
| **2** | `environments/workload/` | `layer2-workload-stack` — NSG, UAMI, static IP, data disk, cloud-init Ansible |
| **3** | `build/` + `.github/workflows/` | Manifest-driven Podman build → ACR push → deploy |

## Modules

| Module | Purpose |
|--------|---------|
| `nsg-baseline` | Banking NSG — deny inbound, Bastion SSH, role egress |
| `compute-linux` | Trusted Launch VM — **UAMI required**, static IP default |
| `acr-baseline` | Banking ACR — private, quarantine, retention |
| `developer-cli-access` | PIM eligible roles for developer `az` CLI (dev only) |
| `layer2-workload-stack` | Runner + runtime + ACR/KV RBAC |
| `vm-role-bootstrap` | Layer-2 cloud-init |
| `storage-fileshare` | Optional Azure Files NFS |
| `image-builder`, `sig`, `build-network` | Layer 1 golden image |

## Build sequence

```bash
./scripts/package-ansible.sh 1.0.0
cd environments/prod && cp terraform.tfvars.example terraform.tfvars
terraform apply
# Trigger AIB → note sig_image_version_id

cd ../workload
# Fill terraform.tfvars from docs/NETWORK-TO-TFVARS-BRIDGE.md
terraform apply
```

## Banking validations enforced

- Layer 1: Ansible on, pinned RHEL version
- Layer 2: `bastion_subnet_prefix`, `acr_id`, `key_vault_id`, static IPs
- Compute: UAMI required, static IP unless override

## Policies

See `policies/` — SIG-only, Trusted Launch, no public IP.
