resource "terraform_data" "acr_banking" {
  lifecycle {
    precondition {
      condition     = !var.enable_private_endpoint || var.private_endpoint_subnet_id != null
      error_message = "private_endpoint_subnet_id required when enable_private_endpoint is true."
    }
    precondition {
      condition     = var.admin_enabled == false
      error_message = "Banking baseline requires admin_enabled = false on ACR."
    }
  }
}
