resource "azurerm_log_analytics_workspace" "example" {
  name                = "policytestworkspace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_resource_group" "secondary_rg" {
  provider                  = azurerm.secondary

  name     = "secondary-sa-rg"
  location = var.location
}

resource "azurerm_storage_account" "secondary_sa" {
  provider                  = azurerm.secondary

  name                      = "timwsecdiags2535"
  resource_group_name       = azurerm_resource_group.secondary_rg.name
  location                  = azurerm_resource_group.secondary_rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  network_rules {
    default_action = "Deny"
    bypass = [ "AzureServices" ]
  }
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