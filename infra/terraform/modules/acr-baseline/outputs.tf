output "acr_id" {
  value       = azurerm_container_registry.this.id
  description = "ACR resource ID — pass to layer2-workload-stack acr_id."
}

output "acr_name" {
  value       = azurerm_container_registry.this.name
  description = "ACR name for az acr login and image references."
}

output "login_server" {
  value       = azurerm_container_registry.this.login_server
  description = "Registry FQDN (e.g. myacr.azurecr.io)."
}

output "private_endpoint_id" {
  value       = try(azurerm_private_endpoint.acr[0].id, null)
  description = "Private endpoint ID when enabled."
}
