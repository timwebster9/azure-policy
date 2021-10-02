resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_api_management" "example" {
  name                = "twpolicyapim8979uaaf"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = "asdfasfsda"
  publisher_email     = "joe@blow.com"
  #zones               = ["1","2","3"]

  sku_name = "Developer_1"

  virtual_network_type = "Internal"

  virtual_network_configuration {
    subnet_id = azurerm_subnet.example.id
  }

  depends_on = [
    azurerm_management_group_policy_assignment.apim_zones,
    azurerm_management_group_policy_assignment.apim_vnet,
    azurerm_management_group_policy_assignment.apim_skus
  ]
}