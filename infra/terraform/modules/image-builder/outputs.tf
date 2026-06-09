output "image_template_id" {
  value       = azapi_resource.rhel9.id
  description = "Azure Image Builder template resource ID."
}

output "image_template_name" {
  value       = azapi_resource.rhel9.name
  description = "Azure Image Builder template name."
}

output "image_template_run_cmd" {
  value       = "az image builder run --resource-group ${var.resource_group_name} --name ${azapi_resource.rhel9.name}"
  description = "CLI command to trigger an on-demand image build."
}

output "managed_identity_principal_id" {
  value       = azurerm_user_assigned_identity.aib.principal_id
  description = "AIB user-assigned identity principal ID for additional RBAC."
}

output "scripts_storage_account_name" {
  value       = azurerm_storage_account.scripts.name
  description = "Storage account holding build scripts and Ansible artifacts."
}

output "scripts_private_endpoint_id" {
  value       = try(azurerm_private_endpoint.scripts_blob[0].id, null)
  description = "Private endpoint for build script storage (null if disabled)."
}
