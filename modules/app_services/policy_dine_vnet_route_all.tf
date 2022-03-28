resource "azurerm_policy_definition" "dine_vnet_route_all" {
  name                  = "dine_vnet_route_all"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "App Service apps should enable outbound non-RFC 1918 traffic to Azure Virtual Network (custom)"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "App Service"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/dine_app_service_vnet_route_all/rules.json")
  parameters = file("${path.module}/policy_defs/dine_app_service_vnet_route_all/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "dine_vnet_route_all" {
  name                 = "vnet_route_all"
  policy_definition_id = azurerm_policy_definition.dine_vnet_route_all.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.dine_vnet_route_all.display_name
  location             = var.location
  
  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "DeployIfNotExists"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "dine_vnet_route_all" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.dine_vnet_route_all.identity[0].principal_id
}