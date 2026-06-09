resource "azurerm_private_endpoint" "scripts_blob" {
  count               = var.enable_scripts_private_endpoint ? 1 : 0
  name                = "${var.name_prefix}-aib-scripts-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.build_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name_prefix}-scripts-blob-psc"
    private_connection_resource_id = azurerm_storage_account.scripts.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns"
    private_dns_zone_ids = [var.blob_private_dns_zone_id]
  }
}

resource "azurerm_storage_account_network_rules" "scripts" {
  count                      = var.enable_scripts_private_endpoint ? 1 : 0
  storage_account_id         = azurerm_storage_account.scripts.id
  default_action             = "Deny"
  bypass                     = ["AzureServices"]
  virtual_network_subnet_ids = [var.build_subnet_id]

  depends_on = [azurerm_private_endpoint.scripts_blob]
}
