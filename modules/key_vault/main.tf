resource "azurerm_management_group_policy_assignment" "key_vault_network_access" {
  name                 = "kv-network-access"
  policy_definition_id = data.azurerm_policy_definition.key_vault_network_access.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.key_vault_network_access.display_name

  parameters = <<PARAMETERS
{
  "Effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

resource "azurerm_resource_group" "policy_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_key_vault" "test_kv" {
  name                        = "policynetwork4558973445"
  location                    = azurerm_resource_group.policy_rg.location
  resource_group_name         = azurerm_resource_group.policy_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  sku_name = "standard"

  network_acls {
    bypass         = "AzureServices"
    default_action = var.network_acls_default_action
  }

  depends_on = [
    azurerm_management_group_policy_assignment.key_vault_network_access
  ]
}