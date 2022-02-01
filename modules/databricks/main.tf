resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_databricks_workspace" "example" {
  name                = "timwtest987908908"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"
  public_network_access_enabled         = false
  network_security_group_rules_required = "NoAzureServiceRules"

  custom_parameters {
    no_public_ip = true
  }

}