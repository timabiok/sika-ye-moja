locals {
  is_nfs = var.share_protocol == "NFS"
  # Storage account names: 3-24 lowercase alphanumeric.
  storage_account_name = substr(replace(lower("${var.name_prefix}fs${var.share_name}"), "-", ""), 0, 24)
  nfs_role_name        = "Storage File Data Privileged Contributor"
  smb_role_name        = "Storage File Data SMB Share Contributor"
}

resource "azurerm_storage_account" "this" {
  name                     = local.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = local.is_nfs ? "Premium" : "Standard"
  account_replication_type = "LRS"
  account_kind             = local.is_nfs ? "FileStorage" : "StorageV2"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags

  public_network_access_enabled = var.enable_private_endpoint ? false : true

  dynamic "network_rules" {
    for_each = length(var.allowed_subnet_ids) > 0 ? [1] : []
    content {
      default_action             = var.enable_private_endpoint ? "Deny" : "Allow"
      bypass                     = ["AzureServices"]
      virtual_network_subnet_ids = var.allowed_subnet_ids
    }
  }

  dynamic "azure_files_authentication" {
    for_each = !local.is_nfs && var.enable_entra_kerberos_smb ? [1] : []
    content {
      directory_type = "AADKERB"
    }
  }
}

resource "azurerm_storage_share" "this" {
  name                 = var.share_name
  storage_account_name = azurerm_storage_account.this.name
  quota                = var.share_quota_gb

  enabled_protocol = local.is_nfs ? "NFS" : "SMB"
}

resource "azurerm_private_endpoint" "file" {
  count = var.enable_private_endpoint ? 1 : 0

  name                = "${var.name_prefix}-file-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name_prefix}-file-psc"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.file_private_dns_zone_id != null ? [1] : []
    content {
      name                 = "file-dns"
      private_dns_zone_ids = [var.file_private_dns_zone_id]
    }
  }
}

resource "azurerm_role_assignment" "share_access" {
  for_each = toset(var.principal_ids)

  scope                = azurerm_storage_account.this.id
  role_definition_name = local.is_nfs ? local.nfs_role_name : local.smb_role_name
  principal_id         = each.value
}
