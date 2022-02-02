resource "azurerm_policy_definition" "vnet_injection" {
  name                  = "vnet_injection"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Azure Dataabricks Workspaces should use VNet injection"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Databricks"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/vnet_injection/rules.json")
  parameters = file("${path.module}/policy_defs/vnet_injection/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "vnet_injection" {
  name                 = "scc"
  policy_definition_id = azurerm_policy_definition.vnet_injection.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.vnet_injection.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
