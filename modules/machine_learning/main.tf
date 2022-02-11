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
  name                = "timwmlkv098g90f8g"
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
  account_replication_type = "LRS"
}

# should pass
resource "azurerm_machine_learning_workspace" "examplepass" {
  name                    = "mlworkspace678733567"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_policy_definition.public_network_access,
    azurerm_policy_definition.diagnostics,
    azurerm_management_group_policy_assignment.public_network_access,
    azurerm_management_group_policy_assignment.diagnostics
  ]
}

# should fail
resource "azurerm_machine_learning_workspace" "examplefail" {
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
    azurerm_policy_definition.public_network_access,
    azurerm_policy_definition.diagnostics,
    azurerm_management_group_policy_assignment.public_network_access,
    azurerm_management_group_policy_assignment.diagnostics
  ]
}