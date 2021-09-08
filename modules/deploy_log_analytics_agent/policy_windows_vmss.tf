resource "azurerm_policy_definition" "policy_def_windows_vmss" {
  name                  = "deploy_oms_windows_vmss"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Deploy Log Analytics Agent for Windows VMSS"
  management_group_name = data.azurerm_management_group.policy_definition_mgmt_group.name

  metadata = <<METADATA
    {
    "category": "Compute"
    }

METADATA

  policy_rule = file("${path.module}/policy_defs/windows/vmss/rules.json")
  parameters = file("${path.module}/policy_defs/windows/vmss/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "policy_assignment_windows_vmss" {
  name                 = "deploy_oms_windows_vmss"
  policy_definition_id = azurerm_policy_definition.policy_def_windows_vmss.id
  management_group_id  = data.azurerm_management_group.policy_assignment_mgmt_group.id
  description          = "Policy Assignment test"
  display_name         = "Deploy Log Analytics Agent for Windows VMSS"
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

resource "azurerm_role_assignment" "role_windows_vmss" {
  scope                = data.azurerm_management_group.policy_assignment_mgmt_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_assignment_windows_vmss.identity[0].principal_id 
}

resource "azurerm_policy_remediation" "rem_windows_vmss" {
  name                    = "windows-vm-remediation"
  #resource_discovery_mode = "ReEvaluateCompliance"
  scope                   = azurerm_management_group_policy_assignment.policy_assignment_windows_vmss.management_group_id
  policy_assignment_id    = azurerm_management_group_policy_assignment.policy_assignment_windows_vmss.id
}
