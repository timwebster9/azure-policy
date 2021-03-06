resource "azurerm_management_group_policy_assignment" "deny_inbound_tcp_pres" {
  name                 = "deny_inbound_tcp_pres"
  policy_definition_id = azurerm_policy_definition.default_nsg_rule.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "deny_inbound_tcp_pres"

  parameters = <<PARAMETERS
{
  "nsgNamePattern": {
    "value": "*-prs"
  },
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
    "value": 204
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