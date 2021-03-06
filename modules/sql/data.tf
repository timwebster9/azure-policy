data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "policy_definition_mgmt_group" {
  name = var.policy_definition_mgmt_group_name 
}

data "azurerm_management_group" "policy_assignment_mgmt_group" {
  name = var.policy_assignment_mgmt_group_name
}

data "azurerm_policy_definition" "sql_deny_public_access" {
  name = "1b8ca024-1d5c-4dec-8995-b1a932b41780"
}

data "azurerm_policy_definition" "sql_diagnostics_eventhub" {
  name = "9a7c7a7d-49e5-4213-bea8-6a502b6272e0"
}

data "azurerm_policy_definition" "aad_admin_audit" {
  name = "1f314764-cb73-4fc9-b863-8eca98ac36e9"
}

data "azurerm_policy_definition" "aad_admin_only" {
  name = "abda6d70-9778-44e7-84a8-06713e6db027"
}

data "azuread_user" "me" {
  user_principal_name = "admin@timwebster9outlookcom.onmicrosoft.com"
}

data "azurerm_storage_account" "secondary" {
  provider = azurerm.secondary
  name                = "tfstatetimw"
  resource_group_name = "mgmt-rg"
}
