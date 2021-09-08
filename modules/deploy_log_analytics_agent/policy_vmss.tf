resource "azurerm_policy_definition" "policy_def_vmss" {
  name                  = var.policy_name
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = var.policy_display_name
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Compute"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/linux/vmss/rules.json")
  parameters = file("${path.module}/policy_defs/linux/vmss/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "policy_assignment_vmss" {
  name                 = var.policy_name
  policy_definition_id = azurerm_policy_definition.policy_def_vmss.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = var.policy_display_name
  location             = azurerm_resource_group.policy.location

  identity {
    type = "SystemAssigned"
  }

  metadata = <<METADATA
    {
    "category": "Compute"
    }
METADATA

  parameters = <<PARAMETERS
{
  "workspaceId": {
    "value": "${azurerm_log_analytics_workspace.workspace.id}"
  },
  "effect": {
    "value": "DeployIfNotExists"
  }
}
PARAMETERS
}

resource "azurerm_role_assignment" "role_vmss" {
  scope                = data.azurerm_management_group.policy_assignment_mgmt_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_assignment_vmss.identity[0].principal_id 
}

resource "azurerm_policy_remediation" "rem_vmss" {
  name                 = "linux-vmss-remediation"
  scope                = azurerm_management_group_policy_assignment.policy_assignment_vmss.management_group_id
  policy_assignment_id = azurerm_management_group_policy_assignment.policy_assignment_vmss.id
}
