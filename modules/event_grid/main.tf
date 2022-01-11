resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# should fail
resource "azurerm_eventgrid_domain" "examplefail" {
  name                = "eg345354h53hj5fail"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_policy_definition.domain_diagnostics,
    azurerm_management_group_policy_assignment.domain_diagnostics,
    azurerm_management_group_policy_assignment.domain_disable_public_network_access,
    azurerm_management_group_policy_assignment.domain_disable_local_auth
  ]
}

# should pass
resource "azurerm_eventgrid_domain" "examplefpass" {
  name                = "eg345354h53hj5"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  public_network_access_enabled = false

  depends_on = [
    azurerm_policy_definition.domain_diagnostics,
    azurerm_management_group_policy_assignment.domain_diagnostics,
    azurerm_management_group_policy_assignment.domain_disable_public_network_access,
    azurerm_management_group_policy_assignment.domain_disable_local_auth
  ]
}

resource "azurerm_eventgrid_domain_topic" "example" {
  name                = "topic897fgsdgfdg"
  domain_name         = azurerm_eventgrid_domain.examplefpass.name
  resource_group_name = azurerm_resource_group.example.name
}

# should fail (public network access)
resource "azurerm_eventgrid_topic" "examplefail" {
  name                = "topicfail3454jkn34jk5"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_policy_definition.topic_diagnostics,
    azurerm_management_group_policy_assignment.topic_diagnostics,
    azurerm_management_group_policy_assignment.topic_disable_public_network_access,
    azurerm_management_group_policy_assignment.topic_disable_local_auth
  ]
}

# should pass
resource "azurerm_eventgrid_topic" "examplepass" {
  name                = "topicpass3454jkn34jk5"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  public_network_access_enabled = false

  depends_on = [
    azurerm_policy_definition.topic_diagnostics,
    azurerm_management_group_policy_assignment.topic_diagnostics,
    azurerm_management_group_policy_assignment.topic_disable_public_network_access,
    azurerm_management_group_policy_assignment.topic_disable_local_auth
  ]
}