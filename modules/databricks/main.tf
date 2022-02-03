resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-databricks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "public" {
  name                 = "${var.prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "${var.prefix}-databricks-del"

    service_delegation {
      actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet" "private" {
  name                 = "${var.prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "${var.prefix}-databricks-del"

    service_delegation {
      actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.prefix}-databricks-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

#should fail - not using SCC
# resource "azurerm_databricks_workspace" "fail_no_scc" {
#   name                        = "DBW-${var.prefix}"
#   resource_group_name         = azurerm_resource_group.example.name
#   location                    = azurerm_resource_group.example.location
#   sku                         = "standard"
#   managed_resource_group_name = "${var.prefix}-DBW-managed-without-lb"

#   public_network_access_enabled = true

#   custom_parameters {
#     no_public_ip        = false
#     public_subnet_name  = azurerm_subnet.public.name
#     private_subnet_name = azurerm_subnet.private.name
#     virtual_network_id  = azurerm_virtual_network.example.id

#     public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
#     private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
#   }

#   depends_on = [
#     azurerm_policy_definition.scc,
#     azurerm_management_group_policy_assignment.scc
#   ]
# }

# should fail - no vnet injection
resource "azurerm_databricks_workspace" "fail_no_vnet_injection" {
  name                        = "failnovnet-${var.prefix}"
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  sku                         = "standard"
  managed_resource_group_name = "${var.prefix}-DBW-managed-without-lb"

  public_network_access_enabled = true

  custom_parameters {
    no_public_ip        = false
    # public_subnet_name  = azurerm_subnet.public.name
    # private_subnet_name = azurerm_subnet.private.name
    # virtual_network_id  = azurerm_virtual_network.example.id

    # public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    # private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  depends_on = [
    #azurerm_policy_definition.scc,
    azurerm_policy_definition.encryption,
    azurerm_policy_definition.vnet_injection,
    azurerm_policy_definition.disable_egress,
    #azurerm_management_group_policy_assignment.scc,
    azurerm_management_group_policy_assignment.vnet_injection,
    azurerm_management_group_policy_assignment.encryption,
    azurerm_management_group_policy_assignment.disable_egress
  ]
}

# should fail - no encryption
resource "azurerm_databricks_workspace" "fail_no_encryption" {
  name                        = "noenc-${var.prefix}"
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  sku                         = "premium"
  managed_resource_group_name = "${var.prefix}-DBW-managed-without-lb"
  infrastructure_encryption_enabled = false

  public_network_access_enabled = true

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = azurerm_subnet.public.name
    private_subnet_name = azurerm_subnet.private.name
    virtual_network_id  = azurerm_virtual_network.example.id

    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  depends_on = [
    #azurerm_policy_definition.scc,
    azurerm_policy_definition.encryption,
    azurerm_policy_definition.vnet_injection,
    azurerm_policy_definition.disable_egress,
    #azurerm_management_group_policy_assignment.scc,
    azurerm_management_group_policy_assignment.vnet_injection,
    azurerm_management_group_policy_assignment.encryption,
    azurerm_management_group_policy_assignment.disable_egress
  ]
}
# should fail - uses NAT gateway
resource "azurerm_databricks_workspace" "fail_uses_natgateway" {
  name                        = "nat-${var.prefix}"
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  sku                         = "premium"
  managed_resource_group_name = "${var.prefix}-DBW-managed-without-lb"
  infrastructure_encryption_enabled = false

  public_network_access_enabled = true

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = azurerm_subnet.public.name
    private_subnet_name = azurerm_subnet.private.name
    virtual_network_id  = azurerm_virtual_network.example.id
    nat_gateway_name    =  "nat-gateway"

    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  depends_on = [
    #azurerm_policy_definition.scc,
    azurerm_policy_definition.encryption,
    azurerm_policy_definition.vnet_injection,
    azurerm_policy_definition.disable_egress,
    #azurerm_management_group_policy_assignment.scc,
    azurerm_management_group_policy_assignment.vnet_injection,
    azurerm_management_group_policy_assignment.encryption,
    azurerm_management_group_policy_assignment.disable_egress
  ]
}

# should pass - uses SCC, vnet injection and encryption
resource "azurerm_databricks_workspace" "pass_scc" {
  name                        = "scc-${var.prefix}"
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  sku                         = "premium"
  managed_resource_group_name = "${var.prefix}-DBW-managed-without-lb"
  infrastructure_encryption_enabled = true

  public_network_access_enabled = true

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = azurerm_subnet.public.name
    private_subnet_name = azurerm_subnet.private.name
    virtual_network_id  = azurerm_virtual_network.example.id

    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  depends_on = [
    #azurerm_policy_definition.scc,
    azurerm_policy_definition.encryption,
    azurerm_policy_definition.vnet_injection,
    azurerm_policy_definition.disable_egress,
    #azurerm_management_group_policy_assignment.scc,
    azurerm_management_group_policy_assignment.vnet_injection,
    azurerm_management_group_policy_assignment.encryption,
    azurerm_management_group_policy_assignment.disable_egress
  ]
}