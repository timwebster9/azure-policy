resource "azurerm_policy_definition" "appgateway_zones" {
  name                  = "public-ip-sku-zones"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Application Gateway should use availability zones"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/zone_redundant/rules.json")
  parameters = file("${path.module}/policy_defs/zone_redundant/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "appgateway_zones" {
  name                 = azurerm_policy_definition.appgateway_zones.name
  policy_definition_id = azurerm_policy_definition.appgateway_zones.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.appgateway_zones.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "locations": {
    "value": ["uksouth"]
  },
  "numZones": {
    "value": 3
  }
}
PARAMETERS
}