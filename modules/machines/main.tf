resource "azurerm_linux_virtual_machine" "jumpbox" {
  #checkov:skip=CKV_AZURE_50:VM extensions remain permitted for standard Azure operations, ansinetes deploys none.
  name                = "vm-jumpbox"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  computer_name       = "jumpbox"
  admin_username      = var.admin_username

  # Terraform provisions access only, it never opens an SSH connection to the VM.
  disable_password_authentication = true
  network_interface_ids           = [var.jumpbox_nic_id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = trimspace(var.admin_ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "worker" {
  #checkov:skip=CKV_AZURE_50:VM extensions remain permitted for standard Azure operations, ansinetes deploys none.
  count = length(var.worker_nic_ids)

  name                = "vm-worker-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  computer_name       = "worker-${count.index}"
  admin_username      = var.admin_username

  # Workers share the public key but have no password or public network interface.
  disable_password_authentication = true
  network_interface_ids           = [var.worker_nic_ids[count.index]]

  admin_ssh_key {
    username   = var.admin_username
    public_key = trimspace(var.admin_ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.tags
}
