output "github_runner_vm_id" {
  value       = module.github_runner_vm.vm_id
  description = "GitHub runner VM resource ID."
}

output "podman_runtime_vm_id" {
  value       = module.podman_runtime_vm.vm_id
  description = "Podman runtime VM resource ID."
}

output "github_runner_private_ip" {
  value       = module.github_runner_vm.private_ip_address
  description = "Runner static private IP."
}

output "podman_runtime_private_ip" {
  value       = module.podman_runtime_vm.private_ip_address
  description = "Runtime static private IP."
}

output "github_runner_uami_id" {
  value       = azurerm_user_assigned_identity.github_runner.id
  description = "Runner UAMI resource ID."
}

output "podman_runtime_uami_id" {
  value       = azurerm_user_assigned_identity.podman_runtime.id
  description = "Runtime UAMI resource ID."
}

output "runtime_data_disk_configuration" {
  value       = module.podman_runtime_vm.data_disk_configuration
  description = "Data disk metadata for fstab automation."
}

output "fileshare_nfs_mount_spec" {
  value       = var.enable_ingestion_fileshare ? module.ingestion_fileshare[0].nfs_mount_spec : null
  description = "NFS mount spec when file share is enabled."
}

output "data_collection_rule_id" {
  value       = var.enable_azure_monitor ? module.monitor_baseline[0].data_collection_rule_id : null
  description = "Banking baseline DCR ID when Azure Monitor is enabled."
}

output "layer3_handoff" {
  value = {
    layer           = 3
    description     = "GitHub Actions build Gorobi, ingestion, fastapi-apis, dagster images; deploy-runtime-stack.sh on runtime VM."
    runner_vm_name  = "${var.name_prefix}-github-runner"
    runtime_vm_name = "${var.name_prefix}-podman-runtime"
    build_manifest  = "build/images.manifest.json"
    build_script    = "build/scripts/build-push-images.sh"
    workflow_path   = ".github/workflows/build-deploy.yml"
    deploy_script   = "/opt/compliance/bootstrap/deploy-runtime-stack.sh"
    examples_path   = "examples/runtime-images/"
    documentation   = "docs/RUNTIME-WORKLOAD-EXAMPLE.md"
  }
  description = "Layer-3 CI/CD workload orchestration handoff."
}
