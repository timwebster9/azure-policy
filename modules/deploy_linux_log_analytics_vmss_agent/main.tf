resource "azurerm_policy_definition" "policy_def" {
  name                  = var.policy_name
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = var.policy_display_name
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Compute"
    }

METADATA

  policy_rule = file("./modules/deploy_linux_log_analytics_vmss_agent/policy_defs/rules.json")
  parameters = file("./modules/deploy_linux_log_analytics_vmss_agent/policy_defs/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "policy_assignment" {
  name                 = var.policy_name
  policy_definition_id = azurerm_policy_definition.policy_def.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = var.policy_display_name

  metadata = <<METADATA
    {
    "category": "Compute"
    }
METADATA

  parameters = <<PARAMETERS
{
  "sharedImageGalleryID": {
    "value": "/subscriptions/2ca65474-3b7b-40f2-b242-0d2fba4bde6e/resourceGroups/mgmt-rg/providers/Microsoft.Compute/galleries/policytestsig/*"
  },
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

