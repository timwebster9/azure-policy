resource "azurerm_policy_definition" "subnet_naming_convention" {
  name                  = "subnet_naming"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Subnet names must end with -pre, -app or -dat."
  management_group_id = data.azurerm_management_group.policy_definition_mgmt_group.id

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  # policy adapted from https://github.com/Azure/Community-Policy/tree/master/Policies/Network/deny-subnets-missing-suffix
  policy_rule = file("${path.module}/policy_defs/subnet_naming_convention/rules.json")
  parameters = file("${path.module}/policy_defs/subnet_naming_convention/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "subnet_naming_convention" {
  name                 = "subnet_naming"
  policy_definition_id = azurerm_policy_definition.subnet_naming_convention.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.subnet_naming_convention.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "allowedSuffixes": {
    "value": ["prs","app","dat"]
  }
}
PARAMETERS
}