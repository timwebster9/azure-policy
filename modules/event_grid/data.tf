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

# Configure Azure Event Grid domains to disable local authentication
data "azurerm_policy_definition" "domain_disable_local_auth" {
  name = "8ac2748f-3bf1-4c02-a3b6-92ae68cf75b1"
}

# Configure Azure Event Grid topics to disable local authentication
data "azurerm_policy_definition" "topic_disable_local_auth" {
  name = "1c8144d9-746a-4501-b08c-093c8d29ad04"
}
