# # Cosmos

# resource "azurerm_private_endpoint" "cosmos_sql" {
#   name                = "cosmos-sql-endpoint"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   subnet_id           = azurerm_subnet.example.id

#   private_service_connection {
#     name                           = "cosmos-sql-pe"
#     private_connection_resource_id = azurerm_cosmosdb_account.example.id
#     is_manual_connection           = false
#     subresource_names              = ["sql"]
#   }

#   lifecycle {
#     ignore_changes = [private_dns_zone_group]
#   }

#   depends_on = [
#     azurerm_policy_definition.pl_dns,
#     azurerm_management_group_policy_assignment.pl_dns_cosmos_sql
#   ]
# }

# # Storage

# resource "azurerm_private_endpoint" "storage_blob_pe" {
#   name                = "sa-blob-endpoint"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   subnet_id           = azurerm_subnet.example.id

#   private_service_connection {
#     name                           = "storage-blob-pe"
#     private_connection_resource_id = azurerm_storage_account.example.id
#     is_manual_connection           = false
#     subresource_names              = ["blob"]
#   }

#   lifecycle {
#     ignore_changes = [private_dns_zone_group]
#   }

#   depends_on = [
#     azurerm_policy_definition.pl_dns,
#     azurerm_management_group_policy_assignment.pl_dns_storage_blob
#   ]
# }

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

# resource "azurerm_private_endpoint" "storage_blob_pe_grs_primary" {
#   name                = "sa-blob-grs-endpoint1"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   subnet_id           = azurerm_subnet.example.id

#   private_service_connection {
#     name                           = "storage-blob-grs-pe-1"
#     private_connection_resource_id = azurerm_storage_account.example_grs.id
#     is_manual_connection           = false
#     subresource_names              = ["blob"]
#   }

#   lifecycle {
#     ignore_changes = [private_dns_zone_group]
#   }

#   depends_on = [
#     azurerm_policy_definition.pl_dns,
#     azurerm_management_group_policy_assignment.pl_dns_storage_blob
#   ]
# }

# resource "azurerm_private_endpoint" "storage_blob_pe_grs_secondary" {
#   name                = "sa-blob-grs-endpoint2"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   subnet_id           = azurerm_subnet.example.id

#   private_service_connection {
#     name                           = "storage-blob-grs-pe-2"
#     private_connection_resource_id = azurerm_storage_account.example_grs.id
#     is_manual_connection           = false
#     subresource_names              = ["blob_secondary"]
#   }

#   lifecycle {
#     ignore_changes = [private_dns_zone_group]
#   }

#   depends_on = [
#     azurerm_policy_definition.pl_dns,
#     azurerm_management_group_policy_assignment.pl_dns_storage_blob
#   ]
# }

# # Synapse

# resource "azurerm_private_endpoint" "synapse_web" {
#   name                = "synapse-web-endpoint"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   subnet_id           = azurerm_subnet.example.id

#   private_service_connection {
#     name                           = "synapse-web-pe"
#     private_connection_resource_id = azurerm_synapse_private_link_hub.example.id
#     is_manual_connection           = false
#     subresource_names              = ["web"]
#   }

#   lifecycle {
#     ignore_changes = [private_dns_zone_group]
#   }

#   depends_on = [
#     azurerm_policy_definition.pl_dns,
#     azurerm_management_group_policy_assignment.pl_dns_synapse_web
#   ]
# }

# resource "azurerm_private_endpoint" "synapse_sql" {
#   name                = "synapse-sql-endpoint"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   subnet_id           = azurerm_subnet.example.id

#   private_service_connection {
#     name                           = "synapse-sql-pe"
#     private_connection_resource_id = azurerm_synapse_workspace.example.id
#     is_manual_connection           = false
#     subresource_names              = ["sql"]
#   }

#   lifecycle {
#     ignore_changes = [private_dns_zone_group]
#   }

#   depends_on = [
#     azurerm_policy_definition.pl_dns,
#     azurerm_management_group_policy_assignment.pl_dns_synapse_sql
#   ]
# }
