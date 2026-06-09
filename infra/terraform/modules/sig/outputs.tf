output "gallery_id" {
  value       = azurerm_shared_image_gallery.this.id
  description = "Shared Image Gallery resource ID."
}

output "gallery_name" {
  value       = azurerm_shared_image_gallery.this.name
  description = "Gallery name for AIB distribute block."
}

output "image_definition_name" {
  value       = azurerm_shared_image.rhel9.name
  description = "Image definition name for AIB distribute block."
}

output "image_definition_id" {
  value       = azurerm_shared_image.rhel9.id
  description = "Image definition resource ID."
}
