resource "azurerm_policy_definition" "app_service_plan_diagnostics" {
  name                  = "asp_diagnostics"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Deploy Diagnostic Settings for App Service Plans"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "App Service"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/app_service_plan_diagnostics/rules.json")
  parameters = file("${path.module}/policy_defs/app_service_plan_diagnostics/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "app_service_plan_diagnostics" {
  name                 = "asp_diagnostics"
  policy_definition_id = azurerm_policy_definition.app_service_plan_diagnostics.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.app_service_plan_diagnostics.display_name
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

resource "azurerm_role_assignment" "app_service_plan_diagnostics" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.app_service_plan_diagnostics.identity[0].principal_id
}

