resource "azurerm_virtual_network" "virtual_network" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  tags = var.common_tags
}

resource "azurerm_subnet" "virtual_subnet" {
  name                 = local.subnet_name
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.0.0/24"]

/*   delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  } */
}