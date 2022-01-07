data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

# Azure Machine Learning workspaces should disable public network access
data "azurerm_policy_definition" "disable_public_network_access" {
  name = "438c38d2-3772-465a-a9cc-7a6666a275ce"
}

