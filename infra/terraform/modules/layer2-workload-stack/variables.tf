variable "name_prefix" {
  type        = string
  description = "Prefix for workload resources."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for layer-2 VMs."
}

variable "sig_image_version_id" {
  type        = string
  description = "Layer-1 SIG image version resource ID."
}

variable "runner_subnet_id" {
  type        = string
  description = "Subnet for GitHub runner VM."
}

variable "runtime_subnet_id" {
  type        = string
  description = "Subnet for Podman runtime VM."
}

variable "runner_private_ip_address" {
  type        = string
  description = "Static private IP for runner VM (firewall allow-list)."
}

variable "runtime_private_ip_address" {
  type        = string
  description = "Static private IP for runtime VM (firewall allow-list)."
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "CIDR for Bastion/jump subnet SSH inbound (banking required)."
}

variable "apim_subnet_prefix" {
  type        = string
  default     = null
  description = "Optional APIM subnet CIDR for runtime inbound."
}

variable "runtime_app_ports" {
  type        = list(string)
  default     = ["443", "8080"]
  description = "Inbound ports on runtime from APIM."
}

variable "admin_ssh_public_key" {
  type        = string
  description = "SSH public key."
  sensitive   = true
}

variable "acr_id" {
  type        = string
  description = "ACR resource ID — required for banking UAMI RBAC."
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault resource ID — required for banking UAMI RBAC."
}

variable "runner_env_label" {
  type        = string
  default     = "uat"
  description = "GitHub runner environment label."
}

variable "runtime_data_disk_mount_point" {
  type        = string
  default     = "/var/lib/containers"
  description = "Guest OS mount point for managed data disk."
}

variable "runtime_data_disks" {
  type = list(object({
    name                 = string
    size_gb              = number
    storage_account_type = optional(string, "Premium_LRS")
    lun                  = number
    caching              = optional(string, "ReadWrite")
    mount_hint           = optional(string, "")
  }))
  default     = []
  description = "Managed data disks for Podman runtime VM."
}

variable "enable_ingestion_fileshare" {
  type        = bool
  default     = false
  description = "Provision optional Azure Files share for shared ingestion."
}

variable "fileshare_name" {
  type        = string
  default     = "ingestion"
  description = "Azure file share name."
}

variable "fileshare_quota_gb" {
  type        = number
  default     = 100
  description = "File share quota in GB."
}

variable "fileshare_protocol" {
  type        = string
  default     = "NFS"
  description = "NFS or SMB."
}

variable "fileshare_mount_point" {
  type        = string
  default     = "/mnt/ingestion"
  description = "Guest mount point for Azure Files."
}

variable "fileshare_enable_private_endpoint" {
  type        = bool
  default     = true
  description = "Private endpoint for Azure Files."
}

variable "fileshare_private_endpoint_subnet_id" {
  type        = string
  default     = null
  description = "Subnet for file private endpoint."
}

variable "enable_azure_monitor" {
  type        = bool
  default     = true
  description = "Provision monitor-baseline DCR + AMA extension on both VMs (banking default)."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Existing Log Analytics workspace ID — required when enable_azure_monitor is true."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional resource tags."
}
