resource "azurerm_policy_definition" "enforce_bgp_disabled" {
  name                  = "enforce_bgp_disabled"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Route tables should have BGP propagation disabled"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/enforce_bgp_disabled/rules.json")
  parameters = file("${path.module}/policy_defs/enforce_bgp_disabled/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "enforce_bgp_disabled" {
  name                 = "enforce_bgp_disabled"
  policy_definition_id = azurerm_policy_definition.enforce_routes.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.enforce_routes.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}