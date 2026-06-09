# compute-linux

Reference module for a **Trusted Launch** RHEL Linux VM with a **user-assigned managed identity (UAMI)**.

Client deploys two instances per environment — see [docs/VM-DESIGN-CONSIDERATIONS.md](../../../../docs/VM-DESIGN-CONSIDERATIONS.md) §1 and §6.2.

## Two VMs per environment

| Instance | Tag `Role` | UAMI (example name) | Typical RBAC on UAMI |
|----------|------------|---------------------|----------------------|
| GitHub runner | `github-runner` | `uami-{env}-github-runner` | `AcrPush`, `Key Vault Secrets User` |
| Podman runtime | `podman-runtime` | `uami-{env}-podman-runtime` | `AcrPull`, `Key Vault Secrets User` |

Create **two UAMI resources** and **two `module "compute-linux"` blocks** (or equivalent Bicep). Do not share one identity across both VMs.

## Azure CLI on both VMs

Azure does not enable CLI via a VM toggle. Client baseline should:

1. Install `azure-cli` on **both** runner and runtime hosts.
2. Attach the correct UAMI via `user_assigned_identity_ids`.
3. Assign RBAC to each UAMI principal at the appropriate scope (ACR, Key Vault).
4. Use on-host auth without secrets:

```bash
az login --identity -u "<user-assigned-identity-resource-id>"
az acr login --name <acr-name>
```

## Example (client Terraform)

```hcl
resource "azurerm_user_assigned_identity" "runner" {
  name                = "uami-prod-github-runner"
  resource_group_name = azurerm_resource_group.app.name
  location            = var.location
}

resource "azurerm_role_assignment" "runner_acr_push" {
  scope                = azurerm_container_registry.app.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.runner.principal_id
}

module "github_runner" {
  source = "../../modules/compute-linux"

  vm_name                     = "vm-prod-github-runner"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.app.name
  subnet_id                   = var.ci_subnet_id
  source_image_id             = var.rhel_image_id
  admin_ssh_public_key        = var.admin_ssh_public_key
  user_assigned_identity_ids  = [azurerm_user_assigned_identity.runner.id]
  tags = {
    Role = "github-runner"
  }
}

module "podman_runtime" {
  source = "../../modules/compute-linux"

  vm_name                     = "vm-prod-podman-runtime"
  # ...
  user_assigned_identity_ids  = [azurerm_user_assigned_identity.runtime.id]
  tags = {
    Role = "podman-runtime"
  }
}
```

RBAC for the runtime UAMI uses `AcrPull` instead of `AcrPush`.

## Managed data disks

Attach EBS-like block volumes via `data_disks` (typical on **Podman runtime**):

```hcl
module "podman_runtime" {
  source = "../../modules/compute-linux"
  # ...
  data_disks = [
    {
      name                 = "vm-prod-runtime-data01"
      size_gb              = 256
      storage_account_type = "Premium_LRS"
      lun                  = 0
      mount_hint           = "/var/lib/containers"
    }
  ]
}
```

Mount in the guest OS using `data_disk_configuration` output (UUID/fstab in cloud-init or Ansible). For optional **Azure File Share**, use `modules/storage-fileshare` and layer-2 mount script.

## Network

Allow egress to `login.microsoftonline.com` and `management.azure.com` on **both** VMs when using managed identity with Azure CLI or ACR.

Do not block instance metadata (`169.254.169.254`) — required for UAMI token acquisition.
