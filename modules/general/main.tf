resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_data_factory" "example" {
  name                = "example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions,
  ]
  
}

data "azurerm_storage_account" "example" {
  name                = "adfsa09890809"
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions,
  ]

}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "example" {
  name                = "adfsalinkedservice"
  resource_group_name = azurerm_resource_group.example.name
  data_factory_id     = azurerm_data_factory.example.id
  connection_string   = data.azurerm_storage_account.example.primary_connection_string

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