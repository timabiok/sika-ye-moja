locals {
  common_tags = merge(
    {
      DeployLayer        = "2"
      ManagedBy          = "terraform"
      DataClassification = "internal"
      ComplianceScope    = "FFIEC-NIST-CIS"
    },
    var.tags
  )

  fileshare_nfs_mount_spec = var.enable_ingestion_fileshare ? module.ingestion_fileshare[0].nfs_mount_spec : ""
}

module "nsg_github_runner" {
  source = "../nsg-baseline"

  name_prefix           = var.name_prefix
  location              = var.location
  resource_group_name   = var.resource_group_name
  vm_role               = "github-runner"
  bastion_subnet_prefix = var.bastion_subnet_prefix
  tags                  = merge(local.common_tags, { Role = "github-runner" })
}

module "nsg_podman_runtime" {
  source = "../nsg-baseline"

  name_prefix           = var.name_prefix
  location              = var.location
  resource_group_name   = var.resource_group_name
  vm_role               = "podman-runtime"
  bastion_subnet_prefix = var.bastion_subnet_prefix
  apim_subnet_prefix    = var.apim_subnet_prefix
  runtime_app_ports     = var.runtime_app_ports
  tags                  = merge(local.common_tags, { Role = "podman-runtime" })
}

resource "azurerm_user_assigned_identity" "github_runner" {
  name                = "${var.name_prefix}-uami-github-runner"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(local.common_tags, { Role = "github-runner" })
}

resource "azurerm_user_assigned_identity" "podman_runtime" {
  name                = "${var.name_prefix}-uami-podman-runtime"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(local.common_tags, { Role = "podman-runtime" })
}

resource "azurerm_role_assignment" "runner_acr_push" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.github_runner.principal_id
}

resource "azurerm_role_assignment" "runtime_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.podman_runtime.principal_id
}

resource "azurerm_role_assignment" "runner_key_vault" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.github_runner.principal_id
}

resource "azurerm_role_assignment" "runtime_key_vault" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.podman_runtime.principal_id
}

module "monitor_baseline" {
  count  = var.enable_azure_monitor ? 1 : 0
  source = "../monitor-baseline"

  name_prefix                = var.name_prefix
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  vm_identity_principal_ids = [
    azurerm_user_assigned_identity.github_runner.principal_id,
    azurerm_user_assigned_identity.podman_runtime.principal_id,
  ]
  tags = local.common_tags
}

module "bootstrap_github_runner" {
  source = "../vm-role-bootstrap"

  vm_role          = "github-runner"
  uami_resource_id = azurerm_user_assigned_identity.github_runner.id
  runner_env_label = var.runner_env_label
}

module "bootstrap_podman_runtime" {
  source = "../vm-role-bootstrap"

  vm_role                  = "podman-runtime"
  uami_resource_id         = azurerm_user_assigned_identity.podman_runtime.id
  data_disk_mount_point    = var.runtime_data_disk_mount_point
  fileshare_nfs_mount_spec = local.fileshare_nfs_mount_spec
  fileshare_mount_point    = var.fileshare_mount_point
}

module "github_runner_vm" {
  source = "../compute-linux"

  vm_name                       = "${var.name_prefix}-github-runner"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.runner_subnet_id
  source_image_id               = var.sig_image_version_id
  admin_ssh_public_key          = var.admin_ssh_public_key
  user_assigned_identity_ids    = [azurerm_user_assigned_identity.github_runner.id]
  network_security_group_id     = module.nsg_github_runner.nsg_id
  private_ip_address_allocation = "Static"
  private_ip_address            = var.runner_private_ip_address
  custom_data                   = module.bootstrap_github_runner.cloud_init
  enable_azure_monitor          = var.enable_azure_monitor
  data_collection_rule_id       = var.enable_azure_monitor ? module.monitor_baseline[0].data_collection_rule_id : null
  tags                          = merge(local.common_tags, { Role = "github-runner" })
}

module "podman_runtime_vm" {
  source = "../compute-linux"

  vm_name                       = "${var.name_prefix}-podman-runtime"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.runtime_subnet_id
  source_image_id               = var.sig_image_version_id
  admin_ssh_public_key          = var.admin_ssh_public_key
  user_assigned_identity_ids    = [azurerm_user_assigned_identity.podman_runtime.id]
  network_security_group_id     = module.nsg_podman_runtime.nsg_id
  private_ip_address_allocation = "Static"
  private_ip_address            = var.runtime_private_ip_address
  custom_data                   = module.bootstrap_podman_runtime.cloud_init
  data_disks                    = var.runtime_data_disks
  enable_azure_monitor          = var.enable_azure_monitor
  data_collection_rule_id       = var.enable_azure_monitor ? module.monitor_baseline[0].data_collection_rule_id : null
  tags                          = merge(local.common_tags, { Role = "podman-runtime" })
}

module "ingestion_fileshare" {
  count  = var.enable_ingestion_fileshare ? 1 : 0
  source = "../storage-fileshare"

  name_prefix                = var.name_prefix
  location                   = var.location
  resource_group_name        = var.resource_group_name
  share_name                 = var.fileshare_name
  share_quota_gb             = var.fileshare_quota_gb
  share_protocol             = var.fileshare_protocol
  allowed_subnet_ids         = [var.runtime_subnet_id]
  enable_private_endpoint    = var.fileshare_enable_private_endpoint
  private_endpoint_subnet_id = var.fileshare_private_endpoint_subnet_id
  principal_ids              = [azurerm_user_assigned_identity.podman_runtime.principal_id]
  tags                       = local.common_tags
}
