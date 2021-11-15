# Policy Def
resource "azurerm_policy_definition" "default_nsg_rule" {
  name                  = "default_nsg_rule"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Append default NSG rules"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/default_nsg_rule/rules.json")
  parameters = file("${path.module}/policy_defs/default_nsg_rule/parameters.json")
}