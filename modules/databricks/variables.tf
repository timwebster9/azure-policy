variable "location" {
    type = string
}

variable resource_group_name {
  type = string
}

variable "policy_definition_mgmt_group_name" {
    type = string
}

variable "policy_assignment_mgmt_group_name" {
    type = string
}


# from TF example: https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/databricks/secure-connectivity-cluster/without-load-balancer
variable "prefix" {
  description = "The Prefix used for all resources in this example"
  default = "timw"
}