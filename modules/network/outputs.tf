output "nic_master_id" {
  value = azurerm_network_interface.nic_master.id
}

output "nic_workers" {
  value = azurerm_network_interface.nic_worker
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "workers_ips" {
  value = azurerm_public_ip.pip_worker[*].ip_address
}

output "master_ip" {
  value = azurerm_public_ip.pip_master.ip_address
}