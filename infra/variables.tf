variable "region" {
  type        = string
  description = "region de despliegue"
}

variable "prefix_name" {
  type        = string
  description = "prefijo para nombres de recursos"
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}

variable "password" {
  description = "The password for the virtual machine"
  type        = string
  sensitive   = true
}
