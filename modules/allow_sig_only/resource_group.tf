# RG
resource "azurerm_resource_group" "policy" {
  name     = "policy-rg"
  location = var.location
}