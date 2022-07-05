resource "azurerm_policy_definition" "pl_network_policies" {
  name                  = "pl_network_policies"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Private link network policies should be enabled."
  management_group_id = data.azurerm_management_group.policy_definition_mgmt_group.id

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/pl_network_policies/rules.json")
  parameters = file("${path.module}/policy_defs/pl_network_policies/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "pl_network_policies" {
  name                 = "pl_network_policies"
  policy_definition_id = azurerm_policy_definition.pl_network_policies.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.pl_network_policies.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}