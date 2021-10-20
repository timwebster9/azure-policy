data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

data "azurerm_policy_definition" "disable_public_network_access" {
  name = "81dff7c0-4020-4b58-955d-c076a2136b56"
}

data "azurerm_policy_definition" "vnet_injection" {
  name = "72d04c29-f87d-4575-9731-419ff16a2757"
}

data "azurerm_policy_definition" "private_link_sku" {
  name = "546fe8d2-368d-4029-a418-6af48a7f61e5"
}

