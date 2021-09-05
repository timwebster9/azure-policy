sig_only_policy_name  = "allow-sig-only"
sig_only_display_name = "Only allow VMs to be deployed from Shared Image Gallery images"

############
# General 
############
location = "uksouth"

############
# Network 
############
vnet_address_space  = "10.0.0.0/16"
host_subnet_cidr    = "10.0.0.64/26"

############
# VM
############
vm_size = "Standard_D4s_v3"

source_image_publisher = "Canonical"
source_image_offer     = "UbuntuServer"
source_image_sku       = "18.04-LTS"
source_image_version   = "latest"
