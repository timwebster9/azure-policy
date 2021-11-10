resource "azurerm_management_group_policy_assignment" "enforce_routes" {
  name                 = "enforce_routes"
  policy_definition_id = data.azurerm_policy_definition.route_firewall.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.enforce_routes.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "AuditIfNotExists"
  }
}
PARAMETERS
}