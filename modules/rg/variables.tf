# Inputs are kept explicit so the module remains reusable without hidden defaults.
variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group."
}

variable "resource_group_location" {
  type        = string
  description = "Azure region of the resource group."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the resource group."
}
