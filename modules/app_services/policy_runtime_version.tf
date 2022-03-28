resource "azurerm_policy_definition" "function_runtime_version" {
  name                  = "runtime_version"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Functions should use an approved runtime version"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "App Service"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/function_runtime_version/rules.json")
  parameters = file("${path.module}/policy_defs/function_runtime_version/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "function_runtime_version" {
  name                 = "runtime_version"
  policy_definition_id = azurerm_policy_definition.function_runtime_version.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.function_runtime_version.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "allowedRuntimeVersions": {
    "value": ["~3"]
  }
}
PARAMETERS
}
