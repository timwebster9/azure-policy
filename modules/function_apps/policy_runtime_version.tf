resource "azurerm_management_group_policy_assignment" "function_runtime_version" {
  name                 = "runtime_version"
  policy_definition_id = data.azurerm_policy_definition.function_runtime_version.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Functions should use an approved runtime version"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
  "allowedRuntimeVersions": {
    "value": ["~3"]
  }
}
PARAMETERS
}
