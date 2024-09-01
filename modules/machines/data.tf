data "azurerm_platform_image" "image" {
  location  = var.resource_group_location
  publisher = "canonical"
  offer     = "ubuntu-24_04-lts"
  sku       = "server"
}