resource "azurerm_public_ip" "pip_load_balancer" {
  name                = "pip-load-balancer"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_lb" "load_balancer" {
  name                = "lb-ansinetes"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip_load_balancer.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "load_balancer_backend_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "BackEndPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "load_balancer_association" {
  count                   = var.worker_count
  network_interface_id    = var.nic_workers[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.load_balancer_backend_pool.id
}

resource "azurerm_lb_probe" "load_balancer_probe" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "HTTP-Probe"
  port            = 80
}

resource "azurerm_lb_rule" "load_balancer_inbound_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "Http-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  disable_outbound_snat          = true
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.load_balancer_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.load_balancer_backend_pool.id]
}