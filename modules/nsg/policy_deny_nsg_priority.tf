resource "azurerm_policy_definition" "deny_nsg_priority" {
  name                  = "deny_nsg_priority"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Network Security Group rules should not have a priority less than the specified value."
  management_group_id = data.azurerm_management_group.policy_definition_mgmt_group.id

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/deny_nsg_priority/rules.json")
  parameters = file("${path.module}/policy_defs/deny_nsg_priority/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "deny_nsg_priority" {
  name                 = "deny_nsg_priority"
  policy_definition_id = azurerm_policy_definition.deny_nsg_priority.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.deny_nsg_priority.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}