# SQL Version
resource "azurerm_policy_definition" "sql_identity" {
  name                  = "sql_identity"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "SQL Servers should have a system assigned managed identity"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/sql_identity/rules.json")
  parameters = file("${path.module}/policy_defs/sql_identity/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "sql_identity" {
  name                 = "sql_identity"
  policy_definition_id = azurerm_policy_definition.deny_firewall_rules.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.sql_identity.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}