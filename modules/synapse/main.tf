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

# should pass
resource "azurerm_synapse_workspace" "examplepass" {
  name                                 = "synapse89798gdfg"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "897safdD£09sdfs*"
  
  managed_virtual_network_enabled      = true  # enforced by policy
  public_network_access_enabled        = false # enforced by policy
  data_exfiltration_protection_enabled = true  # enforced by policy

  # aad_admin {
  #   login     = "AzureAD Admin"
  #   object_id = "00000000-0000-0000-0000-000000000000"
  #   tenant_id = "00000000-0000-0000-0000-000000000000"
  # }

  depends_on = [
    azurerm_policy_definition.synapse_diagnostics,
    azurerm_management_group_policy_assignment.synapse_diagnostics,
    azurerm_management_group_policy_assignment.synapse_managed_vnet,
    azurerm_management_group_policy_assignment.synapse_disable_public_network_access,
    azurerm_management_group_policy_assignment.data_exfiltration
  ]
}

resource "azurerm_synapse_sql_pool" "example" {
  name                 = "sqlpool"
  synapse_workspace_id = azurerm_synapse_workspace.examplepass.id
  sku_name             = "DW100c"
  create_mode          = "Default"

  depends_on = [
    azurerm_policy_definition.sqlpool_diagnostics,
    azurerm_management_group_policy_assignment.sqlpool_diagnostics
  ]
}

resource "azurerm_synapse_spark_pool" "example" {
  name                 = "sparkpool"
  synapse_workspace_id = azurerm_synapse_workspace.examplepass.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"
  cache_size           = 100

  auto_scale {
    max_node_count = 3
    min_node_count = 3
  }

  auto_pause {
    delay_in_minutes = 15
  }

  depends_on = [
    azurerm_policy_definition.sparkpool_diagnostics,
    azurerm_management_group_policy_assignment.sparkpool_diagnostics
  ]

}

# Policy Voilations - should all fail

# should fail -  no managed vnet
resource "azurerm_synapse_workspace" "example_no_managed_vnet" {
  name                                 = "example"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "897safdD£09sdfs*"
  
  managed_virtual_network_enabled      = false  # fail
  public_network_access_enabled        = false  # not available without managed vnet
  data_exfiltration_protection_enabled = true

  depends_on = [
    azurerm_management_group_policy_assignment.synapse_managed_vnet,
    azurerm_management_group_policy_assignment.synapse_disable_public_network_access,
    azurerm_management_group_policy_assignment.data_exfiltration
  ]
}

# should fail - public network access enabled
resource "azurerm_synapse_workspace" "example_public_network_enabled" {
  name                                 = "synapsepublicnetwork345325"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "897safdD£09sdfs*"
  
  managed_virtual_network_enabled      = true
  public_network_access_enabled        = true # fail
  data_exfiltration_protection_enabled = true

  depends_on = [
    azurerm_management_group_policy_assignment.synapse_managed_vnet,
    azurerm_management_group_policy_assignment.synapse_disable_public_network_access,
    azurerm_management_group_policy_assignment.data_exfiltration
  ]
}

# should fail - data exfiltration protection not enabled
resource "azurerm_synapse_workspace" "example_data_exfiltration_disabled" {
  name                                 = "synapsenodataexfil345325"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "897safdD£09sdfs*"
  
  managed_virtual_network_enabled      = true
  public_network_access_enabled        = false
  data_exfiltration_protection_enabled = false # fail

  depends_on = [
    azurerm_management_group_policy_assignment.synapse_managed_vnet,
    azurerm_management_group_policy_assignment.synapse_disable_public_network_access,
    azurerm_management_group_policy_assignment.data_exfiltration
  ]
}