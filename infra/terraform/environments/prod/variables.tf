variable "name_prefix" {
  type        = string
  description = "Short unique prefix for all resources (e.g. acme-bank)."
}

variable "location" {
  type        = string
  description = "Primary Azure region (e.g. eastus2)."
}

variable "gallery_name" {
  type        = string
  description = "Globally unique SIG name."
}

variable "image_definition_name" {
  type        = string
  default     = "rhel9-bank-golden"
}

variable "image_version" {
  type        = string
  description = "Version label for this build (used in artifact naming)."
}

variable "cost_center" {
  type        = string
  description = "Finance chargeback identifier."
}

variable "application_owner" {
  type        = string
  description = "Team or DL owning the golden image pipeline."
}

variable "build_vnet_address_space" {
  type    = string
  default = "10.250.0.0/24"
}

variable "build_subnet_address_prefix" {
  type    = string
  default = "10.250.0.0/26"
}

variable "enable_private_endpoints" {
  type    = bool
  default = true
}

variable "rhel_source_publisher" {
  type    = string
  default = "RedHat"
}

variable "rhel_source_offer" {
  type    = string
  default = "rhel-byos"
}

variable "rhel_source_sku" {
  type    = string
  default = "94-gen2"
}

variable "rhel_source_version" {
  type        = string
  default     = "latest"
  description = "Pin to a specific version in production for reproducible builds."
}

variable "sig_image_publisher" {
  type    = string
  default = "bank.rhel9"
}

variable "sig_image_offer" {
  type    = string
  default = "golden"
}

variable "sig_image_sku" {
  type    = string
  default = "rhel9-cis-l1"
}

variable "replication_regions" {
  type        = list(string)
  default     = []
  description = "DR regions for SIG replication."
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "enable_ansible_customization" {
  type        = bool
  default     = true
  description = "Required for banking baseline (azure-cli, Python/Ansible, layer-2 artifacts)."
}

variable "ansible_archive_path" {
  type    = string
  default = null
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "scripts_storage_public_access" {
  type        = bool
  default     = false
  description = "Only used when enable_private_endpoints is false. Production should use private endpoints."
}

variable "enable_rhsm" {
  type        = bool
  default     = false
  description = "Register RHEL BYOS during image build from a Key Vault activation key."
}

variable "rhsm_key_vault_id" {
  type        = string
  default     = null
  description = "Key Vault resource ID (e.g. /subscriptions/.../vaults/my-kv)."
}

variable "rhsm_secret_name" {
  type    = string
  default = "rhsm-activation-key"
}

variable "rhsm_organization" {
  type        = string
  default     = null
  description = "Red Hat org ID for subscription-manager register --org."
}

variable "enable_key_vault_private_endpoint" {
  type        = bool
  default     = false
  description = "Private endpoint to Key Vault from the build VNet (when vault blocks public access)."
}

variable "deploy_example_vm" {
  type        = bool
  default     = false
  description = "Deploy a test VM from a pinned SIG version (validation only)."
}

variable "sig_image_version_id" {
  type        = string
  default     = null
  description = "Full ARM ID of the SIG image version for example_compute."
}

variable "example_vm_ssh_public_key" {
  type        = string
  default     = null
  description = "SSH public key when deploy_example_vm is true."
}
