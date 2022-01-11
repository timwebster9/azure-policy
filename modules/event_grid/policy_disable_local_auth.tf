resource "azurerm_management_group_policy_assignment" "domain_disable_local_auth" {
  name                 = "domain_disable_auth"
  policy_definition_id = data.azurerm_policy_definition.domain_disable_local_auth.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.domain_disable_local_auth.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Modify"
  }
}
PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "topic_disable_local_auth" {
  name                 = "topic_disable_auth"
  policy_definition_id = data.azurerm_policy_definition.topic_disable_local_auth.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = data.azurerm_policy_definition.topic_disable_local_auth.display_name
  location             = var.location

  identity {
    type = "SystemAssigned"
  }
  
  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Modify"
  }
}
PARAMETERS
}