module "key_vault" {
    source = "./modules/key_vault"

    location                          = var.location
    kv_network_access_name            = "55615ac9-af46-4a59-874e-391cc3dfb490"
    policy_definition_mgmt_group_name = "parent-mgmt-group"
    policy_assignment_mgmt_group_name = "parent-mgmt-group"
    network_acls_default_action       = "Allow"
}