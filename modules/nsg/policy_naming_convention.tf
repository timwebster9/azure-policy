resource "azurerm_policy_definition" "naming_convention" {
  name                  = "nsg_naming"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Network Security Group names must end with -pre, -app or -dat."
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
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

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}