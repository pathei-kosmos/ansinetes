output "load_balancer_ip" {
  value = azurerm_public_ip.pip_load_balancer.ip_address
}