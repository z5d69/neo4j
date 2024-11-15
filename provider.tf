terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # version = "3.114.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = "d0d3542f-abbd-489c-a622-5685febdbcbf"    
  resource_provider_registrations = "none"
}

data "azurerm_client_config" "current" {}
/* 
resource "azurerm_resource_provider_registration" "resource_provider" {
  name = "Microsoft.ContainerService"

  feature {
    name       = "AKS-DataPlaneAutoApprove"
    registered = false
  }
} */