data "azurerm_client_config" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

data "azurerm_policy_definition" "sql_deny_public_access" {
  name = "1b8ca024-1d5c-4dec-8995-b1a932b41780"
}

data "azurerm_log_analytics_workspace" "mgmt_workspace" {
  name                = "mgmtstorage3445354"
  resource_group_name = "mgmt-rg"
}