resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "sdafsdafds7f89d"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  public_network_access_enabled = false

  #enable_automatic_failover = true

  # consistency_policy {
  #   consistency_level       = "BoundedStaleness"
  #   max_interval_in_seconds = 10
  #   max_staleness_prefix    = 200
  # }

  # geo_location {
  #   location          = azurerm_resource_group.example.location
  #   failover_priority = 0
  # }

  depends_on = [
    azurerm_management_group_policy_assignment.disable_public_network_access,
    #azurerm_policy_definition.disallow_ip_filters,
    #azurerm_management_group_policy_assignment.disallow_ip_filters
  ]
}

resource "azurerm_cosmosdb_sql_database" "example" {
  name                = "cosmos-db"
  resource_group_name = azurerm_resource_group.example.name
  account_name        = azurerm_cosmosdb_account.db.name
  throughput          = 400
}
