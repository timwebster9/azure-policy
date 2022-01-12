resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = "synapsesa3457345894"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "example"
  storage_account_id = azurerm_storage_account.example.id
}

resource "azurerm_synapse_workspace" "examplepass" {
  name                                 = "synapse89798gdfg"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "897safdD£09sdfs*"
  
  public_network_access_enabled        = false  # fail
  managed_virtual_network_enabled      = true
  linking_allowed_for_aad_tenant_ids   = false
  
  # aad_admin {
  #   login     = "AzureAD Admin"
  #   object_id = "00000000-0000-0000-0000-000000000000"
  #   tenant_id = "00000000-0000-0000-0000-000000000000"
  # }

  depends_on = [
    azurerm_management_group_policy_assignment.synapse_disable_public_network_access
  ]
}

# should fail
resource "azurerm_synapse_workspace" "examplefail" {
  name                                 = "example"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "897safdD£09sdfs*"
  
  public_network_access_enabled = true  # fail

  # aad_admin {
  #   login     = "AzureAD Admin"
  #   object_id = "00000000-0000-0000-0000-000000000000"
  #   tenant_id = "00000000-0000-0000-0000-000000000000"
  # }

  depends_on = [
    azurerm_management_group_policy_assignment.synapse_disable_public_network_access
  ]
}