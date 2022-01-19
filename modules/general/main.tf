resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_data_factory" "example" {
  name                = "adf987897979"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions,
  ]

}

resource "azurerm_storage_account" "example" {
  name                     = "adfsa098908908"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions,
  ]
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "example" {
  name                = "adfsalinkedservice"
  resource_group_name = azurerm_resource_group.example.name
  data_factory_id     = azurerm_data_factory.example.id
  connection_string   = azurerm_storage_account.example.primary_connection_string

  depends_on = [
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions,
  ]

}

resource "azurerm_data_factory_dataset_azure_blob" "example" {
  name                = "adfblobdataset"
  resource_group_name = azurerm_resource_group.example.name
  data_factory_id     = azurerm_data_factory.example.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.example.name

  path     = "foo"
  filename = "bar.png"

  depends_on = [
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions,
  ]

}

resource "azurerm_cosmosdb_account" "example" {
  name                = "adfcosmos987sf89s7978"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
}

resource "azurerm_data_factory_linked_service_cosmosdb" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  data_factory_id     = azurerm_data_factory.example.id
  account_endpoint    = azurerm_cosmosdb_account.example.endpoint
  account_key         = data.azurerm_cosmosdb_account.example.primary_access_key
  database            = "bar"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  
  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  depends_on = [
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions,
  ]

}

resource "azurerm_data_factory_dataset_cosmosdb_sqlapi" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  data_factory_id     = azurerm_data_factory.example.id
  linked_service_name = azurerm_data_factory_linked_service_cosmosdb.example.name

  collection_name = "bar"

  depends_on = [
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions,
  ]

}