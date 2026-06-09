resource "terraform_data" "scripts_pe_validation" {
  lifecycle {
    precondition {
      condition     = !var.enable_scripts_private_endpoint || (var.build_subnet_id != null && var.blob_private_dns_zone_id != null)
      error_message = "enable_scripts_private_endpoint requires build_subnet_id and blob_private_dns_zone_id."
    }
  }
}

resource "terraform_data" "rhsm_validation" {
  lifecycle {
    precondition {
      condition     = !var.enable_rhsm || (var.rhsm_key_vault_id != null && var.rhsm_organization != null)
      error_message = "enable_rhsm requires rhsm_key_vault_id and rhsm_organization."
    }
  }
}
