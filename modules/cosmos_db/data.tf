data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

data "azurerm_policy_definition" "disable_public_network_access" {
  name = "797b37f7-06b8-444c-b1ad-fc62867f335a"
}
