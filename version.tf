terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.31.0"
    }
  }
}