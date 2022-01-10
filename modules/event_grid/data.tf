data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

# Azure Event Grid domains should disable public network access
data "azurerm_policy_definition" "domain_disable_public_network_access" {
  name = "f8f774be-6aee-492a-9e29-486ef81f3a68"
}

# Azure Event Grid topics should disable public network access
data "azurerm_policy_definition" "topic_disable_public_network_access" {
  name = "1adadefe-5f21-44f7-b931-a59b54ccdb45"
}
