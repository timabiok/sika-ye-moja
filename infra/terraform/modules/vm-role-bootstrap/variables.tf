variable "vm_role" {
  type        = string
  description = "Layer-2 VM role: github-runner or podman-runtime."
  validation {
    condition     = contains(["github-runner", "podman-runtime"], var.vm_role)
    error_message = "vm_role must be github-runner or podman-runtime."
  }
}

variable "uami_resource_id" {
  type        = string
  description = "User-assigned managed identity resource ID attached to the VM."
}

variable "data_disk_mount_point" {
  type        = string
  default     = "/var/lib/containers"
  description = "Mount point for managed data disk (runtime only)."
}

variable "fileshare_nfs_mount_spec" {
  type        = string
  default     = ""
  description = "NFS mount spec for Azure Files (runtime only)."
}

variable "fileshare_mount_point" {
  type        = string
  default     = "/mnt/ingestion"
  description = "Mount point for Azure Files share."
}

variable "runner_env_label" {
  type        = string
  default     = "uat"
  description = "GitHub runner label for environment (dev, uat, prod)."
}
