resource "azurerm_template_deployment" "policy_exemptions" {
  name                = "tls-exemptions"
  resource_group_name = azurerm_resource_group.example.name
  parameters = {
    "exemption_name"         = "TLS exemption"
    "scopes"                 = azurerm_firewall_policy_rule_collection_group.example.id
    "policy_assignment_id"   = azurerm_management_group_policy_assignment.application_rules_tls.id
    "exemption_category"     = "waiver"
    "exemption_display_name" = "Exempted for testing"
    "exemption_description"  = "Exempted for testing"
    "requested_by"           = "Magnum PI"
    "approved_by"            = "John Higgins"
    "approved_date"          = "01-01-2021"
    "ticket_ref"             = "99"
  }
  template_body = <<DEPLOY
    ${file("${path.module}/exemption.json")}
  DEPLOY
  deployment_mode = "Incremental"
}