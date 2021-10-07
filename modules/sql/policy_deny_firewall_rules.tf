# SQL Version
resource "azurerm_policy_definition" "deny_firewall_rules" {
  name                  = "sql_version"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "SQL Servers should not allow firewall rules"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/deny_firewall_rules/rules.json")
  parameters = file("${path.module}/policy_defs/deny_firewall_rules/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "deny_firewall_rules" {
  name                 = "deny_firewall_rules"
  policy_definition_id = azurerm_policy_definition.deny_firewall_rules.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "deny_firewall_rules"

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}