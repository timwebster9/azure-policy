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

# should pass (has AAD Admin)
resource "azurerm_mssql_server" "aad_admin" {
  name                         = "timwaadadmin"
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

  azuread_administrator {
    login_username = azuread_group.example.display_name
    object_id      = azuread_group.example.object_id
  }

  depends_on = [
    azurerm_management_group_policy_assignment.deny_firewall_rules,
    azurerm_management_group_policy_assignment.deny_public_access,
    azurerm_management_group_policy_assignment.tls_version,
    azurerm_management_group_policy_assignment.sql_server_audit,
    azurerm_management_group_policy_assignment.aad_admin_audit,
    azurerm_management_group_policy_assignment.sql_identity,
    azurerm_policy_definition.aad_admin,
    azurerm_management_group_policy_assignment.aad_admin,
    azurerm_policy_definition.sql_server_audit,
    azurerm_role_assignment.sql_server_audit_contrib,
    azurerm_role_assignment.sql_server_audit_uaa,
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions
  ]
}

#should fail
resource "azurerm_mssql_server" "no_aad_admin" {
  name                         = "timwtestnoaadadmin"
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
    azurerm_management_group_policy_assignment.sql_identity,
    azurerm_policy_definition.aad_admin,
    azurerm_management_group_policy_assignment.aad_admin,
    azurerm_policy_definition.sql_server_audit,
    azurerm_role_assignment.sql_server_audit_contrib,
    azurerm_role_assignment.sql_server_audit_uaa,
    azurerm_policy_definition.whitelist_regions,
    azurerm_management_group_policy_assignment.whitelist_regions
  ]
}

#AZ not available with Standard DTU
# resource "azurerm_mssql_database" "dtu_zr_not_eligible" {
#   name           = "dtu-no-zr-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   #license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "S0"
#   zone_redundant = false

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_policy_definition.sql_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# should fail - AZ available with Premium
# resource "azurerm_mssql_elasticpool" "premium" {
#   name                = "premium-epool"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   server_name         = azurerm_mssql_server.example.name
#   license_type        = "LicenseIncluded"
#   max_size_gb         = 50
#   zone_redundant      = false

#   sku {
#     name     = "PremiumPool"
#     tier     = "Premium"
#     #family   = "Gen5"
#     capacity = 125
#   }

#   per_database_settings {
#     min_capacity = 25
#     max_capacity = 25
#   }

#   depends_on = [
#     azurerm_policy_definition.sql_ep_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_ep_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_ep_diagnostics_custom
#   ]
# }

# should pass - AZ not available with BASIC
# resource "azurerm_mssql_elasticpool" "basic" {
#   name                = "basic-epool"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   server_name         = azurerm_mssql_server.example.name
#   license_type        = "LicenseIncluded"
#   max_size_gb         = 4.8828125
#   zone_redundant      = false

#   sku {
#     name     = "BasicPool"
#     tier     = "basic"
#     #family   = "Gen5"
#     capacity = 50
#   }

#   per_database_settings {
#     min_capacity = 5
#     max_capacity = 5
#   }

#   depends_on = [
#     azurerm_policy_definition.sql_ep_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_ep_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_ep_diagnostics_custom
#   ]
# }

# should pass - AZ not available with STANDARD
# resource "azurerm_mssql_elasticpool" "standard" {
#   name                = "std-epool"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   server_name         = azurerm_mssql_server.example.name
#   license_type        = "LicenseIncluded"
#   max_size_gb         = 500
#   zone_redundant      = false

#   sku {
#     name     = "StandardPool"
#     tier     = "Standard"
#     #family   = "Gen5"
#     capacity = 50
#   }

#   per_database_settings {
#     min_capacity = 10
#     max_capacity = 10
#   }

#   depends_on = [
#     azurerm_policy_definition.sql_ep_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_ep_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_ep_diagnostics_custom
#   ]
# }

# should FAIL - AZ available with GP
# resource "azurerm_mssql_elasticpool" "gp" {
#   name                = "gp-epool"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   server_name         = azurerm_mssql_server.example.name
#   license_type        = "LicenseIncluded"
#   max_size_gb         = 756
#   zone_redundant      = false

#   sku {
#     name     = "GP_Gen5"
#     tier     = "GeneralPurpose"
#     family   = "Gen5"
#     capacity = 4
#   }

#   per_database_settings {
#     min_capacity = 0.25
#     max_capacity = 4
#   }

#   depends_on = [
#     azurerm_policy_definition.sql_ep_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_ep_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_ep_diagnostics_custom
#   ]
# }

# resource "azurerm_role_assignment" "sql_msi_storage" {
#   scope                = azurerm_storage_account.example.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azurerm_mssql_server.example.identity.0.principal_id
# }

# should pass
# resource "azurerm_mssql_database" "dtu_zr_eligible" {
#   name           = "dtu-zr-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   #license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "P1"
#   zone_redundant = true

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# # should fail
# resource "azurerm_mssql_database" "dtu_zr_eligible_fail" {
#   name           = "dtu-zr-fail-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   #license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "P1"
#   zone_redundant = false

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_policy_definition.sql_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# # # should fail
# resource "azurerm_mssql_database" "vcore_zr_eligible_fail" {
#   name           = "vcore-zr-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "GP_Gen5_2"
#   zone_redundant = false

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_policy_definition.sql_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# # should fail
# resource "azurerm_mssql_database" "vcore_zr_bc_eligible" {
#   name           = "vcore-bc-zr-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "BC_Gen5_2"
#   zone_redundant = false

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_policy_definition.sql_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# # should fail
# resource "azurerm_mssql_database" "vcore_zr_hs_eligible_fail" {
#   name           = "vcore-hs-zr-fail-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "HS_Gen5_2"
#   zone_redundant = false

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_policy_definition.sql_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# Basic not supported
# resource "azurerm_mssql_database" "vcore_basic" {
#   name           = "vcore-basic-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "Basic"
#   zone_redundant = false

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_policy_definition.sql_zone_redundant,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# # should pass
# resource "azurerm_mssql_database" "vcore_zr_gp_eligible" {
#   name           = "vcore-gp-zr-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "GP_Gen5_2"
#   zone_redundant = true

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# # should pass
# resource "azurerm_mssql_database" "vcore_zr_hs_eligible" {
#   name           = "vcore-hs-zr-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "HS_Gen5_2"
#   zone_redundant = false

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

# # should fail
# resource "azurerm_mssql_database" "vcore_zr_bc_eligible_fail" {
#   name           = "vcore-bc-zr-fail-db"
#   server_id      = azurerm_mssql_server.example.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   license_type   = "LicenseIncluded"
#   #max_size_gb    = 4
#   #read_scale     = true
#   sku_name       = "BC_Gen5_2"
#   zone_redundant = false

#   depends_on = [
#     azurerm_management_group_policy_assignment.sql_db_diagnostics_custom,
#     azurerm_management_group_policy_assignment.sql_zone_redundant
#   ]
# }

