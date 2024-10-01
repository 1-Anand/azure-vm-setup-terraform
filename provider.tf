terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "stg-01"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "pipra80"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "container1"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
  subscription_id = "55071ba7-3ef9-4ff3-84d2-29d88b809397"
}