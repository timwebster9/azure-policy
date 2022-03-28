resource "azurerm_policy_definition" "dine_tls_version" {
  name                  = "dine_tls_version"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Configure Functon App to use the specified TLS version"
  management_group_id   = data.azurerm_management_group.policy_definition_mgmt_group.id

  metadata = <<METADATA
    {
    "category": "App Service"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/dine_tls_version/rules.json")
  parameters = file("${path.module}/policy_defs/dine_tls_version/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "dine_tls_version" {
  name                 = "dine_tls_version"
  policy_definition_id = azurerm_policy_definition.dine_tls_version.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.dine_tls_version.display_name
  location             = var.location
  
  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "deployIfNotExists"
  },
  "minTlsVersion": {
    "value": "1.2"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "dine_tls_version" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.dine_tls_version.identity[0].principal_id
}