resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_automation_account" "example" {
  name                = "example-account"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "Basic"

  depends_on = [
    azurerm_policy_definition.automation_diagnostics,
    azurerm_management_group_policy_assignment.automation_diagnostics
  ]
}