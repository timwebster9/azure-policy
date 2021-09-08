resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "acctest-01"
  location            = azurerm_resource_group.policy.location
  resource_group_name = azurerm_resource_group.policy.name
  sku                 = "Free"
}

resource "azurerm_policy_definition" "policy_def" {
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

  policy_rule = file("./modules/deploy_linux_log_analytics_vmss_agent/policy_defs/rules.json")
  parameters = file("./modules/deploy_linux_log_analytics_vmss_agent/policy_defs/parameters.json")
}

resource "azurerm_management_group_policy_assignment" "policy_assignment" {
  name                 = var.policy_name
  policy_definition_id = azurerm_policy_definition.policy_def.id
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

resource "azurerm_role_assignment" "role" {
  scope                = data.azurerm_management_group.policy_assignment_mgmt_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_assignment.identity[0].principal_id 
}

resource "azurerm_policy_remediation" "rem" {
  name                 = "example-policy-remediation"
  scope                = azurerm_management_group_policy_assignment.policy_assignment.management_group_id
  policy_assignment_id = azurerm_management_group_policy_assignment.policy_assignment.id
}
