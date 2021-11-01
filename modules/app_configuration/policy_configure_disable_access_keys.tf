resource "azurerm_management_group_policy_assignment" "disable_access_keys" {
  name                 = "disable_keys"
  policy_definition_id = data.azurerm_policy_definition.configure_disable_access_keys.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.configure_disable_access_keys.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Modify"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "access_keys_contributor" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.disable_access_keys.identity.0.principal_id
}