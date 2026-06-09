output "vm_id" {
  value       = azurerm_linux_virtual_machine.this.id
  description = "Linux VM resource ID."
}

output "private_ip_address" {
  value       = azurerm_network_interface.this.private_ip_address
  description = "Private IP address of the VM."
}

output "network_interface_id" {
  value       = azurerm_network_interface.this.id
  description = "NIC resource ID."
}

output "data_disk_ids" {
  value = {
    for name, disk in azurerm_managed_disk.data : name => disk.id
  }
  description = "Managed data disk resource IDs keyed by disk name."
}

output "azure_monitor_extension_id" {
  value       = var.enable_azure_monitor && var.data_collection_rule_id != null ? azurerm_virtual_machine_extension.azure_monitor_agent[0].id : null
  description = "AMA VM extension ID when enabled."
}

output "data_disk_configuration" {
  value = [
    for disk in var.data_disks : {
      name       = disk.name
      lun        = disk.lun
      size_gb    = disk.size_gb
      mount_hint = disk.mount_hint
    }
  ]
  description = "Data disk metadata for cloud-init/Ansible fstab automation."
}
