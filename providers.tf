terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # Stay on the compatible AzureRM 4.x line until a live migration can be tested.
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}
