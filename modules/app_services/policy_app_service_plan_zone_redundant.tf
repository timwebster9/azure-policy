resource "azurerm_policy_definition" "app_service_plan_zone_redundant" {
  name                  = "asp_zr"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "App Service Plans should be zone redundant in supported regions"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "App Service"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/app_service_plan_zone_redundant/rules.json")
  parameters = file("${path.module}/policy_defs/app_service_plan_zone_redundant/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "app_service_plan_zone_redundant" {
  name                 = "asp_zr"
  policy_definition_id = azurerm_policy_definition.app_service_plan_zone_redundant.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.app_service_plan_zone_redundant.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "locations": {
    "value": ["uksouth"]
  }
}
PARAMETERS
}