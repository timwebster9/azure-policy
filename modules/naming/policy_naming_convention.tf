resource "azurerm_policy_definition" "naming_convention" {
  name                  = "naming_convention"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Resources should use the provided naming convention"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.id

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/naming_convention/rules.json")
  parameters = file("${path.module}/policy_defs/naming_convention/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "naming_convention" {
  name                 = "naming_convention"
  policy_definition_id = azurerm_policy_definition.naming_convention.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.naming_convention.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "resourceTypes": {
    "value": ["Microsoft.Network/virtualNetworks"]
  }
}
PARAMETERS
}