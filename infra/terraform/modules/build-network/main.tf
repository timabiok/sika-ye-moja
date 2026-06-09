resource "azurerm_network_security_group" "build" {
  name                = "${var.name_prefix}-aib-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowVNetOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowAzurePlatformOutbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureCloud"
  }
}

resource "azurerm_subnet_network_security_group_association" "build" {
  subnet_id                 = azurerm_subnet.build.id
  network_security_group_id = azurerm_network_security_group.build.id
}

resource "azurerm_virtual_network" "build" {
  name                = "${var.name_prefix}-aib-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "build" {
  name                 = "image-builder"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.build.name
  address_prefixes     = [var.subnet_address_prefix]

  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_private_dns_zone" "blob" {
  count               = var.enable_private_endpoints ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  count                 = var.enable_private_endpoints ? 1 : 0
  name                  = "${var.name_prefix}-blob-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob[0].name
  virtual_network_id    = azurerm_virtual_network.build.id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone" "vault" {
  count               = var.enable_private_endpoints && var.enable_key_vault_dns ? 1 : 0
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vault" {
  count                 = var.enable_private_endpoints && var.enable_key_vault_dns ? 1 : 0
  name                  = "${var.name_prefix}-vault-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.vault[0].name
  virtual_network_id    = azurerm_virtual_network.build.id
  registration_enabled  = false
  tags                  = var.tags
}
