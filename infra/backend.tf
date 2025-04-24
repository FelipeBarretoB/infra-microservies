terraform {
  backend "azurerm" {
    #we can't use variables here, only static values
    resource_group_name   = "taller-rg"   
    storage_account_name  = "tfstatestoragef851169d"   
    container_name        = "terraform-state"       
    key                    = "terraform.tfstate"    
  }
}
