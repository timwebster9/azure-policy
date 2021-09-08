#####################
# Key Vault Policies
#####################
# module "key_vault" {
#     source = "./modules/key_vault"

#     location                          = var.location
#     resource_group_name               = "kv-policy-rg"

#     kv_network_access_name            = "55615ac9-af46-4a59-874e-391cc3dfb490" # built-in policy 'name'
#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"

#     network_acls_default_action       = "Allow"  # will fail, "Deny" will pass
# }

#####################
# VM image policies
#####################
# module "allow_sig_only" {
#     source = "./modules/allow_sig_only"

#     location                          = var.location
#     resource_group_name               = "image-policy-rg"

#     policy_name              = "allow-sig-only"
#     policy_display_name             = "Only allow VMs to be deployed from Shared Image Gallery images"
#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"

#     vnet_address_space      = "10.0.0.0/16"
#     host_subnet_cidr        = "10.0.0.64/26"

#     vm_size                 = "Standard_D2s_v3"
#     source_image_publisher  = "Canonical"
#     source_image_offer      = "UbuntuServer"
#     source_image_sku        = "18.04-LTS"
#     source_image_version    = "latest"
#     allowed_source_image_id = "/subscriptions/2ca65474-3b7b-40f2-b242-0d2fba4bde6e/resourceGroups/mgmt-rg/providers/Microsoft.Compute/galleries/policytestsig/images/ubuntu-20.04-LTS/versions/0.0.1"
# }

########################################
# Linux VM Log Analytics Agent policy
########################################
module "linux_vmss_log_agent" {
    source = "./modules/deploy_linux_log_analytics_vmss_agent"

    location                          = var.location
    resource_group_name               = "policy-rg"

    policy_name                       = "deploy_oms_vmss"
    policy_display_name               = "Deploy Log Analytics Agent for VMSS"
    policy_definition_mgmt_group_name = "parent-mgmt-group"
    policy_assignment_mgmt_group_name = "parent-mgmt-group"

    vnet_address_space      = "10.0.0.0/16"
    host_subnet_cidr        = "10.0.0.64/26"

    vm_size                 = "Standard_D2s_v3"
    source_image_publisher  = "Canonical"
    source_image_offer      = "UbuntuServer"
    source_image_sku        = "18.04-LTS"
    source_image_version    = "latest"
    allowed_source_image_id = "/subscriptions/2ca65474-3b7b-40f2-b242-0d2fba4bde6e/resourceGroups/mgmt-rg/providers/Microsoft.Compute/galleries/policytestsig/images/ubuntu-20.04-LTS/versions/0.0.1"
}
