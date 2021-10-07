resource "azurerm_management_group_policy_assignment" "deny_inbound_udp_pres" {
  name                 = "deny_inbound_udp_pres"
  policy_definition_id = azurerm_policy_definition.default_nsg_rule.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "deny_inbound_udp_pres"

  parameters = <<PARAMETERS
{
  "name": {
    "value": "deny-inbound-pres-tcp"
  },
  "protocol": {
    "value": "UDP"
  },
  "access": {
    "value": "Deny"
  },
  "priority": {
    "value": "205"
  },
  "direction": {
    "value": "Inbound"
  },
  "sourcePortRanges": {
    "value": ["*"]
  },
  "destinationPortRanges": {
    "value": ["*"]
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