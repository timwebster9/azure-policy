resource "azurerm_policy_definition" "sql_server_audit" {
  name                  = "sql_server_audit"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Enable auditing on Azure SQL Servers"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/sql_server_audit/rules.json")
  parameters = file("${path.module}/policy_defs/sql_server_audit/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "sql_server_audit" {
  name                 = "sql_server_audit"
  policy_definition_id = azurerm_policy_definition.sql_server_audit.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.sql_server_audit.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "auditActionsAndGroups": {
    "value": ["BATCH_COMPLETED_GROUP","SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP","FAILED_DATABASE_AUTHENTICATION_GROUP"]
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "sql_audit_policy_eh" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "SQL Security Manager"
  principal_id         = azurerm_management_group_policy_assignment.sql_diagnostics.identity[0].principal_id
}