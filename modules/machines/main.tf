resource "azurerm_linux_virtual_machine" "Master" {
  name                            = "Master-0"
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  size                            = var.vm_size
  computer_name                   = "Master"
  admin_username                  = "adminuser"
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids = [
    var.nic_master_id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = data.azurerm_platform_image.image.publisher
    offer     = data.azurerm_platform_image.image.offer
    sku       = data.azurerm_platform_image.image.sku
    version   = data.azurerm_platform_image.image.version
  }

  connection {
    type     = "ssh"
    user     = "adminuser"
    password = var.vm_password
    host     = self.public_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/adminuser",
      "sudo apt update",
      "sudo apt install -y python3 git ansible-core sshpass",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      for index, ip in azurerm_linux_virtual_machine.Worker[*].private_ip_address :
      "echo \"${azurerm_linux_virtual_machine.Worker[index].name} ansible_host=${ip} ansible_user=adminuser ansible_password=${var.vm_password} ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'\" >> /home/adminuser/hosts.ini"
    ]
  }

  provisioner "file" {
    source      = "./playbooks/nginx.yml"
    destination = "/home/adminuser/nginx.yml"
  }

  provisioner "remote-exec" {
    inline = ["ansible-playbook -i hosts.ini nginx.yml"]
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "Worker" {
  count                           = var.worker_count
  name                            = "Worker-${count.index}"
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  size                            = var.vm_size
  computer_name                   = "Worker-${count.index}"
  admin_username                  = "adminuser"
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids = [
    var.nic_workers[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = data.azurerm_platform_image.image.publisher
    offer     = data.azurerm_platform_image.image.offer
    sku       = data.azurerm_platform_image.image.sku
    version   = data.azurerm_platform_image.image.version
  }

  connection {
    type     = "ssh"
    user     = "adminuser"
    password = var.vm_password
    host     = self.public_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/adminuser",
      "sudo apt update",
      "sudo apt install -y python3 git"
    ]
  }

  tags = var.tags
}