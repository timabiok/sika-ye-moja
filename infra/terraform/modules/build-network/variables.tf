variable "name_prefix" {
  type        = string
  description = "Prefix for build network resources."
}

variable "location" {
  type        = string
  description = "Azure region for the build VNet."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group hosting build network resources."
}

variable "vnet_address_space" {
  type        = string
  default     = "10.250.0.0/24"
  description = "Address space for the isolated image-build VNet."
}

variable "subnet_address_prefix" {
  type        = string
  default     = "10.250.0.0/26"
  description = "Subnet for Azure Image Builder staging VMs."
}

variable "enable_private_endpoints" {
  type        = bool
  default     = true
  description = "Create private DNS zones for blob/storage private endpoints used during build."
}

variable "enable_key_vault_dns" {
  type        = bool
  default     = false
  description = "Create privatelink.vaultcore.azure.net zone for RHSM Key Vault private endpoints."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags including compliance metadata."
}
