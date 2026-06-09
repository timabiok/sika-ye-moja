variable "gallery_name" {
  type        = string
  description = "Globally unique Shared Image Gallery name (letters and numbers only)."
}

variable "image_definition_name" {
  type        = string
  default     = "rhel9-bank-golden"
  description = "Image definition name inside the gallery."
}

variable "location" {
  type        = string
  description = "Primary Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for gallery resources."
}

variable "description" {
  type        = string
  default     = "Bank-grade hardened RHEL 9 golden images"
  description = "Gallery description for audit inventory."
}

variable "image_publisher" {
  type        = string
  default     = "bank.rhel9"
  description = "Publisher segment of the managed image identifier."
}

variable "image_offer" {
  type        = string
  default     = "golden"
  description = "Offer segment of the managed image identifier."
}

variable "image_sku" {
  type        = string
  default     = "rhel9-cis-l1"
  description = "SKU segment of the managed image identifier."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Compliance and ownership tags."
}
