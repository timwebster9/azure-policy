# SQL Version
resource "azurerm_policy_definition" "tls_version" {
  name                  = "tls_version"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "SQL Servers have minimal TLS version"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "SQL"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/tls_version/rules.json")
  parameters = file("${path.module}/policy_defs/tls_version/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "tls_version" {
  name                 = "tls_version"
  policy_definition_id = azurerm_policy_definition.tls_version.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "tls_version"

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  },
  "tlsVersion": {
    "value": "1.2"
  }
}
PARAMETERS
}