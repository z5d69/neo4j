data "azurerm_key_vault" "keyvault" {
  name                = "${local.key_vault_name}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

data "azurerm_key_vault_secret" "ssh_key" {
  name         = "${var.keyvault_secret_name}"
  key_vault_id = data.azurerm_key_vault.keyvault.id
} 