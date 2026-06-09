variable "name_prefix" {
  type        = string
  description = "Prefix for storage account and share names."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for storage resources."
}

variable "share_name" {
  type        = string
  default     = "ingestion"
  description = "Azure file share name."
}

variable "share_quota_gb" {
  type        = number
  default     = 100
  description = "File share quota in GB."
}

variable "share_protocol" {
  type        = string
  default     = "NFS"
  description = "NFS (recommended for RHEL) or SMB. NFS requires Premium FileStorage account."
  validation {
    condition     = contains(["NFS", "SMB"], var.share_protocol)
    error_message = "share_protocol must be NFS or SMB."
  }
}

variable "enable_entra_kerberos_smb" {
  type        = bool
  default     = false
  description = "Enable Entra Kerberos on SMB shares when share_protocol is SMB and client AD integration is ready."
}

variable "allowed_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet IDs allowed to reach the storage account (service endpoints or PE subnet)."
}

variable "enable_private_endpoint" {
  type        = bool
  default     = true
  description = "Create private endpoint for file.core.windows.net (recommended for prod)."
}

variable "private_endpoint_subnet_id" {
  type        = string
  default     = null
  description = "Subnet for the file private endpoint. Required when enable_private_endpoint is true."
}

variable "file_private_dns_zone_id" {
  type        = string
  default     = null
  description = "Optional privatelink.file.core.windows.net private DNS zone ID for the PE."
}

variable "principal_ids" {
  type        = list(string)
  default     = []
  description = "Entra principal IDs (e.g. VM UAMI) granted data-plane access to the share."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
