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

  depends_on = [
    azurerm_policy_definition.subnet_naming_convention,
    azurerm_management_group_policy_assignment.subnet_naming_convention
  ]
}

resource "azurerm_subnet" "dat" {
  name                 = "subnet-dat"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [
    azurerm_policy_definition.subnet_naming_convention,
    azurerm_management_group_policy_assignment.subnet_naming_convention
  ]
}

resource "azurerm_subnet" "app" {
  name                 = "subnet-app"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.3.0/24"]

  depends_on = [
    azurerm_policy_definition.subnet_naming_convention,
    azurerm_management_group_policy_assignment.subnet_naming_convention
  ]
}

# should fail - doesn't meet naming convention
resource "azurerm_subnet" "fail" {
  name                 = "subnet-fail"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.4.0/24"]

  depends_on = [
    azurerm_policy_definition.subnet_naming_convention,
    azurerm_management_group_policy_assignment.subnet_naming_convention
  ]
}

resource "azurerm_network_security_group" "prs" {
  name                = "nsg-prs"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [
    azurerm_policy_definition.nsg_naming_convention,
    azurerm_policy_definition.deny_nsg_priority,
    azurerm_management_group_policy_assignment.deny_nsg_priority,
    azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
    azurerm_management_group_policy_assignment.deny_inbound_udp_pres,
    azurerm_management_group_policy_assignment.nsg_naming_convention
  ]
}

# resource "azurerm_network_security_rule" "fail_rule_priority" {
#   name                        = "fail-rule-priority"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.example.name
#   network_security_group_name = azurerm_network_security_group.prs.name

#   depends_on = [
#     azurerm_policy_definition.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
#     azurerm_management_group_policy_assignment.deny_inbound_udp_pres,
#     azurerm_policy_definition.nsg_naming_convention,
#     azurerm_management_group_policy_assignment.nsg_naming_convention
#   ]
# }

resource "azurerm_network_security_group" "dat" {
  name                = "nsg-dat"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "fail100priority"
    priority                   = 100  # this will cause it to fail because it is < 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.0/24"
  }

  depends_on = [
    azurerm_policy_definition.deny_nsg_priority,
    azurerm_management_group_policy_assignment.deny_nsg_priority,
    azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
    azurerm_management_group_policy_assignment.deny_inbound_udp_pres,
    azurerm_policy_definition.nsg_naming_convention,
    azurerm_management_group_policy_assignment.nsg_naming_convention
  ]
}

# fail
resource "azurerm_network_security_rule" "fail_low_priority" {
  name                        = "faillowpriority"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.dat.name
}

# resource "azurerm_network_security_group" "app" {
#   name                = "nsg-app"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   depends_on = [
#     azurerm_policy_definition.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
#     azurerm_management_group_policy_assignment.deny_inbound_udp_pres,
#     azurerm_policy_definition.nsg_naming_convention,
#     azurerm_management_group_policy_assignment.nsg_naming_convention
#   ]
# }

# should fail - contains a rule with '*' in destination ports
# resource "azurerm_network_security_rule" "fail_rule" {
#   name                        = "fail-rule"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.example.name
#   network_security_group_name = azurerm_network_security_group.app.name

#   depends_on = [
#     azurerm_policy_definition.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
#     azurerm_management_group_policy_assignment.deny_inbound_udp_pres,
#     azurerm_policy_definition.nsg_naming_convention,
#     azurerm_management_group_policy_assignment.nsg_naming_convention
#   ]
# }

# should fail - contains a rule with '*' in destination ports
# resource "azurerm_network_security_group" "test_app" {
#   name                = "nsg-test-app"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   security_rule {
#     name                       = "test123"
#     priority                   = 100
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   depends_on = [
#     azurerm_policy_definition.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
#     azurerm_management_group_policy_assignment.deny_inbound_udp_pres,
#     azurerm_policy_definition.nsg_naming_convention,
#     azurerm_management_group_policy_assignment.nsg_naming_convention
#   ]
# }

# should fail - doesn't follow naming convention
# resource "azurerm_network_security_group" "fail" {
#   name                = "nsgfail"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   depends_on = [
#     azurerm_policy_definition.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_nsg_priority,
#     azurerm_management_group_policy_assignment.deny_inbound_tcp_pres,
#     azurerm_management_group_policy_assignment.deny_inbound_udp_pres,
#     azurerm_policy_definition.nsg_naming_convention,
#     azurerm_management_group_policy_assignment.nsg_naming_convention
#   ]
# }

resource "azurerm_subnet_network_security_group_association" "prs_assoc" {
  subnet_id                 = azurerm_subnet.prs.id
  network_security_group_id = azurerm_network_security_group.prs.id
}

# resource "azurerm_subnet_network_security_group_association" "dat_assoc" {
#   subnet_id                 = azurerm_subnet.dat.id
#   network_security_group_id = azurerm_network_security_group.dat.id
# }
