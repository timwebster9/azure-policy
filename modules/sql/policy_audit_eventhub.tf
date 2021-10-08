resource "azurerm_policy_definition" "sql_audit_eventhub" {
  name                  = "sql_audit_eventhub"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Deploy audit settings for SQL databases to Event Hub"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/sql_audit_eventhub/rules.json")
  parameters = file("${path.module}/policy_defs/sql_audit_eventhub/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "sql_audit_eventhub" {
  name                 = "sql_audit_eventhub"
  policy_definition_id = azurerm_policy_definition.sql_audit_eventhub.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.sql_audit_eventhub.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "eventHubRuleId": {
    "value": "${azurerm_eventhub_namespace_authorization_rule.example.id}}"
  },
  "eventHubName": {
    "value": "${azurerm_eventhub_namespace_authorization_rule.example.name}"
  }
}
PARAMETERS
}

# resource "azurerm_role_assignment" "sql_audit_policy_eh" {
#   scope                = data.azurerm_subscription.current.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_management_group_policy_assignment.sql_diagnostics.identity[0].principal_id
# }