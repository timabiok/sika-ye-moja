variable "name_prefix" {
  type        = string
  description = "Prefix for image builder resources."
}

variable "location" {
  type        = string
  description = "Azure region for image build."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for image builder resources."
}

variable "gallery_id" {
  type        = string
  description = "Shared Image Gallery ID for RBAC assignment."
}

variable "image_definition_id" {
  type        = string
  description = "Target image definition ID in SIG."
}

variable "image_version" {
  type        = string
  description = "Semantic version label for this image build (e.g. 1.0.0)."
}

variable "build_subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID for private VNet-integrated builds (required for production)."
}

variable "source_publisher" {
  type        = string
  default     = "RedHat"
  description = "Marketplace publisher for RHEL 9 base image."
}

variable "source_offer" {
  type        = string
  default     = "rhel-byos"
  description = "BYOS offer; banks typically use existing Red Hat subscriptions."
}

variable "source_sku" {
  type        = string
  default     = "94-gen2"
  description = "RHEL 9.4 Gen2 SKU; align with your RH subscription and patch cadence."
}

variable "source_version" {
  type        = string
  default     = "latest"
  description = "Marketplace image version; pin in production for reproducibility."
}

variable "replication_regions" {
  type        = list(string)
  default     = []
  description = "Additional regions for SIG replication (DR)."
}

variable "replica_count" {
  type        = number
  default     = 1
  description = "Regional replica count in SIG."
}

variable "enable_ansible_customization" {
  type        = bool
  default     = false
  description = "Run supplemental Ansible hardening from uploaded archive."
}

variable "ansible_archive_path" {
  type        = string
  default     = null
  description = "Local path to ansible.tar.gz uploaded for AIB Ansible customizer."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Log Analytics workspace for AIB build diagnostics."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Compliance tags applied to all resources."
}

variable "enable_scripts_private_endpoint" {
  type        = bool
  default     = false
  description = "Attach a private endpoint for script storage on the build subnet (production)."
}

variable "blob_private_dns_zone_id" {
  type        = string
  default     = null
  description = "Private DNS zone ID for privatelink.blob.core.windows.net (required when enable_scripts_private_endpoint is true)."
}

variable "scripts_storage_public_access" {
  type        = bool
  default     = true
  description = "Allow public network access to script storage. Ignored when enable_scripts_private_endpoint is true."
}

variable "enable_rhsm" {
  type        = bool
  default     = false
  description = "Register RHEL BYOS during image build using an activation key from Key Vault."
}

variable "rhsm_key_vault_id" {
  type        = string
  default     = null
  description = "Key Vault resource ID containing the RHSM activation key secret."
}

variable "rhsm_secret_name" {
  type        = string
  default     = "rhsm-activation-key"
  description = "Key Vault secret name for the Red Hat activation key."
}

variable "rhsm_organization" {
  type        = string
  default     = null
  description = "Red Hat subscription organization ID for activation."
}

variable "enable_key_vault_private_endpoint" {
  type        = bool
  default     = false
  description = "Private endpoint for Key Vault on the build subnet (when vault has public access disabled)."
}

variable "key_vault_private_dns_zone_id" {
  type        = string
  default     = null
  description = "Private DNS zone ID for privatelink.vaultcore.azure.net."
}
