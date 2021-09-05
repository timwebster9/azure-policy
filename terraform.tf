terraform {
  required_providers {
    azure = {
      source = "azuread"
      version = "2.0.1"
    }
    azurerm = {
      source = "azurerm"
      version = "2.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "mgmt-rg"
    storage_account_name = "mgmtstorage3445354"
    container_name       = "tfstate"
    key                  = "bastion.tfstate"
  }
}