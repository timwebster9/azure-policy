# resource "azurerm_policy_definition" "app_service_vnet_route_all" {
#   name                  = "vnet_route_all"
#   policy_type           = "Custom"
#   mode                  = "Indexed"
#   display_name          = "App Service apps should enable outbound non-RFC 1918 traffic to Azure Virtual Network (custom)"
#   management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

#   metadata = <<METADATA
#     {
#     "category": "App Service"
#     }

# METADATA

#   policy_rule = file("${path.module}/policy_defs/app_service_vnet_route_all/rules.json")
#   parameters = file("${path.module}/policy_defs/app_service_vnet_route_all/parameters.json")
# }

# resource "azurerm_management_group_policy_assignment" "app_service_vnet_route_all" {
#   name                 = "vnet_route_all"
#   policy_definition_id = azurerm_policy_definition.app_service_vnet_route_all.id
#   management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
#   description          = "Policy Assignment test"
#   display_name         = azurerm_policy_definition.app_service_vnet_route_all.display_name

#   parameters = <<PARAMETERS
# {
#   "effect": {
#     "value": "Deny"
#   }
# }
# PARAMETERS
# }