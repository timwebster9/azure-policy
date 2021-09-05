module "key_vault" {
    source = "./modules/key_vault"

    location                          = var.location
    kv_network_access_name            = "55615ac9-af46-4a59-874e-391cc3dfb490"
    policy_definition_mgmt_group_name = "parent-mgmt-group"
    policy_assignment_mgmt_group_name = "parent-mgmt-group"
    network_acls_default_action       = "Allow"  # will fail, "Deny" will pass
}

# #####################
# # Policy Naming
# #####################
# sig_only_policy_name  = "allow-sig-only"
# sig_only_display_name = "Only allow VMs to be deployed from Shared Image Gallery images"

# kv_network_access_name         = "55615ac9-af46-4a59-874e-391cc3dfb490"

# ############
# # Network 
# ############
# vnet_address_space  = "10.0.0.0/16"
# host_subnet_cidr    = "10.0.0.64/26"

# ############
# # VM
# ############
# vm_size = "Standard_D4s_v3"

# source_image_publisher = "Canonical"
# source_image_offer     = "UbuntuServer"
# source_image_sku       = "18.04-LTS"
# source_image_version   = "latest"
# allowed_source_image_id = "/subscriptions/2ca65474-3b7b-40f2-b242-0d2fba4bde6e/resourceGroups/mgmt-rg/providers/Microsoft.Compute/galleries/policytestsig/images/ubuntu-20.04-LTS/versions/0.0.1"