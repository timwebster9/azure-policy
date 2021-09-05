resource "azurerm_policy_definition" "allow_sig_only" {
  name         = var.sig_only_policy_name
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = var.sig_only_display_name

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
  "listOfAllowedSKUs": {
    "value": [ "Standard_B2s" ]
  }
}
PARAMETERS
}
