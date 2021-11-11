resource "azurerm_policy_definition" "application_rules_tls" {
  name                  = "application_rules_tls"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Firewall application rules should have TLS inspection enabled"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/application_rules_tls/rules.json")
  parameters = file("${path.module}/policy_defs/application_rules_tls/parameters.json")
}
resource "azurerm_management_group_policy_assignment" "application_rules_tls" {
  name                 = "application_rules_tls"
  policy_definition_id = azurerm_policy_definition.application_rules_tls.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.application_rules_tls.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}