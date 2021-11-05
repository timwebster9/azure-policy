resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_firewall_policy" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Premium"
}