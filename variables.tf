# ======== Variables to override in ./terraform.tfvars
variable "vm_password" {
  type        = string
  sensitive   = true
  description = "Machine administrator account password"
}

variable "subscription_id" {
  type        = string
  sensitive   = true
  description = "ID of the Azure subscription on which to deploy (mandatory since version 4.0 of AzureRM)"
}

# ======== Global variables
variable "resource_group_name" {
  default     = "rg-ansinetes"
  type        = string
  description = "Cluster resource group name"
}

variable "resource_group_location" {
  type        = string
  default     = "East US"
  description = "Cluster resource group location"
}

variable "worker_count" {
  type        = number
  default     = 3
  description = "Number of Workers machines to deploy"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2als_v2"
  description = "Virtual machine SKU to be used for cluster nodes"
}

variable "tags" {
  type = map(string)
  default = {
    Provisioning  = "Terraform",
    Project       = "Ansinetes",
    Configuration = "Ansible"
  }
  description = "Tags for deployed resources"
}