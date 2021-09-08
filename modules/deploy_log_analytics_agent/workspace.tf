resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "acctest-01"
  location            = azurerm_resource_group.policy.location
  resource_group_name = azurerm_resource_group.policy.name
  sku                 = "Free"
}