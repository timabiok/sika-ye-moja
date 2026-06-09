output "developer_group_object_id" {
  value       = var.developer_group_object_id
  description = "Entra group receiving PIM eligible roles."
}

output "reader_scope" {
  value       = local.reader_scope
  description = "Scope for Reader eligible assignment."
}

output "pim_activation_max_hours" {
  value       = var.pim_activation_max_hours
  description = "Documented activation cap — configure in Entra PIM role settings."
}

output "developer_login_script" {
  value       = "scripts/az-developer-login.sh"
  description = "Repo script developers run after PIM activation."
}

output "cli_workflow" {
  value = {
    step_1 = "Activate PIM role(s) in Entra portal (My roles)"
    step_2 = "Run scripts/az-developer-login.sh with AZURE_TENANT_ID and AZURE_DEV_SUBSCRIPTION_ID"
    step_3 = "Use az cli (acr login, resource show, etc.) until activation expires"
    step_4 = "az logout when finished"
  }
  description = "Developer temporary CLI workflow."
}
