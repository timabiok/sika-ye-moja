resource "terraform_data" "uami_required" {
  lifecycle {
    precondition {
      condition     = length(var.user_assigned_identity_ids) > 0
      error_message = "Banking baseline requires at least one user-assigned managed identity on every Linux VM."
    }
  }
}

resource "terraform_data" "static_ip_recommended" {
  lifecycle {
    precondition {
      condition     = var.private_ip_address_allocation != "Dynamic" || var.allow_dynamic_private_ip
      error_message = "Banking baseline requires static private IP (private_ip_address_allocation = Static) unless allow_dynamic_private_ip = true."
    }
  }
}

resource "terraform_data" "azure_monitor_dcr" {
  lifecycle {
    precondition {
      condition     = !var.enable_azure_monitor || var.data_collection_rule_id != null
      error_message = "enable_azure_monitor requires data_collection_rule_id from monitor-baseline module."
    }
  }
}
