### Deny public network access
resource "azurerm_policy_definition" "event_hub_deny_public_access" {
  name                  = "eh-network-access"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Event Hubs public access should be disallowed"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Event Hub"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/eventhub_deny_public_network_access/rules.json")
  parameters = file("${path.module}/policy_defs/eventhub_deny_public_network_access/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "event_hub_deny_public_access" {
  name                 = "eh-network-access"
  policy_definition_id = azurerm_policy_definition.event_hub_deny_public_access.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Event Hubs public access should be disallowed"

  metadata = <<METADATA
    {
    "category": "Event Hub"
    }
METADATA

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

# Must be zone-redundant
resource "azurerm_policy_definition" "event_hub_zone_redundant" {
  name                  = "eh-zone-redundant"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Event Hubs should be zone-redundant"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Event Hub"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/eventhub_zone_redundant/rules.json")
  parameters = file("${path.module}/policy_defs/eventhub_zone_redundant/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "event_hub_zone_redundant" {
  name                 = "eh-zone-redundant"
  policy_definition_id = azurerm_policy_definition.event_hub_zone_redundant.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Event Hubs should be zone-redundant"

  metadata = <<METADATA
    {
    "category": "Event Hub"
    }
METADATA

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

resource "azurerm_resource_group" "policy_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "timwpolicyehnamespace"
  location            = azurerm_resource_group.policy_rg.location
  resource_group_name = azurerm_resource_group.policy_rg.name
  sku                 = "Standard"
  capacity            = 2
  zone_redundant      = true

  network_rulesets {
      default_action = "Deny"

    #   ip_rule {
    #       ip_mask = "212.159.71.60"
    #       action = "Allow"
    #   }
  }

  depends_on = [
    azurerm_management_group_policy_assignment.event_hub_deny_public_access,
    azurerm_management_group_policy_assignment.event_hub_zone_redundant
  ]
}