data "azurerm_resource_group" resource_group {
  name     = var.resource_group_name
  
}
output "id" {
  value = data.azurerm_resource_group.resource_group.id
}