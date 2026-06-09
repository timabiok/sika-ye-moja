# storage-fileshare

Reference module for **Azure Files** (shared file landing zone). Complements `compute-linux` **managed data disks** (VM-local block storage).

| Storage | Module | Use on runtime VM |
|---------|--------|-------------------|
| **Managed Disk** | `compute-linux` `data_disks` | Podman volumes, local ingestion staging |
| **Azure File Share** | `storage-fileshare` | Shared ingestion drop, multi-consumer files |

## Protocol

- **NFS** (default): Premium `FileStorage` — recommended for **RHEL** without AD domain join.
- **SMB**: `StorageV2` with Entra Kerberos — requires AD/AADDS integration on client side.

Grant VM **UAMI** access via `principal_ids` (`Storage File Data Privileged Contributor` for NFS).

## Network

- Enable **private endpoint** for prod (`enable_private_endpoint = true`).
- Allow VM subnet in `allowed_subnet_ids` and firewall egress to storage / private endpoint.
- Guest mount at **layer 2** (cloud-init/Ansible) using `nfs_mount_spec` or `smb_unc_path` outputs.

## Example

```hcl
module "ingestion_share" {
  source = "../../modules/storage-fileshare"

  name_prefix          = "prod-data"
  location             = var.location
  resource_group_name  = azurerm_resource_group.app.name
  share_name           = "ingestion"
  share_quota_gb       = 500
  share_protocol       = "NFS"
  allowed_subnet_ids   = [var.app_subnet_id]
  enable_private_endpoint    = true
  private_endpoint_subnet_id = var.pe_subnet_id
  principal_ids        = [azurerm_user_assigned_identity.runtime.principal_id]
}

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

Mount Azure Files on the VM after deploy (see `ansible/roles/rhel9_bank_baseline/files/mount-azure-fileshare.sh`).
