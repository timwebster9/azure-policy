data "azurerm_management_group" "parent" {
  name = "parent-mgmt-group"
}

data "azurerm_policy_definition" "key_vault_network_access" {
  name = var.kv_network_access
}