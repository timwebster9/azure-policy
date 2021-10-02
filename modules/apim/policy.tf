# AZ Policy
resource "azurerm_policy_definition" "apim_zones" {
  name                  = "apim_zones"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "API Management should use availability zones"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "API Management"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/apim_zones/rules.json")
  parameters = file("${path.module}/policy_defs/apim_zones/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "apim_zones" {
  name                 = azurerm_policy_definition.apim_zones.name
  policy_definition_id = azurerm_policy_definition.apim_zones.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.apim_zones.display_name

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

# APIM use VNet
resource "azurerm_policy_definition" "apim_vnet" {
  name                  = "apim_vnet"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "API Management should use vnet"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "API Management"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/apim_vnet/rules.json")
  parameters = file("${path.module}/policy_defs/apim_vnet/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "apim_vnet" {
  name                 = azurerm_policy_definition.apim_vnet.name
  policy_definition_id = azurerm_policy_definition.apim_vnet.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.apim_vnet.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

# VNET SKU
resource "azurerm_management_group_policy_assignment" "apim_skus" {
  name                 = "apim-skus"
  policy_definition_id = data.azurerm_policy_definition.apim_skus.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "API Management service should use a SKU that supports virtual networks"

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}