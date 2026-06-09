variable "name_prefix" {
  type        = string
  description = "Prefix for tagging / documentation."
}

variable "developer_group_object_id" {
  type        = string
  description = "Entra ID group object ID for platform developers (grp-platform-developers)."
}

variable "dev_subscription_id" {
  type        = string
  description = "Dev subscription scope for CLI access — never prod."
}

variable "dev_resource_group_id" {
  type        = string
  default     = null
  description = "Optional dev RG scope (tighter than subscription)."
}

variable "acr_id" {
  type        = string
  default     = null
  description = "Dev ACR resource ID for AcrPush eligible assignment."
}

variable "key_vault_id" {
  type        = string
  default     = null
  description = "Dev Key Vault resource ID for secrets read during local dev."
}

variable "enable_reader" {
  type        = bool
  default     = true
  description = "PIM eligible Reader on dev scope."
}

variable "enable_acr_push" {
  type        = bool
  default     = true
  description = "PIM eligible AcrPush on dev ACR (podman push from developer workstation)."
}

variable "enable_key_vault_secrets" {
  type        = bool
  default     = true
  description = "PIM eligible Key Vault Secrets User on dev KV."
}

variable "pim_activation_max_hours" {
  type        = number
  default     = 8
  description = "Documented max PIM activation duration — enforce in Entra role settings."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags (informational — PIM assignments are Entra objects)."
}
