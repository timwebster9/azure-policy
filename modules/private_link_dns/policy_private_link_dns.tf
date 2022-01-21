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

# Storage BLOB
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
  "resourceType": {
    "value": "Microsoft.Storage/storageAccounts"
  },
  "privateDnsZoneId": {
    "value": "${azurerm_private_dns_zone.dns_storage_blob.id}"
  },
  "privateDnsZoneGroupIds": {
    "value": ["blob", "blob_secondary"]
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "pl_dns_storage_blob" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.pl_dns_storage_blob.identity[0].principal_id
}


# Storage WEB
resource "azurerm_management_group_policy_assignment" "pl_dns_storage_web" {
  name                 = "pl_dns_storage_web"
  policy_definition_id = azurerm_policy_definition.pl_dns.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Deploy Private Link A Record: Static Web Site"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "DeployIfNotExists"
  },
  "resourceType": {
    "value": "Microsoft.Storage/storageAccounts"
  },
  "privateDnsZoneId": {
    "value": "${azurerm_private_dns_zone.dns_storage_web.id}"
  },
  "privateDnsZoneGroupIds": {
    "value": ["web"]
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "pl_dns_storage_web" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.pl_dns_storage_web.identity[0].principal_id
}

# Synapse WEB
resource "azurerm_management_group_policy_assignment" "pl_dns_synapse_web" {
  name                 = "pl_dns_synapse_web"
  policy_definition_id = azurerm_policy_definition.pl_dns.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Deploy Private Link A Record: Synapse Private Link Hubs"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "DeployIfNotExists"
  },
  "resourceType": {
    "value": "Microsoft.Synapse/privateLinkHubs"
  },
  "privateDnsZoneId": {
    "value": "${azurerm_private_dns_zone.dns_synapse_web.id}"
  },
  "privateDnsZoneGroupIds": {
    "value": ["web"]
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "pl_dns_synapse_web" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.pl_dns_synapse_web.identity[0].principal_id
}

# Synapse SQL
resource "azurerm_management_group_policy_assignment" "pl_dns_synapse_sql" {
  name                 = "pl_dns_synapse_sql"
  policy_definition_id = azurerm_policy_definition.pl_dns.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Deploy Private Link A Record: Synapse SQL"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "DeployIfNotExists"
  },
  "resourceType": {
    "value": "Microsoft.Synapse/workspaces"
  },
  "privateDnsZoneId": {
    "value": "${azurerm_private_dns_zone.dns_synapse_sql.id}"
  },
  "privateDnsZoneGroupIds": {
    "value": ["sql"]
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "pl_dns_synapse_sql" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.pl_dns_synapse_sql.identity[0].principal_id
}

# Cosmos SQL
resource "azurerm_management_group_policy_assignment" "pl_dns_cosmos_sql" {
  name                 = "pl_dns_cosmos_sql"
  policy_definition_id = azurerm_policy_definition.pl_dns.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Deploy Private Link A Record: Cosmos SQL"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "DeployIfNotExists"
  },
  "resourceType": {
    "value": "Microsoft.DocumentDB/databaseAccounts"
  },
  "privateDnsZoneId": {
    "value": "${azurerm_private_dns_zone.dns_cosmos_sql.id}"
  },
  "privateDnsZoneGroupIds": {
    "value": ["sql"]
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "pl_dns_cosmos_sql" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.pl_dns_cosmos_sql.identity[0].principal_id
}