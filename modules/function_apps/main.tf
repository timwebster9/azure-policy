resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "function" {
  name                     = "timwpolicysa9087sadfs"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "timwpolicyfunction908sfsd"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key
  https_only                 = true  # policy check
  version                    = "~3"  # policy check
  
  site_config {
    min_tls_version        = "1.2" # policy check
    vnet_route_all_enabled = true  # policy check
  }

  depends_on = [
    azurerm_policy_definition.app_service_https_only,
    azurerm_policy_definition.app_service_tls_version,
    azurerm_policy_definition.app_service_vnet_route_all,
    azurerm_policy_definition.function_diagnostics,
    azurerm_management_group_policy_assignment.function_runtime_version,
    azurerm_management_group_policy_assignment.app_service_https_only,
    azurerm_management_group_policy_assignment.app_service_tls_version,
    azurerm_management_group_policy_assignment.app_service_vnet_route_all,
    azurerm_management_group_policy_assignment.disable_public_network_access,
    azurerm_management_group_policy_assignment.function_runtime_version,
    azurerm_management_group_policy_assignment.function_diagnostics
  ]
}