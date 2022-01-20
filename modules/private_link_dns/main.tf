resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_private_dns_zone" "dns_storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone" "dns_storage_web" {
  name                = "privatelink.web.core.windows.net"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_network" "example" {
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

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

resource "azurerm_private_endpoint" "storage_web_pe" {
  name                = "sa-web-endpoint"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "storage-web-pe"
    private_connection_resource_id = azurerm_storage_account.example.id
    is_manual_connection           = false
    subresource_names              = ["web"]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }

  depends_on = [
    azurerm_policy_definition.pl_dns,
    azurerm_management_group_policy_assignment.pl_dns_storage_web
  ]
}
