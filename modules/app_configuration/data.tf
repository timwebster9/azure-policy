data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

data "azurerm_policy_definition" "disable_public_network_access" {
  name = "73290fa2-dfa7-4bbb-945d-a5e23b75df2c"
}

data "azurerm_policy_definition" "configure_disable_access_keys" {
  name = "72bc14af-4ab8-43af-b4e4-38e7983f9a1f"
}