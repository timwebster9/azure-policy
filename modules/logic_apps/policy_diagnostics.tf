resource "azurerm_policy_definition" "diagnostics" {
  name                  = "la_diagnostics"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Deploy Diagnostic Settings for Function Apps"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Logic Apps"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/diagnostics/rules.json")
  parameters = file("${path.module}/policy_defs/diagnostics/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "diagnostics" {
  name                 = "la_diagnostics"
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
    "value": "${azurerm_storage_account.diagsexample.id}"
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

resource "azurerm_role_assignment" "diagnostics" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.diagnostics.identity[0].principal_id
}

