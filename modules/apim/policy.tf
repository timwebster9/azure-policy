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
    "value": "Audit"
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

# APIM Custom Domain
resource "azurerm_policy_definition" "apim_custom_domain" {
  name                  = "apim_custom_domain"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "API Management should have at least one custom domain of type Proxy which matches *.deggymacets.com"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "API Management"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/apim_custom_domain/rules.json")
  parameters = file("${path.module}/policy_defs/apim_custom_domain/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "apim_custom_domain" {
  name                 = azurerm_policy_definition.apim_custom_domain.name
  policy_definition_id = azurerm_policy_definition.apim_custom_domain.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.apim_custom_domain.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Audit"
  }
}
PARAMETERS
}

# APIM Backends HTTPS
resource "azurerm_policy_definition" "apim_backends_https" {
  name                  = "apim_backends_https"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "API Management backends should use HTTPS"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "API Management"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/apim_backends_https/rules.json")
  parameters = file("${path.module}/policy_defs/apim_backends_https/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "apim_backends_https" {
  name                 = azurerm_policy_definition.apim_backends_https.name
  policy_definition_id = azurerm_policy_definition.apim_backends_https.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.apim_backends_https.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

# APIM custom domain pattern
resource "azurerm_policy_definition" "apim_custom_domain_pattern" {
  name                  = "apim_pattern"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "API Management custom domains must use allowed names"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "API Management"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/apim_custom_domain_pattern/rules.json")
  parameters = file("${path.module}/policy_defs/apim_custom_domain_pattern/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "apim_custom_domain_pattern" {
  name                 = azurerm_policy_definition.apim_custom_domain_pattern.name
  policy_definition_id = azurerm_policy_definition.apim_custom_domain_pattern.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.apim_custom_domain_pattern.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "domain1": {
    "value": "*.deggymacets.com"
  },
  "domain2": {
    "value": "*.kife.com"
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