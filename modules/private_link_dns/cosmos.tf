resource "azurerm_cosmosdb_account" "db" {
  name                = "sdafsdafds7f89d"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  public_network_access_enabled = false

  #enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = azurerm_resource_group.example.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "example" {
  name                = "cosmos-db"
  resource_group_name = azurerm_resource_group.example.name
  account_name        = azurerm_cosmosdb_account.db.name
  throughput          = 400
}

resource "azurerm_private_endpoint" "cosmos_sql" {
  name                = "cosmos-sql-endpoint"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "cosmos-sql-pe"
    private_connection_resource_id = azurerm_cosmosdb_account.example.id
    is_manual_connection           = false
    subresource_names              = ["sql"]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }

  depends_on = [
    azurerm_policy_definition.pl_dns,
    azurerm_management_group_policy_assignment.pl_dns_cosmos_sql
  ]
}