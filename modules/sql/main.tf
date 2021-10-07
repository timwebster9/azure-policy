resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_mssql_server" "example" {
  name                         = "mssqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"
  public_network_access_enabled = false

  # azuread_administrator {
  #   login_username = "AzureAD Admin"
  #   object_id      = "00000000-0000-0000-0000-000000000000"
  # }

  depends_on = [
    azurerm_management_group_policy_assignment.deny_firewall_rules,
    azurerm_management_group_policy_assignment.deny_public_access,
    azurerm_management_group_policy_assignment.tls_version
  ]
}