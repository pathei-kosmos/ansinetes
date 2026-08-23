locals {
  # Fixed subnet ranges make ansinetes topology immediately auditable.
  management_subnet_cidr = "10.0.1.0/24"
  backend_subnet_cidr    = "10.0.2.0/24"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-ansinetes"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  tags = var.tags
}

resource "azurerm_subnet" "management" {
  name                 = "snet-management"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.management_subnet_cidr]

  # The jumpbox public IP is its explicit Internet connectivity mechanism.
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "backend" {
  name                 = "snet-backend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.backend_subnet_cidr]

  # Workers use the Load Balancer outbound rule, never Azure default outbound access.
  default_outbound_access_enabled = false
}

resource "azurerm_network_security_group" "management" {
  name                = "nsg-management"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowAdminSSH"
    description                = "Allow SSH to the jumpbox only from the operator CIDR."
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_cidr
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "backend" {
  #checkov:skip=CKV_AZURE_160:The public HTTP rule is the intentional application ingress behind the Load Balancer.
  name                = "nsg-backend"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSSHFromManagement"
    description                = "Allow worker administration through the management subnet."
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = local.management_subnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowPublicHTTP"
    description                = "Allow public client traffic forwarded by the Load Balancer."
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowLoadBalancerProbe"
    description                = "Allow Azure Load Balancer health probes to nginx."
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.backend.id
}

resource "azurerm_public_ip" "jumpbox" {
  name                = "pip-jumpbox"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_network_interface" "jumpbox" {
  #checkov:skip=CKV_AZURE_119:The jumpbox public IP is required for the restricted administrative entry point.
  name                = "nic-jumpbox"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "worker" {
  count = var.worker_count

  name                = "nic-worker-${count.index}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
    # A deliberately omitted public_ip_address_id keeps every worker private.
  }

  tags = var.tags
}
