# AZ Policy
resource "azurerm_policy_definition" "appgateway_zones" {
  name                  = "appgateway-zones"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Application Gateway should use availability zones"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/zone_redundant/rules.json")
  parameters = file("${path.module}/policy_defs/zone_redundant/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "appgateway_zones" {
  name                 = azurerm_policy_definition.appgateway_zones.name
  policy_definition_id = azurerm_policy_definition.appgateway_zones.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.appgateway_zones.display_name

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

# Front end port policy
resource "azurerm_policy_definition" "appgateway_frontend_ports" {
  name                  = "appgateway-ports"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Application Gateway front end ports should only use port 443"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/frontend_ports/rules.json")
  parameters = file("${path.module}/policy_defs/frontend_ports/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "appgateway_frontend_ports" {
  name                 = azurerm_policy_definition.appgateway_frontend_ports.name
  policy_definition_id = azurerm_policy_definition.appgateway_frontend_ports.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.appgateway_frontend_ports.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

# HTTPS-only listeners
resource "azurerm_policy_definition" "appgateway_listener_https_only" {
  name                  = "appgateway-listener"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Application Gateway listeners should use HTTPS only"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/listener_https_only/rules.json")
  parameters = file("${path.module}/policy_defs/listener_https_only/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "appgateway_listener_https_only" {
  name                 = azurerm_policy_definition.appgateway_listener_https_only.name
  policy_definition_id = azurerm_policy_definition.appgateway_listener_https_only.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.appgateway_listener_https_only.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}