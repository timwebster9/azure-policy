resource "azurerm_management_group_policy_assignment" "domain_disable_public_network_access" {
  name                 = "domain_disable_network"
  policy_definition_id = data.azurerm_policy_definition.domain_disable_public_network_access.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.domain_disable_public_network_access.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "topic_disable_public_network_access" {
  name                 = "topic_disable_network"
  policy_definition_id = data.azurerm_policy_definition.topic_disable_public_network_access.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.topic_disable_public_network_access.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}