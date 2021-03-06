resource "azurerm_management_group_policy_assignment" "deny_public_access" {
  name                 = "sql_deny_public_access"
  policy_definition_id = data.azurerm_policy_definition.sql_deny_public_access.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.sql_deny_public_access.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Audit"
  }
}
PARAMETERS
} 