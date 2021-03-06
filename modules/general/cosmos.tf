# resource "azurerm_cosmosdb_account" "example" {
#   name                = "adfcosmos987sf89s7978"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   offer_type          = "Standard"
#   kind                = "GlobalDocumentDB"

#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 300
#     max_staleness_prefix    = 100000
#   }
  
#   geo_location {
#     location          = azurerm_resource_group.example.location
#     failover_priority = 0
#   }
# }

# resource "azurerm_cosmosdb_sql_database" "example" {
#   name                = "bar"
#   resource_group_name = azurerm_resource_group.example.name
#   account_name        = azurerm_cosmosdb_account.example.name
#   throughput          = 400
# }

# resource "azurerm_data_factory_linked_service_cosmosdb" "example" {
#   name                = "example"
#   resource_group_name = azurerm_resource_group.example.name
#   data_factory_id     = azurerm_data_factory.example.id
#   account_endpoint    = azurerm_cosmosdb_account.example.endpoint
#   account_key         = azurerm_cosmosdb_account.example.primary_key
#   database            = "bar"

#   depends_on = [
#     azurerm_policy_definition.whitelist_regions,
#     azurerm_management_group_policy_assignment.whitelist_regions,
#   ]

# }

# resource "azurerm_data_factory_dataset_cosmosdb_sqlapi" "example" {
#   name                = "example"
#   resource_group_name = azurerm_resource_group.example.name
#   data_factory_id     = azurerm_data_factory.example.id
#   linked_service_name = azurerm_data_factory_linked_service_cosmosdb.example.name

#   collection_name = "bar"

#   depends_on = [
#     azurerm_policy_definition.whitelist_regions,
#     azurerm_management_group_policy_assignment.whitelist_regions,
#   ]

# }