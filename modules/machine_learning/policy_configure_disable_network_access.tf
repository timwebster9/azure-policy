resource "azurerm_policy_definition" "public_network_access" {
  name                  = "public_network_access"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Azure Machine Learning workspaces should disable public network access (custom)"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Machine Learning"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/public_network_access/rules.json")
  parameters = file("${path.module}/policy_defs/public_network_access/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "public_network_access" {
  name                 = "public_network_access"
  policy_definition_id = data.azurerm_policy_definition.public_network_access.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.public_network_access.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
