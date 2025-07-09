terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.4.0"
    }
  }
}

provider "azurerm" {
  features {}
  tenant_id = "843ca2ca-435f-4f66-a407-605e86eafa44"
  subscription_id = "1b2003fc-5952-448e-92f8-01383f5b9c95"
}

