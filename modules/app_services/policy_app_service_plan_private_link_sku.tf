resource "azurerm_policy_definition" "private_link_sku" {
  name                  = "private_link_sku"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "App Service apps should use a SKU that supports private link (custom)"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "App Service"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/app_service_plan_private_link_sku/rules.json")
  parameters = file("${path.module}/policy_defs/app_service_plan_private_link_sku/parameters.json")
}
resource "azurerm_management_group_policy_assignment" "private_link_sku" {
  name                 = "private_link_sku"
  policy_definition_id = azurerm_policy_definition.private_link_sku.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.private_link_sku.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
