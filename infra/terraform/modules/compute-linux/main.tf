resource "azurerm_linux_virtual_machine" "this" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  tags                = var.tags

  network_interface_ids = [azurerm_network_interface.this.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_id = var.source_image_id

  secure_boot_enabled = true
  vtpm_enabled        = true

  identity {
    type         = "UserAssigned"
    identity_ids = var.user_assigned_identity_ids
  }

  patch_mode  = "ImageDefault"
  custom_data = var.custom_data != null ? base64encode(var.custom_data) : null

  lifecycle {
    ignore_changes = [source_image_id]
  }
}

resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address_allocation == "Static" ? var.private_ip_address : null
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  count                     = var.network_security_group_id != null ? 1 : 0
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.network_security_group_id
}

locals {
  data_disks = { for disk in var.data_disks : disk.name => disk }
}

resource "azurerm_managed_disk" "data" {
  for_each = local.data_disks

  name                 = each.value.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.size_gb
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  for_each = azurerm_managed_disk.data

  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  lun                = local.data_disks[each.key].lun
  caching            = local.data_disks[each.key].caching
}
