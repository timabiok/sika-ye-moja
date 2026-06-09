variable "name_prefix" {
  type        = string
  description = "Workload name prefix."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Existing resource group for layer-2 VMs."
}

variable "sig_image_version_id" {
  type        = string
  description = "Layer-1 SIG image version ID from environments/prod."
}

variable "runner_subnet_id" {
  type        = string
  description = "CI subnet for GitHub runner VM."
}

variable "runtime_subnet_id" {
  type        = string
  description = "App subnet for Podman runtime VM."
}

variable "runner_private_ip_address" {
  type        = string
  description = "Static private IP for runner (document in firewall allow-list)."
}

variable "runtime_private_ip_address" {
  type        = string
  description = "Static private IP for runtime (document in firewall allow-list)."
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "Bastion subnet CIDR for NSG SSH inbound."
}

variable "apim_subnet_prefix" {
  type        = string
  default     = null
  description = "Optional APIM subnet CIDR."
}

variable "admin_ssh_public_key" {
  type        = string
  description = "SSH public key."
  sensitive   = true
}

variable "acr_id" {
  type        = string
  description = "ACR resource ID for UAMI RBAC."
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault resource ID for UAMI RBAC."
}

variable "runner_env_label" {
  type        = string
  default     = "uat"
  description = "GitHub runner label (dev, uat, prod)."
}

variable "runtime_data_disk_size_gb" {
  type        = number
  default     = 256
  description = "Managed data disk size for runtime VM."
}

variable "enable_ingestion_fileshare" {
  type        = bool
  default     = false
  description = "Enable Azure Files ingestion share."
}

variable "fileshare_private_endpoint_subnet_id" {
  type        = string
  default     = null
  description = "Subnet for file share private endpoint."
}

variable "enable_azure_monitor" {
  type        = bool
  default     = true
  description = "Attach monitor-baseline DCR + AMA extension to both VMs."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Client Log Analytics workspace ID (required when enable_azure_monitor is true)."
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags."
}
