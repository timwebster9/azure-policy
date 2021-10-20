provider "azure" {
  tenant_id = "d8d82719-a4e3-4922-8d10-be2b4a616bcd"

  // uncomment if using SP
  //client_id = ""
  //client_secret = ""
}

provider "azurerm" {
  features {}

  storage_use_azuread = true

  subscription_id = "2ca65474-3b7b-40f2-b242-0d2fba4bde6e"

  // uncomment if using SP
  //tenant_id = "d8d82719-a4e3-4922-8d10-be2b4a616bcd"
  //client_id = ""
  //client_secret = ""
}

provider "azurerm" {
  alias = "secondary"
  subscription_id = "5b3b6b87-0c84-4cc0-ac99-75797863d447"
  features {}
}
