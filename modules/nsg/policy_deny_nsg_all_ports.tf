resource "azurerm_policy_definition" "deny_nsg_all_ports" {
  name                  = "deny_nsg_all_ports"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Network Security Group rules should not use '*' for destination port ranges"
  management_group_id = data.azurerm_management_group.policy_definition_mgmt_group.id

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/deny_nsg_all_ports/rules.json")
  parameters = file("${path.module}/policy_defs/deny_nsg_all_ports/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "deny_nsg_all_ports" {
  name                 = "deny_nsg_all_ports"
  policy_definition_id = azurerm_policy_definition.deny_nsg_all_ports.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.deny_nsg_all_ports.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}