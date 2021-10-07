# AZ Policy
resource "azurerm_policy_definition" "default_nsg_rule" {
  name                  = "apim_zones"
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

resource "azurerm_management_group_policy_assignment" "default_nsg_rule" {
  name                 = azurerm_policy_definition.default_nsg_rule.name
  policy_definition_id = azurerm_policy_definition.default_nsg_rule.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.default_nsg_rule.display_name

  parameters = <<PARAMETERS
{
  "name": {
    "value": "deny-inbound-pres-tcp"
  },
  "protocol": {
    "value": "TCP"
  },
  "access": {
    "value": "Deny"
  },
  "priority": {
    "value": "204"
  },
  "direction": {
    "value": "Inbound"
  },
  "sourcePortRanges": {
    "value": ["*"]
  },
  "destinationPortRanges": {
    "value": ["1-21","23-52","54-79","81-442","444-65535"]
  },
  "sourceAddressPrefixes": {
    "value": ["*"]
  },
  "destinationAddressPrefixes": {
    "value": ["*"]
  },
  "effect": {
    "value": "Append"
  }
}
PARAMETERS
}