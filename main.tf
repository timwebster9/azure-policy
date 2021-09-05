resource "azurerm_policy_definition" "allow_sig_only" {
  name                  = var.sig_only_policy_name
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = var.sig_only_display_name
  management_group_name = data.azurerm_management_group.parent.name

  metadata = <<METADATA
    {
    "category": "Compute"
    }

METADATA

  policy_rule = file("policy_defs/compute/allow_sig_only/rules.json")
  parameters = file("policy_defs/compute/allow_sig_only/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "allow_sig_only" {
  name                 = var.sig_only_policy_name
  policy_definition_id = azurerm_policy_definition.allow_sig_only.id
  management_group_id  = data.azurerm_management_group.parent.id
  description          = "Policy Assignment test"
  display_name         = var.sig_only_display_name

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

resource "azurerm_management_group_policy_assignment" "key_vault_network_access" {
  name                 = var.kv_network_access
  policy_definition_id = data.azurerm_policy_definition.key_vault_network_access.id
  management_group_id  = data.azurerm_management_group.parent.id
  description          = "Policy Assignment test"
  display_name         = var.sig_only_display_name

  parameters = <<PARAMETERS
{
  "Effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
