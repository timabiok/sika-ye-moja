output "data_collection_rule_id" {
  value       = azurerm_monitor_data_collection_rule.linux_baseline.id
  description = "DCR resource ID for VM associations."
}

output "data_collection_rule_name" {
  value       = azurerm_monitor_data_collection_rule.linux_baseline.name
  description = "DCR name."
}

output "ama_extension_publisher" {
  value       = "Microsoft.Azure.Monitor"
  description = "AMA extension publisher."
}

output "ama_extension_type" {
  value       = "AzureMonitorLinuxAgent"
  description = "AMA extension type."
}

output "ama_extension_version" {
  value       = "1.28"
  description = "Pinned AMA handler version — update per Microsoft release notes."
}
