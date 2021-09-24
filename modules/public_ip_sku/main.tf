resource "azurerm_policy_definition" "public_ip_sku_zones" {
  name                  = "public-ip-sku-zones"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Public IP Addresses must be Standard SKU and use availability zones"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/rules.json")
  parameters = file("${path.module}/policy_defs/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "public_ip_sku_zones" {
  name                 = "public-ip-sku-zones"
  policy_definition_id = azurerm_policy_definition.public_ip_sku_zones.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.public_ip_sku_zones.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "locations": {
    "value": ["uksouth"]
  },
  "numZones": {
    "value": 3
  }
}
PARAMETERS
}

resource "azurerm_resource_group" "policy_rg" {
  name     = var.resource_group_name
  location = var.location
}

# should pass - standard SKU and zone-redundant
resource "azurerm_public_ip" "standard_sku_az" {
  name                = "policy-pip-standard-3AZ"
  resource_group_name = azurerm_resource_group.policy_rg.name
  location            = "uksouth"        # triggers zone-redundant check
  allocation_method   = "Static"
  sku                 = "Standard"       # PASS
  availability_zone   = "Zone-Redundant" # PASS

 depends_on = [
    azurerm_management_group_policy_assignment.public_ip_sku_zones
  ]
}

# should pass - standard SKU and UK West doesn't support AZ
resource "azurerm_public_ip" "ukwest_nozone" {
  name                = "policy-pip-ukwest-nozone"
  resource_group_name = azurerm_resource_group.policy_rg.name
  location            = "ukwest"   # exempt from zone-redundant check
  allocation_method   = "Static"
  sku                 = "Standard" # PASS
  availability_zone   = "No-Zone"  # PASS - ukwest doesn't support AZ

 depends_on = [
    azurerm_management_group_policy_assignment.public_ip_sku_zones
  ]
}

# should fail - UK south but doesn't use AZ
resource "azurerm_public_ip" "standard_sku_nozone" {
  name                = "policy-pip-standard-nozone"
  resource_group_name = azurerm_resource_group.policy_rg.name
  location            = "uksouth"  # triggers zone-redundant check
  allocation_method   = "Static"
  sku                 = "Standard" # PASS
  availability_zone   = "No-Zone"  # FAIL!!!

 depends_on = [
    azurerm_management_group_policy_assignment.public_ip_sku_zones
  ]
}

# should fail - UK south but only uses 1 AZ
resource "azurerm_public_ip" "standard_sku_zone1" {
  name                = "policy-pip-standard-zone1"
  resource_group_name = azurerm_resource_group.policy_rg.name
  location            = "uksouth"  # triggers zone-redundant check
  allocation_method   = "Static"
  sku                 = "Standard" # PASS
  availability_zone   = "1"        # FAIL!!!

 depends_on = [
    azurerm_management_group_policy_assignment.public_ip_sku_zones
  ]
}

# should fail - UK South and Basic SKU not allowed
resource "azurerm_public_ip" "basic_sku" {
  name                = "policy-pip-basic-sku"
  resource_group_name = azurerm_resource_group.policy_rg.name
  location            = azurerm_resource_group.policy_rg.location
  allocation_method   = "Static"
  sku                 = "Basic" # FAIL!!!

 depends_on = [
    azurerm_management_group_policy_assignment.public_ip_sku_zones
  ]
}

# should fail - UK West and Basic SKU not allowed
resource "azurerm_public_ip" "basic_sku" {
  name                = "policy-pip-basic-sku"
  resource_group_name = azurerm_resource_group.policy_rg.name
  location            = "ukwest"
  allocation_method   = "Static"
  sku                 = "Basic" # FAIL!!!

 depends_on = [
    azurerm_management_group_policy_assignment.public_ip_sku_zones
  ]
}