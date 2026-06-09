resource "terraform_data" "banking_prerequisites" {
  lifecycle {
    precondition {
      condition     = var.bastion_subnet_prefix != null && length(var.bastion_subnet_prefix) > 0
      error_message = "bastion_subnet_prefix is required for banking NSG baseline."
    }
    precondition {
      condition     = var.acr_id != null && var.key_vault_id != null
      error_message = "acr_id and key_vault_id are required for banking UAMI RBAC."
    }
    precondition {
      condition     = !var.enable_ingestion_fileshare || var.fileshare_private_endpoint_subnet_id != null
      error_message = "fileshare_private_endpoint_subnet_id required when enable_ingestion_fileshare is true."
    }
    precondition {
      condition     = !var.enable_azure_monitor || var.log_analytics_workspace_id != null
      error_message = "log_analytics_workspace_id is required when enable_azure_monitor is true."
    }
  }
}
