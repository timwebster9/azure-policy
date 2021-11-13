resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azuread_application" "example" {
  display_name = "example"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "example" {
  application_id               = azuread_application.example.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.example.object_id
}