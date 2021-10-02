resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_api_management" "example" {
  name                = "twpolicyapim8979uaaf"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "asdfasfsda"
  publisher_email     = "joe@blow.com"

  sku_name = "Developer_1"
}