variable "vm_name" {
  type        = string
  description = "Linux VM name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the VM."
}

variable "subnet_id" {
  type        = string
  description = "Subnet for the VM NIC (private-only for production)."
}

variable "source_image_id" {
  type        = string
  description = "Full SIG image version resource ID from the golden image gallery."
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Local admin username (SSH key auth only)."
}

variable "admin_ssh_public_key" {
  type        = string
  description = "SSH public key for admin access."
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2s_v5"
  description = "VM SKU."
}

variable "os_disk_size_gb" {
  type        = number
  default     = 64
  description = "OS disk size in GB."
}

variable "os_disk_storage_account_type" {
  type        = string
  default     = "Premium_LRS"
  description = "OS disk storage type."
}

variable "private_ip_address_allocation" {
  type        = string
  default     = "Static"
  description = "Static private IP required for firewall allow-lists (banking default)."
  validation {
    condition     = contains(["Static", "Dynamic"], var.private_ip_address_allocation)
    error_message = "Must be Static or Dynamic."
  }
}

variable "private_ip_address" {
  type        = string
  default     = null
  description = "Static private IP when allocation is Static."
}

variable "allow_dynamic_private_ip" {
  type        = bool
  default     = false
  description = "Override banking default — allow Dynamic private IP (dev/lab only)."
}

variable "data_disks" {
  type = list(object({
    name                 = string
    size_gb              = number
    storage_account_type = optional(string, "Premium_LRS")
    lun                  = number
    caching              = optional(string, "ReadWrite")
    mount_hint           = optional(string, "")
  }))
  default     = []
  description = "Optional managed data disks (EBS-like block volumes). Mount in guest OS via cloud-init/Ansible using UUID/fstab."
}

variable "user_assigned_identity_ids" {
  type        = list(string)
  description = "User-assigned managed identity resource ID(s). Banking baseline: exactly one dedicated UAMI per VM role."
  validation {
    condition     = length(var.user_assigned_identity_ids) > 0
    error_message = "At least one user_assigned_identity_id is required."
  }
}

variable "network_security_group_id" {
  type        = string
  default     = null
  description = "NSG for the NIC — required in banking workload stacks."
}

variable "custom_data" {
  type        = string
  default     = null
  description = "Optional cloud-init/cloud-config for layer-2 role bootstrap (base64-encoded by module)."
}

variable "enable_azure_monitor" {
  type        = bool
  default     = true
  description = "Attach Azure Monitor Agent extension and DCR association (banking default)."
}

variable "data_collection_rule_id" {
  type        = string
  default     = null
  description = "DCR resource ID from monitor-baseline module."
}

variable "azure_monitor_extension_version" {
  type        = string
  default     = "1.28"
  description = "Pinned AzureMonitorLinuxAgent handler version."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
