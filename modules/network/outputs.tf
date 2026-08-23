output "jumpbox_nic_id" {
  description = "Resource ID of the jumpbox network interface."
  value       = azurerm_network_interface.jumpbox.id
}

output "worker_nic_ids" {
  description = "Resource IDs of the private worker network interfaces."
  value       = azurerm_network_interface.worker[*].id
}

output "worker_private_ips" {
  description = "Private IPv4 addresses assigned to worker network interfaces."
  value       = azurerm_network_interface.worker[*].private_ip_address
}

output "jumpbox_public_ip" {
  description = "Public IPv4 address assigned to the jumpbox."
  value       = azurerm_public_ip.jumpbox.ip_address
}
