variable "azregion" {
  type=string
  description = "This is the region for resources to deploy in"
  default = "EastUS"
}

variable "keyvault_secret_name" {
    type=string
    description = "this is the name of the secret used for storing the ssh key"
    default = null
}

variable "resource_group_name" {
    type=string
    description = "This is the resource group for resources to deploy in"
    default = "Azure-Sandbox"
}

variable "zones" {
    type = list
    description = "this is the list of zones to deploy VMs to"
    default = null
}

variable "key_vault_name" {
    type=string
    description = "this is the keyvault for this deployment"
    default = null
}

variable "vnet_name" {
    type=string
    description = "this is the vnet name for this deployment"
    default = null
}

variable "vm_count" {
    type=number
    description = "this is the count of VMs for this deployment"
    default = null
}

variable "vm_name" {
    type=string
    description = "this is the VM name for this deployment"
    default = null
}

variable "os_disk_name" {
    type=string
    description = "this is the os disk name for this VM deployment"
    default = null
}

variable "data_disk_name" {
    type=string
    description = "this is the data disk name for this VM deployment"
    default = null
}

variable "subnet_name" {
    type=string
    description = "this is the subnet for this deployment"
    default = null
}

variable "common_tags" {
  type = map(string)
  default = {
    environment = "sandbox"
    shortenvironment = "sbx"
    project  = "neo4j"
    createdby = "David Lawrence"
  }
}