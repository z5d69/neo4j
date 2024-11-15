locals {
name_base = "${var.common_tags["project"]}${var.common_tags["shortenvironment"]}"
key_vault_name = var.key_vault_name == null ? "kv${local.name_base}" : var.key_vault_name
vnet_name = var.vnet_name == null ? "vnet${local.name_base}" : var.vnet_name
subnet_name = var.vnet_name == null ? "sub${local.vnet_name}" : var.vnet_name
vm_name = var.vm_name == null ? "vm${local.name_base}" : var.vm_name
os_disk_name = var.os_disk_name == null ? "diskos${local.vm_name}" : var.os_disk_name
data_disk_name = var.data_disk_name == null ? "diskdata${local.name_base}" : var.data_disk_name
zones = var.zones == null ? ["1","2","3"] : var.zones
}
