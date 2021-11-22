resource "azurerm_policy_definition" "sql_ep_diagnostics_custom" {
  name                  = "sql_ep_diagnostics"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Deploy Diagnostic Settings for Azure SQL Elastic Pools"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/sql_ep_diagnostics_custom/rules.json")
  parameters = file("${path.module}/policy_defs/sql_ep_diagnostics_custom/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "sql_ep_diagnostics_custom" {
  name                 = "sql_ep_diagnostics"
  policy_definition_id = azurerm_policy_definition.sql_ep_diagnostics_custom.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.sql_ep_diagnostics_custom.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
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
    "value": "${azurerm_storage_account.secondary_sa.id}"
  },
  "storageRetentionDays": {
    "value": 365
  },
  "metricsEnabled": {
    "value": "True"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "sql_ep_diagnostics_custom" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.sql_ep_diagnostics_custom.identity[0].principal_id
}

