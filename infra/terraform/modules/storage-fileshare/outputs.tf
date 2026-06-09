output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "Storage account resource ID."
}

output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "Storage account name."
}

output "share_name" {
  value       = azurerm_storage_share.this.name
  description = "File share name."
}

output "share_protocol" {
  value       = var.share_protocol
  description = "NFS or SMB."
}

output "nfs_mount_spec" {
  value = var.share_protocol == "NFS" ? format(
    "%s.file.core.windows.net:/%s/%s",
    azurerm_storage_account.this.name,
    azurerm_storage_account.this.name,
    azurerm_storage_share.this.name
  ) : null
  description = "NFS mount source for /etc/fstab (use private endpoint FQDN in prod)."
}

output "smb_unc_path" {
  value = var.share_protocol == "SMB" ? format(
    "//%s.file.core.windows.net/%s",
    azurerm_storage_account.this.name,
    azurerm_storage_share.this.name
  ) : null
  description = "SMB UNC path for cifs mount."
}

output "private_endpoint_fqdn" {
  value       = var.enable_private_endpoint ? "${azurerm_storage_account.this.name}.file.core.windows.net" : null
  description = "Resolve via private DNS when private endpoint is enabled."
}

output "mount_bootstrap_path" {
  value       = "/opt/compliance/bootstrap/mount-azure-fileshare.sh"
  description = "Guest OS bootstrap script path (deploy via cloud-init/Ansible layer 2)."
}
