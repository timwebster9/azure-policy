resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "rlg-dev-pol-uks-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_policy_definition.naming_convention,
    azurerm_management_group_policy_assignment.naming_convention
  ]
}
