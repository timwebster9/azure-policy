resource "azurerm_private_dns_zone" "dns_storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone" "dns_storage_web" {
  name                = "privatelink.web.core.windows.net"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone" "dns_synapse_web" {
  name                = "privatelink.azuresynapse.net"
  resource_group_name = azurerm_resource_group.example.name
}
resource "azurerm_private_dns_zone" "dns_cosmos_sql" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone" "dns_synapse_sql" {
  name                = "privatelink.sql.azuresynapse.net"
  resource_group_name = azurerm_resource_group.example.name
}