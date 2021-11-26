resource "azurerm_policy_definition" "deny_nat_rules" {
  name                  = "deny_nat_rules"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Firewall NAT rules are not allowed"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/deny_nat_rules/rules.json")
  parameters = file("${path.module}/policy_defs/deny_nat_rules/parameters.json")
}
resource "azurerm_management_group_policy_assignment" "deny_nat_rules" {
  name                 = "deny_nat_rules"
  policy_definition_id = azurerm_policy_definition.deny_nat_rules.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.deny_nat_rules.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}