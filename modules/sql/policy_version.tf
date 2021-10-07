# SQL Version
/* resource "azurerm_policy_definition" "sql_version" {
  name                  = "sql_version"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "SQL Servers should use the specified version"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/sql_version/rules.json")
  parameters = file("${path.module}/policy_defs/sql_version/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "sql_version" {
  name                 = "sql_version"
  policy_definition_id = azurerm_policy_definition.sql_version.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "sql_version"

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "version": {
    "value": "deny-inbound-pres-tcp"
  }
}
PARAMETERS
} */