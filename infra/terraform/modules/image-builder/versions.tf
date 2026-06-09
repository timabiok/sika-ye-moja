terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.116"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}
