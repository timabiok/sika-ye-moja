output "vnet_id" {
  value       = azurerm_virtual_network.build.id
  description = "Build VNet resource ID for AIB vnet_config."
}

output "subnet_id" {
  value       = azurerm_subnet.build.id
  description = "Build subnet resource ID for AIB vnet_config."
}

output "subnet_name" {
  value       = azurerm_subnet.build.name
  description = "Build subnet name."
}

output "vnet_name" {
  value       = azurerm_virtual_network.build.name
  description = "Build VNet name."
}

output "blob_private_dns_zone_id" {
  value       = try(azurerm_private_dns_zone.blob[0].id, null)
  description = "Private DNS zone for script storage private endpoints."
}

output "key_vault_private_dns_zone_id" {
  value       = try(azurerm_private_dns_zone.vault[0].id, null)
  description = "Private DNS zone for Key Vault private endpoints during build."
}
