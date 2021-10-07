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

resource "azurerm_subnet" "prs" {
  name                 = "subnet-prs"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "dat" {
  name                 = "subnet-dat"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "prs" {
  name                = "nsg-prs"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
    azurerm_management_group_policy_assignment.deny_inbound_udp_pres
  ]
}

resource "azurerm_network_security_group" "dat" {
  name                = "nsg-dat"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
    azurerm_management_group_policy_assignment.deny_inbound_udp_pres
  ]
}

resource "azurerm_subnet_network_security_group_association" "prs_assoc" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.prs.id
}

resource "azurerm_subnet_network_security_group_association" "dat_assoc" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.dat.id
}

# Policy Def
resource "azurerm_policy_definition" "default_nsg_rule" {
  name                  = "default_nsg_rule"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Append default NSG rules"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/default_nsg_rule/rules.json")
  parameters = file("${path.module}/policy_defs/default_nsg_rule/parameters.json")
}