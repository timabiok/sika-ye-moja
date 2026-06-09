locals {
  cloud_init = templatefile("${path.module}/cloud-init.tpl", {
    vm_role                  = var.vm_role
    uami_resource_id         = var.uami_resource_id
    data_disk_mount_point    = var.data_disk_mount_point
    fileshare_nfs_mount_spec = var.fileshare_nfs_mount_spec
    fileshare_mount_point    = var.fileshare_mount_point
    runner_env_label         = var.runner_env_label
  })
}

output "cloud_init" {
  value       = local.cloud_init
  description = "cloud-config payload for compute-linux custom_data (layer 2 bootstrap)."
}

output "vm_role" {
  value       = var.vm_role
  description = "github-runner or podman-runtime."
}

output "layer" {
  value       = 2
  description = "Deploy layer identifier."
}
