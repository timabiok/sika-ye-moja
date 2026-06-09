output "nsg_id" {
  value       = azurerm_network_security_group.this.id
  description = "NSG resource ID."
}
