resource "azurerm_policy_definition" "app_service_ip_restrictions" {
  name                  = "ip_restrictions"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "IP restrictions for App Services are not allowed"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "App Service"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/app_service_ip_restrictions/rules.json")
  parameters = file("${path.module}/policy_defs/app_service_ip_restrictions/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "app_service_ip_restrictions" {
  name                 = "ip_restrictions"
  policy_definition_id = azurerm_policy_definition.app_service_ip_restrictions.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.app_service_ip_restrictions.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}