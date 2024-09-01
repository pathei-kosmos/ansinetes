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

variable "tags" {
  type        = map(string)
  description = "Tags for deployed resources"
}