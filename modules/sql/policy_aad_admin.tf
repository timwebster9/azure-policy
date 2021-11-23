/**
 * Terraform azurerm provider > 2.82 required
 */
 
resource "azurerm_policy_definition" "aad_admin" {
  name                  = "aad_admin"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "SQL Servers should have an Azure Active Directory administrator"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/aad_admin/rules.json")
  parameters = file("${path.module}/policy_defs/aad_admin/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "aad_admin" {
  name                 = "aad_admin"
  policy_definition_id = azurerm_policy_definition.aad_admin.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = azurerm_policy_definition.aad_admin.display_name

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}