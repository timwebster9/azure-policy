# RG
resource "azurerm_resource_group" "policy" {
  name     = var.resource_group_name
  location = var.location
}