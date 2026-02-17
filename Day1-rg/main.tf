provider "azurerm"{
    features{}
} 

resource "azurerm_resource_group" "rg"{
    name = "rg-day1_practice"
    location = "Central India"
}

