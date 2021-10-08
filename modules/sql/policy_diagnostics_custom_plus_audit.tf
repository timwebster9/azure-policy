resource "azurerm_policy_definition" "diagnostics_eventhub" {
  name                  = "diagnostics_eventhub"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Deploy diagnostics settings for SQL databases"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/diagnostics_eventhub/rules.json")
  parameters = file("${path.module}/policy_defs/diagnostics_eventhub/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "diagnostics_eventhub" {
  name                 = "diagnostics_eventhub"
  policy_definition_id = azurerm_policy_definition.diagnostics_eventhub.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "diagnostics_eventhub"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "eventHubRuleId": {
    "value": "${azurerm_eventhub_namespace_authorization_rule.example.id}"
  },
  "metricsEnabled": {
    "value": "true"
  },
  "logsEnabled": {
    "value": "true"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "policy_logs" {
  scope                = azurerm_log_analytics_workspace.example.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.diagnostics_eventhub.identity[0].principal_id
}