variable "name_prefix" {
  type        = string
  description = "Prefix for monitor resources."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for DCR."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Existing Log Analytics workspace resource ID (client provides)."
}

variable "vm_identity_principal_ids" {
  type        = list(string)
  default     = []
  description = "UAMI principal IDs granted Monitoring Metrics Publisher on the DCR."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
