locals {
  acr_login_server = "${var.acr_name}.azurecr.io"
}

resource "azurerm_container_registry" "this" {
  name                          = var.acr_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  quarantine_policy_enabled     = var.quarantine_policy_enabled
  retention_policy_in_days      = var.retention_days
  trust_policy_enabled          = var.trust_policy_enabled
  anonymous_pull_enabled        = false
  tags                          = var.tags

  dynamic "network_rule_set" {
    for_each = length(var.allowed_ip_ranges) > 0 ? [1] : []
    content {
      default_action = "Deny"
      ip_rule = [
        for cidr in var.allowed_ip_ranges : {
          action   = "Allow"
          ip_range = cidr
        }
      ]
    }
  }

  dynamic "georeplications" {
    for_each = var.georeplications
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
    }
  }
}

resource "azurerm_private_endpoint" "acr" {
  count = var.enable_private_endpoint && var.private_endpoint_subnet_id != null ? 1 : 0

  name                = "${var.name_prefix}-acr-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name_prefix}-acr-psc"
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "acr-dns"
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }
}
