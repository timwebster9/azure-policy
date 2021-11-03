/*
resource "azurerm_policy_definition" "disallow_ip_filters" {
  name                  = "disallow_ip"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Azure Cosmos DB accounts should not have firewall rules"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Cosmos DB"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/disallow_ip_filters/rules.json")
  parameters = file("${path.module}/policy_defs/disallow_ip_filters/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "disallow_ip_filters" {
  name                 = azurerm_policy_definition.disallow_ip_filters.name
  policy_definition_id = azurerm_policy_definition.disallow_ip_filters.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.disallow_ip_filters.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
*/