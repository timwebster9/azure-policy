resource "azurerm_management_group_policy_assignment" "sql_diagnostics_eh" {
  name                 = "sql_diagnostics_eh"
  policy_definition_id = data.azurerm_policy_definition.sql_diagnostics_eventhub.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.sql_diagnostics_eventhub.display_name
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
    "value": "True"
  },
  "logsEnabled": {
    "value": "True"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "diags_policy_eh" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.sql_diagnostics.identity[0].principal_id
}

