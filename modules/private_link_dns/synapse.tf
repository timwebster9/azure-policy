resource "azurerm_storage_account" "synapse_sa" {
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
  storage_account_id = azurerm_storage_account.synapse_sa.id
}

# should pass
resource "azurerm_synapse_workspace" "example" {
  name                                 = "synapse89798gdfg"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "897safdD£09sdfs*"
  
  managed_virtual_network_enabled      = true  # enforced by policy
  public_network_access_enabled        = false # enforced by policy
  data_exfiltration_protection_enabled = true  # enforced by policy
}

resource "azurerm_synapse_private_link_hub" "example" {
  name                = "synapsepehub"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_endpoint" "synapse_web" {
  name                = "synapse-web-endpoint"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "synapse-web-pe"
    private_connection_resource_id = azurerm_synapse_private_link_hub.example.id
    is_manual_connection           = false
    subresource_names              = ["web"]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }

  depends_on = [
    azurerm_policy_definition.pl_dns,
    azurerm_management_group_policy_assignment.pl_dns_synapse_web
  ]
}
