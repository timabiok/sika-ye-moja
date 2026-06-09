resource "terraform_data" "layer1_banking_baseline" {
  lifecycle {
    precondition {
      condition     = var.enable_ansible_customization
      error_message = "Banking baseline requires enable_ansible_customization = true (run scripts/package-ansible.sh first)."
    }
    precondition {
      condition     = !var.enable_ansible_customization || var.ansible_archive_path != null
      error_message = "ansible_archive_path is required when enable_ansible_customization is true."
    }
    precondition {
      condition     = var.rhel_source_version != "latest"
      error_message = "Pin rhel_source_version for audit reproducibility (not 'latest')."
    }
  }
}
