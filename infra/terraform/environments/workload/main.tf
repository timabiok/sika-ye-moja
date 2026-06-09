# Layer 2 — Deploy VMs from layer-1 SIG golden image with role bootstrap cloud-init.
# Layer 3 — GitHub Actions / systemd workloads (see module output layer3_handoff).

locals {
  tags = merge(
    {
      Environment      = var.name_prefix
      DeployLayer      = "2"
      WorkloadStack    = "github-runner-podman-runtime"
      ApplicationOwner = "client-platform"
    },
    var.additional_tags
  )

  runtime_data_disks = [
    {
      name                 = "${var.name_prefix}-runtime-data01"
      size_gb              = var.runtime_data_disk_size_gb
      storage_account_type = "Premium_LRS"
      lun                  = 0
      mount_hint           = "/var/lib/containers"
    }
  ]
}

module "workload_stack" {
  source = "../../modules/layer2-workload-stack"

  name_prefix                          = var.name_prefix
  location                             = var.location
  resource_group_name                  = var.resource_group_name
  sig_image_version_id                 = var.sig_image_version_id
  runner_subnet_id                     = var.runner_subnet_id
  runtime_subnet_id                    = var.runtime_subnet_id
  runner_private_ip_address            = var.runner_private_ip_address
  runtime_private_ip_address           = var.runtime_private_ip_address
  bastion_subnet_prefix                = var.bastion_subnet_prefix
  apim_subnet_prefix                   = var.apim_subnet_prefix
  admin_ssh_public_key                 = var.admin_ssh_public_key
  acr_id                               = var.acr_id
  key_vault_id                         = var.key_vault_id
  runner_env_label                     = var.runner_env_label
  runtime_data_disks                   = local.runtime_data_disks
  enable_ingestion_fileshare           = var.enable_ingestion_fileshare
  fileshare_private_endpoint_subnet_id = var.fileshare_private_endpoint_subnet_id
  enable_azure_monitor                 = var.enable_azure_monitor
  log_analytics_workspace_id           = var.log_analytics_workspace_id
  tags                                 = local.tags
}
