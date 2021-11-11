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

  depends_on = [
    azurerm_policy_definition.enforce_routes,
    azurerm_management_group_policy_assignment.enforce_routes,
    azurerm_management_group_policy_assignment.route_firewall
  ]
}

# should pass
resource "azurerm_route_table" "bgp_enabled" {
  name                          = "bgp-enabled"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "vnetlocal"
  }

  depends_on = [
    azurerm_policy_definition.enforce_bgp_disabled,
    azurerm_management_group_policy_assignment.enforce_bgp_disabled
  ]
}

# should fail
resource "azurerm_route_table" "bgp_disabled" {
  name                          = "bgp-disabled"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  disable_bgp_route_propagation = true

  route {
    name           = "route1"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "vnetlocal"
  }

  depends_on = [
    azurerm_policy_definition.enforce_bgp_disabled,
    azurerm_management_group_policy_assignment.enforce_bgp_disabled
  ]

}