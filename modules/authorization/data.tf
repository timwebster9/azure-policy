data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

# [Preview]: All Internet traffic should be routed via your deployed Azure Firewall
data "azurerm_policy_definition" "route_firewall" {
  name = "fc5e4038-4584-4632-8c85-c0448d374b2c"
}

