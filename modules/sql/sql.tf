resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azuread_group" "example" {
  display_name     = "SQLAdmins"
  security_enabled = true

  members = [
    data.azuread_user.me.object_id
  ]
}

resource "azurerm_mssql_server" "example" {
  name                         = "timw9078safsaf"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"
  public_network_access_enabled = true # testing diagnostics only

  identity {
    type = "SystemAssigned"
  }

  # azuread_administrator {
  #   login_username = azuread_group.example.display_name
  #   object_id      = azuread_group.example.object_id
  # }

  depends_on = [
    azurerm_management_group_policy_assignment.deny_firewall_rules,
    azurerm_management_group_policy_assignment.deny_public_access,
    azurerm_management_group_policy_assignment.tls_version,
    azurerm_management_group_policy_assignment.sql_server_audit,
    azurerm_management_group_policy_assignment.aad_admin_audit,
    azurerm_management_group_policy_assignment.sql_identity
  ]
}

resource "azurerm_role_assignment" "sql_msi_storage" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mssql_server.example.identity.0.principal_id
}

resource "azurerm_mssql_database" "test" {
  name           = "policytestdb"
  server_id      = azurerm_mssql_server.example.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  #max_size_gb    = 4
  #read_scale     = true
  sku_name       = "S0"
  zone_redundant = false

  depends_on = [
    azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
    azurerm_management_group_policy_assignment.sql_zone_redundant
  ]

  # extended_auditing_policy {
  #   storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
  #   storage_account_access_key              = azurerm_storage_account.example.primary_access_key
  #   storage_account_access_key_is_secondary = true
  #   retention_in_days                       = 6
  # }

}

resource "azurerm_mssql_elasticpool" "example" {
  name                = "test-epool"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  server_name         = azurerm_mssql_server.example.name
  license_type        = "LicenseIncluded"
  max_size_gb         = 756
  zone_redundant      = false

  sku {
    name     = "GP_Gen5"
    tier     = "GeneralPurpose"
    family   = "Gen5"
    capacity = 4
  }

  per_database_settings {
    min_capacity = 0.25
    max_capacity = 4
  }

  depends_on = [
    azurerm_management_group_policy_assignment.sql_ep_zone_redundant,
    azurerm_management_group_policy_assignment.sql_ep_diagnostics_custom
  ]
}