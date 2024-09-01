variable "resource_group_name" {
  type        = string
  description = "Cluster resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "Cluster resource group location"
}

variable "worker_count" {
  type        = number
  description = "Number of Workers machines to deploy"
}

variable "vm_size" {
  type        = string
  description = "Virtual machine SKU to be used for cluster nodes"
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "Machine administrator account password"
}

variable "nic_master_id" {
  type        = string
  description = "Master node network interface ID"
}

variable "nic_workers" {
  type        = any
  description = "Worker nodes network interfaces"
}

variable "tags" {
  type        = map(string)
  description = "Tags for deployed resources"
}