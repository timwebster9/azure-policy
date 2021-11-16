resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "policytestworkspace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# should fail
resource "azurerm_application_insights" "fail" {
  name                = "tf-appinsights-fail"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"

  depends_on = [
    azurerm_policy_definition.workspace_based,
    azurerm_management_group_policy_assignment.workspace_based
  ]
}

resource "azurerm_application_insights" "example" {
  name                = "tf-test-appinsights-workspace-based"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  workspace_id        = azurerm_log_analytics_workspace.example.id
  application_type    = "web"

  depends_on = [
    azurerm_policy_definition.workspace_based,
    azurerm_management_group_policy_assignment.workspace_based
  ]
}