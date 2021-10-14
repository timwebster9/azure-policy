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

resource "azurerm_virtual_network" "example" {
  name                = "example-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "example-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_app_service_plan" "example" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  zone_redundant      = true

  sku {
    tier = "PremiumV2"
    size = "P1v2"
  }

  depends_on = [
    azurerm_policy_definition.app_service_plan_diagnostics,
    azurerm_policy_definition.app_service_plan_zone_redundant,
    azurerm_management_group_policy_assignment.app_service_plan_diagnostics,
    azurerm_management_group_policy_assignment.app_service_plan_zone_redundant
  ]
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

    ip_restriction =  [
      {
        action = "Allow"
        ip_address = "212.159.71.60/32"
        name = "test"
        priority = 100
        headers = null
        service_tag = null
        virtual_network_subnet_id = null
      }
    ]
  }

  depends_on = [
    azurerm_policy_definition.app_service_https_only,
    azurerm_policy_definition.app_service_tls_version,
    azurerm_policy_definition.app_service_vnet_route_all,
    azurerm_policy_definition.function_diagnostics,
    azurerm_policy_definition.app_service_ip_restrictions,
    azurerm_management_group_policy_assignment.function_runtime_version,
    azurerm_management_group_policy_assignment.app_service_https_only,
    azurerm_management_group_policy_assignment.app_service_tls_version,
    azurerm_management_group_policy_assignment.app_service_vnet_route_all,
    azurerm_management_group_policy_assignment.disable_public_network_access,
    azurerm_management_group_policy_assignment.function_runtime_version,
    azurerm_management_group_policy_assignment.function_diagnostics,
    azurerm_management_group_policy_assignment.app_service_ip_restrictions
  ]
}

resource "azurerm_app_service_virtual_network_swift_connection" "example" {
  app_service_id = azurerm_function_app.example.id
  subnet_id      = azurerm_subnet.example.id
}