resource "azurerm_policy_definition" "disable_egress" {
  name                  = "disable_egress"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Azure Databricks Workspaces should use Azure Firewall for egress traffic"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Databricks"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/disable_egress/rules.json")
  parameters = file("${path.module}/policy_defs/disable_egress/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "disable_egress" {
  name                 = "disable_egress"
  policy_definition_id = azurerm_policy_definition.disable_egress.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.disable_egress.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
