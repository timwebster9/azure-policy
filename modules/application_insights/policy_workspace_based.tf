resource "azurerm_policy_definition" "workspace_based" {
  name                  = "workspace_based"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Application Insights components must be workspace-based."
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Monitoring"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/workspace_based/rules.json")
  parameters = file("${path.module}/policy_defs/workspace_based/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "workspace_based" {
  name                 = "workspace_based"
  policy_definition_id = azurerm_policy_definition.workspace_based.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.workspace_based.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}