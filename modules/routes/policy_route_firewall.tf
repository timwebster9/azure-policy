resource "azurerm_management_group_policy_assignment" "route_firewall" {
  name                 = "route_firewall"
  policy_definition_id = data.azurerm_policy_definition.route_firewall.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.route_firewall.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "AuditIfNotExists"
  }
}
PARAMETERS
}