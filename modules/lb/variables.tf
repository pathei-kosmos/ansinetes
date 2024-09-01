variable "resource_group_name" {
  type        = string
  description = "Cluster resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "Cluster resource group location"
}

variable "vnet_id" {
  type        = string
  description = "Cluster virtual network ID"
}

variable "worker_count" {
  type        = number
  description = "Number of Workers machines to deploy"
}

variable "nic_workers" {
  type        = any
  description = "Worker nodes network interfaces"
}

variable "tags" {
  type        = map(string)
  description = "Tags for deployed resources"
}