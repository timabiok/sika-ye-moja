resource "azurerm_private_endpoint" "rhsm_key_vault" {
  count               = var.enable_rhsm && var.enable_key_vault_private_endpoint && var.key_vault_private_dns_zone_id != null ? 1 : 0
  name                = "${var.name_prefix}-aib-kv-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.build_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name_prefix}-kv-psc"
    private_connection_resource_id = var.rhsm_key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "vault-dns"
    private_dns_zone_ids = [var.key_vault_private_dns_zone_id]
  }
}

resource "azurerm_role_assignment" "aib_key_vault_secrets" {
  count                = var.enable_rhsm ? 1 : 0
  scope                = var.rhsm_key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aib.principal_id
}
