# The Load Balancer receives only the worker NIC IDs required for pool membership.
variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group."
}

variable "resource_group_location" {
  type        = string
  description = "Azure region in which to create Load Balancer resources."
}

variable "worker_nic_ids" {
  type        = list(string)
  description = "Resource IDs of worker network interfaces attached to the backend pool."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Load Balancer resources that support them."
}
