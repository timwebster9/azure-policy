resource "azurerm_policy_definition" "disallowed_roles" {
  name                  = "disallowed_roles"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Disallowed Role Assignments"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Authorization"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/disallowed_roles/rules.json")
  parameters = file("${path.module}/policy_defs/disallowed_roles/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "disallowed_roles" {
  name                 = "disallowed_roles"
  policy_definition_id = azurerm_policy_definition.disallowed_roles.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.disallowed_roles.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "roleDefinitionIds": {
    "value": ["8e3af657-a8ff-443c-a75c-2fe8c4bcb635","18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"]
  },
  "exemptPrincipalIDs": {
    "value": []
  }
}
PARAMETERS
}