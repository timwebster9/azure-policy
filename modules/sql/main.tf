resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "policytestworkspace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_storage_account" "example" {
  name                     = "timwpolicydiags908745"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "timwpolicyeh9874534"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  capacity            = 2
}

resource "azurerm_eventhub" "logs" {
  name                = "logs"
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "logs_rule" {
  name                = "logs-rule"
  namespace_name      = azurerm_eventhub_namespace.example.name
  eventhub_name       = azurerm_eventhub.logs.name
  resource_group_name = azurerm_resource_group.example.name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_eventhub_namespace_authorization_rule" "namespace_rule" {
  name                = "namespace_logs"
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name

  listen = true
  send   = true
  manage = true
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

  # azuread_administrator {
  #   login_username = "AzureAD Admin"
  #   object_id      = "00000000-0000-0000-0000-000000000000"
  # }

  depends_on = [
    azurerm_management_group_policy_assignment.deny_firewall_rules,
    azurerm_management_group_policy_assignment.deny_public_access,
    azurerm_management_group_policy_assignment.tls_version,
    azurerm_management_group_policy_assignment.sql_server_audit
  ]
}

resource "azurerm_mssql_database" "test" {
  name           = "policytestdb"
  server_id      = azurerm_mssql_server.example.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  #read_scale     = true
  sku_name       = "GP_Gen5_2"
  zone_redundant = true

  depends_on = [
    azurerm_management_group_policy_assignment.sql_diagnostics_custom,
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
    name     = "BC_Gen5"
    tier     = "BusinessCritical"
    family   = "Gen5"
    capacity = 4
  }

  per_database_settings {
    min_capacity = 0.25
    max_capacity = 4
  }

  depends_on = [
    azurerm_management_group_policy_assignment.sql_ep_zone_redundant
  ]
}