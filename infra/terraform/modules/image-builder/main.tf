data "azurerm_client_config" "current" {}

resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_user_assigned_identity" "aib" {
  name                = "${var.name_prefix}-aib-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_storage_account" "scripts" {
  name                            = substr(replace("${var.name_prefix}aib${random_string.storage_suffix.result}", "-", ""), 0, 24)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false
  public_network_access_enabled   = var.enable_scripts_private_endpoint ? false : var.scripts_storage_public_access
  tags                            = var.tags

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    versioning_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "scripts" {
  name                  = "image-builder"
  storage_account_name  = azurerm_storage_account.scripts.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "ansible_archive" {
  count                  = var.enable_ansible_customization ? 1 : 0
  name                   = "ansible-${var.image_version}.tar.gz"
  storage_account_name   = azurerm_storage_account.scripts.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = var.ansible_archive_path
}

resource "azurerm_role_assignment" "aib_gallery" {
  scope                = var.gallery_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aib.principal_id
}

resource "azurerm_role_assignment" "aib_storage" {
  scope                = azurerm_storage_account.scripts.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.aib.principal_id
}

resource "azurerm_role_assignment" "aib_network" {
  count                = var.build_subnet_id != null ? 1 : 0
  scope                = var.build_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aib.principal_id
}

resource "azapi_resource" "rhel9" {
  type      = "Microsoft.VirtualMachineImages/imageTemplates@2024-02-01"
  name      = "${var.name_prefix}-rhel9-golden"
  location  = var.location
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  tags      = var.tags

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aib.id
    ]
  }

  body = {
    properties = {
      source = {
        type      = "PlatformImage"
        publisher = var.source_publisher
        offer     = var.source_offer
        sku       = var.source_sku
        version   = var.source_version
      }
      customize = local.customize_steps
      distribute = [
        {
          type           = "SharedImage"
          galleryImageId = var.image_definition_id
          runOutputName  = "golden-rhel9"
          targetRegions  = local.target_regions
          versioning = {
            scheme = "Latest"
            major  = local.version_major
          }
        }
      ]
      vmProfile = merge(
        {
          userAssignedIdentities = [
            azurerm_user_assigned_identity.aib.id
          ]
          vmSize = "Standard_D4s_v5"
        },
        var.build_subnet_id != null ? {
          vnetConfig = {
            subnetId = var.build_subnet_id
          }
        } : {}
      )
      buildTimeoutInMinutes = 240
      managedResourceTags   = var.tags
    }
  }

  depends_on = [
    azurerm_role_assignment.aib_gallery,
    azurerm_role_assignment.aib_storage,
    azurerm_private_endpoint.scripts_blob,
    azurerm_storage_account_network_rules.scripts,
    azurerm_role_assignment.aib_key_vault_secrets,
    azurerm_private_endpoint.rhsm_key_vault,
  ]
}

resource "azurerm_monitor_diagnostic_setting" "aib" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.name_prefix}-aib-diag"
  target_resource_id         = azapi_resource.rhel9.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AzureImageBuilderTemplateCustomizationLog"
  }

  enabled_log {
    category = "AzureImageBuilderTemplatePackagingLog"
  }

  enabled_log {
    category = "AzureImageBuilderTemplateValidationLog"
  }
}
