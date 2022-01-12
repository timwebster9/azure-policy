data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

# Azure Synapse workspaces should disable public network access
data "azurerm_policy_definition" "disable_public_network_acceess" {
  name = "38d8df46-cf4e-4073-8e03-48c24b29de0d"
}
