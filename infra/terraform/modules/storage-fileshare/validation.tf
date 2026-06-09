resource "terraform_data" "fileshare_pe" {
  lifecycle {
    precondition {
      condition     = !var.enable_private_endpoint || var.private_endpoint_subnet_id != null
      error_message = "private_endpoint_subnet_id is required when enable_private_endpoint is true."
    }
  }
}
