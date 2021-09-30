data "azurerm_client_config" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

data "azurerm_policy_definition" "appgateway_waf" {
  name = "564feb30-bf6a-4854-b4bb-0d2d2d1e6c66"
}
