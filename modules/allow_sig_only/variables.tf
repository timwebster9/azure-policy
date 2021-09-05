#####################
# Policy Naming
#####################
variable "sig_only_policy_name" {
    type = string
}

variable "sig_only_display_name" {
    type = string
}

variable "policy_definition_mgmt_group_name" {
    type = string
}

variable "policy_assignment_mgmt_group_name" {
    type = string
}

variable location {
  type = string
}

variable resource_group_name {
  type = string
}

variable vnet_address_space {
  type = string
}

variable host_subnet_cidr {
    type = string
}

variable "vm_size" {
  type = string
}

variable "source_image_publisher" {
  type = string
}

variable "source_image_offer" {
  type = string
}

variable "source_image_sku" {
  type = string
}

variable "source_image_version" {
  type = string
}

variable "allowed_source_image_id" {
  type = string
}