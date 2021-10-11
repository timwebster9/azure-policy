# SQL Version
resource "azurerm_policy_definition" "sql_zone_redundant" {
  name                  = "sql_zone_redundant"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "SQL Databases should be zone redundant"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/sql_zone_redundant/rules.json")
  parameters = file("${path.module}/policy_defs/sql_zone_redundant/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "sql_zone_redundant" {
  name                 = "sql_zone_redundant"
  policy_definition_id = azurerm_policy_definition.sql_zone_redundant.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.sql_zone_redundant.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Audit"
  },
  "locations": {
    "value": ["uksouth"]
  }
}
PARAMETERS
}