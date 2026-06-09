locals {
  name_prefix = var.name_prefix
  common_tags = merge(
    {
      DeployLayer         = "1"
      Environment         = "prod"
      DataClassification  = "internal"
      ManagedBy           = "terraform"
      ImagePipeline       = "azure-image-builder"
      ComplianceScope     = "FFIEC-NIST-CIS"
      CostCenter          = var.cost_center
      ApplicationOwner    = var.application_owner
    },
    var.additional_tags
  )
}

resource "azurerm_resource_group" "golden_image" {
  name     = "${local.name_prefix}-golden-image-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_provider_registration" "vm_images" {
  name = "Microsoft.VirtualMachineImages"
}

data "azurerm_client_config" "current" {}

module "build_network" {
  source = "../../modules/build-network"

  name_prefix           = local.name_prefix
  location              = var.location
  resource_group_name   = azurerm_resource_group.golden_image.name
  vnet_address_space    = var.build_vnet_address_space
  subnet_address_prefix = var.build_subnet_address_prefix
  enable_private_endpoints = var.enable_private_endpoints
  enable_key_vault_dns     = var.enable_rhsm
  tags                     = local.common_tags
}

module "sig" {
  source = "../../modules/sig"

  gallery_name          = var.gallery_name
  image_definition_name = var.image_definition_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.golden_image.name
  image_publisher       = var.sig_image_publisher
  image_offer           = var.sig_image_offer
  image_sku             = var.sig_image_sku
  description           = "Production RHEL 9 golden image — CIS L1, Trusted Launch, FIPS-ready"
  tags                  = local.common_tags
}

module "image_builder" {
  source = "../../modules/image-builder"

  name_prefix              = local.name_prefix
  location                 = var.location
  resource_group_name      = azurerm_resource_group.golden_image.name
  gallery_id               = module.sig.gallery_id
  image_definition_id      = module.sig.image_definition_id
  image_version              = var.image_version
  build_subnet_id            = module.build_network.subnet_id
  source_publisher           = var.rhel_source_publisher
  source_offer               = var.rhel_source_offer
  source_sku                 = var.rhel_source_sku
  source_version             = var.rhel_source_version
  replication_regions        = var.replication_regions
  replica_count              = var.replica_count
  enable_ansible_customization = var.enable_ansible_customization
  ansible_archive_path       = var.ansible_archive_path
  log_analytics_workspace_id        = var.log_analytics_workspace_id
  scripts_storage_public_access     = var.scripts_storage_public_access
  enable_scripts_private_endpoint   = var.enable_private_endpoints
  blob_private_dns_zone_id          = module.build_network.blob_private_dns_zone_id
  enable_rhsm                       = var.enable_rhsm
  rhsm_key_vault_id                 = var.rhsm_key_vault_id
  rhsm_secret_name                  = var.rhsm_secret_name
  rhsm_organization                 = var.rhsm_organization
  enable_key_vault_private_endpoint = var.enable_key_vault_private_endpoint
  key_vault_private_dns_zone_id     = module.build_network.key_vault_private_dns_zone_id
  tags                              = local.common_tags

  depends_on = [azurerm_resource_provider_registration.vm_images]
}

# Use environments/workload/ for banking VMs (NSG, UAMI, static IP). Example VM deprecated.
