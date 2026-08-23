# Machine inputs contain only infrastructure references and public SSH material.
variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group."
}

variable "resource_group_location" {
  type        = string
  description = "Azure region in which to create the virtual machines."
}

variable "vm_size" {
  type        = string
  description = "Azure VM size used for the jumpbox and workers."
}

variable "admin_username" {
  type        = string
  description = "Administrator username configured on every VM."
}

variable "admin_ssh_public_key" {
  type        = string
  description = "Existing OpenSSH public key configured on every VM."
}

variable "jumpbox_nic_id" {
  type        = string
  description = "Resource ID of the jumpbox network interface."
}

variable "worker_nic_ids" {
  type        = list(string)
  description = "Resource IDs of private worker network interfaces."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the virtual machines."
}
