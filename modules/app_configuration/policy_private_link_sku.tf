resource "azurerm_management_group_policy_assignment" "private_link_sku" {
  name                 = "private_link_sku"
  policy_definition_id = data.azurerm_policy_definition.private_link_sku.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.private_link_sku.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
