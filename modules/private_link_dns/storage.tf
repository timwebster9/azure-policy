resource "azurerm_storage_account" "example" {
  name                     = "petest908sfdsfd9"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_private_endpoint" "storage_blob_pe" {
  name                = "sa-blob-endpoint"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "storage-blob-pe"
    private_connection_resource_id = azurerm_storage_account.example.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }

  depends_on = [
    azurerm_policy_definition.pl_dns,
    azurerm_management_group_policy_assignment.pl_dns_storage_blob
  ]
}

# resource "azurerm_private_endpoint" "storage_web_pe" {
#   name                = "sa-web-endpoint"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   subnet_id           = azurerm_subnet.example.id

#   private_service_connection {
#     name                           = "storage-web-pe"
#     private_connection_resource_id = azurerm_storage_account.example.id
#     is_manual_connection           = false
#     subresource_names              = ["web"]
#   }

#   lifecycle {
#     ignore_changes = [private_dns_zone_group]
#   }

#   depends_on = [
#     azurerm_policy_definition.pl_dns,
#     azurerm_management_group_policy_assignment.pl_dns_storage_web
#   ]
# }