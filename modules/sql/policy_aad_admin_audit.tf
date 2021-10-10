resource "azurerm_management_group_policy_assignment" "aad_admin_audit" {
  name                 = "aad_admin_audit"
  policy_definition_id = data.azurerm_policy_definition.aad_admin_audit.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.aad_admin_audit.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "AuditIfNotExists"
  }
}
PARAMETERS
}