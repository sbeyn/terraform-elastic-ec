terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.90.0"
    }

    ec = {
      source = "elastic/ec"
      version = "0.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}
