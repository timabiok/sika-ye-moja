resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  count = var.enable_azure_monitor && var.data_collection_rule_id != null ? 1 : 0

  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = var.azure_monitor_extension_version
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}

resource "azurerm_monitor_data_collection_rule_association" "ama" {
  count = var.enable_azure_monitor && var.data_collection_rule_id != null ? 1 : 0

  name                    = "${var.vm_name}-dcr-assoc"
  target_resource_id      = azurerm_linux_virtual_machine.this.id
  data_collection_rule_id = var.data_collection_rule_id
}
