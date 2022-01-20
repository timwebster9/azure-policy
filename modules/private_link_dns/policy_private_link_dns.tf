resource "azurerm_policy_definition" "pl_dns" {
  name                  = "pl_dns"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Deploy Private Link A Record"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Network"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/generic/rules.json")
  parameters = file("${path.module}/policy_defs/generic/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "pl_dns_storage_blob" {
  name                 = "pl_dns_storage_blob"
  policy_definition_id = azurerm_policy_definition.pl_dns.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Deploy Private Link A Record: Blob Storage"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "DeployIfNotExists"
  },
  "privateDnsZoneId": {
    "value": "${azurerm_private_dns_zone.dns_storage_blob.id}"
  },
  "privateDnsZoneGroupId": {
    "value": "blob"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "pl_dns_storage_blob" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.pl_dns_storage_blob.identity[0].principal_id
}