resource "azurerm_policy_definition" "workspace_auditing" {
  name                  = "workspace_auditing"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Configure Azure Synapse Workspace Auditing"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Synapse"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/workspace_auditing/rules.json")
  parameters = file("${path.module}/policy_defs/workspace_auditing/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "workspace_auditing" {
  name                 = "workspace_auditing"
  policy_definition_id = azurerm_policy_definition.workspace_auditing.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.workspace_auditing.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "DeployIfNotExists"
  },
  "storageEndpoint": {
    "value": "${azurerm_storage_account.diagsexample.primary_blob_endpoint}"
  },
  "storageAccountAccessKey": {
    "value": "${azurerm_storage_account.diagsexample.primary_access_key}"
  },
  "storageAccountSubscriptionId": {
    "value": "${data.azurerm_subscription.current.subscription_id}"
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

resource "azurerm_role_assignment" "workspace_auditing" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.workspace_auditing.identity[0].principal_id
}