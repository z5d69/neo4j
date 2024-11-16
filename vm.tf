module "vm" {
    source="./modules/vm"
    mod_vm_name="${local.vm_name}"
    mod_vm_count = var.vm_count    
    mod_common_tags  = var.common_tags
    mod_location = data.azurerm_resource_group.resource_group.location
    mod_resource_group_name = data.azurerm_resource_group.resource_group.name
    mod_subnet_id = azurerm_subnet.virtual_subnet.id
    mod_ssh_public_key = data.azurerm_key_vault_secret.ssh_key.value
    mod_zones = local.zones
}