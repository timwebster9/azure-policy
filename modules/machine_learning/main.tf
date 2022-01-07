resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_application_insights" "example" {
  name                = "ml-ai-566456"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_key_vault" "example" {
  name                = "mlkeyvault3453455"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_storage_account" "example" {
  name                     = "mlstorage34566456"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# resource "azurerm_machine_learning_workspace" "example" {
#   name                    = "mlworkspace234235245"
#   location                = azurerm_resource_group.example.location
#   resource_group_name     = azurerm_resource_group.example.name
#   application_insights_id = azurerm_application_insights.example.id
#   key_vault_id            = azurerm_key_vault.example.id
#   storage_account_id      = azurerm_storage_account.example.id
#   public_network_access_enabled = true
  
#   identity {
#     type = "SystemAssigned"
#   }

#   depends_on = [
#     azurerm_management_group_policy_assignment.disable_public_network_access
#   ]
# }

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "mlworkspace234235245"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_management_group_policy_assignment.disable_public_network_access
  ]
}