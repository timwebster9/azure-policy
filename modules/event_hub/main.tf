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

resource "azurerm_resource_group" "policy_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "example-namespace"
  location            = azurerm_resource_group.policy_rg.location
  resource_group_name = azurerm_resource_group.policy_rg.name
  sku                 = "Standard"
  capacity            = 2

  depends_on = [
    azurerm_management_group_policy_assignment.event_hub_deny_public_access
  ]
}