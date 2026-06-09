variable "name_prefix" {
  type        = string
  description = "Prefix for ACR and related resources."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for ACR."
}

variable "acr_name" {
  type        = string
  description = "Globally unique ACR name (alphanumeric only, 5-50 chars)."
}

variable "sku" {
  type        = string
  default     = "Premium"
  description = "Premium required for private endpoint, quarantine, retention policies."
}

variable "admin_enabled" {
  type        = bool
  default     = false
  description = "Banking default — disable admin user; use UAMI/RBAC only."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Banking default — deny public access; use private endpoint."
}

variable "quarantine_policy_enabled" {
  type        = bool
  default     = true
  description = "Hold newly pushed images until vulnerability scan passes (Defender)."
}

variable "retention_days" {
  type        = number
  default     = 30
  description = "Untagged manifest retention in days."
}

variable "allowed_ip_ranges" {
  type        = list(string)
  default     = []
  description = "Optional firewall IP allow-list. VNet access uses private endpoint (runner/runtime subnets)."
}

variable "trust_policy_enabled" {
  type        = bool
  default     = false
  description = "Content trust (notation) — enable when client signs images."
}

variable "enable_private_endpoint" {
  type        = bool
  default     = true
  description = "Private endpoint for registry.data access."
}

variable "private_endpoint_subnet_id" {
  type        = string
  default     = null
  description = "Subnet for ACR private endpoint."
}

variable "private_dns_zone_ids" {
  type        = list(string)
  default     = []
  description = "privatelink.azurecr.io zone IDs for PE DNS integration."
}

variable "georeplications" {
  type = list(object({
    location                = string
    zone_redundancy_enabled = optional(bool, false)
  }))
  default     = []
  description = "Optional geo-replication (Premium SKU)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
