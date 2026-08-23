# Values without defaults must be supplied through terraform.tfvars or TF_VAR_*.
variable "subscription_id" {
  type        = string
  description = "Azure subscription ID in which to create the resources."

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "subscription_id must be a valid UUID."
  }
}

variable "admin_cidr" {
  type        = string
  description = "IPv4 CIDR allowed to connect to the jumpbox over SSH."

  validation {
    condition     = can(cidrnetmask(var.admin_cidr)) && var.admin_cidr != "0.0.0.0/0"
    error_message = "admin_cidr must be a valid IPv4 CIDR and must not allow the entire Internet."
  }
}

variable "admin_ssh_public_key" {
  type        = string
  description = "Existing OpenSSH public key used by the administrator account on every VM."

  validation {
    condition = (
      startswith(trimspace(var.admin_ssh_public_key), "ssh-ed25519 ") ||
      startswith(trimspace(var.admin_ssh_public_key), "ssh-rsa ")
    )
    error_message = "admin_ssh_public_key must be an ssh-ed25519 or ssh-rsa public key."
  }
}

# Small, stable project-level settings remain configurable without exposing module internals.
variable "admin_username" {
  type        = string
  default     = "adminuser"
  description = "Administrator username configured on the jumpbox and worker VMs."

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,31}$", var.admin_username))
    error_message = "admin_username must be a lowercase Linux username of at most 32 characters."
  }
}

variable "resource_group_name" {
  type        = string
  default     = "rg-ansinetes"
  description = "Name of the Azure resource group."
}

variable "resource_group_location" {
  type        = string
  default     = "East US"
  description = "Azure region in which to create the resources."
}

variable "worker_count" {
  type        = number
  default     = 3
  description = "Number of private nginx worker VMs to create."

  validation {
    condition     = var.worker_count >= 1 && var.worker_count <= 10 && floor(var.worker_count) == var.worker_count
    error_message = "worker_count must be an integer between 1 and 10."
  }
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2ats_v2"
  description = "Azure VM size used for the jumpbox and workers."
}

variable "tags" {
  type = map(string)
  default = {
    Provisioning  = "Terraform"
    Project       = "Ansinetes"
    Configuration = "Ansible"
  }
  description = "Tags applied to resources that support them."
}
