terraform {
    backend "azurerm" {
        resource_group_name  = "rg-tf-backend"
        storage_account_name = "tfstatebackendci"
        container_name       = "tfstate"
        key                  = "dev/network.tfstate"
    }
}