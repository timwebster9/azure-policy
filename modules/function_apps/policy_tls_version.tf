resource "azurerm_policy_definition" "app_service_tls_version" {
  name                  = "https_only"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Functon App should use the specified TLS version"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "App Service"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/app_service_https_only/rules.json")
  parameters = file("${path.module}/policy_defs/app_service_https_only/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "app_service_tls_version" {
  name                 = "app_service_tls_version"
  policy_definition_id = azurerm_policy_definition.app_service_tls_version.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.app_service_tls_version.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}