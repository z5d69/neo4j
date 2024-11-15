resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg${local.vnet_name}${local.subnet_name}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  tags = var.common_tags

  security_rule {
    name                        = "allowssh"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    }

  security_rule {
    name                        = "allowhttps"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    # source_address_prefix       = "10.0.0.0/16"
    # destination_address_prefix  = "10.0.0.0/16"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"    
    }

  security_rule {
    name                        = "allowbolt"
    priority                    = 102
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "7687"
    # source_address_prefix       = "10.0.0.0/16"
    # destination_address_prefix  = "10.0.0.0/16"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"   
    }

  security_rule {
    name                        = "blockall"
    priority                    = 200
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "nsgasub1" {
  subnet_id                 = azurerm_subnet.virtual_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
