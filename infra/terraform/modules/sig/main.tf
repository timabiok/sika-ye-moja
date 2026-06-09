resource "azurerm_shared_image_gallery" "this" {
  name                = var.gallery_name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = var.description
  tags                = var.tags
}

resource "azurerm_shared_image" "rhel9" {
  name                         = var.image_definition_name
  gallery_name                 = azurerm_shared_image_gallery.this.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  os_type                      = "Linux"
  hyper_v_generation           = "V2"
  architecture                 = "x64"
  trusted_launch_enabled = true
  accelerated_network_support_enabled = false

  identifier {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
  }

  tags = var.tags
}
