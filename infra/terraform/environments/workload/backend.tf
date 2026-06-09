terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateclient"
    container_name       = "tfstate"
    key                  = "workload/layer2.terraform.tfstate"
  }
}
