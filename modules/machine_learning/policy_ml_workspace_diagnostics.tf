resource "azurerm_policy_definition" "diagnostics" {
  name                  = "diagnostics"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Deploy Machine Learning Workspace Diagnostics"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Machine Learning"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/ml_workspace_diagnostics/rules.json")
  parameters = file("${path.module}/policy_defs/ml_workspace_diagnostics/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "diagnostics" {
  name                 = "diagnostics"
  policy_definition_id = azurerm_policy_definition.diagnostics.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.diagnostics.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "DeployIfNotExists"
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
    "value": "${azurerm_storage_account.example.id}"
  },
  "storageRetentionDays": {
    "value": 365
  },
  "metricsEnabled": {
    "value": "True"
  },
  "logsEnabled": {
    "value": "True"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "ml_diagnostics" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.diagnostics.identity[0].principal_id
}