resource "azurerm_policy_definition" "domain_diagnostics" {
  name                  = "domain_diagnostics"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Deploy Event Grid Domain Diagnostics"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.id

  metadata = <<METADATA
    {
    "category": "Event Grid"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/eg_domain_diagnostics/rules.json")
  parameters = file("${path.module}/policy_defs/eg_domain_diagnostics/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "domain_diagnostics" {
  name                 = "domain_diagnostics"
  policy_definition_id = azurerm_policy_definition.domain_diagnostics.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.domain_diagnostics.display_name
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
    "value": "${azurerm_storage_account.diagsstorageaccount.id}"
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

resource "azurerm_role_assignment" "domain_diagnostics" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.domain_diagnostics.identity[0].principal_id
}