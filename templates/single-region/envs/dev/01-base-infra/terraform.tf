terraform {
  required_version = "~> 1.13.1"

  backend "azurerm" {
    use_azuread_auth = true
  }

  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.39.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Aliased provider with Azure AD authentication for storage account access
# Used by the Observability module since storage access keys are disabled,
# and Terraform needs to authenticate via managed identity instead
provider "azurerm" {
  features {}
  storage_use_azuread = true
  alias               = "storage-use-azuread"
}

provider "mongodbatlas" {
}
