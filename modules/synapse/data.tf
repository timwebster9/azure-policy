data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

# Managed workspace virtual network on Azure Synapse workspaces should be enabled
data "azurerm_policy_definition" "synapse_managed_vnet" {
  name = "2d9dbfa3-927b-4cf0-9d0f-08747f971650"
}

# Azure Synapse workspaces should disable public network access
data "azurerm_policy_definition" "disable_public_network_acceess" {
  name = "38d8df46-cf4e-4073-8e03-48c24b29de0d"
}

# Azure Synapse workspaces should allow outbound data traffic only to approved targets
data "azurerm_policy_definition" "data_exfiltration" {
  name = "3484ce98-c0c5-4c83-994b-c5ac24785218"
}
