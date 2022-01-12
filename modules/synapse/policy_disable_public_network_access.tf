resource "azurerm_management_group_policy_assignment" "synapse_disable_public_network_access" {
  name                 = "synapse_disable_network"
  policy_definition_id = data.azurerm_policy_definition.disable_public_network_acceess.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.disable_public_network_acceess.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Audit"
  }
}
PARAMETERS
}
