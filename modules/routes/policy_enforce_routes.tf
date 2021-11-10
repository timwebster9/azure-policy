resource "azurerm_policy_definition" "enforce_routes" {
  name                  = "enforce_routes"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Subnets should have a default route"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/enforce_routes/rules.json")
  parameters = file("${path.module}/policy_defs/enforce_routes/parameters.json")
}
resource "azurerm_management_group_policy_assignment" "enforce_routes" {
  name                 = "enforce_routes"
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