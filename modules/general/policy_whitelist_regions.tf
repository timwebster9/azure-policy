resource "azurerm_policy_definition" "whitelist_regions" {
  name                  = "whitelist_regions"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Whitelist allowed regions (custom)"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/whitelist_regions/rules.json")
  parameters = file("${path.module}/policy_defs/whitelist_regions/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "whitelist_regions" {
  name                 = "whitelist_regions"
  policy_definition_id = azurerm_policy_definition.whitelist_regions.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.whitelist_regions.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "listOfRegionsAllowed": {
    "value": ["OK South"]
  }
}
PARAMETERS
}