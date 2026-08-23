output "load_balancer_ip" {
  description = "Public IPv4 address of the Load Balancer frontend."
  value       = azurerm_public_ip.load_balancer.ip_address
}
