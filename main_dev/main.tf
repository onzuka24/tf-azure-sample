terraform {
  required_version = ">= 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

# fixed to westus to use bastion dev SKU
resource "azurerm_resource_group" "rg" {
  name     = "${var.stage}_resource_group"
  location = "westus"
}
