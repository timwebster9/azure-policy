resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_app_configuration" "appconf" {
  name                = "safasfsdfsd"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"

  depends_on = [
    azurerm_management_group_policy_assignment.disable_public_network_access,
    azurerm_management_group_policy_assignment.disable_access_keys,
    azurerm_management_group_policy_assignment.private_link_sku
  ]
}

# should fail
resource "azurerm_app_configuration" "free" {
  name                = "hgfhdgfgh"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "free"

  depends_on = [
    azurerm_management_group_policy_assignment.disable_public_network_access,
    azurerm_management_group_policy_assignment.disable_access_keys,
    azurerm_management_group_policy_assignment.private_link_sku
  ]
}
