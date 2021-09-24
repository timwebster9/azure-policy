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
  policy_definition_id = data.azurerm_policy_definition.public_ip_sku_zones.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.public_ip_sku_zones.display_name

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

resource "azurerm_public_ip" "example" {
  name                = "policy-pip"
  resource_group_name = azurerm_resource_group.policy_rg.name
  location            = azurerm_resource_group.policy_rg.location
  allocation_method   = "Static"

 depends_on = [
    azurerm_management_group_policy_assignment.public_ip_sku_zones
  ]

}