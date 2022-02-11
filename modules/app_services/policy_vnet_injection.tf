resource "azurerm_management_group_policy_assignment" "vnet_injection" {
  name                 = "vnet_injection"
  policy_definition_id = data.azurerm_policy_definition.vnet_injection.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.vnet_injection.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
