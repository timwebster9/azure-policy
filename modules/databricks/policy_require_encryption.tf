resource "azurerm_policy_definition" "encryption" {
  name                  = "encryption"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Azure Dataabricks Workspaces should have infrastructure encryption enabled"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Databricks"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/require_encryption/rules.json")
  parameters = file("${path.module}/policy_defs/require_encryption/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "encryption" {
  name                 = "encryption"
  policy_definition_id = azurerm_policy_definition.encryption.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.encryption.display_name
  location             = var.location

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
