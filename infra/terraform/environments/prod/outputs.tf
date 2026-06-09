output "shared_image_gallery_id" {
  value       = module.sig.gallery_id
  description = "Use in VM deployment policies and Azure Policy."
}

output "image_definition_id" {
  value       = module.sig.image_definition_id
  description = "Image definition for version pinning in compute modules."
}

output "image_template_run_command" {
  value       = module.image_builder.image_template_run_cmd
  description = "Run after terraform apply to produce a new SIG version."
}

output "build_subnet_id" {
  value       = module.build_network.subnet_id
  description = "Subnet used for isolated image builds."
}

output "aib_managed_identity_principal_id" {
  value       = module.image_builder.managed_identity_principal_id
  sensitive   = false
  description = "Grant additional scoped RBAC if integrating Key Vault or CMK."
}

output "scripts_storage_account_name" {
  value       = module.image_builder.scripts_storage_account_name
  description = "Build script storage account (private endpoint when enabled)."
}

output "scripts_private_endpoint_id" {
  value       = module.image_builder.scripts_private_endpoint_id
  description = "Private endpoint for build script storage."
}

output "example_vm_private_ip" {
  value       = try(module.example_compute[0].private_ip_address, null)
  description = "Private IP of validation VM when deploy_example_vm is true."
}
