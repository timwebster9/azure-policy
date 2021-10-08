resource "azurerm_policy_definition" "sql_diagnostics" {
  name                  = "diagnostics"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Deploy diagnostics settings for SQL databases"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/diagnostics/rules.json")
  parameters = file("${path.module}/policy_defs/diagnostics/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "sql_diagnostics" {
  name                 = "sql_diagnostics"
  policy_definition_id = azurerm_policy_definition.sql_diagnostics.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "sql_diagnostics"

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "logAnalyticsWorkspaceId": {
    "value": "${azurerm_log_analytics_workspace.example.workspace_id}"
  },
  "metricsAndLogsEnabled": {
    "value": "true"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "policy_logs" {
  scope                = azurerm_log_analytics_workspace.example.id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.sql_diagnostics.identity.principal_id
}