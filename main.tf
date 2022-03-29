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
# module "linux_vmss_log_agent" {
#     source = "./modules/deploy_log_analytics_agent"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

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
# Public IP policy
########################################

# module "public_ip_policy" {
#     source = "./modules/public_ip_sku"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "event_hubs" {
#     source = "./modules/event_hub"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "app_gateway" {
#     source = "./modules/app_gateway"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "apim" {
#     source = "./modules/apim"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

module "nsg" {
    source = "./modules/nsg"

    location                          = var.location
    resource_group_name               = "policy-rg"

    policy_definition_mgmt_group_name = "parent-mgmt-group"
    policy_assignment_mgmt_group_name = "parent-mgmt-group"
}

# module "sql" {
#     source = "./modules/sql"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "app_services" {
#     source = "./modules/app_services"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "app_config" {
#     source = "./modules/app_configuration"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "cosmos_db" {
#     source = "./modules/cosmos_db"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "firewall_policy" {
#     source = "./modules/firewall_policy"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "routes" {
#     source = "./modules/routes"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "authorization" {
#     source = "./modules/authorization"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "application_insights" {
#     source = "./modules/application_insights"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "machine_learning" {
#     source = "./modules/machine_learning"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "event_grid" {
#     source = "./modules/event_grid"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "logic_apps" {
#     source = "./modules/logic_apps"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "synapse" {
#     source = "./modules/synapse"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "general" {
#     source = "./modules/general"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "private_link_dns" {
#     source = "./modules/private_link_dns"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "databricks" {
#     source = "./modules/databricks"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }

# module "data_factory" {
#     source = "./modules/data_factory"

#     location                          = var.location
#     resource_group_name               = "policy-rg"

#     policy_definition_mgmt_group_name = "parent-mgmt-group"
#     policy_assignment_mgmt_group_name = "parent-mgmt-group"
# }