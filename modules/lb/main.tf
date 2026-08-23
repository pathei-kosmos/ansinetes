locals {
  # A shared name prevents drift between rules and the single public frontend.
  frontend_name = "public"
}

resource "azurerm_public_ip" "load_balancer" {
  name                = "pip-load-balancer"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_lb" "load_balancer" {
  name                = "lb-ansinetes"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = local.frontend_name
    public_ip_address_id = azurerm_public_ip.load_balancer.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "workers" {
  name            = "workers"
  loadbalancer_id = azurerm_lb.load_balancer.id
}

resource "azurerm_network_interface_backend_address_pool_association" "worker" {
  count = length(var.worker_nic_ids)

  network_interface_id    = var.worker_nic_ids[count.index]
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.workers.id
}

resource "azurerm_lb_probe" "http" {
  name            = "http-root"
  loadbalancer_id = azurerm_lb.load_balancer.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "http" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = local.frontend_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.workers.id]
  probe_id                       = azurerm_lb_probe.http.id

  # The explicit outbound rule below is the sole SNAT authority for workers.
  disable_outbound_snat = true
}

resource "azurerm_lb_outbound_rule" "workers" {
  name                     = "worker-egress"
  loadbalancer_id          = azurerm_lb.load_balancer.id
  backend_address_pool_id  = azurerm_lb_backend_address_pool.workers.id
  protocol                 = "All"
  allocated_outbound_ports = 1024
  idle_timeout_in_minutes  = 4

  frontend_ip_configuration {
    name = local.frontend_name
  }
}
