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
    key                  = "policy.tfstate"
    #subscription_id      = "2ca65474-3b7b-40f2-b242-0d2fba4bde6e"
    #tenant_id            = "d8d82719-a4e3-4922-8d10-be2b4a616bcd"
  }
}