resource "azurerm_firewall_policy_rule_collection_group" "nat_rule_group" {
  name               = "nat-rule-group"
  firewall_policy_id = azurerm_firewall_policy.example.id
  priority           = 1000

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = "104.21.28.74"
      destination_ports   = ["443"]
      translated_address  = "192.168.0.1"
      translated_port     = "443"
    }
  }
}