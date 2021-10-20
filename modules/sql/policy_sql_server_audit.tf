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
  },
  "eventHubRuleId": {
    "value": "${azurerm_eventhub_namespace_authorization_rule.namespace_rule.id}"
  },
  "eventHubName": {
    "value": "${azurerm_eventhub.logs.name}"
  },
  "logAnalyticsWorkspaceId": {
    "value": "${azurerm_log_analytics_workspace.example.id}"
  },
  "storageAccountId": {
    "value": "${data.azurerm_storage_account.secondary.id}"
  },
  "storageAccountSubscriptionId": {
    "value": "5b3b6b87-0c84-4cc0-ac99-75797863d447"
  },
  "storageEndpoint": {
    "value": "${data.azurerm_storage_account.secondary.primary_blob_endpoint}"
  },
  "storageRetentionDays": {
    "value": 365
  },
  "logsEnabled": {
    "value": "True"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "sql_server_audit" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "SQL Security Manager"
  principal_id         = azurerm_management_group_policy_assignment.sql_server_audit.identity[0].principal_id
}