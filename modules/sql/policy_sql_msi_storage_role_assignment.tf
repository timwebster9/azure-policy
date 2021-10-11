# SQL Version
resource "azurerm_policy_definition" "sql_msi_storage_role_assignment" {
  name                  = "sql_msi_ra"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Assign roles for SQL Server managed identity on storage account"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/sql_msi_storage_role_assignment/rules.json")
  parameters = file("${path.module}/policy_defs/sql_msi_storage_role_assignment/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "sql_msi_storage_role_assignment" {
  name                 = "sql_identity"
  policy_definition_id = azurerm_policy_definition.sql_msi_storage_role_assignment.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.sql_msi_storage_role_assignment.display_name

  parameters = <<PARAMETERS
{
  "storageAccountName": {
    "value": "timwpolicydiags908745"
  },
  "storageAccountSubscriptionId": {
    "value": "2ca65474-3b7b-40f2-b242-0d2fba4bde6e"
  }
}
PARAMETERS
}