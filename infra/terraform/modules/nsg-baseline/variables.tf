variable "name_prefix" {
  type        = string
  description = "Resource name prefix."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group."
}

variable "vm_role" {
  type        = string
  description = "github-runner or podman-runtime."
  validation {
    condition     = contains(["github-runner", "podman-runtime"], var.vm_role)
    error_message = "vm_role must be github-runner or podman-runtime."
  }
}

variable "bastion_subnet_prefix" {
  type        = string
  default     = null
  description = "CIDR for Bastion/jump subnet allowed to SSH (e.g. 10.1.1.0/24). Required for banking baseline."
}

variable "apim_subnet_prefix" {
  type        = string
  default     = null
  description = "CIDR for APIM subnet inbound to runtime (optional)."
}

variable "runtime_app_ports" {
  type        = list(string)
  default     = ["443", "8080"]
  description = "Inbound ports on runtime VM from APIM."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags."
}
