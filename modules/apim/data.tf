data "azurerm_client_config" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

# use SKU that supports virtual networks
data "azurerm_policy_definition" "apim_skus" {
  name = "73ef9241-5d81-4cd4-b483-8443d1730fe5"
}
