output "github_runner_vm_id" {
  value = module.workload_stack.github_runner_vm_id
}

output "podman_runtime_vm_id" {
  value = module.workload_stack.podman_runtime_vm_id
}

output "github_runner_private_ip" {
  value = module.workload_stack.github_runner_private_ip
}

output "podman_runtime_private_ip" {
  value = module.workload_stack.podman_runtime_private_ip
}

output "github_runner_uami_id" {
  value = module.workload_stack.github_runner_uami_id
}

output "podman_runtime_uami_id" {
  value = module.workload_stack.podman_runtime_uami_id
}

output "runtime_data_disk_configuration" {
  value = module.workload_stack.runtime_data_disk_configuration
}

output "fileshare_nfs_mount_spec" {
  value = module.workload_stack.fileshare_nfs_mount_spec
}

output "data_collection_rule_id" {
  value       = module.workload_stack.data_collection_rule_id
  description = "Azure Monitor DCR ID when monitor baseline is enabled."
}

output "layer3_handoff" {
  value       = module.workload_stack.layer3_handoff
  description = "Layer-3 CI/CD orchestration is client GitHub Actions — not Terraform."
}
