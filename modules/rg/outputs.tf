output "resource_group_location" {
  description = "Azure region of the resource group."
  value       = azurerm_resource_group.rg.location
}

output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.rg.name
}
