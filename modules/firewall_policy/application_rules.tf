# allowed: HTTPS rule with no TLS inspecetion, but has an exemption created
resource "azurerm_firewall_policy_rule_collection_group" "example" {
  name               = "example-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.example.id
  priority           = 500

  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["*.microsoft.com"]
      terminate_tls     = false
    }
  }

  depends_on = [
    azurerm_policy_definition.application_rules_tls,
    azurerm_management_group_policy_assignment.application_rules_tls
  ]
}

# should be denied: HTTPS rule with no TLS inspection
resource "azurerm_firewall_policy_rule_collection_group" "example2" {
  name               = "example-fwpolicy-rcg2"
  firewall_policy_id = azurerm_firewall_policy.example.id
  priority           = 600

  application_rule_collection {
    name     = "app_rule_collection2"
    priority = 600
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["*.microsoft.com"]
      terminate_tls     = false
    }
  }

  depends_on = [
    azurerm_policy_definition.application_rules_tls,
    azurerm_management_group_policy_assignment.application_rules_tls
  ]
}

# should be allowed as it's HTTP/80
resource "azurerm_firewall_policy_rule_collection_group" "example3" {
  name               = "example-fwpolicy-rcg3"
  firewall_policy_id = azurerm_firewall_policy.example.id
  priority           = 700

  application_rule_collection {
    name     = "app_rule_collection3"
    priority = 700
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["*.microsoft.com"]
      terminate_tls     = false
    }
  }

  depends_on = [
    azurerm_policy_definition.application_rules_tls,
    azurerm_management_group_policy_assignment.application_rules_tls
  ]
}