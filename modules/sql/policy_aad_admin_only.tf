/**
 * Terraform azurerm provider > 2.82 required
 */
 
# resource "azurerm_management_group_policy_assignment" "aad_admin_only" {
#   name                 = "aad_admin_only"
#   policy_definition_id = data.azurerm_policy_definition.aad_admin_only.id
#   management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
#   description          = "Policy Assignment test"
#   display_name         = data.azurerm_policy_definition.aad_admin_only.display_name

#   parameters = <<PARAMETERS
# {
#   "effect": {
#     "value": "Deny"
#   }
# }
# PARAMETERS
# }