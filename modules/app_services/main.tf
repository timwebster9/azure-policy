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
resource "azurerm_service_plan" "example" {
  name                = "newserviceplan098098"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_name            = "P1v2"
  os_type             = "Linux"

  depends_on = [
    azurerm_policy_definition.app_service_plan_diagnostics,
    azurerm_policy_definition.app_service_plan_zone_redundant,
    azurerm_policy_definition.private_link_sku,
    azurerm_management_group_policy_assignment.app_service_plan_diagnostics,
    azurerm_management_group_policy_assignment.app_service_plan_zone_redundant,
    azurerm_management_group_policy_assignment.private_link_sku
  ]
}

resource "azurerm_service_plan" "ep" {
  name                = "ep-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  maximum_elastic_worker_count = 3
  sku_name            = "EP1"
  os_type             = "Linux"

  depends_on = [
    azurerm_policy_definition.app_service_plan_diagnostics,
    azurerm_policy_definition.app_service_plan_zone_redundant,
    azurerm_policy_definition.private_link_sku,
    azurerm_management_group_policy_assignment.app_service_plan_diagnostics,
    azurerm_management_group_policy_assignment.app_service_plan_zone_redundant,
    azurerm_management_group_policy_assignment.private_link_sku
  ]
}

resource "azurerm_service_plan" "eptls11" {
  name                = "ep-plan-tls11"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  maximum_elastic_worker_count = 3
  sku_name            = "EP1"
  os_type             = "Linux"

  depends_on = [
    azurerm_policy_definition.app_service_plan_diagnostics,
    azurerm_policy_definition.app_service_plan_zone_redundant,
    azurerm_policy_definition.private_link_sku,
    azurerm_management_group_policy_assignment.app_service_plan_diagnostics,
    azurerm_management_group_policy_assignment.app_service_plan_zone_redundant,
    azurerm_management_group_policy_assignment.private_link_sku
  ]
}

# should pass
# resource "azurerm_service_plan" "premiumv2" {
#   name                = "v2-plan"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   zone_redundant      = true
#   maximum_elastic_worker_count = 3

#   sku {
#     tier = "PremiumV2"
#     size = "P1v2"
#     capacity = 1
#   }

#   depends_on = [
#     azurerm_policy_definition.app_service_plan_diagnostics,
#     azurerm_policy_definition.app_service_plan_zone_redundant,
#     azurerm_policy_definition.private_link_sku,
#     azurerm_management_group_policy_assignment.app_service_plan_diagnostics,
#     azurerm_management_group_policy_assignment.app_service_plan_zone_redundant,
#     azurerm_management_group_policy_assignment.private_link_sku
#   ]
# }

# should pass
# resource "azurerm_service_plan" "premiumv3" {
#   name                = "v3-plan"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   zone_redundant      = true
#   maximum_elastic_worker_count = 3

#   sku {
#     tier = "PremiumV3"
#     size = "P1v3"
#     capacity = 1
#   }

#   depends_on = [
#     azurerm_policy_definition.app_service_plan_diagnostics,
#     azurerm_policy_definition.app_service_plan_zone_redundant,
#     azurerm_policy_definition.private_link_sku,
#     azurerm_management_group_policy_assignment.app_service_plan_diagnostics,
#     azurerm_management_group_policy_assignment.app_service_plan_zone_redundant,
#     azurerm_management_group_policy_assignment.private_link_sku
#   ]
# }

# should fail
resource "azurerm_service_plan" "basic" {
  name                = "basic-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  maximum_elastic_worker_count = 3
  sku_name            = "B1"
  os_type             = "Linux"

  depends_on = [
    azurerm_policy_definition.app_service_plan_diagnostics,
    azurerm_policy_definition.app_service_plan_zone_redundant,
    azurerm_policy_definition.private_link_sku,
    azurerm_management_group_policy_assignment.app_service_plan_diagnostics,
    azurerm_management_group_policy_assignment.app_service_plan_zone_redundant,
    azurerm_management_group_policy_assignment.private_link_sku
  ]
}

#should fail
resource "azurerm_service_plan" "standard" {
  name                = "standard-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  maximum_elastic_worker_count = 3
  sku_name            = "S1"
  os_type             = "Linux"

  depends_on = [
    azurerm_policy_definition.app_service_plan_diagnostics,
    azurerm_policy_definition.app_service_plan_zone_redundant,
    azurerm_policy_definition.private_link_sku,
    azurerm_management_group_policy_assignment.app_service_plan_diagnostics,
    azurerm_management_group_policy_assignment.app_service_plan_zone_redundant,
    azurerm_management_group_policy_assignment.private_link_sku
  ]
}


# resource "azurerm_function_app" "example" {
#   name                       = "timwpolicyfunction908sfsd"
#   location                   = azurerm_resource_group.example.location
#   resource_group_name        = azurerm_resource_group.example.name
#   app_service_plan_id        = azurerm_service_plan.ep.id
#   storage_account_name       = azurerm_storage_account.function.name
#   storage_account_access_key = azurerm_storage_account.function.primary_access_key
#   https_only                 = true  # policy check
#   version                    = "~3"  # policy check
  
#   site_config {
#     min_tls_version        = "1.2" # policy check
#     vnet_route_all_enabled = true  # policy check
#     elastic_instance_minimum = 3

#     # ip_restriction =  [
#     #   {
#     #     action = "Allow"
#     #     ip_address = "212.159.71.60/32"
#     #     name = "test"
#     #     priority = 100
#     #     headers = null
#     #     service_tag = null
#     #     virtual_network_subnet_id = null
#     #   }
#     # ]
#   }

#   depends_on = [
#     azurerm_policy_definition.app_service_https_only,
#     azurerm_policy_definition.dine_tls_version,
#     azurerm_policy_definition.dine_vnet_route_all,
#     azurerm_policy_definition.function_diagnostics,
#     azurerm_policy_definition.app_service_ip_restrictions,
#     azurerm_management_group_policy_assignment.function_runtime_version,
#     azurerm_management_group_policy_assignment.app_service_https_only,
#     azurerm_management_group_policy_assignment.dine_tls_version,
#     azurerm_management_group_policy_assignment.dine_vnet_route_all,
#     azurerm_management_group_policy_assignment.disable_public_network_access,
#     azurerm_management_group_policy_assignment.function_runtime_version,
#     azurerm_management_group_policy_assignment.function_diagnostics,
#     azurerm_management_group_policy_assignment.app_service_ip_restrictions,
#     azurerm_management_group_policy_assignment.vnet_injection
#   ]
# }

# resource "azurerm_app_service_virtual_network_swift_connection" "example" {
#   app_service_id = azurerm_function_app.example.id
#   subnet_id      = azurerm_subnet.example.id
# }

# resource "azurerm_function_app" "tls_11" {
#   name                       = "timwpolicyfunctionTLS11"
#   location                   = azurerm_resource_group.example.location
#   resource_group_name        = azurerm_resource_group.example.name
#   app_service_plan_id        = azurerm_service_plan.eptls11.id
#   storage_account_name       = azurerm_storage_account.function.name
#   storage_account_access_key = azurerm_storage_account.function.primary_access_key
#   https_only                 = true  # policy check
#   version                    = "~3"  # policy check
  
#   site_config {
#     min_tls_version        = "1.0" # policy check: DINE
#     vnet_route_all_enabled = false  # policy check: DINE
#     elastic_instance_minimum = 3

#     # ip_restriction =  [
#     #   {
#     #     action = "Allow"
#     #     ip_address = "212.159.71.60/32"
#     #     name = "test"
#     #     priority = 100
#     #     headers = null
#     #     service_tag = null
#     #     virtual_network_subnet_id = null
#     #   }
#     # ]
#   }

#   depends_on = [
#     azurerm_policy_definition.app_service_https_only,
#     azurerm_policy_definition.dine_tls_version,
#     azurerm_policy_definition.dine_vnet_route_all,
#     azurerm_policy_definition.function_diagnostics,
#     azurerm_policy_definition.app_service_ip_restrictions,
#     azurerm_management_group_policy_assignment.function_runtime_version,
#     azurerm_management_group_policy_assignment.app_service_https_only,
#     azurerm_management_group_policy_assignment.dine_tls_version,
#     azurerm_management_group_policy_assignment.dine_vnet_route_all,
#     azurerm_management_group_policy_assignment.disable_public_network_access,
#     azurerm_management_group_policy_assignment.function_runtime_version,
#     azurerm_management_group_policy_assignment.function_diagnostics,
#     azurerm_management_group_policy_assignment.app_service_ip_restrictions,
#     azurerm_management_group_policy_assignment.vnet_injection
#   ]
# }