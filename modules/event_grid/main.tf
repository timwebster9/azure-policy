resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_eventgrid_domain" "example" {
  name                = "eg345354h53hj5"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_management_group_policy_assignment.domain_disable_public_network_access
  ]
}

resource "azurerm_eventgrid_domain_topic" "example" {
  name                = "topic897fgsdgfdg"
  domain_name         = azurerm_eventgrid_domain.example.name
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_management_group_policy_assignment.topic_disable_public_network_access
  ]
}