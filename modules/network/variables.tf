# The network module owns topology and security boundaries, not VM configuration.
variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group."
}

variable "resource_group_location" {
  type        = string
  description = "Azure region in which to create network resources."
}

variable "worker_count" {
  type        = number
  description = "Number of private worker network interfaces to create."
}

variable "admin_cidr" {
  type        = string
  description = "IPv4 CIDR allowed to connect to the jumpbox over SSH."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to network resources that support them."
}
